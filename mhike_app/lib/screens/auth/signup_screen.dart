// signup_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mhike_app/database/database_helper.dart';
import 'package:mhike_app/screens/auth/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signUpMethod() async {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (username.isEmpty) {
      Get.snackbar(
          backgroundColor: Colors.white, 'Error', 'Please enter your username');
    } else if (email.isEmpty) {
      Get.snackbar(
          backgroundColor: Colors.white, 'Error', 'Please enter your email');
    } else if (password.isEmpty) {
      Get.snackbar(
          backgroundColor: Colors.white, 'Error', 'Please enter your password');
    } else {
      await DatabaseHelper().signUp(username, email, password);
      // Sau khi đăng ký thành công, bạn có thể chuyển đến màn hình đăng nhập hoặc thực hiện các hành động khác.
      Get.to(() => LogInScreen());
      print('Sign Up successful');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset("assets/signup.png"),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'User Name',
                  prefixIcon: Icon(Icons.person),
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
              const SizedBox(height: 20),
              SizedBox(
                height: 70,
                width: 250,
                child: ElevatedButton(
                  onPressed: signUpMethod,
                  child: Text(
                    'Sign Up',
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
