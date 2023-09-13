import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future<void> googleLogin() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      _user = googleUser;

      final googleAuth = await googleUser.authentication;
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential res =
          await FirebaseAuth.instance.signInWithCredential(authCredential);

      // Save User details in database
      bool newUser = true;
      String docId = "";
      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: res.user?.email)
          .get()
          .then(
            (singleUserQuery) => {
              if (singleUserQuery.docs.isNotEmpty)
                {
                  newUser = false,
                  docId = singleUserQuery.docs[0].id,
                }
            },
            onError: (e) => print("Error completing: $e"),
          );

      if (newUser) {
        await FirebaseFirestore.instance.collection('users').add({
          'name': res.user?.displayName,
          'age': 0,
          'email': res.user?.email,
          'phoneNumber': res.user?.phoneNumber,
          'photoURL': res.user?.photoURL,
          'emailVerified': res.user?.emailVerified,
          'uid': res.user?.uid,
        });
      } else {
        await FirebaseFirestore.instance.collection('users').doc(docId).update({
          'name': res.user?.displayName,
          'age': 10,
          'email': res.user?.email,
          'phoneNumber': res.user?.phoneNumber,
          'photoURL': res.user?.photoURL,
          'emailVerified': res.user?.emailVerified,
          'uid': res.user?.uid,
        });
      }
    } on FirebaseAuthException catch (e) {
      AlertDialog(
        title: const Text("Error"),
        content: Text('Failed to sign in with Google: $e.message'),
      );
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn().disconnect();
    await FirebaseAuth.instance.signOut();
  }
}
