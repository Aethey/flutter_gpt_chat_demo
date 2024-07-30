import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../entity/message_entity.dart';

class MessageRepository {
  final FirebaseFirestore firestore;

  MessageRepository({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<MessageEntity>> fetchMessages(String conversationId) {
    return firestore
        .collection('messages')
        .where('conversationId', isEqualTo: conversationId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageEntity.fromJson(doc.data()))
            .toList());
  }

  Future<void> addMessage(MessageEntity message) async {
    await firestore.collection('messages').add(message.toJson());
  }
}
