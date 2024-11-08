import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../global_varibales.dart';
import '../models/subcategory.dart';

class SubcategoryController {
  Future<List<Subcategory>> getSubCategoriesByCategoryName(
      String categoryName) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/category/$categoryName/subcategories'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return data
              .map((subcategory) => Subcategory.fromMap(subcategory))
              .toList();
        } else {
          log('subcategories not found');
          return [];
        }
      } else if (response.statusCode == 404) {
        log('subcategories not found');
        return [];
      } else {
        log('Failed to fitch sub categories');
        return [];
      }
    } catch (e) {
      log('error fetching categories ${e.toString()}');
      return [];
    }
  }
}
