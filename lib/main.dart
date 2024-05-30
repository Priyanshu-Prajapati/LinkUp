import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:social_media_app/auth/auth.dart';
import 'package:social_media_app/firebase_options.dart';
// import 'package:social_media_app/auth/login_or_register.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    ),
  );
}
