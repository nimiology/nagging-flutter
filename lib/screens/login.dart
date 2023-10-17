import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import '../helper/auth_jwt_token_helper.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/login_button.dart';
import 'nagging.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool sending = false;
  String errorText = '';
  bool usernameError = false;
  bool passwordError = false;

  void changeSendingState() {
    setState(() {
      sending = !sending;
    });
  }

  Future login(BuildContext context) async {
    if (!sending) {
      errorText = '';

      changeSendingState();

      final username = usernameController.text;
      final password = passwordController.text;

      if (username.isNotEmpty && password.isNotEmpty) {
        try {
          http.Response response = await http.post(
              Uri.parse('https://twitterbutanonymous.pythonanywhere.com/auth/jwt/create/'),
              body: {'id': username, 'password': password});
          var tokensMap = json.decode(response.body);
          switch (response.statusCode) {
            case 200:
              {
                AuthToken.saveFromMap(tokensMap);
                Navigator.popAndPushNamed(context, NagsScreen.routeName);
                break;
              }
            case 400:
              {
                for (String? key in tokensMap.keys) {
                  for (String? value in tokensMap[key]) {
                    errorText += '$key: $value \n';
                  }
                }
                break;
              }
            case 401:
              {
                for (String? key in tokensMap.keys) {
                  errorText += '$key: ${tokensMap[key]}';
                }
              }
          }
        } on SocketException catch (_) {
          errorText = "There is no internet connection";
        } catch (e) {
          errorText = "Something went wrong";
        }
      } else if (username.isEmpty) {
        usernameError = true;
        errorText = "Fill the forms";
      } else if (password.isEmpty) {
        passwordError = true;
        errorText = "Fill the forms";
      }

      changeSendingState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 35, top: 40),
              alignment: Alignment.centerLeft,
              child: Text('Log In',
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold, fontSize: 35)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, left: 40, right: 60),
              alignment: Alignment.centerLeft,
              child: Text('lorem ipsum dolor site atemp   kha to kon',
                  style: GoogleFonts.lato(fontSize: 15)),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: usernameController,
                      hintText: 'ID',
                      svg: 'user.svg',
                      enabled: !sending,
                      error: usernameError,
                    ),
                    const SizedBox(height: 25),
                    CustomTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      svg: 'lock.svg',
                      obscureText: true,
                      enabled: !sending,
                      error: passwordError,
                    ),
                    errorText.isNotEmpty
                        ? Center(
                            child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 25),
                                child: Text(
                                  errorText,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headline4!
                                      .copyWith(color: Colors.red),
                                )),
                          )
                        : const SizedBox(height: 30),
                    LoginButton(
                        loading: sending,
                        function: () async {
                          login(context);
                        },
                        title: 'Log In'),
                    const SizedBox(height: 35),
                    GestureDetector(
                      onTap: () => Navigator.of(context).popAndPushNamed(
                        SignUpScreen.routeName,
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(left: 25),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'No Account? ',
                              ),
                              TextSpan(
                                text: 'Create One',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                    color:
                                        const Color.fromRGBO(15, 106, 255, 1)),
                              ),
                            ],
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
