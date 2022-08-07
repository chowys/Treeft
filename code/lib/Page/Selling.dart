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
        title: Container(
          color: Color(0xffFFDE59),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text('Add Product',
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(color: Colors.black)),
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
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xffFFDE59),
                        onPrimary: Colors.black,
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
    XFile? tempImg2 = await pickImage;
    if (pickImage == null || tempImg2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No image is selected'),
        ),
      );
    } else {
      File tempImg = File(tempImg2.path);
      print(tempImg);
      //File tempImg = File(tempImg2.path);
      switch (imageNumber) {
        case 1:
          setState(() => _image1 = tempImg);
          print('Pic 1');
          break;
      }
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

  void validateAndUpload() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      if (_image1 != null) {
        String imageUrl1;
        final FirebaseStorage storage = FirebaseStorage.instance;
        final String picture1 =
            "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
        UploadTask task1 = storage.ref().child(picture1).putFile(_image1);

        task1.then((snapshot) async {
          imageUrl1 = await snapshot.ref.getDownloadURL();
          List<String> imageList = [
            imageUrl1,
          ];

          FirebaseFirestore.instance
              .collection('UserData')
              .doc(user?.uid)
              .get()
              .then((DocumentSnapshot<Map<String, dynamic>> ds) {
            int trans = ds.data()!['transactions'];
            bool featured = false;
            String username = ds.data()!['username'];

            //remember to change
            if (trans <= 10 && trans >= 0) {
              featured = false;
            } else if (trans > 10) {
              featured = true;
            }

            _productService.uploadProduct(
                name: productNameController.text,
                category: _currentCategory,
                images: imageList,
                price: double.parse(priceController.text),
                description: productDescriptionController.text,
                featured: featured,
                general: true,
                username: username);
          }).catchError((e) {
            print(e);
          });

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
