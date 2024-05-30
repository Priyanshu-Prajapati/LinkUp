import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:social_media_app/models/messages.dart';
import 'package:like_button/like_button.dart';
import 'dart:io'; // Import the 'dart:io' library for platform detection

class MessageItem extends StatefulWidget {
  const MessageItem(this.message, {super.key});

  final Message message;

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  // var likeCount = 0;
  late int likeCount = 0;
  late bool isLiked = false;
  final getStorage = GetStorage();

  @override
  void initState() {
    super.initState();
    likeCount = getStorage.read('likeCount_${widget.message.id}') ?? 0;
    isLiked = getStorage.read('isLiked_${widget.message.id}') ?? false;
  }

  Future<bool> saveLikeCount(bool isLiked) async {
    final messageKey = 'isLiked_${widget.message.id}';
    getStorage.write(messageKey, !isLiked);
    setState(() {
      this.isLiked = !isLiked;
    });
    return !isLiked;
  }

  String getServerUrl(String route) {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/$route'; // Android emulator
    } else {
      return 'http://localhost:8000/$route'; // iOS simulator and physical iOS device
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.only(right: 25, left: 25, top: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding:
            const EdgeInsets.only(right: 25, left: 25, bottom: 25, top: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.message.formatedDate),
                Text(
                  widget.message.formatedTime,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      width: 280,
                      child: Text(
                        widget.message.email,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Container(
                      color: Colors.white,
                      width: 280,
                      child: Text(
                        widget.message.message,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(right: 30)),
                  child: LikeButton(
                    size: 20,
                    likeCount: 0,
                    bubblesColor: const BubblesColor(
                      dotPrimaryColor: Color(0xff33b5e5),
                      dotSecondaryColor: Color(0xff0099cc),
                    ),
                    onTap: (isLiked) {
                      return saveLikeCount(isLiked);
                    },
                    isLiked: isLiked,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.comment_rounded,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
