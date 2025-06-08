import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';
import 'chat_history_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AITutorScreen extends StatefulWidget {
  const AITutorScreen({Key? key}) : super(key: key);

  @override
  State<AITutorScreen> createState() => _AITutorScreenState();
}

final BACKEND_HOST = dotenv.env['BACKEND_HOST'] ?? "";

class _AITutorScreenState extends State<AITutorScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final _speech = stt.SpeechToText();
  final _tts = FlutterTts();
  final _audioPlayer = AudioPlayer();
  final _storage = const FlutterSecureStorage();
  bool _isListening = false;
  String? _chatId;
  final _apiBase = "$BACKEND_HOST:8000/api/ai";
  bool _sendMessageLoading = false;

  late AnimationController _bgController;
  late Animation<Color?> _bgAnimation;

  @override
  void initState() {
    super.initState();
    _initTTS();
    _createChat();
    _initAnimation();
  }

  void _initTTS() {
    _tts
      ..setLanguage("en-US")
      ..setPitch(1.0)
      ..setSpeechRate(0.9);
  }

  void _initAnimation() {
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
    _bgAnimation = ColorTween(
      begin: const Color(0xFF0D0D0D),
      end: const Color(0xFF1C1C2D),
    ).animate(_bgController);
  }

  Future<void> _createChat() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) throw Exception("No token");
      final userId = JwtDecoder.decode(token)['userID'];
      final resp = await http.get(Uri.parse("$_apiBase/chat/new/$userId"));
      if (resp.statusCode == 200) {
        _chatId = jsonDecode(resp.body)['chatId'];
      } else {
        throw Exception("Chat creation failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _startListening() async {
    if (await Permission.microphone.request() != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission required')),
      );
      return;
    }
    if (await _speech.initialize()) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (r) {
          setState(() => _controller.text = r.recognizedWords);
        },
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _chatId == null) return;

    setState(() {
      _messages.add({'text': text, 'isBot': false});
      _controller.clear();
    });

    try {
      setState(() {
        _sendMessageLoading = true;
      });
      final resp = await http.post(
        Uri.parse("$_apiBase/chat/kokoro/$_chatId"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'role': 'user', 'text': text}),
      );

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final reply = data['text'] as String;
        final audioUrl = "$BACKEND_HOST:8000${data['final_audio_file']}";

        setState(() {
          _messages.add({'text': reply, 'isBot': true, 'audioUrl': audioUrl});
          _sendMessageLoading = false;
        });

        await _audioPlayer.setUrl(audioUrl);
        _audioPlayer.play();
      } else {
        throw Exception('API ${resp.statusCode}');
      }
    } catch (e) {
      setState(() {
        _sendMessageLoading = false;
      });
      setState(() => _messages.add({'text': '🤖 Error: $e', 'isBot': true}));
    }
  }

  @override
  void dispose() {
    _tts.stop();
    _speech.stop();
    _audioPlayer.dispose();
    _bgController.dispose();
    super.dispose();
  }

  Widget _buildMessage(Map<String, dynamic> msg) {
    final isBot = msg['isBot'] as bool;
    final text = msg['text'] as String;
    final audioUrl = msg['audioUrl'] as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBot)
            const CircleAvatar(
              backgroundColor: Colors.pink,
              child: Icon(Icons.smart_toy, color: Colors.white, size: 20),
            ),
          if (isBot) const SizedBox(width: 8),
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color:
                        isBot
                            ? Colors.pinkAccent.withOpacity(0.3)
                            : Colors.cyanAccent.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      if (isBot && audioUrl != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                await _audioPlayer.setUrl(audioUrl);
                                if (_audioPlayer.playing) {
                                  await _audioPlayer.pause();
                                  return;
                                }
                                await _audioPlayer.play();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Audio Error: $e')),
                                );
                              }
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.play_arrow, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  'Play again',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (!isBot) const SizedBox(width: 8),
          if (!isBot)
            const CircleAvatar(
              backgroundColor: Colors.cyan,
              child: Icon(Icons.person, color: Colors.black, size: 20),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.history, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChatHistoryScreen()),
                  );
                },
              ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/icon.jpg'),
                fit: BoxFit.cover,
              ),
              color: _bgAnimation.value,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (ctx, i) => _buildMessage(_messages[i]),
                  ),
                ),
                _sendMessageLoading
                    ? Row(
                      children: [
                        SizedBox(width: 16),
                        LoadingAnimationWidget.waveDots(
                          color: Colors.white,
                          size: 35,
                        ),
                      ],
                    )
                    : SizedBox(),
                Container(
                  color: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _isListening ? _stopListening() : _startListening();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors:
                                  _isListening
                                      ? [Colors.pinkAccent, Colors.deepPurple]
                                      : [Colors.grey.shade800, Colors.black],
                              center: Alignment.center,
                              radius: 0.9,
                            ),
                            boxShadow:
                                _isListening
                                    ? [
                                      BoxShadow(
                                        color: Colors.pinkAccent.withOpacity(
                                          0.8,
                                        ),
                                        blurRadius: 12,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                    : [],
                          ),
                          child: Icon(
                            _isListening ? Icons.mic : Icons.mic_none,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black87, Colors.grey.shade900],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.cyanAccent.withOpacity(0.7),
                              width: 1.5,
                            ),
                          ),
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: 'Type or speak your message...',
                              hintStyle: TextStyle(color: Colors.white54),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _sendMessage,
                        child: Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Colors.cyanAccent, Colors.blueAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(
                            Icons.send,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
