import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mobile_login_system_app/screens/home.dart';
import 'package:mobile_login_system_app/widgets/custom_password_field.dart';
import 'package:mobile_login_system_app/widgets/custom_textfield.dart';
import 'package:realm/realm.dart';

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

  final app = App(AppConfiguration('loginapp-jlkjb'));

  Future<void> _createAccount(BuildContext context) async {
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

    // Create account
    EmailPasswordAuthProvider authProvider = EmailPasswordAuthProvider(app);
    await authProvider.registerUser(email, password);

    //final user = app.currentUser;
    //final updatedUserData = {'fullName': fullName, 'phoneNumber': phone};

    //final functionResponse =
    //await user?.functions.call('writeCustomUserData', [updatedUserData]);

    // Login the user upon successful account creation
    final emailPwCredentials = Credentials.emailPassword(email, password);

    app.logIn(emailPwCredentials).then((value) {
      // If all validations pass, login user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully. You are now logged in.'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to home screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('There was an error creating account. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    });
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
