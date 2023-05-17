import 'package:firebase_tutorial/View%20Model/auth/loginphone_view_model.dart';
import 'package:firebase_tutorial/View%20Model/auth/signup_view_model.dart';
import 'package:flutter/material.dart';
import '../../Model/Error Message/error_message.dart';
import '../../Model/Widgets/login_button.dart';
import '../../Utils/Colors/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../post/post_view_model.dart';

class LoginViewModel extends StatefulWidget {
  const LoginViewModel({super.key});

  @override
  State<LoginViewModel> createState() => _LoginViewModelState();
}

class _LoginViewModelState extends State<LoginViewModel> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fromkey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isHidden = ValueNotifier<bool>(true);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();

  bool loading = false;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordNode.dispose();
    emailNode.dispose();
  }

  void fetchLogin() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      ErrorMessage.toastMessage(
          // value.user!.email.toString()
          'Login Sucessfully');
      setState(() {
        loading = false;
      });
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const PostViewModel()));
    }).onError((error, stackTrace) {
      ErrorMessage.toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: fromkey,
                  child: ValueListenableBuilder(
                      valueListenable: _isHidden,
                      builder: (context, value, child) {
                        return Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.alternate_email_sharp),
                                  hintText: "Enter Your Email Address"),
                              focusNode: emailNode,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(passwordNode);
                              },
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Email Required';
                                } else if (!val.contains("@") ||
                                    !val.contains('.')) {
                                  return 'sample@gmail.com';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: height * 0.020,
                            ),
                            TextFormField(
                                controller: passwordController,
                                obscureText: _isHidden.value,
                                obscuringCharacter: '*',
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.lock_outline_rounded),
                                    hintText: "Enter Your Password",
                                    suffixIcon: InkWell(
                                        onTap: () {
                                          _isHidden.value = !_isHidden.value;
                                        },
                                        child: Icon(_isHidden.value
                                            ? Icons.visibility_off
                                            : Icons.visibility_rounded))),
                                focusNode: passwordNode,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Password Required';
                                  } else if (val.length < 8) {
                                    return 'Maximum use 8 Character';
                                  } else {
                                    return null;
                                  }
                                }),
                          ],
                        );
                      })),
              SizedBox(
                height: height * 0.085,
              ),
              LoginButton(
                title: "Login",
                loading: loading,
                onpress: () {
                  if (fromkey.currentState!.validate()) {
                    fetchLogin();
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Dont't have an Account? ",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupViewModel()));
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            color: AppColors.loginButtonColor, fontSize: 18),
                      )),
                ],
              ),
              SizedBox(
                height: height * 0.020,
              ),
              LoginButton(
                  title: 'Login with Phone no',
                  onpress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const LoginPhoneNoViewModel()));
                  }),
            ]),
      ),
    );
  }
}
