import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';

class ChatHistoryScreen extends StatefulWidget {
  @override
  _ChatHistoryScreenState createState() => _ChatHistoryScreenState();
}

final BACKEND_HOST = dotenv.env['BACKEND_HOST'] ?? "";
final NODE_BACKEND_BASE = dotenv.env['NODE_BACKEND_BASE'] ?? "";

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  final logger = Logger();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final String _baseUrl = "$NODE_BACKEND_BASE/chat/from-user";
  List<Map<String, dynamic>> _allMessages = [];
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();
  String? _userId;

  @override
  void initState() {
    logger.i(_baseUrl);
    super.initState();
    _loadChatHistory();
  }

  String _normalizeBase64(String str) {
    int padding = (4 - str.length % 4) % 4;
    return str + '=' * padding;
  }

  Future<void> _loadChatHistory() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) throw Exception("Token not found");

      final payload = token.split('.')[1];
      final normalized = _normalizeBase64(payload);
      final decoded = jsonDecode(utf8.decode(base64Url.decode(normalized)));
      _userId = decoded['userID'];

      final response = await http.get(Uri.parse("$_baseUrl/$_userId"));
      if (response.statusCode != 200) throw Exception("Failed to load history");

      List<dynamic> data = jsonDecode(response.body);
      data = data.reversed.toList();

      List<Map<String, dynamic>> messages = [];
      for (var conversation in data) {
        for (var chat in conversation['chat']) {
          messages.add({
            'role': chat['role'],
            'message': chat['message'],
            'audio': chat['audio'],
          });
        }
      }

      setState(() {
        _allMessages = messages; // newest first
        _isLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        }
      });
    } catch (e) {
      print("Error loading chat: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildMessageBubble(Map<String, dynamic> chat) {
    final isUser = chat['role'] == 'user';
    final message = chat['message'];
    final audio = chat['audio'];
    final neonColor = isUser ? Colors.cyanAccent : Colors.pinkAccent;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: neonColor, width: 1.6),
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey[900]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: neonColor.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (message != null)
              Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 15.5),
              ),
            if (audio != null) _buildAudioPlayer(audio),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPlayer(String path) {
    final player = AudioPlayer(androidOffloadSchedulingEnabled: true);
    final fullUrl = "$BACKEND_HOST:8000$path";

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.play_arrow, color: Colors.cyanAccent),
          onPressed: () async {
            try {
              if (player.playing) {
                player.pause();
                return;
              }
              await player.setUrl(fullUrl);
              await player.play();
            } catch (e) {
              print("Audio playback failed: $e");
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Audio failed to load.")));
            }
          },
        ),
        Text("Audio", style: TextStyle(color: Colors.cyanAccent)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Chat History"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.cyanAccent,
        elevation: 0,
      ),
      body:
          _isLoading
              ? Center(
                child: CircularProgressIndicator(color: Colors.cyanAccent),
              )
              : _allMessages.isEmpty
              ? Center(
                child: Text(
                  "No chat history available.",
                  style: TextStyle(color: Colors.white60),
                ),
              )
              : ListView.builder(
                controller: _scrollController,
                reverse: false, // newest at bottom
                itemCount: _allMessages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(_allMessages[index]);
                },
              ),
    );
  }
}
