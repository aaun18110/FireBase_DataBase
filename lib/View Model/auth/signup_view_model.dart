import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../Model/Error Message/error_message.dart';
import '../../Utils/Colors/app_colors.dart';
import '../../Model/Widgets/login_button.dart';
import 'login_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupViewModel extends StatefulWidget {
  const SignupViewModel({super.key});

  @override
  State<SignupViewModel> createState() => _SignupViewModelState();
}

class _SignupViewModelState extends State<SignupViewModel> {
  final _auth = FirebaseAuth.instance;
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

  void fetchSignup() {
    setState(() {
      loading = true;
    });
    _auth
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginViewModel()));
      setState(() {
        loading = false;
      });
      ErrorMessage.toastMessage('Submit Sucessfully');
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      ErrorMessage.toastMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Apply Registration"),
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
                title: "Sign up",
                loading: loading,
                onpress: () {
                  if (kDebugMode) {
                    print("tap");
                  }
                  if (fromkey.currentState!.validate()) {
                    fetchSignup();
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an Account? ",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginViewModel()));
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: AppColors.loginButtonColor, fontSize: 18),
                      )),
                ],
              )
            ]),
      ),
    );
  }
}
