import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateUserData(String name, String bio) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'bio': bio,
    });
  }
}
