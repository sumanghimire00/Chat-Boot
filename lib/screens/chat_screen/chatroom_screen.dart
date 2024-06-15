import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<void> sendMessage({String? imageUrl}) async {
    if (messageController.text.isEmpty && imageUrl == null) {
      return;
    }

    Map<String, dynamic> getMessage = {
      "message": messageController.text,
      "sender_name": Provider.of<UserProvider>(context, listen: false).userName,
      "sender_id": Provider.of<UserProvider>(context, listen: false).userId,
      "chatroom_id": widget.chatRoomID,
      "timestamp": FieldValue.serverTimestamp(),
    };

    if (imageUrl != null) {
      getMessage["image_url"] = imageUrl;
    }

    messageController.clear();

    try {
      await db.collection("messages").add(getMessage);
    } catch (e) {
      e.toString();
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      String fileName = pickedFile.name;
      try {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child('chat_images/$fileName')
            .putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        sendMessage(imageUrl: imageUrl);
      } catch (e) {
        e.toString();
      }
    } else {}
  }

  void showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Photo Library'),
              onTap: () {
                Navigator.of(context).pop();
                pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final height = MediaQuery.of(context).size.height;
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Text(
                    "Some error has occurred!",
                  );
                }

                var allMessages = snapshot.data?.docs ?? [];
                if (allMessages.isEmpty) {
                  return const Text("No messages appeared here!");
                }

                return ListView.builder(
                  itemCount: allMessages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    var messageData = allMessages[index];
                    return Padding(
                      padding: EdgeInsets.all(height * 0.01),
                      child: Container(
                        child: singleChatItem(
                          senderName: messageData["sender_name"],
                          message: messageData["message"],
                          imageUrl: messageData.data().containsKey("image_url")
                              ? messageData["image_url"]
                              : null,
                          senderId: messageData["sender_id"],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(height * 0.01),
            color: themeProvider.themeMode == ThemeMode.dark
                ? Colors.white12
                : Colors.grey.shade200,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => showImageSourceActionSheet(context),
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

  Widget singleChatItem({
    required String senderName,
    required String message,
    required String senderId,
    String? imageUrl,
  }) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment:
          senderId == Provider.of<UserProvider>(context, listen: false).userId
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: width * 0.06, left: width * 0.015),
          child: Text(
            senderName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height * 0.025),
              color: senderId ==
                      Provider.of<UserProvider>(context, listen: false).userId
                  ? Colors.grey[200]
                  : Colors.blueGrey[900]),
          child: Padding(
            padding: EdgeInsets.all(height * 0.012),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null)
                  Image.network(
                    imageUrl,
                    height: height * 0.3,
                    width: width * 0.6,
                    fit: BoxFit.cover,
                  ),
                if (message.isNotEmpty)
                  Text(
                    message,
                    style: TextStyle(
                        color: senderId ==
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .userId
                            ? Colors.black
                            : Colors.white),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
