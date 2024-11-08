import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import '../global_varibales.dart';
import '../models/product.dart';
import '../services/manage_http_reponse.dart';
import 'package:http/http.dart' as http;

class Productcontroller {
  Future<void> uploadProduct(
      {required String productName,
      required int productPrice,
      required int quantity,
      required String description,
      required String category,
      required String vendorId,
      required String fullName,
      required String subCategory,
      required List<File>? pickedImages,
      required BuildContext context}) async {
    if (pickedImages != null) {
      final cloudinary = CloudinaryPublic('dr7uizj8z', 'i6j2zmec');
      List<String> images = [];
      // loop through each image in picked images list
      for (var i = 0; i < pickedImages.length; i++) {
        // await the upload of the current image to cloudinary
        CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(pickedImages[i].path, folder: productName),
        );
        // add the secure url to images list
        images.add(cloudinaryResponse.secureUrl);
      }
      if (category.isNotEmpty && subCategory.isNotEmpty) {
        final Product product = Product(
            id: '',
            productName: productName,
            productPrice: productPrice,
            quantity: quantity,
            description: description,
            category: category,
            vendorId: vendorId,
            fullName: fullName,
            subCategory: subCategory,
            images: images);

        http.Response response = await http.post(
          Uri.parse('$uri/api/add-product'),
          body: product.toJson(),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8',
          },
        );

        manageHttpResponse(
            response: response,
            context: context,
            onSuccess: () {
              showSnackBar(context, 'Product Uploaded Successfully');
            });
      } else {
        showSnackBar(context, 'Select Category');
      }
    } else {
      showSnackBar(context, 'select images');
    }
  }
}
