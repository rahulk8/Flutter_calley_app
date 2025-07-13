import 'package:calley_app/signup_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LanguageSelectionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLang = 'English';

  final List<Map<String, String>> languages = [
    {'lang': 'English', 'subtitle': 'Hi'},
    {'lang': 'Hindi', 'subtitle': 'नमस्ते'},
    {'lang': 'Bengali', 'subtitle': 'হ্যালো'},
    {'lang': 'Kannada', 'subtitle': 'ನಮಸ್ಕಾರ'},
    {'lang': 'Punjabi', 'subtitle': 'ਸਤ ਸ੍ਰੀ ਅਕਾਲ'},
    {'lang': 'Tamil', 'subtitle': 'வணக்கம்'},
    {'lang': 'Telugu', 'subtitle': 'హలో'},
    {'lang': 'French', 'subtitle': 'Bonjour'},
    {'lang': 'Spanish', 'subtitle': 'Hola'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                'Choose Your Language',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: ListView.separated(
                    itemCount: languages.length,
                    separatorBuilder: (_, __) => const Divider(height: 0),
                    itemBuilder: (context, index) {
                      final item = languages[index];
                      return RadioListTile(
                        value: item['lang']!,
                        groupValue: selectedLang,
                        onChanged: (val) {
                          setState(() {
                            selectedLang = val!;
                          });
                        },
                        title: Text(item['lang']!),
                        subtitle: Text(item['subtitle']!),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Select', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
