import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mhike_app/database/database_helper.dart';
import 'package:mhike_app/screens/auth/signup_screen.dart';
import 'package:mhike_app/screens/navbar_bottom.dart';

class LogInScreen extends StatefulWidget {
  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void loginMethod() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    bool loggedIn = await DatabaseHelper().login(email, password);

    if (email.isEmpty) {
      Get.snackbar(
          backgroundColor: Colors.white,
          'Error',
          'Please enter your email and password');
    } else if (password.isEmpty) {
      Get.snackbar(
          backgroundColor: Colors.white, 'Error', 'Please enter your password');
    } else {
      if (loggedIn) {
        Get.to(() => NavBarBottom());
        print('Login successful');
      } else {
        // Xử lý trường hợp đăng nhập không thành công, ví dụ hiển thị thông báo lỗi.
        print('Login failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset('assets/login.png'),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.password),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  text: "Don't have an account? ",
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Register now",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(() => SignUpScreen());
                        },
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                height: 70,
                width: 200,
                child: ElevatedButton(
                  onPressed: loginMethod,
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
