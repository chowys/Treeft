import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/Database/Products.dart';
import 'package:code/Page/Homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Database/Category.dart';
import '../Database/Products.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart';

class Selling extends StatefulWidget {
  const Selling({Key? key}) : super(key: key);

  @override
  State<Selling> createState() => _SellingState();
}

class _SellingState extends State<Selling> {
  CategoryService _categoryService = CategoryService();
  ProductService _productService = ProductService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  final priceController = TextEditingController();
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  String _currentCategory = '';
  var _image1;
  var _image2;
  var _image3;
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    _getCategories();
  }

  List<DropdownMenuItem<String>> getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = <DropdownMenuItem<String>>[];
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(categories[i]['Category']),
                value: categories[i]['Category']));
      });
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color(0xffFFDE59),
        leading: IconButton(
          icon: new Icon(Icons.close),
          color: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Homescreen()),
            );
          },
        ),
        title: Text(
          "Add Product",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: isLoading
              ? CircularProgressIndicator()
              : Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        width: 2.5,
                                        color: Colors.black.withOpacity(0.5))),
                                onPressed: () {
                                  _selectImage(
                                      _picker.pickImage(
                                          source: ImageSource.gallery),
                                      1);
                                },
                                child: _displayChild1()),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        width: 2.5,
                                        color: Colors.black.withOpacity(0.5))),
                                onPressed: () {
                                  _selectImage(
                                      _picker.pickImage(
                                          source: ImageSource.gallery),
                                      2);
                                },
                                child: _displayChild2()),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      width: 2.5,
                                      color: Colors.black.withOpacity(0.5))),
                              onPressed: () {
                                _selectImage(
                                    _picker.pickImage(
                                        source: ImageSource.gallery),
                                    3);
                              },
                              child: _displayChild3(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: productNameController,
                        decoration: InputDecoration(hintText: 'Listing Title'),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'You must enter a product name';
                          }
                        },
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Category: ',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        DropdownButton(
                          items: categoriesDropDown,
                          onChanged: changeSelectedCategory,
                          value: _currentCategory,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Price',
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'You must enter the product price';
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: productDescriptionController,
                        decoration:
                            InputDecoration(hintText: 'Product description'),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'You must enter a product description';
                          }
                        },
                      ),
                    ),
                    ElevatedButton(
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                      ),
                      child: Text('Add product',
                          style: TextStyle(color: Colors.black)),
                      onPressed: () {
                        validateAndUpload();
                      },
                    )
                  ],
                ),
        ),
      ),
    );
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    print(data.length);
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropDown();
      _currentCategory = categories[0]['Category'];
    });
  }

  void changeSelectedCategory(String? selectedCategory) {
    setState(() => _currentCategory = selectedCategory!);
  }

  void _selectImage(Future<XFile?> pickImage, int imageNumber) async {
    //File tempImg = await pickImage;
    XFile? tempImg2 = await pickImage;
    File tempImg = File(tempImg2!.path);
    print(tempImg);
    //File tempImg = File(tempImg2.path);
    switch (imageNumber) {
      case 1:
        setState(() => _image1 = tempImg);
        print('Pic 1');
        break;
      case 2:
        setState(() => _image2 = tempImg);
        print('Pic 2');
        break;
      case 3:
        setState(() => _image3 = tempImg);
        print('Pic 3');
        break;
    }
  }

  Widget _displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: Colors.black,
        ),
      );
    } else {
      return Image.file(
        _image1,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Widget _displayChild2() {
    if (_image2 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: Colors.black,
        ),
      );
    } else {
      return Image.file(
        _image2,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Widget _displayChild3() {
    if (_image3 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: Colors.black,
        ),
      );
    } else {
      return Image.file(
        _image3,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  void validateAndUpload() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      if (_image1 != null && _image2 != null && _image3 != null) {
        String imageUrl1;
        String imageUrl2;
        String imageUrl3;
        final FirebaseStorage storage = FirebaseStorage.instance;
        final String picture1 =
            "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
        UploadTask task1 = storage.ref().child(picture1).putFile(_image1);
        final String picture2 =
            "2${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
        UploadTask task2 = storage.ref().child(picture2).putFile(_image2);
        final String picture3 =
            "3${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
        UploadTask task3 = storage.ref().child(picture3).putFile(_image3);

        TaskSnapshot snapshot1 = await task1.then((snapshot) => snapshot);
        TaskSnapshot snapshot2 = await task2.then((snapshot) => snapshot);
        task3.then((snapshot3) async {
          imageUrl1 = await snapshot1.ref.getDownloadURL();
          imageUrl2 = await snapshot2.ref.getDownloadURL();
          imageUrl3 = await snapshot3.ref.getDownloadURL();
          List<String> imageList = [imageUrl1, imageUrl2, imageUrl3];

          FirebaseFirestore.instance
              .collection('UserData')
              .doc(user?.uid)
              .get()
              .then((DocumentSnapshot<Map<String, dynamic>> ds) {
            int trans = ds.data()!['transactions'];
            bool featured = false;
            String username = ds.data()!['username'];

            //remember to change
            if (trans <= 5 && trans >= 0) {
              featured = false;
            } else if (trans > 5 && trans <= 10) {
              featured = true;
            } else if (trans > 10 && trans <= 15) {
              featured = true;
            }

            _productService.uploadProduct(
                productName: productNameController.text,
                category: _currentCategory,
                images: imageList,
                price: double.parse(priceController.text),
                productDescription: productDescriptionController.text,
                isFeatured: featured,
                isGeneral: true,
                userName: username);
          }).catchError((e) {
            print(e);
          });

          /*_productService.uploadProduct(
              productName: productNameController.text,
              category: _currentCategory,
              images: imageList,
              price: double.parse(priceController.text),
              productDescription: productDescriptionController.text);*/

          _formKey.currentState!.reset();
          setState(() => isLoading = false);
          Fluttertoast.showToast(
              msg: 'Your listing has been successfully updated');
          Navigator.pop(context);
        });
      } else {
        setState(() => isLoading = false);
        Fluttertoast.showToast(msg: 'All the images must be provided');
      }
    }
  }
}
