import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lingo/Home/Appdrawer.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'models/gemini-2.0-flash',
      apiKey: "AIzaSyBEnHyjfYQ-heuPe6IdP7klvFuzgsuTgQ0",
    );
    _chatSession = _model.startChat();
  }

  @override
  void dispose() {
    _streamSub?.cancel();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(text);
      _controller.clear();
      _isLoading = true;
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
          } catch (e) {
            setState(() {
              _messages.add('🤖: Failed to process response.');
            });
          }
        },
        onError: (_) {
          setState(() {
            _messages.add('🤖: Failed to load response.');
            _isLoading = false;
          });
        },
        onDone: () {
          setState(() => _isLoading = false);
        },
      );
    } catch (e) {
      setState(() {
        _messages.add('🤖: Failed to load response.');
        _isLoading = false;
      });
    }
  }

  Widget _buildMessage(String msg) {
    final isBot = msg.startsWith('🤖: ');
    final displayMsg = isBot ? msg.replaceFirst('🤖: ', '') : msg;

    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isBot)
            const CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.room, color: Colors.white),
              radius: 18,
            ),
          if (isBot) const SizedBox(width: 8),
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color:
                    isBot
                        ? Colors.deepPurple.withOpacity(0.75)
                        : Colors.cyan.shade600.withOpacity(0.85),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                displayMsg,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
          if (!isBot) const SizedBox(width: 8),
          if (!isBot)
            const CircleAvatar(
              backgroundColor: Colors.cyan,
              child: Icon(Icons.person, color: Colors.white),
              radius: 18,
            ),
        ],
      ),
    );
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
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.03,
                child: Image.asset(
                  'assets/images/lingoo2.png',
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
                      final actualMsg =
                          isBot ? msg.replaceFirst('🤖: ', '') : msg;

                      return Align(
                        alignment:
                            isBot
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment:
                              isBot
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isBot)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundImage: AssetImage(
                                    'assets/images/Aibot.jpg',
                                  ), // 👈 Add your bot image here
                                ),
                              ),
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                padding: const EdgeInsets.all(14),
                                constraints: const BoxConstraints(
                                  maxWidth: 280,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color:
                                      isBot
                                          ? Colors.deepPurple.shade400
                                              .withOpacity(0.8)
                                          : Colors.cyan.shade400.withOpacity(
                                            0.8,
                                          ),
                                ),
                                child: Text(
                                  actualMsg,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                        icon: const Icon(Icons.mic, color: Colors.white),
                        onPressed: () {
                          // TODO: Voice input
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
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
      ),
    );
  }
}
