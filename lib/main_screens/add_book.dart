import 'dart:io';
import 'dart:ui';
import 'package:mytest/models/input_text_form_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytest/db/auth_service.dart';
import 'package:mytest/models/book.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mytest/models/reusable_container.dart';
import 'package:mytest/models/constants.dart';
import 'package:mytest/db/category_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as p;
import 'package:mytest/db/store.dart';
import 'package:provider/provider.dart';

class ProvideBook extends StatefulWidget {
  static const id = 'provide';
  @override
  _ProvideBookState createState() => _ProvideBookState();
}

class _ProvideBookState extends State<ProvideBook> {
  Store _store = Store();
  double sliderval = 168.0;
  Duration d = Duration();
  String _url;
  String _bookName, _autherName, _category, _description;
  TextEditingController bookName = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController autherNameController = TextEditingController();
  TextEditingController bookDescriptionController = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey();
  GlobalKey<FormState> _bookFormKey = GlobalKey();
  CategoryService _categoryService = CategoryService();
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropdown =
      <DropdownMenuItem<String>>[];
  String currentCategory;
  String message = 'Enter at most 10 charachters only ';

  @override
  void initState() {
    _getCategories();
    categoriesDropdown = _categoryService.getCategoriesDropdown(categories);
  }

  //----------------------------------------------------------
  // related to image
  Future<void> _showChoiceDialoge(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Going to take a picture of the book'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("OKKKK!!"),
                    onTap: () {
                      _openCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  //-----------------------------------------------------
  File imageFile;
  //related to the image
  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    if(picture != null){
      setState(() {
        imageFile = picture;
      });
      Navigator.of(context).pop();
    }
  }

  //--------------------------------------------------------
  // related to the image
  Widget _decideImageView() {
    if (imageFile == null) {
      return OutlineButton(
        borderSide: BorderSide(color: Colors.white, width: 4.0 ,style: BorderStyle.solid),
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 8, 20, 8),
          child: Icon(
            Icons.add_a_photo,
            color: Colors.deepPurple,
          ),
        ),
      );
    } else {
      return Image.file(
        imageFile,
        width: 200.0,
        height: 200.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.purple[700],
        title: Text('Share your books' , style: kWelcome),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          validateAndUpload();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.purple[700],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Center(
                child: ReusableContainer(
                  c: Colors.purple[200],
                  cardChild: Form(
                    key: _bookFormKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0))),
                          height: 500.0,
                          child: ListView(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          _decideImageView(),
                                          FlatButton(
                                            child: Text(
                                              'Add Picture',
                                              style:
                                              TextStyle(color: Colors.white),
                                            ),
                                            onPressed: () {
                                              _showChoiceDialoge(context);
                                            },
                                            color: Color(0xFCE4EC),
                                          ),
                                          InputTextFormFields(
                                            hint: 'Enter book Name',
                                            lines: 1,
                                            textController: bookName,
                                            onChange: (value){setState(() {
                                              _bookName = value;
                                            });},
                                            icon: Icon(FontAwesomeIcons.book, size: 30.0,color: Colors.purple[700],),
                                            validOrNot: (value) {
                                              if (value.isEmpty) {
                                                return 'this Can not be empty';
                                              } else {
                                                if (value.length > 20) {
                                                  return 'this should not be more than 10 chars';
                                                }
                                              }
                                            },
                                          ),
                                          InputTextFormFields(
                                            hint: 'Enter Auther Name',
                                            lines: 1,
                                            onChange: (value){setState(() {
                                              _autherName = value;
                                            });},
                                            textController: autherNameController,
                                            icon: Icon(FontAwesomeIcons.user ,size: 30.0, color: Colors.purple[700],),
                                            validOrNot: (value) {
                                              if (value.isEmpty) {
                                                return 'this Can not be empty';
                                              } else {
                                                if (value.length > 20) {
                                                  return 'this should not be more than 10 chars';
                                                }
                                              }
                                            },
                                          ),
                                          InputTextFormFields(
                                            hint: 'Enter the description',
                                            lines: 5,
                                            onChange: (value){setState(() {
                                              _description = value ;
                                            });
                                            print (_description);
                                            },
                                            icon:Icon(FontAwesomeIcons.comment, size: 30.0,color: Colors.purple[700],),
                                            validOrNot: (value) {
                                              if (value.isEmpty) {
                                                return 'this Can not be empty';
                                              }
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Card(
                                                        color: Colors.purple[700],
                                                        child: Text(
                                                          'Select Category',
                                                          style: kWords,
                                                        )),
                                                    Center(
                                                      child: DropdownButton(
                                                        items: categoriesDropdown,
                                                        onChanged:
                                                            (selectedcategory) {
                                                          setState(() {
                                                            currentCategory =
                                                                selectedcategory;
                                                            _category =
                                                                currentCategory;
                                                          });
                                                        },
                                                        value: currentCategory,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                    'If not found try adding your own category'),
                                                FlatButton(
                                                  child: Text('Add a Category' , style: TextStyle(color: Colors.white)),
                                                  onPressed: _categoryAlert,
                                                  color: Colors.purple[700],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
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


  void _categoryAlert() {
    var alert = AlertDialog(
      content: Form(
        key: _formkey,
        child: TextFormField(
          controller: categoryController,
          validator: (value) {
            if (value.isEmpty) {
              return 'category cannot be empty';
            }
          },
          decoration: InputDecoration(hintText: 'Create Category'),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            if (categoryController.text != null) {
              _categoryService.createCategory(categoryController.text);
            }
            Fluttertoast.showToast(msg: 'Category Created');
            Navigator.pop(context);
          },
          child: Text('add'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('cancel'),
        )
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }

  // related to category
//  List<DropdownMenuItem<String>> getCategoriesDropdown(List<DocumentSnapshot> categories) {
//    List<DropdownMenuItem<String>> item = new List();
//    for (DocumentSnapshot category in categories) {
//      item.add(new DropdownMenuItem(
//        child: Text(
//          category['category'],
//        ),
//        value: category['category'],
//      ));
//    }
//    return item;
//  }

  // related to category
  void _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategoriesDocuments();
    setState(() {
      categories = data;
      categoriesDropdown = _categoryService.getCategoriesDropdown(categories);
      currentCategory = categoriesDropdown[0].value;
    });
  }

  // valdating aabd uploading the book
  void validateAndUpload() async {
    try {
      // apps that requires user input needs forms
      // to check if the user input is valid
      // needs a global key that acts as an identifier for the form
      if (_bookFormKey.currentState.validate()) {
        // If the form is valid, display a snackbar. In the real world,
        // you'd often call a server or save the information in a database.
        if (imageFile != null) {
          FirebaseStorage storage =
              FirebaseStorage(storageBucket: 'gs://blocker-d8840.appspot.com');
          StorageReference ref =
              storage.ref().child(p.basename(imageFile.path));
          StorageUploadTask task = ref.putFile(imageFile);
          StorageTaskSnapshot taskSnapshot = await task.onComplete;
          String url = await taskSnapshot.ref.getDownloadURL();
          if(url != null){
            setState(() {
              _url = url;
            });
            Book book = Book(bName: _bookName,bAuther: _autherName,
            bDescription: _description,
            bCategory: _category,
            bImageURL: _url,);
          _bookFormKey.currentState.save();
          _store.add_Book(context , book);
          // tracing the output
          print('Sucess');
          String user_id = await Provider.of<AuthService>(context , listen: false).getCurrentUser();
          Store().increaseRate(user_id, 2);
          Fluttertoast.showToast(msg: "book is added" , textColor: Colors.black, backgroundColor: Colors.purple[300], timeInSecForIosWeb: 8);}
          bookName.clear();
          autherNameController.clear();
          bookDescriptionController.clear();
        } else {
          Fluttertoast.showToast(msg: "The image is a must" , webBgColor: Color(0xFCE4EC));
        }
      }
    } catch (e) {
      print('the exception that is $e');
    }
  }
}
