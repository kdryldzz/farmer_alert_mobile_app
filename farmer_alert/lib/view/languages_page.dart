import 'package:flutter/material.dart';

class LanguagesPage extends StatefulWidget {
  const LanguagesPage({super.key});

  @override
  State<LanguagesPage> createState() => _LanguagesPageState();
}

class _LanguagesPageState extends State<LanguagesPage> {
  String _selectedLanguage = "Türkçe"; // Varsayılan dil

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dil Seçimi"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text("Türkçe"),
              leading: Radio<String>(
                value: "Türkçe",
                groupValue: _selectedLanguage,
                onChanged: (String? value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: Text("İngilizce"),
              leading: Radio<String>(
                value: "İngilizce",
                groupValue: _selectedLanguage,
                onChanged: (String? value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Seçilen dili kaydet ve geri dön
                Navigator.pop(context, _selectedLanguage);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }
}
