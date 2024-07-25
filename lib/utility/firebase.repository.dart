import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoapp/utility/customException.dart';

class FirebaseRepository {
  Future<UserCredential?> signUp(
      {required String email, required String password}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw CustomException(msg: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw CustomException(
            msg: 'The account already exists for that email.');
      }
    } catch (e) {
      throw CustomException(msg: e.toString());
    }
  }

  Future<UserCredential?> signIn(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  String? loginStatus() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  final instance = FirebaseAuth.instance;
}
