import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Database {
  late FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  Future<void> create(int PhoneNumber, String location) async {
    try {
      await firestore.collection("userlocation").add({
        'PhoneNumber': PhoneNumber,
        'Location': location,
        'timestamp': FieldValue.serverTimestamp()
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await firestore.collection("userlocation").doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<List> read() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot =
          await firestore.collection('userlocation').orderBy('timestamp').get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "PhoneNumber": doc['PhoneNumber'],
            "Location": doc["location"]
          };
          docs.add(a);
        }
        return docs;
      }
    } catch (e) {
      print(e);
      return docs;
    }
    return docs;
  }

  Future<void> update(String id, int PhoneNumber, String location) async {
    try {
      await firestore
          .collection("userlocation")
          .doc(id)
          .update({'PhoneNumber': PhoneNumber, 'Location': location});
    } catch (e) {
      print(e);
    }
  }
}
