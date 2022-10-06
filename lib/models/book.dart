import 'package:mytest/models/constants.dart';

class Book {
  String bName;
  String bAuther;
  String bCategory;
  String bDescription;
  String bImageURL;
  int bhours;
  bool bisAvailable ;
  String bprovider_id;

  //---------------------------------
  Book(
      {this.bName, this.bCategory, this.bImageURL, this.bDescription, this.bAuther, this.bhours , this.bisAvailable});

  Book.fromMap(Map<String , dynamic> data) {
    bprovider_id = data['provider_id'];
    bName = data[kBNameField];
    bAuther = data[kBAutherNameField];
    bCategory = data[kBCategoryField];
    bImageURL = data[kBURLField];
    bisAvailable = data[kBookAvailabilty];
    bDescription = data[kBDescriptionField];
  }


}