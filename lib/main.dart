import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'helper/auth_jwt_token_helper.dart';
import 'screens/comment.dart';
import 'screens/login.dart';
import 'screens/nag.dart';
import 'screens/nagging.dart';
import 'screens/profile.dart';
import 'screens/settings.dart';
import 'screens/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: AuthToken.isLogin(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool isLoggedIn = snapshot.data!;
            return MaterialApp(
              title: 'Hallery',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primaryColor: const Color.fromRGBO(111, 211, 255, 1),
                  scaffoldBackgroundColor: const Color.fromRGBO(0, 0, 0, 1),
                  unselectedWidgetColor: Colors.white,
                  // accentColor: ,
                  colorScheme: const ColorScheme.dark(
                    primary: Color.fromRGBO(111, 211, 255, 1),
                  ),
                  textTheme: TextTheme(
                    headlineLarge: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    headlineMedium: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    headlineSmall: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    bodyLarge: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    bodyMedium: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    bodySmall: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  )),
              initialRoute: isLoggedIn
                  ? NaggingScreen.routeName
                  : LoginScreen.routeName,
              routes: {
                LoginScreen.routeName: (ctx) => const LoginScreen(),
                SignUpScreen.routeName: (ctx) => const SignUpScreen(),
                NaggingScreen.routeName: (ctx) => const NaggingScreen(),
                ProfileScreen.routeName: (ctx) => ProfileScreen(),
                SettingScreen.routeName: (ctx) => SettingScreen(),
                NagScreen.routeName: (ctx) => NagScreen(),
                CommentScreen.routeName: (ctx) => const CommentScreen(),
              },
            );
          } else {
            return const MaterialApp();
          }
        });

  }
}