import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mobile_login_system_app/screens/create_account.dart';
import 'package:mobile_login_system_app/screens/home.dart';
import 'package:mobile_login_system_app/services/auth_service.dart';
import 'package:mobile_login_system_app/utils/secrets.dart';
import 'package:mobile_login_system_app/widgets/custom_password_field.dart';
import 'package:mobile_login_system_app/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String realmAppId = Secrets.realmAppId;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    // Handle login logic here
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    // Check if email is valid
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    var authService = AuthService(realmAppId);

    try {
      await authService.login(email, password);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful'),
          backgroundColor: Colors.green,
        ),
      );

      // // Navigate to home screen
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Gap(40.0),
                Image.asset(
                  'assets/images/mobile_login_system_logo.png',
                  //height: 200.0,
                ),
                const Gap(40.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple),
                  ),
                ),
                const Gap(40.0),
                CustomTextField(
                  controller: emailController,
                  labelText: 'Email',
                  labelColor: Colors.purple,
                  prefixIcon: Icons.person,
                  keyboardType: TextInputType.emailAddress,
                ),
                const Gap(40.0),
                CustomPasswordField(
                  controller: passwordController,
                  labelText: 'Password',
                  labelColor: Colors.purple,
                  prefixIcon: Icons.lock,
                ),
                const Gap(20.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(
                        Colors.purple.withOpacity(0.1),
                      ),
                    ),
                    onPressed: () {
                      // Handle forgot password logic here
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),
                ),
                const Gap(20.0),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.purple),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          _login();
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(20.0),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    child: const Text(
                      'Don\'t have an account? Sign Up',
                      style: TextStyle(color: Colors.purple),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateAccount()));
                    },
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
