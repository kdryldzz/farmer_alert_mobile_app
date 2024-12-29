import 'package:farmer_alert/models/bottom_navigation_layout.dart';
import 'package:farmer_alert/view/Privacy_security_page.dart';
import 'package:farmer_alert/view/help_support_page.dart';
import 'package:farmer_alert/view/languages_page.dart';
import 'package:farmer_alert/view/login_page.dart';
import 'package:farmer_alert/view/notifications_page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final int _currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationLayout(
      currentIndex: _currentIndex,
      body: Scaffold(
        appBar: AppBar(
          title: Text(
            'AYARLAR',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Profil kısmı
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                color: Colors.green[50],
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'images/profile.jpg', // Profil fotoğrafı
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kadir Yıldız',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text('kadir_yildiz@example.com'),
                      ],
                    ),
                  ],
                ),
              ),

              // Ayarlar listesi
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildSettingTile(
                    icon: Icons.notifications,
                    title: 'Bildirimler',
                    onTap: () {
                      // Bildirimler ayarları
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationsPage()));
                    },
                  ),
                  _buildSettingTile(
                    icon: Icons.language,
                    title: 'Dil',
                    onTap: () {
                      // Dil seçimi
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LanguagesPage()));
                    },
                  ),
                  _buildSettingTile(
                    icon: Icons.lock,
                    title: 'Gizlilik ve Güvenlik',
                    onTap: () {
                      // Gizlilik ve güvenlik ayarları
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrivacySecurityPage()));
                    },
                  ),
                  _buildSettingTile(
                    icon: Icons.help,
                    title: 'Yardım ve Destek',
                    onTap: () {
                      // Yardım sayfası
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HelpSupportPage()));
                    },
                  ),
                  _buildSettingTile(
                    icon: Icons.exit_to_app,
                    title: 'Çıkış Yap',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ListTile için yardımcı fonksiyon
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      leading: Icon(icon, color: Colors.green),
      title: Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
      onTap: onTap,
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
