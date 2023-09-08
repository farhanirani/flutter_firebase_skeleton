import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mitch/controllers/get_user_details.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  String currentUserName = 'loading';
  int currentUserAge = 0;

  List<String> allNames = [];
  List<String> docIds = [];

  Future getDocIds() async {
    await FirebaseFirestore.instance
        .collection('users')
        .orderBy('age', descending: false)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              docIds.add(document.reference.id);
              allNames.add(document.data()['name'] ?? 'Empty');
            }));
  }

  Future getCurrentUserDetails() async {
    if (currentUserName == 'loading') {
      await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .get()
          .then(
        (singleUserQuery) {
          print("Successfully completed");
          if (singleUserQuery.docs.isNotEmpty) {
            print(
                'User found : ${singleUserQuery.docs[0].id} => ${singleUserQuery.docs[0].data()}');

            currentUserName = singleUserQuery.docs[0].data()['name'];
            currentUserAge = singleUserQuery.docs[0].data()['age'];
          } else {
            print('No user found for this UID');
          }
        },
        onError: (e) => print("Error completing: $e"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text('Signed In :  ${user.email!}'),
              Text('User Id :  ${user.uid}'),
              _userDetails(),
              _signOutButton(),
              _bodyData(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      title: FutureBuilder(
        future: getCurrentUserDetails(),
        builder: (context, snapshot) {
          return Text(
            currentUserName,
            style: const TextStyle(fontSize: 16),
          );
        },
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          textColor: Colors.white,
          child: const Icon(Icons.logout),
        )
      ],
    );
  }

  FutureBuilder<dynamic> _userDetails() {
    return FutureBuilder(
      future: getCurrentUserDetails(),
      builder: (context, snapshot) {
        return Column(
          children: [
            Text('Current user name : $currentUserName'),
            Text('Current user age : $currentUserAge'),
          ],
        );
      },
    );
  }

  Padding _signOutButton() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: MaterialButton(
          padding: const EdgeInsets.symmetric(vertical: 20),
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          color: Colors.deepPurple,
          textColor: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Sign Out'),
            ],
          )),
    );
  }

  Expanded _bodyData() {
    return Expanded(
      child: FutureBuilder(
        future: getDocIds(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: allNames.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  tileColor: Colors.grey[200],
                  title: GetUserDetails(documentId: docIds[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
