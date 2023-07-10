import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../api/api_service.dart';
import '../model/register_response.dart';
import '../provider/auth_provider.dart';
import '../utils/color_theme.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onRegister;
  final Function() onLogin;

  const RegisterScreen({
    Key? key,
    required this.onRegister,
    required this.onLogin,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late Future<RegisterResponse> registerResponse;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Register Screen"),
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
                  'Please enter your e-mail address and create password',
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
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Full Name",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.account_circle_outlined,
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
                      const SizedBox(height: 132),
                      context.watch<AuthProvider>().isLoadingRegister
                          ? ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: green,
                                  minimumSize: Size(300, 60),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: const Center(
                                  child: CircularProgressIndicator(color: white)))
                          : ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  final scaffoldMessenger =
                                  ScaffoldMessenger.of(context);
                                  final authRead = context.read<AuthProvider>();
                                  authRead.registerState(true);

                                  registerResponse =
                                      ApiService().registerResponse(
                                    http.Client(),
                                    nameController.text,
                                    emailController.text,
                                    passwordController.text,
                                  );

                                  registerResponse.then((value) async {
                                    if (value.error) {
                                      authRead.registerState(false);
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
                                      final result =
                                          await authRead.registerComplete();
                                      if (result) widget.onRegister();
                                    }
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: green,
                                  minimumSize: Size(300, 60),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: Text(
                                "Sign Up",
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
                            "Already have an account? ",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: white),
                          ),
                          InkWell(
                              onTap: () => widget.onLogin(),
                              child: Text(
                                "Login",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: lightGreen,
                                        fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                      // const SizedBox(height: 8),
                      // OutlinedButton(
                      //   onPressed: () => widget.onLogin(),
                      //   child: const Text("LOGIN"),
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
                              'Sign up with',
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
                          Image.asset('images/facebook.png', scale: 2),
                          Image.asset('images/google.png', scale: 2),
                          Image.asset('images/twitter.png')
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
