import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controllers/category_controller.dart';
import '../../../controllers/productController.dart';
import '../../../controllers/subcategory_controller.dart';
import '../../../models/category.dart';
import '../../../models/subcategory.dart';
import '../../../provider/vendor_provider.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Productcontroller _productcontroller = Productcontroller();
  final ImagePicker picker = ImagePicker();
  List<File> images = [];
  late Future<List<Category>> futureCategories;
  Future<List<Subcategory>>? futureSubCategories;
  Subcategory? selectedSubCategory;
  Category? selectedCategory;
  late String productName;
  late int productPrice;
  late int quantity;
  late String description;
  bool isLoading = false;

  void chooseImage() async {
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        images.add(File(pickedImage.path));
      });
    } else {
      log('No image picked');
    }
  }

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadcategories();
  }

  void getSubcategoryByCategory(Category category) {
    // Fetch subcategories based on selected category
    setState(() {
      futureSubCategories =
          SubcategoryController().getSubCategoriesByCategoryName(category.name);
    });

    // Reset the selectedSubcategory, not the selectedCategory
    selectedSubCategory = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.builder(
                shrinkWrap: true,
                itemCount: images.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return index == 0
                      ? Center(
                          child: IconButton(
                            onPressed: chooseImage,
                            icon: const Icon(Icons.add),
                          ),
                        )
                      : SizedBox(
                          width: 50,
                          height: 40,
                          child: Image.file(images[index - 1]),
                        );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          productName = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Product Name';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Product Name',
                          hintText: 'Enter Product Name',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          productPrice = int.parse(value);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Product price';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Product Price',
                          hintText: 'Enter Product Price',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          quantity = int.parse(value);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Product Quantity';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Product Quantity',
                          hintText: 'Enter Product Quantity',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 200,
                      child: FutureBuilder<List<Category>>(
                        future: futureCategories,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(child: Text('No Categories'));
                          } else {
                            return DropdownButton<Category>(
                              value: selectedCategory,
                              hint: const Text('Select Category'),
                              items: snapshot.data!.map((Category category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value;
                                  selectedSubCategory =
                                      null; // Reset subcategory when category changes
                                });
                                getSubcategoryByCategory(value!);
                                log('Selected Category: ${selectedCategory!.name}');
                              },
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 200,
                      child: FutureBuilder<List<Subcategory>>(
                        future: futureSubCategories,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No Subcategories'));
                          } else {
                            return DropdownButton<Subcategory>(
                              value: selectedSubCategory,
                              hint: const Text('Select Subcategory'),
                              items:
                                  snapshot.data!.map((Subcategory subCategory) {
                                return DropdownMenuItem(
                                  value: subCategory,
                                  child: Text(subCategory.subCategoryName),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedSubCategory = value;
                                });
                                log('Selected Subcategory: ${selectedSubCategory!.subCategoryName}');
                              },
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          description = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Product Description';
                          } else {
                            return null;
                          }
                        },
                        maxLines: 3,
                        maxLength: 500,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Product Description',
                          hintText: 'Enter Product Description',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      final vendor = ref.read(vendorProvider);
                      if (vendor == null) {
                        log('Vendor is not set');
                        return;
                      }
                      final fullName = vendor.fullName;
                      final vendorId = vendor.id;

                      await _productcontroller
                          .uploadProduct(
                              productName: productName,
                              productPrice: productPrice,
                              quantity: quantity,
                              description: description,
                              category: selectedSubCategory!.categoryName,
                              vendorId: vendorId,
                              fullName: fullName,
                              subCategory: selectedSubCategory!.subCategoryName,
                              pickedImages: images,
                              context: context)
                          .whenComplete(() {
                        setState(() {
                          isLoading = false;
                          selectedCategory = null;
                          selectedCategory = null;
                          images.clear();
                        });
                      });
                    } else {
                      log('please Enter all the fildes');
                    }
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Center(
                            child: Text(
                              'Upload Product',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.7,
                              ),
                            ),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
