import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoomProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _chatList = [];
  final List<String> _chatId = [];
  List<String> get chatId => _chatId;
  List<Map<String, dynamic>> get chatList => _chatList;

//  get Chatroom Details

  void getChatrooms() {
    var db = FirebaseFirestore.instance;

    db.collection("chatrooms").get().then((snapshotData) {
      for (var singleChatroomData in snapshotData.docs) {
        _chatList.add(singleChatroomData.data());
        _chatId.add(singleChatroomData.id.toString());
      }
      notifyListeners();
    });
  }
}
