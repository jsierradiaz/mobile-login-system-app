import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mobile_login_system_app/screens/home.dart';
import 'package:mobile_login_system_app/services/auth_service.dart';
import 'package:mobile_login_system_app/utils/secrets.dart';
import 'package:mobile_login_system_app/widgets/custom_password_field.dart';
import 'package:mobile_login_system_app/widgets/custom_textfield.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  CreateAccountState createState() => CreateAccountState();
}

class CreateAccountState extends State<CreateAccount> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> _createAccount(BuildContext context) async {
    final realmAppId = Secrets.realmAppId;

    var navigator = Navigator.of(context);
    var messager = ScaffoldMessenger.of(context);

    // Handle account creation logic here
    String fullName = fullNameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (email.isEmpty ||
        fullName.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
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

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if password is strong
    pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    regex = RegExp(pattern);
    if (!regex.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one number, and one special character.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Register a user

    var authService = AuthService(realmAppId);
    try {
      await authService.register(email, password);
      // Navigate to home screen

      messager.showSnackBar(
        const SnackBar(
          content: Text('Account created successfully'),
          backgroundColor: Colors.green,
        ),
      );
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      messager.showSnackBar(
        const SnackBar(
          content: Text('Failed to create account'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Create Account'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Gap(20.0),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label:
                        const Text('Back', style: TextStyle(fontSize: 18.0))),
              ),
              const Gap(40.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple),
                ),
              ),
              const Gap(40.0),
              CustomTextField(
                  controller: fullNameController,
                  labelText: 'Full Name',
                  labelColor: Colors.purple,
                  prefixIcon: Icons.person),
              const Gap(40.0),
              CustomTextField(
                  controller: emailController,
                  labelText: 'Email',
                  labelColor: Colors.purple,
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress),
              const Gap(40.0),
              CustomTextField(
                  controller: phoneController,
                  labelText: 'Phone',
                  labelColor: Colors.purple,
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone),
              const Gap(40.0),
              CustomPasswordField(
                controller: passwordController,
                labelText: 'Password',
                labelColor: Colors.purple,
                prefixIcon: Icons.lock,
              ),
              const Gap(40.0),
              CustomPasswordField(
                controller: confirmPasswordController,
                labelText: 'Confirm Password',
                labelColor: Colors.purple,
                prefixIcon: Icons.lock,
              ),
              const Gap(40.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.purple),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    // Handle login logic here
                    _createAccount(context);
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
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
