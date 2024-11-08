import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../global_varibales.dart';
import '../models/category.dart';

class CategoryController {


// load uploaded category

  Future<List<Category>> loadcategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/categories'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );
      log(response.body.toString());
      if (response.statusCode == 200) {
        // the response will be a list when we decode it we just need to use from map
        final List<dynamic> data = jsonDecode(response.body);
        List<Category> categories =
            data.map((category) => Category.fromMap(category)).toList();
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      log('Error: ' + e.toString());
      // Returning an empty list to handle errors gracefully
      return [];
    }
  }
}
