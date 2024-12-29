import 'package:farmer_alert/models/bottom_navigation_layout.dart';
import 'package:farmer_alert/view/login_page.dart';
import 'package:flutter/material.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final int _currentIndex = 0;

  // Kullanıcı verileri
  String userName = "Kadir Yıldız";
  String userEmail = "kadir_yildiz@example.com";
  String userPhone = "+90 123 456 7890";
  String userLocation = "Sivas, Türkiye";
  final String profileImage = "images/profile.jpg"; // Profil fotoğrafı

  @override
  Widget build(BuildContext context) {
    return BottomNavigationLayout(
      currentIndex: _currentIndex,
      body: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profil Fotoğrafı ve Ad Soyad
              const SizedBox(height: 30),
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(profileImage),
                ),
              ),

              Text(
                userName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),

              // Kullanıcı Bilgileri
              InfoTile(
                icon: Icons.phone,
                title: "Telefon",
                subtitle: userPhone,
              ),
              InfoTile(
                icon: Icons.location_on,
                title: "Konum",
                subtitle: userLocation,
              ),
              const SizedBox(height: 30),

              // Düzenle ve Çıkış Butonları
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Düzenleme sayfasına git ve güncellenen bilgileri al
                      final updatedInfo = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            currentName: userName,
                            currentEmail: userEmail,
                            currentPhone: userPhone,
                            currentLocation: userLocation,
                          ),
                        ),
                      );

                      // Eğer bilgi güncellenmişse, yeni bilgileri ayarla
                      if (updatedInfo != null) {
                        setState(() {
                          userName = updatedInfo["name"];
                          userEmail = updatedInfo["email"];
                          userPhone = updatedInfo["phone"];
                          userLocation = updatedInfo["location"];
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Yeşil renk
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Düzenle',
                      style: TextStyle(color: Colors.white), // Yazı rengi beyaz
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey, // Gri renk
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Çıkış',
                      style: TextStyle(color: Colors.white), // Yazı rengi beyaz
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
