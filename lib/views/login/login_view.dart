import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_reconcile/views/login/login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> formKey = GlobalKey();
  LoginViewModel _viewModel = Get.put(LoginViewModel());

  TextEditingController emailCtr = TextEditingController();
  TextEditingController passwordCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Norden Communication Middle East FZE',style: TextStyle(
            fontSize: 17, // Set the text size here
          ),),
        backgroundColor: Color.fromARGB(255, 189, 15, 15),
        foregroundColor: Colors.white,
        ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.symmetric(horizontal: 12.0),
        // padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            const SizedBox(
          height: 10,
        ),
            Center(
              
              child: Container(
                width: 200,
                height: 150,
                child: Image.asset('assets/images/main.png'),
              ),
            ),
            const SizedBox(height: 20), // Add some space between the image and the form
            Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: loginForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Form loginForm() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        // const SizedBox(
        //   height: 60,
        // ),
        // Padding( 
              
        Center( 
          child: Text('Login',
          style:TextStyle(fontSize: 24)), 
        ), 
            // ),
        const SizedBox(
          height: 50,
        ),
        
        TextFormField(
          controller: emailCtr,
          validator: (value) {
            return (value == null || value.isEmpty)
                ? 'Please Enter Email'
                : null;
          },
          decoration: inputDecoration('Username', Icons.person),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          obscureText: true,
          validator: (value) {
            return (value == null || value.isEmpty)
                ? 'Please Enter Password'
                : null;
          },
          controller: passwordCtr,
          decoration: inputDecoration('Password', Icons.lock),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState?.validate() ?? false) {
              await _viewModel.loginUser(emailCtr.text, passwordCtr.text);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 32, 139, 226), // Button background color
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // Makes the button rectangular
            ), // Button text (foreground) color
          ),
          child: const Text('Login'),
          
        ),
      ]),
    );
  }
}

InputDecoration inputDecoration(String labelText, IconData iconData,
    {String? prefix, String? helperText}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    helperText: helperText,
    labelText: labelText,
    labelStyle: const TextStyle(color: Colors.grey),
    fillColor: Colors.grey.shade200,
    filled: true,
    prefixText: prefix,
    prefixIcon: Icon(
      iconData,
      size: 20,
    ),
    prefixIconConstraints: const BoxConstraints(minWidth: 60),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.black)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.black)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.black)),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.black)),
  );
}

enum FormType { login, register }
