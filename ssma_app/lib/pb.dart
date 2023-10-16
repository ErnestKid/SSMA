import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('http://127.0.0.1:8090');


Future<void> signUpMethod({
  required String username,
  required String name,
  required String avatar,
  required String password,
  required String confirmPassword,
  required String email,
  required bool isBot,
}) async {
  try {
    final user = await pb.collection('users').create(body: {
      'username': username,
      'password': password,
      'email': email,
      'avatar': avatar,
      'name': name,
      'confirmPassword': confirmPassword,
      'isBot': isBot,
    });
    if (pb.authStore.isValid != false) {
      pb.authStore.save(pb.authStore.token, pb.authStore.model);
    }
    debugPrint(user.toString());
  } catch (error) {
    debugPrint('Error: $error');
  }
}
