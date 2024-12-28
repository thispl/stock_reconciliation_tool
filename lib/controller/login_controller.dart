import 'package:get/get.dart';

class LoginController extends GetxController {
  LoginController();

  final isLoading = true.obs;

  checkLogin(username, password) {
    print(username);
    print(password);
  }
}
