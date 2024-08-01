import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReplyMessageBubble extends StatefulWidget {
  final Stream<String> messageStream;

  const ReplyMessageBubble({Key? key, required this.messageStream})
      : super(key: key);

  @override
  _ReplyMessageBubbleState createState() => _ReplyMessageBubbleState();
}

class _ReplyMessageBubbleState extends State<ReplyMessageBubble>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 保持widget活动

  @override
  Widget build(BuildContext context) {
    super.build(context); // 由于使用了AutomaticKeepAliveClientMixin，需要调用super.build

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: StreamBuilder<String>(
            stream: widget.messageStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('...');
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text(
                  snapshot.data ?? '',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
