import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

// generate unique codes
Set<String> existingCodes = {}; // Set to store existing codes
String generateCode({required int length, Set<String>? existingCodes  ,String? name}) {
  const characters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  String code;

  do {
    code = List.generate(
      length,
      (_) => characters[random.nextInt(characters.length)],
    ).join();
  } while (existingCodes!.contains(code)); // ensure uniqueness

  existingCodes.add(code); // save for future checks
  return code;
}

// generate random color
generateRandomColor() {
  final random = Random();
  final color = Color.fromARGB(
    255, // full opacity
    random.nextInt(256), // red
    random.nextInt(256), // green
    random.nextInt(256), // blue
  );

  return color;
}

// show toast messages
showToastification({BuildContext? context, String? message}) {
  toastification.show(
    context: context, // optional if you use ToastificationWrapper
    title: Text(message!),
    animationDuration: const Duration(seconds: 2),
    autoCloseDuration: const Duration(seconds: 3),
  );
}

// copy
copyToClipboard({String? text}) {
  Clipboard.setData(ClipboardData(text: text!));
}

// show snackbar messages
void showMessage(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

void navigateToWithGoRouter({required BuildContext context, required String path, dynamic extra, }) {
  GoRouter.of(context).push(path, extra: extra);
}


void navigateReplacementWithGoRouter({required BuildContext context, required String path, dynamic extra, }) {
  GoRouter.of(context).replace(path, extra: extra);
}

// context.read<UserDetailsCubit>().navigateTo( context: context,path: AppScreens.debitScreen, );