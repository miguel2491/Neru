import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  String _policyText = '';
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchPolicyFromApi();
  }

  Future<void> _fetchPolicyFromApi() async {
    const String apiUrl =
        'https://gcconsultoresmexico.com/api/api.php?action=politica'; // 🔹 Reemplaza por tu endpoint real

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          _policyText = response.body; // 🔹 Si tu API devuelve texto plano
          // Si tu API devuelve JSON, usa:
          // _policyText = jsonDecode(response.body)['policyText'];
          _isLoading = false;
        });
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Política de Privacidad')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _hasError
            ? const Center(
                child: Text('Error al cargar la política. Intenta más tarde.'),
              )
            : SingleChildScrollView(
                child: Text(_policyText, style: const TextStyle(fontSize: 16)),
              ),
      ),
    );
  }
}
