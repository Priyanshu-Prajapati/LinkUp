import 'dart:convert';
import 'dart:io'; // Import the 'dart:io' library for platform detection

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/message_item.dart';
import 'package:social_media_app/models/messages.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Text controller
  final textController = TextEditingController();
  final ScrollController _controller = ScrollController();
  final FocusNode _focusNode = FocusNode();

  bool isTextEntered = false;

  final currentUser = FirebaseAuth.instance.currentUser!;

  String getServerUrl(String route) {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/$route'; // Android emulator
    } else {
      return 'http://localhost:8000/$route'; // iOS simulator and physical iOS device
    }
  }

  void sendData() async {
    final Map<String, String> data = {
      'id': uuid.v4(),
      'message': textController.text,
      'email': currentUser.email!,
      'date': DateTime.now().toString() // Example date format, adjust as needed
    };

    final response = await http.post(
      Uri.parse(getServerUrl('user_message')),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('success');
    } else {
      print('Error sending data');
    }

    textController.clear();
    isTextEntered = false;
    _focusNode.unfocus();
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
    );
  }

  void fetchData() async {
    final response = await http.get(
      Uri.parse(getServerUrl('fetch-data')),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        _registeredMessages = jsonData
            .map((data) => Message(
                  id: data['id'],
                  message: data['message'],
                  email: data['email'],
                  date: DateTime.parse(data['date']),
                ))
            .toList();

        fetchData();
      });
    } else {
      print('Failed to fetch data');
    }
  }

  List<Message> _registeredMessages = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: const Text(
          'LinkUp',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
            style: IconButton.styleFrom(foregroundColor: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              //user messages
              Expanded(
                child: ListView.builder(
                  controller: _controller,
                  itemCount: _registeredMessages.length,
                  itemBuilder: (context, index) {
                    return MessageItem(
                      _registeredMessages[index],
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              //post message
              Padding(
                padding: const EdgeInsets.only(
                    right: 25, left: 25, top: 25, bottom: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        focusNode: _focusNode,
                        onChanged: (text) {
                          setState(() {
                            isTextEntered = text.isNotEmpty;
                          });
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText: 'Write something on LinkUp...',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ),
                    if (isTextEntered)
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: sendData,
                          icon: const Icon(Icons.arrow_circle_up),
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              //User
              Text(
                'Logged in as: ${currentUser.email!}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
