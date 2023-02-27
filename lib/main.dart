import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  TextEditingController? _controller;
  late CollectionReference driverCollection;

  _createInitChatRepo() async {
    driverCollection = FirebaseFirestore.instance
        .collection("chats")
        .doc("e10403da-ddf0-4784-b0a4-c6df850ae057")
        .collection("chat");
  }

  _sendMessage() async {
    driverCollection.doc().set({
      "message": _controller!.text,
      "time": DateTime.now(),
    });
  }

  _getData() async {
    final msgDocs = FirebaseFirestore.instance
        .collection("chats")
        .doc("e10403da-ddf0-4784-b0a4-c6df850ae057")
        .collection("driver")
        .get();

    //List<MessageModel>
  }

  @override
  void initState() {
    _controller = TextEditingController();
    _createInitChatRepo();
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("chats")
                      .doc("e10403da-ddf0-4784-b0a4-c6df850ae057")
                      .collection("chat")
                      .orderBy("time", descending: true)
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          log(snapshot.data!.docs[index]["message"]);
                          log(index.toString());
                          return Text(snapshot.data!.docs[index]["message"]);
                        }),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  })),
            ),
            Container(
              width: size.width,
              height: size.height * 0.08,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.lightBlue,
                  )),
              child: TextField(
                controller: _controller,
                onSubmitted: (message) {
                  _controller!.clear();
                  _sendMessage();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
