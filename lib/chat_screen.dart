import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  // Cargar mensajes desde SharedPreferences
  Future<void> _loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedMessages = prefs.getString('messages');
    if (savedMessages != null) {
      List<dynamic> decodedMessages = json.decode(savedMessages);
      setState(() {
        // Asegúrate de que cada elemento es un Map<String, String>
        _messages.addAll(decodedMessages.map((msg) => Map<String, String>.from(msg)));
      });
    }
  }

  // Guardar mensajes en SharedPreferences
  Future<void> _saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('messages', json.encode(_messages));
  }

  // Enviar mensaje
  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({'user': message});
        _controller.clear();
      });

      String botResponse = _getBotResponse(message);
      setState(() {
        _messages.add({'bot': botResponse});
      });

      _flutterTts.speak(botResponse);
      _saveMessages();
    }
  }

  // Obtener respuesta del bot
  String _getBotResponse(String message) {
    message = message.toLowerCase();

    if (message.contains('hora')) {
      return 'La hora actual es ${TimeOfDay.now().format(context)}.';
    } else if (message.contains('día')) {
      return 'Hoy es ${DateTime.now().toLocal().toString().split(' ')[0]}.';
    } else if (message.contains('chiapas')) {
      return 'Chiapas es un estado de México conocido por su diversidad cultural y natural.';
    } else if (message.contains('software')) {
      return 'El software es un conjunto de programas y aplicaciones que permiten que un dispositivo realice diversas tareas.';
    } else if (message.contains('hola')) {
      return '¡Hola! ¿En qué puedo ayudarte?';
    } else if (message.contains('adiós')) {
      return '¡Adiós! Que tengas un buen día.';
    } else if (message.contains('quién eres')) {
      return 'Soy un chatbot creado para ayudarte con tus preguntas. ¿En qué te puedo asistir?';
    } else if (message.contains('qué es')) {
      return '¿Qué es lo que te gustaría saber?';
    }
    return 'Lo siento, no entendí eso. ¿Puedes preguntarme otra cosa?';
  }

  // Iniciar escucha
  void _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speechToText.listen(onResult: (result) {
        _controller.text = result.recognizedWords;
      });
    }
  }

  // Detener escucha
  void _stopListening() {
    _speechToText.stop();
    setState(() {
      _isListening = false;
    });
    _sendMessage(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    _flutterTts.stop();
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.android),  // Ícono de un robot
            SizedBox(width: 8),  // Espacio entre el ícono y el texto
            Text('Chat Bot'),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(
                    message.values.first,
                    textAlign: message.keys.first == 'user'
                        ? TextAlign.end
                        : TextAlign.start,
                    style: TextStyle(
                      color: message.keys.first == 'user'
                          ? Colors.blue
                          : Colors.green,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Escribe tu mensaje...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                GestureDetector(
                  onLongPress: _startListening,
                  onLongPressUp: _stopListening,
                  child: Icon(
                    Icons.mic,
                    color: _isListening ? Colors.red : Colors.black,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}