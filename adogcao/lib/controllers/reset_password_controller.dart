import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResetpasswordController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<void> resetPassword(String email) async {
      await _auth.sendPasswordResetEmail(email: email);
    }

    Future<bool> emailExiste(String email) async
    {
      var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

      if(querySnapshot.docs.isNotEmpty){
        return true;
      }
      return false;
    }

}
