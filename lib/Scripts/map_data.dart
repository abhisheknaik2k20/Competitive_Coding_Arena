import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:competitivecodingarena/Core_Project/CodeScreen/Containers/responses.dart';
import 'package:uuid/uuid.dart';

mapdata() {
  for (Map<String, dynamic> data in responses) {
    FirebaseFirestore.instance
        .collection("problems")
        .doc("1")
        .collection("python solutions")
        .doc(const Uuid().v4())
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        return docSnapshot.reference.update(data);
      } else {
        return docSnapshot.reference.set(data);
      }
    }).catchError((error) {
      print("Error updating/creating document: $error");
    });
  }
  for (Map<String, dynamic> data in javaresponses) {
    FirebaseFirestore.instance
        .collection("problems")
        .doc("1")
        .collection("java solutions")
        .doc(const Uuid().v4())
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        return docSnapshot.reference.update(data);
      } else {
        return docSnapshot.reference.set(data);
      }
    }).catchError((error) {
      print("Error updating/creating document: $error");
    });
  }
  for (Map<String, dynamic> data in cppresponses) {
    FirebaseFirestore.instance
        .collection("problems")
        .doc("1")
        .collection("cpp solutions")
        .doc(const Uuid().v4())
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        return docSnapshot.reference.update(data);
      } else {
        return docSnapshot.reference.set(data);
      }
    }).catchError((error) {
      print("Error updating/creating document: $error");
    });
  }
}
