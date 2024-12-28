import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_reconcile/utils/authentication_manager.dart';
import 'package:stock_reconcile/views/home_view.dart';
import 'package:stock_reconcile/views/login/login_view.dart';

class OnBoard extends StatelessWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticationManager _authManager = Get.find();

    return Obx(() {
      return _authManager.isLogged.value ? const HomeView() : const LoginView();
    });
  }
}
