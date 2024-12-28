import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stock_reconcile/views/login/splash_view.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Stock Reconciliation Tool',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: SplashView(),
    );
  }
}
