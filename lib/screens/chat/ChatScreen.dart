import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:neru/model/Messsage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Mensaje del usuario
    setState(() {
      _messages.add(Message(text, true, DateTime.now()));
      _scrollToBottom();
    });

    // Respuesta de DeepSeek
    try {
      final response = await _getGroqResponse(text);
      setState(() {
        _messages.add(Message(response, false, DateTime.now()));
        _scrollToBottom();
      });
    } catch (e) {
      setState(() {
        _messages.add(Message("Error: $e", false, DateTime.now()));
      });
    }

    _textController.clear();
  }

  Future<String> _getGroqResponse(String prompt) async {
    try {
      // 1. Carga la API Key desde .env
      await dotenv.load(fileName: ".env");
      final apiKey = dotenv.env['GROQ_API_KEY'];

      if (apiKey == null) throw Exception("GROQ_API_KEY no encontrada en .env");

      // 2. Configura la petición
      final response = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama3-8b-8192', // Modelo gratuito rápido
          // 'model': 'llama3-70b-8192',   // Modelo más avanzado (puede requerir plan de pago)
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
        }),
      );
      print(response);
      // 3. Procesa la respuesta
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['choices'][0]['message']['content'];
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error en Groq: $e');
    }
  }

  Future<String> _getDeepSeekResponse(String prompt) async {
    if (!dotenv.isInitialized) {
      await dotenv.load(fileName: ".env");
    }

    final apiKey = dotenv.env['DEEPSEEK_API_KEY'];
    if (apiKey == null) throw Exception("API Key no encontrada en .env");
    final url = Uri.parse('https://api.deepseek.com/v1/chat/completions');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'deepseek-free',
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    );
    print(response);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['choices'][0]['message']['content'];
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NeruChat 🤖"),
        centerTitle: true,
        backgroundColor: Color(0xFFBF4141),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/fondo.png',
            ), // Asegúrate de tener esta imagen
            fit: BoxFit.cover, // Cubre toda la pantalla
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ChatBubble(message: message);
                },
              ),
            ),
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: EdgeInsets.only(
        // Añade espacio abajo y a los lados
        left: 8.0,
        right: 8.0,
        bottom: 80.0, // Ajusta este valor según necesites
        top: 8.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Escribe un mensaje...',
                hintStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                ), // ¡Corregido!
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                  ), // Borde sutil
                ),
                enabledBorder: OutlineInputBorder(
                  // Borde cuando no está enfocado
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  // Borde cuando está seleccionado
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.blue), // Azul al tocar
                ),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Color(0xFFBF4141)),
            onPressed: () => _sendMessage(_textController.text),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.text),
            SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
