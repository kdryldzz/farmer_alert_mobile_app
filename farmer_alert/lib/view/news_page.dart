import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<dynamic> _announcements = [];

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    try {
      // JSON dosyasını assets'den okuma
      final String response =
          await rootBundle.loadString('datas/announcements.json');
      final data = json.decode(response);
      setState(() {
        _announcements = data;
      });
    } catch (e) {
      print("Hata: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HABERLER",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
        ),
        backgroundColor:
            Color.fromARGB(255, 54, 116, 215), // Uyarlanmış başlık rengi
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/login_page.jpg"), // Arka plan resmi
            fit: BoxFit.cover,
          ),
        ),
        child: _announcements.isEmpty
            ? Center(
                child:
                    CircularProgressIndicator()) // Veriler yüklenirken gösterilecek animasyon
            : ListView.builder(
                itemCount: _announcements.length,
                itemBuilder: (context, index) {
                  final announcement = _announcements[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 10,
                    color: Colors.white.withOpacity(0.8),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(15),
                      title: Text(
                        announcement['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color:
                              Color.fromARGB(255, 54, 116, 215), // Başlık rengi
                        ),
                      ),
                      subtitle: Text(
                        announcement['date'],
                        style: TextStyle(color: Colors.black87),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward,
                        color: Color.fromARGB(255, 54, 116, 215),
                      ),
                      onTap: () {
                        // Bağlantıyı açma
                        _openLink(announcement['link']);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _openLink(String url) async {
    final Uri testUri = Uri.parse(url);
    await launchUrl(testUri, mode: LaunchMode.externalApplication);
  }
}
