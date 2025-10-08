import 'package:flutter/material.dart';

Future<T?> navigatePush<T>(BuildContext context, Widget page) {
  return Navigator.push<T>(
    context,
    MaterialPageRoute(builder: (_) => page),
  );
}

void navigatePop(BuildContext context, [Object? result]) {
  Navigator.pop(context, result);
}

Future<T?> navigatePushReplacement<T, TO>(BuildContext context, Widget page) {
  return Navigator.pushReplacement<T, TO>(
    context,
    MaterialPageRoute(builder: (_) => page),
  );
}

Future<T?> navigatePushAndRemoveUntil<T>(BuildContext context, Widget page) {
  return Navigator.pushAndRemoveUntil<T>(
    context,
    MaterialPageRoute(builder: (_) => page),
    (route) => false,
  );
}
