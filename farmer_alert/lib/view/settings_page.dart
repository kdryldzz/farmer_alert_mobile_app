import 'package:farmer_alert/models/bottom_navigation_layout.dart';
import 'package:farmer_alert/services/auth_service.dart';
import 'package:farmer_alert/view/Privacy_security_page.dart';
import 'package:farmer_alert/view/help_support_page.dart';
import 'package:farmer_alert/view/home_page.dart';
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
  String profileImage ="";
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>?> fetchUserProfile() async {
    final id = _authService.getCurrentUserId(); // Aktif kullanıcı ID'sini alın
    if (id == null) return null;

    final response = await _authService.supabase
        .from('users')
        .select()
        .eq('userId', id) // 'id' sütununu kontrol edin
        .single();

    return response as Map<String, dynamic>?;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Geri tuşuna basıldığında HomePage'e yönlendir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return false; // Varsayılan geri işlevi engelleniyor
      },
      child: BottomNavigationLayout(
        currentIndex: _currentIndex,
        body: Scaffold(
          appBar: AppBar(
            title: const Text(
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
                FutureBuilder<Map<String, dynamic>?>( 
                  future: fetchUserProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        color: Colors.green[50],
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  AssetImage('images/profile.jpg'), // Profil fotoğrafı
                            ),
                            const SizedBox(width: 20),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bilinmeyen Kullanıcı',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text('E-posta bulunamadı'),
                              ],
                            ),
                          ],
                        ),
                      );
                    }

                    final user = snapshot.data!;

                      if(user['gender']=='Female'){
                profileImage = "images/profile.jpg"; // Profil fotoğrafı
              }else{
                profileImage = "images/women_profile.jpg"; // Profil fotoğrafı
              }

                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      color: Colors.green[50],
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                AssetImage(profileImage), // Profil fotoğrafı
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${user['name']} ${user['surname']}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(user['email']),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Ayarlar listesi
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildSettingTile(
                      icon: Icons.notifications,
                      title: 'Bildirimler',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NotificationsPage()),
                        );
                      },
                    ),
                    _buildSettingTile(
                      icon: Icons.lock,
                      title: 'Gizlilik ve Güvenlik',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PrivacySecurityPage()),
                        );
                      },
                    ),
                    _buildSettingTile(
                      icon: Icons.help,
                      title: 'Yardım ve Destek',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HelpSupportPage()),
                        );
                      },
                    ),
                    _buildSettingTile(
                      icon: Icons.exit_to_app,
                      title: 'Çıkış Yap',
                      onTap: () {
                        _authService.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
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
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      leading: Icon(icon, color: Colors.green),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
