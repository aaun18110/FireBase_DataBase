import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_tutorial/Model/Error%20Message/error_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../auth/login_view_model.dart';
import 'add_post_view_mode.dart';

class PostViewModel extends StatefulWidget {
  const PostViewModel({super.key});

  @override
  State<PostViewModel> createState() => _PostViewModelState();
}

class _PostViewModelState extends State<PostViewModel> {
  final auth = FirebaseAuth.instance;
  final dataBaseRef = FirebaseDatabase.instance.ref('Post');
  final searchController = TextEditingController();
  final updateController = TextEditingController();
  String search = '';
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Post"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            InkWell(
              onTap: () {
                auth.signOut().then((value) {
                  ErrorMessage.toastMessage("Logout Sucessfully");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginViewModel()));
                }).onError((error, stackTrace) {
                  ErrorMessage.toastMessage(error.toString());
                });
              },
              child: const Icon(Icons.logout_rounded),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                      hintText: "Search here...",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade400,
                      )),
                  onChanged: (value) {
                    setState(() {
                      search = value;
                    });
                  },
                ),
                SizedBox(
                  height: height * 0.020,
                ),
                Expanded(
                    child: FirebaseAnimatedList(
                        defaultChild:
                            const Center(child: CircularProgressIndicator()),
                        query: dataBaseRef,
                        itemBuilder: (
                          context,
                          snapshot,
                          animation,
                          index,
                        ) {
                          String position =
                              snapshot.child('title').value.toString();
                          if (searchController.text.isEmpty) {
                            return Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    snapshot.child('DateTime').value.toString(),
                                    style:
                                        TextStyle(color: Colors.green.shade700),
                                  ),
                                  ListTile(
                                    title: Text(
                                      snapshot.child('title').value.toString(),
                                    ),
                                    subtitle: Text(
                                        snapshot.child('id').value.toString()),
                                    leading: const CircleAvatar(
                                        backgroundColor: Colors.black,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              'https://sm.ign.com/ign_pk/cover/a/avatar-gen/avatar-generations_rpge.jpg'),
                                        )),
                                    trailing: PopupMenuButton(
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: '1',
                                            child: ListTile(
                                              minLeadingWidth: 1,
                                              onTap: () {
                                                Navigator.pop(context);
                                                updateDialogueBox(
                                                    position,
                                                    snapshot
                                                        .child('id')
                                                        .value
                                                        .toString());
                                              },
                                              leading: const Icon(Icons.edit),
                                              title: const Text("Update"),
                                            )),
                                        PopupMenuItem(
                                            value: '2',
                                            child: ListTile(
                                              onTap: () {
                                                deleteDialogeBox(snapshot
                                                    .child('id')
                                                    .value
                                                    .toString());
                                                Navigator.pop(context);
                                              },
                                              minLeadingWidth: 1,
                                              leading: const Icon(Icons.delete),
                                              title: const Text("Delete"),
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (position
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase())) {
                            return Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    snapshot.child('DateTime').value.toString(),
                                    style:
                                        TextStyle(color: Colors.green.shade700),
                                  ),
                                  ListTile(
                                    title: Text(
                                      snapshot
                                          .child(
                                            'title',
                                          )
                                          .value
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.red, letterSpacing: 2),
                                    ),
                                    subtitle: Text(
                                        snapshot.child('id').value.toString()),
                                    leading: const CircleAvatar(
                                        backgroundColor: Colors.black,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              'https://sm.ign.com/ign_pk/cover/a/avatar-gen/avatar-generations_rpge.jpg'),
                                        )),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          snapshot
                                              .child('DateTime')
                                              .value
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.green.shade700),
                                        ),
                                        Icon(
                                          Icons.done_all_rounded,
                                          color: Colors.grey.shade500,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }))
              ]),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.deepPurpleAccent,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PostAddViewModel()));
                  },
                  child: const Icon(
                    Icons.add_box_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                SizedBox(
                  height: height * 0.070,
                ),
              ]),
        ));
  }

  Future<void> deleteDialogeBox(String id) async {
    print("delete");
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('Do you want to Delete Know?'),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    dataBaseRef.child(id).remove();
                  },
                  icon: const Text('Ok')),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Text('Cancel')),
            ],
          );
        });
  }

  Future<void> updateDialogueBox(String title, String id) async {
    print("sho Dialogue");
    updateController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              decoration: const BoxDecoration(),
              child: TextFormField(
                controller: updateController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
            ),
            actionsPadding: const EdgeInsets.all(5),
            actions: [
              IconButton(
                  onPressed: () {
                    dataBaseRef.child(id).update({
                      'title': updateController.text.toLowerCase()
                    }).then((value) {
                      ErrorMessage.toastMessage('Update Sucessfully');
                      Navigator.pop(context);
                    }).onError((error, stackTrace) {
                      ErrorMessage.toastMessage(error.toString());
                    });
                  },
                  icon: const Text("Ok")),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Text('Cancel')),
            ],
          );
        });
  }
}
