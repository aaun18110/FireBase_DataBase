import 'package:firebase_tutorial/Model/Error%20Message/error_message.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../Model/Widgets/login_button.dart';
import 'package:firebase_database/firebase_database.dart';

class PostAddViewModel extends StatefulWidget {
  const PostAddViewModel({super.key});

  @override
  State<PostAddViewModel> createState() => _PostAddViewModelState();
}

class _PostAddViewModelState extends State<PostAddViewModel> {
  final postController = TextEditingController();
  bool loading = false;
  final dataBaseReference = FirebaseDatabase.instance.ref('Post');
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    postController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post"),
        centerTitle: true,
        // automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.030,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: postController,
                decoration: InputDecoration(
                  hintText: "What is in your mind?",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 2,
                          strokeAlign: 5)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 2,
                          strokeAlign: 5)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please fill this field.';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            SizedBox(
              height: height * 0.030,
            ),
            LoginButton(
              title: "Add Post",
              loading: loading,
              onpress: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    loading = true;
                  });
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  dataBaseReference.child(id).set({
                    'id': id,
                    'title': postController.text.toString(),
                    'DateTime':
                        "${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()}:${DateTime.now().second.toString()}"
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    ErrorMessage.toastMessage('Submit Sucessfully');
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    if (kDebugMode) {
                      print(error.toString());
                    }
                    ErrorMessage.toastMessage(error.toString());
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
