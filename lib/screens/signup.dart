import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import '../helper/auth_jwt_token_helper.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/login_button.dart';
import 'login.dart';
import 'nagging.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup-screen';

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController passwordController = TextEditingController();

  bool sending = false;

  String errorText = '';

  bool passwordError = false;

  void changeSendingState() {
    setState(() {
      sending = !sending;
    });
  }

  Future login(BuildContext context) async {
    if (!sending) {
      errorText = '';
      passwordError = false;

      changeSendingState();

      final password = passwordController.text;

      if (password.isNotEmpty ) {
          try {
            final http.Response response1 = await http.post(
                Uri.parse('https://twitterbutanonymous.pythonanywhere.com/auth/users/'),
                body: {
                  'password': password
                });
            final Map idMap = json.decode(response1.body);
            switch (response1.statusCode) {
              case 201:
                {
                  try {
                    final http.Response response2 = await http.post(
                        Uri.parse('https://twitterbutanonymous.pythonanywhere.com/auth/jwt/create/'),
                        body: {'id': idMap['id'].toString(), 'password': password});
                    final Map tokensMap = json.decode(response2.body);
                    switch (response2.statusCode) {
                      case 200:
                        {
                          await AuthToken.saveFromMap(tokensMap);
                          Navigator.popAndPushNamed(context, NaggingScreen.routeName);
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
                  break;
                }
              case 400:
                {
                  for (String? key in idMap.keys) {
                    for (String? value in idMap[key]) {
                      errorText += '$key: $value \n';
                    }
                  }
                  break;
                }
              case 401:
                {
                  for (String? key in idMap.keys) {
                    errorText += '$key: ${idMap[key]}';
                  }
                }
            }
          } on SocketException catch (_) {
            errorText = "There is no internet connection";
          } catch (_) {
            errorText = "Something went wrong";
            rethrow;
        }
      } else {
        passwordError = true;
        errorText = "Fill the forms.";
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
              child: Text('Create Account',
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold, fontSize: 35)),
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
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        title: 'Create Account'),
                    const SizedBox(height: 35),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(
                        LoginScreen.routeName,
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Already have an account? ',
                              ),
                              TextSpan(
                                text: 'Log in',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                    color: const Color.fromRGBO(
                                        15, 106, 255, 1)),
                              ),
                            ],
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
