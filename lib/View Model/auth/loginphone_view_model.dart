import 'package:firebase_tutorial/Model/Widgets/login_button.dart';
import 'package:firebase_tutorial/View%20Model/auth/verfication_view_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Model/Error Message/error_message.dart';

class LoginPhoneNoViewModel extends StatefulWidget {
  const LoginPhoneNoViewModel({super.key});

  @override
  State<LoginPhoneNoViewModel> createState() => _LoginPhoneNoViewModelState();
}

class _LoginPhoneNoViewModelState extends State<LoginPhoneNoViewModel> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneNoController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    phoneNoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage("assets/images/verify.png")),
                )),
            Text(
              "Phone Verification",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurpleAccent.shade400,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: phoneNoController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintText: "+92 3004578098",
                    labelText: "Phone no",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: const Icon(Icons.phone)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Phone no required';
                  }
                  else if (value.length <= 12) {
                    return '+92 3007845902';
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            LoginButton(
                title: 'Send Verify Code',
                loading: loading,
                onpress: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    auth.verifyPhoneNumber(
                        phoneNumber: phoneNoController.text,
                        verificationCompleted: (_) {
                          setState(() {
                            loading = false;
                          });
                        },
                        verificationFailed: (e) {
                          ErrorMessage.toastMessage(e.toString());
                          setState(() {
                            loading = false;
                          });
                        },
                        codeSent: (String verficationId, int? token) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VerficationViewModel(
                                        verficationId: verficationId,
                                      )));
                          setState(() {
                            loading = false;
                          });
                        },
                        codeAutoRetrievalTimeout: (e) {
                          setState(() {
                            loading = false;
                          });
                          ErrorMessage.toastMessage(e.toString());
                        });
                  }
                }),
          ],
        ),
      ),
    );
  }
}
