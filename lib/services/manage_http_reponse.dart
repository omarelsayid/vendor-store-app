import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// manage htpp response base on the staus code

void manageHttpResponse({
  required http.Response response, // the thhp response from the request
  required BuildContext context, // the context to show snack bar
  required VoidCallback
      onSuccess, // the callback to excute on a successfull response
}) {
  // switch statment to handle different http status code
  switch (response.statusCode) {
    case 200: //Status code 200 indicates a successfull request
      onSuccess();
      break;

    case 400: //Status code 400 indicates a abd request

      showSnackBar(context, json.decode(response.body)['msg']);
      
      break;

    case 500: //Status code 200 indicates a server erorr

      showSnackBar(context, json.decode(response.body)['error']);
      

      break;
    case 201: //Status code 201 indicates a resource was created successfully
      onSuccess();
      break;
  }
}

void showSnackBar(BuildContext context, String tilte) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(tilte),
    ),
  );
}
