import 'package:flutter/material.dart';
import 'package:mobile_login_system_app/screens/login.dart';
import 'package:mobile_login_system_app/services/auth_service.dart';
import 'package:mobile_login_system_app/utils/secrets.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final realmAppId = Secrets.realmAppId;
    var authService = AuthService(realmAppId);
    try {
      await authService.logout();
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout Failed'),
            content: Text('Failed to log out user: $e'),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
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
            onTap: () {
              _logout(context);

              // Update the state of the app
            },
          ),
        ],
      ),
    );
  }
}
