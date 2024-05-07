import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/provider/theme_provider.dart';
import 'package:testapp/provider/user_provider.dart';

class ChatRommScreen extends StatefulWidget {
  final String chatRoomName;
  final String chatRoomID;

  const ChatRommScreen(
      {required this.chatRoomName, required this.chatRoomID, super.key});

  @override
  State<ChatRommScreen> createState() => _ChatRommScreenState();
}

class _ChatRommScreenState extends State<ChatRommScreen> {
  TextEditingController messageController = TextEditingController();
  var db = FirebaseFirestore.instance;

  Future<void> sendMessage() async {
    if (messageController.text.isEmpty) {
      return;
    }

    Map<String, dynamic> getMessage = {
      "message": messageController.text,
      "sender_name": Provider.of<UserProvider>(context, listen: false).userName,
      "sender_id": Provider.of<UserProvider>(context, listen: false).userId,
      "chatroom_id": widget.chatRoomID,
      "timestamp": FieldValue.serverTimestamp(),
    };
    messageController.text = "";
    try {
      db.collection("messages").add(getMessage);
    } catch (e) {
      e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoomName),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
            stream: db
                .collection("messages")
                .where("chatroom_id", isEqualTo: widget.chatRoomID)
                .orderBy("timestamp", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Some Error occured!!");
              }
              var allMessages = snapshot.data?.docs ?? [];
              return ListView.builder(
                itemCount: allMessages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: singleChatItem(
                        senderName: allMessages[index]["sender_name"],
                        message: allMessages[index]["message"],
                        senderId: allMessages[index]["sender_id"],
                      ),
                    ),
                  );
                },
              );
            },
          )),
          Container(
            padding: const EdgeInsets.all(8),
            color: themeProvider.themeMode == ThemeMode.dark
                ? Colors.white12
                : Colors.grey.shade200,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_a_photo),
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Type a message..'),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    sendMessage();
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //  Chat room Widget is herer !!!!!!!!!!!!
  Widget singleChatItem(
      {required String senderName,
      required String message,
      required String senderId}) {
    return Column(
      crossAxisAlignment:
          senderId == Provider.of<UserProvider>(context, listen: false).userId
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 6, left: 6),
          child: Text(
            senderName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: senderId ==
                      Provider.of<UserProvider>(context, listen: false).userId
                  ? Colors.grey[200]
                  : Colors.blueGrey[900]),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              message,
              style: TextStyle(
                  color: senderId ==
                          Provider.of<UserProvider>(context, listen: false)
                              .userId
                      ? Colors.black
                      : Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
