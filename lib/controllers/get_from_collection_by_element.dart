import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetElementFromCollection extends StatelessWidget {
  final String documentId;
  final String jsonElement;

  const GetElementFromCollection(
      {super.key, required this.documentId, required this.jsonElement});

  @override
  Widget build(BuildContext context) {
    // get the collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Text(data[jsonElement]);
        }

        return const Text('Loading...');
      }),
    );
  }
}
