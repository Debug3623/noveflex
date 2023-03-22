import 'dart:async';

import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Provider/UserProvider.dart';
import '../../Utils/toast.dart';

class ChatScreen extends StatefulWidget {
  String bookName;
  String bookID;
  ChatScreen({Key? key, required this.bookName, required this.bookID})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _controller = StreamController<QuerySnapshot>.broadcast();
  late TextEditingController _messageController;
  Stream? stream;

  _listener() {
    stream = _firestore
        .collection("Chat")
        .doc(widget.bookID)
        .collection("users")
        .snapshots(); //retrieve all clients

    stream!.listen((data) {
      print(data.size);
    });
  }

  sendMessage(var message) async {
    _firestore.collection("Chat").doc(widget.bookID).collection("users").add({
      "message": message,
      "url":
          "https://upload.wikimedia.org/wikipedia/commons/8/8b/Rose_flower.jpg",
      "sender": context.read<UserProvider>().UserName,
      "time": DateTime.now().millisecondsSinceEpoch,
    });
  }

  String parseTimeStamp(int value) {
    var date = DateTime.fromMillisecondsSinceEpoch(value );
    var d12 = DateFormat('MM-dd-yyyy, hh:mm a').format(date);
    return d12;
  }

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _listener();
  }

  @override
  void dispose() {
    _controller.close();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffebf5f9),
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black54,
            )),
      ),
      body: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: _height * 0.05,
                                left: _width * 0.01,
                                right: _width * 0.01),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: _height * _width * 0.0001,
                                  backgroundImage: NetworkImage(
                                    snapshot.data.docs[index]['url'],
                                  ),
                                ),
                                SizedBox(
                                  width: _width*0.1,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: _height*0.02,
                                      ),
                                      Text(snapshot.data.docs[index]
                                      ['sender'],style: const TextStyle(
                                          color:  const Color(0xff202124),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Neckar",
                                          fontStyle:  FontStyle.normal,
                                          fontSize: 14.0
                                      ),),
                                      SizedBox(
                                        height: _height*0.01,
                                      ),
                                      BubbleSpecialOne(
                                        text: snapshot.data.docs[index]
                                            ['message'],
                                        isSender: false,
                                        color: Colors.purple.shade100,
                                        textStyle: const TextStyle(
                                            color:  const Color(0xff75787a),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Alexandria",
                                            fontStyle:  FontStyle.normal,
                                            fontSize: 12.0
                                        ),
                                      ),
                                      Text(
                                          parseTimeStamp(snapshot.data.docs[index]['time']),
                                        style: const TextStyle(
                                            color:  const Color(0xff75787a),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Alexandria",
                                            fontStyle:  FontStyle.normal,
                                            fontSize: 12.0
                                        ),
                                          )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    MessageBar(
                      onSend: (_) {
                        if (_messageController.text.isNotEmpty) {
                          sendMessage(_messageController.text);
                        } else {
                          ToastConstant.showToast(
                              context, "Please enter message");
                        }
                      },
                      onTextChanged: (data) {
                        _messageController.text = data;
                      },
                      // actions: [
                      //   InkWell(
                      //     child: Icon(
                      //       Icons.add,
                      //       color: Colors.black,
                      //       size: 24,
                      //     ),
                      //     onTap: () {},
                      //   ),
                      //   Padding(
                      //     padding: EdgeInsets.only(left: 8, right: 8),
                      //     child: InkWell(
                      //       child: Icon(
                      //         Icons.camera_alt,
                      //         color: Colors.green,
                      //         size: 24,
                      //       ),
                      //       onTap: () {},
                      //     ),
                      //   ),
                      // ],
                    ),
                  ],
                )
              : Container();
        },
      ),
    );
  }
}
