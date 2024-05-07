import 'package:burgan_task/utils/constants.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/asymmetric/api.dart';
import '../model/user_model.dart';

class AuthRepository {
  const AuthRepository();

  login(User user) async {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: user.email!.trim(),
      password: user.password!,
    );
    if (userCredential.user != null && (userCredential.user?.emailVerified ?? false)) {
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref("users/${userCredential.user!.uid}");
      var userSnapshot = await databaseReference.get();
      Map<dynamic, dynamic> map = (userSnapshot.value as Map<dynamic, dynamic>);
      User user = User.fromJson(map);
      user.id = userCredential.user!.uid;
      return user;
    }
  }

  loginWithBiometric() async {
    await FirebaseAuth.instance.signInAnonymously();
  }

  Future<User> signup(User user) async {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: user.email!.trim(),
      password: user.password!,
    )
        .then((d) async {
      final publicKey = await convertStringToRSA<RSAPublicKey>(publicStringKey);
      final privateKey = await convertStringToRSA<RSAPrivateKey>(privateStringKey);

      Encrypter encrypter = Encrypter(RSA(publicKey: publicKey, privateKey: privateKey));
      final encryptedPhone = user.phone;
      final encryptedData = encrypter.encrypt(encryptedPhone ?? '');
      debugPrint('Encrypted Data: ${encryptedData.base64}');
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref("users/${d.user!.uid}");
      databaseReference.set({
        'name': user.username,
        'email': user.email,
        'phone': encryptedData.base64,
      });
      await d.user?.sendEmailVerification();
      var userSnapshot = await databaseReference.get();
      Map<dynamic, dynamic> map = (userSnapshot.value) as Map<dynamic, dynamic>;
      User newUser = User.fromJson(map);
      newUser.id = d.user!.uid;
      newUser.phone = encrypter.decrypt(encryptedData);
      return newUser;
    });
  }

  Future<T> convertStringToRSA<T extends RSAAsymmetricKey>(String key) async {
    final parser = RSAKeyParser();
    return parser.parse(key) as T;
  }
}
