// ignore: import_of_legacy_library_into_null_safe
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:convert';

var db;
var userCollection;

class User {
  final String location;
  final int phone;

  const User({required this.location, required this.phone});
  String toString() {
    return "[PhoneNumber=${phone},location=${location}]";
  }
}

connect() async {
  db = await Db.create(
      "mongodb+srv://farmeasy:<FarmEasy>@farmeasy.jjlm7.mongodb.net/myFirstDatabase?retryWrites=true&w=majority;");
  await db.open();
  userCollection = db.collection('farmeasy');
  print(userCollection);
}

void insert(User data) async {
  await userCollection.insertAll([jsonEncode(data.toString())]);
}

Future<bool> getDocuments(value) async {
  try {
    final users = await userCollection.find(value).toList();
    print(users);
    if (users.isEmpty) {
      return false;
    } else {
      return true;
    }
  } catch (e) {
    return false;
  }
}

void main() async {
  await connect();
  final bool isConnected = await getDocuments({"PhoneNumber": 1234567890});
  if (isConnected) {
    print("Connected");
  } else {
    print("Not Connected");
  }
}
