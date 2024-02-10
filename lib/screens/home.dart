import 'package:flutter/material.dart';
import 'package:mobile_login_system_app/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('Welcome to the home screen!'),
      ),
      drawer: CustomDrawer(),
    );
  }
}
