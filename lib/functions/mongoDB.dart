import 'package:mongo_dart/mongo_dart.dart' hide State;

const connectionurl =
    'mongodb+srv://farmeasy:farmeasy@farmeasy.jjlm7.mongodb.net/farmeasy?retryWrites=true&w=majority';

// initiate mongoDB connection
// void connect() async {
//   final conn = Db(connectionurl);
//   await conn.open();
// }
// get all data from mongoDB using create collection
void getallFiles() async {
  var db = await Db.create(connectionurl);
  await db.open();
  var coll = db.collection('farmeasy');
  var result = await coll.find();
  print(result);
  result.forEach((element) {
    print(element);
  });
}

// get files from collection
void getFiles() async {
  var db = await Db.create(connectionurl);
  // connect to created connection
  await db.open();
  var collection = db.collection('farmeasy');
  var result = await collection.find();
  result.forEach((element) {
    print(element);
  });
  // await db.close();
}

// add data to collection
// void mongoadddata(Map<String, String> data) async {
//   var db = await Db.create(connectionurl);
//   // connect to created connection
//   await db.open();
//   var collection = db.collection('farmeasy');
//   var result = await collection.insert(data);
//   print(result.entries.first);
//   await db.close();
// }

// get data from collection where phone number is equal to the phone number
Future<bool> getdata(String phone) async {
  var db = await Db.create(connectionurl);
  // connect to created connection
  await db.open();
  var collection = db.collection('farmeasy');
  var result = await collection.findOne(where.eq('PhoneNumber', phone));
  await db.close();
  var ans = result == null ? false : true;
  return ans;
}

// return data from collection where phone number is equal to the phone number
Future<Map<String, dynamic>> getdata2(String loc) async {
  var db = await Db.create(connectionurl);
  // connect to created connection
  await db.open();
  var collection = db.collection('waterprediction');
  var result = await collection.findOne(where.eq('Location', loc));
  await db.close();
  Map<String, dynamic> da = <String, dynamic>{};
  result?.forEach((key, value) {
    da[key] = value;
  });
  return da;
}

Future<List<Map<String, dynamic>>> getdata3(int level) async {
  var db = await Db.create(connectionurl);
  // connect to created connection
  await db.open();
  var collection = db.collection('crops');
  var result = await collection.find(where.eq('Level', level)).toList();
  print("result : $result");

  List<Map<String, dynamic>> da = [];
  print(result.first);
  result.forEach((element) {
    var temp = <String, dynamic>{};
    element.forEach((key, value) {
      print("key : $key");
      print("value : $value");
      temp[key] = value;
    });
    da.add(temp);
  });
  print(da);
  await db.close();
  return da;
}

// update data in collection
void mongoupdate(String phone, String loc) async {
  var db = await Db.create(connectionurl);
  // connect to created connection
  await db.open();
  var collection = db.collection('farmeasy');
  var result = await collection.update(
      where.eq('PhoneNumber', phone), modify.set('Location', loc));
  // print(result);
  await db.close();
}

// get complete data from collection
Future<List<String>> getcompleteData() async {
  List<String> data = [];
  var db = await Db.create(connectionurl);
  // connect to created connection
  await db.open();
  var collection = db.collection('locations');
  var result = await collection.findOne(where.eq("Key", "Locations"));
  // print("result: $result");

  data = List<String>.from(result?["Locations"]);
  await db.close();
  return data;
}

// add data by creating id to collection and then add data to collection
void mongoadddata(Map<String, dynamic> data) async {
  var db = await Db.create(connectionurl);
  // connect to created connection
  await db.open();
  var collection = db.collection('farmeasy');
  // create random ObjectId for each data to be added
  // var id = ObjectId();
  // data['_id'] = id;
  var result = await collection.insertOne(data);
  print(result.document?.keys.first);
  await db.close();
}
