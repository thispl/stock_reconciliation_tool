import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_reconcile/model/login_request_model.dart';
import 'package:stock_reconcile/service/login_service.dart';
import 'package:stock_reconcile/utils/authentication_manager.dart';

class LoginViewModel extends GetxController {
  late final LoginService _loginService;
  late final AuthenticationManager _authManager;

  @override
  void onInit() {
    super.onInit();
    _loginService = Get.put(LoginService());
    _authManager = Get.find();
  }

  Future<void> loginUser(String email, String password) async {
    final response = await _loginService
        .fetchLogin(LoginRequestModel(usr: email, pwd: password));
    if (response != null) {
      /// Set isLogin to true
      _authManager.login(response.token);
    } else {
      /// Show user a dialog about the error response
      Get.defaultDialog(
          middleText: 'User not found!',
          textConfirm: 'OK',
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back();
          });
    }
  }
}
