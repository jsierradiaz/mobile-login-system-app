import 'package:flutter/material.dart';
import 'package:mobile_login_system_app/screens/login.dart';
import 'package:mobile_login_system_app/services/auth_service.dart';
import 'package:mobile_login_system_app/utils/secrets.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isLoggedOut = false;

  Future<void> _logout(BuildContext context) async {
    final realmAppId = Secrets.realmAppId;
    var authService = AuthService(realmAppId);
    var navigator = Navigator.of(context);
    var messager = ScaffoldMessenger.of(context);
    try {
      await authService.logout();
      isLoggedOut = true;
    } catch (e) {
      isLoggedOut = false;
    }

    if (isLoggedOut) {
      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      messager.showSnackBar(
        const SnackBar(
          content: Text('An error occurred while logging out'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple,
            ),
            child: Text('Menu'),
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () async {
              await _logout(context);
              // Update the state of the app
              // if (isLoggedOut) {
              //   Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(builder: (context) => const LoginScreen()),
              //   );
              // }
            },
          ),
        ],
      ),
    );
  }
}
