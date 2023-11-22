import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mhike_app/screens/auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Screen'),
      ),
      body: Center(
        child: Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blueGrey),
                    ),
                    child: const Text("Log Out",
                        style: TextStyle(
                          fontSize: 17,
                        )),
                    onPressed: () {
                      Get.to(() => LogInScreen());
                    },
                  ),
                ),
      ),
    );
  }
}