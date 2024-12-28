import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:stock_reconcile/components/background.dart';
import 'package:stock_reconcile/controller/login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: const Text(
                  "LOGIN",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "fantasy",
                      color: Color.fromARGB(255, 228, 8, 8),
                      fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: username,
                  decoration: const InputDecoration(labelText: "Username"),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: password,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: GetX<LoginController>(
                        init: LoginController(),
                        initState: (_) {},
                        builder: (loginController) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            onPressed: () {
                              loginController.checkLogin(username, password);
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
