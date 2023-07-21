import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:story_app_flutter/utils/color_theme.dart';
import 'package:story_app_flutter/widget/social_widget.dart';

import '../api/api_service.dart';
import '../model/login_response.dart';
import '../provider/auth_provider.dart';
import '../utils/style_theme.dart';

class LoginScreen extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;

  const LoginScreen({
    Key? key,
    required this.onLogin,
    required this.onRegister,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Future<LoginResponse> loginResponse;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final ratio = screenSize.height / 803.137269;
    return Scaffold(
      backgroundColor: grey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.08),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'story',
                  style: displaySmall(
                    context,
                    ratio,
                    white,
                  ),
                ),
                Text(
                  'app',
                  style: displaySmall(
                    context,
                    ratio,
                    lightGreen,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.03),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenSize.width * 0.6),
              child: Text(
                'Please enter your e-mail address and enter password',
                style: titleMedium(
                  context,
                  ratio,
                  white,
                  null,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: screenSize.height * 0.05),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: screenSize.width * 0.7),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email.';
                          } else if (!EmailValidator.validate(value)) {
                            return 'Please enter a valid email.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your email",
                          hintStyle: titleMedium(
                            context,
                            ratio,
                            Colors.grey,
                            null,
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: lightGreen,
                            size: ratio * 24,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: white),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: lightGreen),
                          ),
                        ),
                        style: titleMedium(
                          context,
                          ratio,
                          white,
                          null,
                        ),
                        cursorColor: white,
                      ),
                      SizedBox(height: screenSize.height * 0.03),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          hintStyle: titleMedium(
                            context,
                            ratio,
                            Colors.grey,
                            null,
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: lightGreen,
                            size: ratio * 24,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: white),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: lightGreen),
                          ),
                        ),
                        style: titleMedium(
                          context,
                          ratio,
                          white,
                          null,
                        ),
                        cursorColor: white,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password.';
                          } else if (value.length < 8) {
                            return 'Password must be at least 8 characters.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenSize.height * 0.25),
                      context.watch<AuthProvider>().isLoadingLogin
                          ? ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: green,
                                minimumSize: Size(
                                  screenSize.width * 0.07,
                                  screenSize.height * 0.08,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(color: white),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  final scaffoldMessenger =
                                      ScaffoldMessenger.of(context);
                                  final authRead = context.read<AuthProvider>();
                                  authRead.loginState(true);

                                  loginResponse = ApiService().loginResponse(
                                    http.Client(),
                                    emailController.text,
                                    passwordController.text,
                                  );

                                  loginResponse.then(
                                    (value) async {
                                      if (value.error) {
                                        authRead.loginState(false);
                                        scaffoldMessenger.showSnackBar(
                                          SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: green,
                                            content: Text(
                                              value.message,
                                              style: titleMedium(
                                                context,
                                                ratio,
                                                white,
                                                null,
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        scaffoldMessenger.showSnackBar(
                                          SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: green,
                                            content: Text(
                                              value.message,
                                              style: titleMedium(
                                                context,
                                                ratio,
                                                white,
                                                null,
                                              ),
                                            ),
                                          ),
                                        );
                                        final result = await authRead
                                            .login(value.loginResult);
                                        if (result) {
                                          widget.onLogin();
                                        } else {
                                          scaffoldMessenger.showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "Your email or password is invalid"),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: green,
                                minimumSize: Size(
                                  screenSize.width * 0.07,
                                  screenSize.height * 0.08,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                "Login",
                                style: titleMedium(
                                  context,
                                  ratio,
                                  white,
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                      SizedBox(height: screenSize.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: titleMedium(
                              context,
                              ratio,
                              white,
                              null,
                            ),
                          ),
                          InkWell(
                            onTap: () => widget.onRegister(),
                            child: Text(
                              "Sign Up",
                              style: titleMedium(
                                context,
                                ratio,
                                lightGreen,
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.05),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 1,
                            width: screenSize.width * 0.7,
                            child: const DecoratedBox(
                              decoration: BoxDecoration(color: white),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: const BoxDecoration(color: grey),
                            child: Text(
                              'Sign in with',
                              style: titleMedium(
                                context,
                                ratio,
                                white,
                                null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SocialWidget(
                            source: 'images/facebook.png',
                            ratio: ratio,
                            height: screenSize.height,
                          ),
                          SocialWidget(
                            source: 'images/google.png',
                            ratio: ratio,
                            height: screenSize.height,
                          ),
                          SocialWidget(
                            source: 'images/twitter.png',
                            ratio: ratio,
                            height: screenSize.height,
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.05)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
