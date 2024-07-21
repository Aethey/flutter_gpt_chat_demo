import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../home/home_page.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> _authUser(LoginData data) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
      debugPrint("Logged in: ${userCredential.user?.email}");
      return null;
    } catch (e) {
      debugPrint("Login failed: $e");
      return 'Login failed: ${e.toString()}';
    }
  }

  // default?
  Future<String?> _signupUser(SignupData data) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: data.name!,
        password: data.password!,
      );
      await userCredential.user?.sendEmailVerification();
      debugPrint("Registered user: ${userCredential.user?.email}");
      return null;
    } catch (e) {
      debugPrint("Registration failed: $e");
      return 'Registration failed: ${e.toString()}';
    }
  }

  Future<String?> _recoverPassword(String name) async {
    try {
      await _auth.sendPasswordResetEmail(email: name);
      debugPrint("Password recovery email sent to: $name");
      return null;
    } catch (e) {
      debugPrint("Password recovery failed: $e");
      return 'Password recovery failed: ${e.toString()}';
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      debugPrint("Signed in with Google: ${userCredential.user?.displayName}");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'AIChat',
      // logo: const AssetImage('assets/images/robot.png'),
      theme: LoginTheme(
          primaryColor: Colors.black,
          accentColor: Colors.grey,
          errorColor: Colors.deepOrange,
          titleStyle: const TextStyle(fontWeight: FontWeight.bold),
          cardTheme: CardTheme(
            color: Colors.white,
            elevation: 1,
            margin: const EdgeInsets.only(top: 4),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
          ),
          buttonTheme: const LoginButtonTheme()),
      onLogin: _authUser,
      onSignup: _signupUser,
      loginProviders: <LoginProvider>[
        LoginProvider(
          // icon: FontAwesomeIcons.google,
          label: "Sign in with Google",
          button: Buttons.google,
          callback: () async {
            debugPrint('start google sign in');
            await _signInWithGoogle(context);
            debugPrint('stop google sign in');
            return null;
          },
        ),
        // LoginProvider(
        //   icon: FontAwesomeIcons.githubAlt,
        //   callback: () async {
        //     debugPrint('start github sign in');
        //     await Future.delayed(loginTime);
        //     debugPrint('stop github sign in');
        //     return null;
        //   },
        // ),
      ],
      onSubmitAnimationCompleted: () {
        //
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
