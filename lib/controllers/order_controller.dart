import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_store_app/global_varibales.dart';
import 'package:vendor_store_app/models/order.dart';
import 'package:vendor_store_app/services/manage_http_reponse.dart';

class OrderController {
  // function to upload orders

// Method to GET order by ID
  Future<List<Order>> loadOrders({required String vendorId}) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders/vendors/$vendorId'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );
      // check if the response status code is 200(OK).
      if (response.statusCode == 200) {
        // parse json into dynamic list
        // This convert the json data into a formate that can be further processed in dart
        List<dynamic> data = jsonDecode(response.body);
        // Map the dynamic list to List of orders object using fromJson factory
        // this step convert the raw data into list of orders object , which is easier to work with
        List<Order> orders =
            data.map((order) => Order.fromJson(order)).toList();
        return orders;
      } else {
        // throw an exciption for now if the server with an error status code
        throw Exception('failed to load orders');
      }
    } catch (e) {
      throw Exception('error in Loading Orders');
    }
  }

  Future<void> deleteOrder(
      {required String id, required BuildContext context}) async {
    try {
      http.Response response = await http.delete(
        Uri.parse('$uri/api/orders/$id'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Order Deleted sucessfully');
          });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateDeliveryStatus(
      {required String id, required BuildContext context}) async {
    try {
      http.Response response = await http.patch(
        Uri.parse('$uri/api/orders/$id/delivered'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'delivered': true,
            'processing': false,
          },
        ),
      );
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'order updated');
          });
    } catch (e) {}
  }

  Future<void> cancelOrder(
      {required String id, required BuildContext context}) async {
    try {
      http.Response response = await http.patch(
        Uri.parse('$uri/api/orders/$id/processing'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'delivered': false,
            'processing': false,
          },
        ),
      );
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'order canceled');
          });
    } catch (e) {}
  }
}
