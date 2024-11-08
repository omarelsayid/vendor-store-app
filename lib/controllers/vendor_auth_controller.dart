import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../global_varibales.dart';
import '../main_Vendor_screen.dart';
import '../models/vendor.dart';
import 'package:http/http.dart' as http;
import '../provider/vendor_provider.dart';
import '../services/manage_http_reponse.dart';

final providerContainer = ProviderContainer();

class VendorAuthController {
  Future<void> signUpVendor(
      {required String fullName,
      required String email,
      required String password,
      required BuildContext context}) async {
    try {
      Vendor vendor = Vendor(
        id: '',
        fullName: fullName,
        email: email,
        state: '',
        city: '',
        locality: '',
        role: '',
        password: password,
      );

      http.Response response = await http.post(
          Uri.parse('$uri/api/vendor/signup'),
          body: vendor
              .toJson(), // convert the vendor object to json for the request body
          headers: <String, String>{
            // set the Headers for the request
            "Content-Type": "application/json; charset=UTF-8"
          });

      // managehttp response to handle http response base on their status code

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'account has been created ');
          });
    } catch (e) {
      log('error:${e.toString()}');
    }
  }

// function to consume the back-end vendor signIn api
  Future<void> singInVendor({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      http.Response response =
          await http.post(Uri.parse('$uri/api/vendor/signin'),
              headers: <String, String>{
                // set the Headers for the request
                "Content-Type": "application/json; charset=UTF-8"
              },
              body: jsonEncode({
                'email': email,
                'password': password,
              }));

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            // extract the authincation from token from the response body

            String token = jsonDecode(response.body)['token'];

            // store the uathentication token in shared prefrences

            preferences.setString('auth_token', token);

            // encode the user data recived from the back end as json

            final vendorJson = jsonEncode(jsonDecode(response.body)['vendor']);

// update the application state with user data using riverpod

            providerContainer
                .read(vendorProvider.notifier)
                .setVendor(vendorJson);

            // store the dtat in sharedPrefrences

            await preferences.setString('vendor', vendorJson);

            showSnackBar(context, 'Logged In ');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MainVendorScreen(),
              ),
              (route) => false,
            );
          });
    } catch (e) {
      showSnackBar(context, 'error:${e.toString()}');
    }
  }
}
