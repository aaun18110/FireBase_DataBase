import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class StreamBuilderViewModel extends StatefulWidget {
  const StreamBuilderViewModel({super.key});

  @override
  State<StreamBuilderViewModel> createState() => _StreamBuilderViewModelState();
}

class _StreamBuilderViewModelState extends State<StreamBuilderViewModel> {
  final dataBaseRef = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    //StearmBuilder Help to Fetch stream Data Therefore FireBase return data in stream form
    return Expanded(
        child: StreamBuilder(
            stream: dataBaseRef.onValue,
            builder: (
              context,
              AsyncSnapshot<DatabaseEvent> snapShot,
            ) {
              if (!snapShot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                Map<dynamic, dynamic> map =
                    snapShot.data!.snapshot.value as dynamic;
                List<dynamic> listPost = [];
                listPost.clear();
                listPost = map.values.toList();
                return ListView.builder(
                    itemCount: snapShot.data!.snapshot.children.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(listPost[index]['title'].toString()),
                      );
                    });
              }
            }));
  }
}
