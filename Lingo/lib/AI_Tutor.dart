import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lingo/Appdrawer.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class AITutorScreen extends StatefulWidget {
  const AITutorScreen({Key? key}) : super(key: key);

  @override
  State<AITutorScreen> createState() => _AITutorScreenState();
}

class _AITutorScreenState extends State<AITutorScreen> {
  late final GenerativeModel _model;
  late final ChatSession _chatSession;
  final List<String> _messages = [];
  final TextEditingController _controller = TextEditingController();
  StreamSubscription<GenerateContentResponse>? _streamSub;

  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isListening = false;
  String _recognizedText = '';

  @override
  void initState() {
    super.initState();

    // Gemini model initialization
    _model = GenerativeModel(
      model: 'models/gemini-2.0-flash',
      apiKey: 'AIzaSyBEnHyjfYQ-heuPe6IdP7klvFuzgsuTgQ0', // Replace with your actual API key
    );
    _chatSession = _model.startChat();
    _initTTS();
  }

  void _initTTS() {
    _tts.setLanguage("en-US");
    _tts.setPitch(1.0);
    _tts.setSpeechRate(0.9);
  }

  void _speak(String text) async {
    await _tts.stop(); // Stop previous speech
    await _tts.speak(text);
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _recognizedText = result.recognizedWords;
            _controller.text = _recognizedText;
          });
        },
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  void dispose() {
    _streamSub?.cancel();
    _tts.stop();
    _speech.stop();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(text);
      _controller.clear();
    });

    _streamSub?.cancel();

    final content = Content.text(text);
    String buffer = '';

    try {
      final stream = _chatSession.sendMessageStream(content);

      _streamSub = stream.listen(
        (resp) {
          try {
            final part = resp.candidates.first.content.parts.first as TextPart;
            buffer = part.text;

            setState(() {
              if (_messages.isNotEmpty && _messages.last.startsWith('🤖: ')) {
                _messages[_messages.length - 1] = '🤖: $buffer';
              } else {
                _messages.add('🤖: $buffer');
              }
            });

            _speak(buffer);
          } catch (e) {
            setState(() {
              _messages.add('🤖: Failed to process response.');
            });
          }
        },
        onError: (error) {
          setState(() {
            _messages.add('🤖: Failed to load response.');
          });
        },
        onDone: () {},
      );
    } catch (e) {
      setState(() {
        _messages.add('🤖: Failed to load response.');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'AI Tutor',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/ChatGPT Image May 1, 2025, 04_41_47 AM.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, i) {
                    final msg = _messages[i];
                    final isBot = msg.startsWith('🤖: ');
                    return Align(
                      alignment:
                          isBot ? Alignment.centerLeft : Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(14),
                        constraints: const BoxConstraints(maxWidth: 280),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color:
                              isBot
                                  ? Colors.deepPurple.shade400.withOpacity(0.8)
                                  : Colors.cyan.shade400.withOpacity(0.8),
                        ),
                        child: Text(
                          msg,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                color: Colors.black87,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (_isListening) {
                          _stopListening();
                        } else {
                          _startListening();
                        }
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Type or speak your message...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
