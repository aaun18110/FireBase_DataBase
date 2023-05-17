import 'package:firebase_tutorial/Model/Error%20Message/error_message.dart';
import 'package:firebase_tutorial/Model/Widgets/login_button.dart';
import 'package:firebase_tutorial/View%20Model/post/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerficationViewModel extends StatefulWidget {
  final String verficationId;

  const VerficationViewModel({super.key, required this.verficationId});

  @override
  State<VerficationViewModel> createState() => _VerficationViewModelState();
}

class _VerficationViewModelState extends State<VerficationViewModel> {
  final auth = FirebaseAuth.instance;
  bool loading = false;
  String currentText = '';
  TextEditingController verficationController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    verficationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.deepPurple,
            size: 32,
            weight: 4,
          ),
        ),
      ),
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
                  color: Colors.deepPurpleAccent.shade400),
            ),
            const SizedBox(
              height: 40,
            ),
            PinCodeTextField(
              controller: verficationController,
              keyboardType: TextInputType.phone,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(12),
                fieldHeight: 60,
                fieldWidth: 50,
                selectedColor: Colors.deepPurpleAccent.shade200,
                activeColor: Colors.deepPurpleAccent.shade400,
              ),
              enabled: true,
              enablePinAutofill: true,
              length: 6,
              animationType: AnimationType.fade,
              animationDuration: const Duration(milliseconds: 300),
              appContext: context,
              onChanged: (value) {
                setState(() {
                  currentText = value;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            LoginButton(
                title: 'Verfiy Phone Number',
                loading: loading,
                onpress: () async {
                  setState(() {
                    loading = true;
                  });
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verficationId,
                      smsCode: verficationController.text.toString());
                  try {
                    await auth.signInWithCredential(credential);
                    ErrorMessage.toastMessage('Verify Sucessfully');
                    setState(() {
                      loading = false;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PostViewModel()));
                  } catch (e) {
                    setState(() {
                      loading = false;
                    });
                    ErrorMessage.toastMessage(e.toString());
                  }
                }),
          ],
        ),
      ),
    );
  }
}
