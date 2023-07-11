import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:story_app_flutter/utils/color_theme.dart';

import '../api/api_service.dart';
import '../model/login_response.dart';
import '../provider/auth_provider.dart';

/// todo 14: create LoginScreen
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
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Login Screen"),
      // ),
      backgroundColor: grey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'story',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: white, fontWeight: FontWeight.bold),
                ),
                Text(
                  'app',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: lightGreen, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 250),
                child: Text(
                  'Please enter your e-mail address and enter password',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: white),
                  textAlign: TextAlign.center,
                )),
            SizedBox(height: 40),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),

                /// todo 16: add Form widget to handle form component, and
                /// add component key
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /// todo 15: add component like TextFormField and Button,
                      /// add component like controller, hint, obscureText, and onPressed,
                      /// dispose that controller, and
                      /// add validation to validate the text.
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
                            hintStyle: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: lightGreen,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: lightGreen))),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: white),
                        cursorColor: white,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Enter your password",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: lightGreen,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: lightGreen))),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: white),
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
                      const SizedBox(height: 200),

                      /// todo 18: update the UI when button is tapped.
                      context.watch<AuthProvider>().isLoadingLogin
                          ? ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: green,
                                  minimumSize: Size(300, 60),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: const Center(
                                  child:
                                      CircularProgressIndicator(color: white)))
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

                                  loginResponse.then((value) async {
                                    if (value.error) {
                                      authRead.loginState(false);
                                      scaffoldMessenger.showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: green,
                                          content: Text(
                                            value.message,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(color: white),
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
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(color: white),
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
                                  });

                                  // final scaffoldMessenger =
                                  //     ScaffoldMessenger.of(context);
                                  // final User user = User(
                                  //   email: emailController.text,
                                  //   password: passwordController.text,
                                  // );
                                  // final authRead = context.read<AuthProvider>();

                                  // final result = await authRead.login(user);
                                  // if (result) {
                                  //   widget.onLogin();
                                  // } else {
                                  //   scaffoldMessenger.showSnackBar(
                                  //     const SnackBar(
                                  //       content:
                                  //           Text("Your email or password is invalid"),
                                  //     ),
                                  //   );
                                  // }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: green,
                                  minimumSize: Size(300, 60),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: Text(
                                "Login",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: white,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: white),
                          ),
                          InkWell(
                              onTap: () => widget.onRegister(),
                              child: Text(
                                "Sign Up",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: lightGreen,
                                        fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                      // /// todo 19: update the function when button is tapped.
                      // OutlinedButton(
                      //   onPressed: () => widget.onRegister(),
                      //   child: const Text("REGISTER"),
                      // ),
                      SizedBox(height: 40),
                      Stack(alignment: Alignment.center, children: [
                        SizedBox(
                          height: 1,
                          width: 300,
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: white),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(color: grey),
                            child: Text(
                              'Sign in with',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: white),
                            )),
                      ]),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Container(
                          //   padding: EdgeInsets.all(10),
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     color: Colors.grey
                          //   ),
                          //     child: Image.asset('images/facebook.png', scale: 2,)),
                          // Container(
                          //     padding: EdgeInsets.all(10),
                          //     decoration: BoxDecoration(
                          //         shape: BoxShape.circle,
                          //         color: Colors.grey
                          //     ),
                          //     child: Image.asset('images/facebook.png', scale: 2,)),
                          // Container(
                          //     padding: EdgeInsets.all(10),
                          //     decoration: BoxDecoration(
                          //         shape: BoxShape.circle,
                          //         color: Colors.grey
                          //     ),
                          //     child: Image.asset('images/facebook.png', scale: 2,)),
                          Image.asset('images/facebook.png', scale: 1.5),
                          Image.asset('images/google.png', scale: 1.5),
                          Image.asset('images/twitter.png', scale: 1.5,)
                        ],
                      ),
                      SizedBox(height: 20)
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
