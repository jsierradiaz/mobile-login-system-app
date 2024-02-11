import 'package:realm/realm.dart';

class AuthService {
  final App app;

  AuthService(String appId) : app = App(AppConfiguration(appId));

  Future<User> register(String email, String password) async {
    EmailPasswordAuthProvider authProvider = EmailPasswordAuthProvider(app);
    await authProvider.registerUser(email, password);
    var credentials = Credentials.emailPassword(email, password);
    return await app.logIn(credentials);
  }

  Future<User> login(String email, String password) async {
    var credentials = Credentials.emailPassword(email, password);
    return await app.logIn(credentials);
  }

  Future<void> logout() async {
    User? user = app.currentUser;
    if (user != null) {
      await user.logOut();
      user = null;
    }
  }

  User? getCurrentUser() {
    return app.currentUser;
  }
}
