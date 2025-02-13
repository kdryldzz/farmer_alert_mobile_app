import 'package:farmer_alert/models/bottom_navigation_layout.dart';
import 'package:farmer_alert/services/auth_service.dart';
import 'package:farmer_alert/view/login_page.dart';
import 'package:flutter/material.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String profileImage = "";
  final int _currentIndex = 0;
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>?> fetchUserProfile() async {
    final id = _authService.getCurrentUserId(); // Aktif kullanıcı ID'sini alın
    if (id == null) return null;

    final response = await _authService.supabase
        .from('users')
        .select()
        .eq('userId', id)
        .single(); // 'userId' yerine 'id' yazıldığına dikkat edin, Supabase'deki primary key genelde 'id' olarak adlandırılır.

    return response as Map<String, dynamic>?;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationLayout(
      currentIndex: _currentIndex,
      body: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/login_page.jpg"), // Arka plan resmi
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken), // Modern efekt
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<Map<String, dynamic>?>( 
              future: fetchUserProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                  return const Center(
                    child: Text("Kullanıcı bilgileri yüklenirken bir hata oluştu."),
                  );
                }

                final user = snapshot.data!;
                if (user['gender'] == 'Female') {
                  profileImage = "images/profile.jpg"; // Profil fotoğrafı
                } else {
                  profileImage = "images/women_profile.jpg"; // Profil fotoğrafı
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),

                    // Profil Fotoğrafı ve Ad Soyad
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage(profileImage),
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "${user['name']} ${user['surname']}",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Yazı rengini beyaz yapıyoruz
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user['email'] ?? "Email adresi yok",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70, // Yazı rengini açık beyaz yapıyoruz
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Kullanıcı Bilgileri
                    _buildInfoTile(Icons.phone, "Telefon", user['phone'] ?? "Telefon bilgisi yok"),
                    _buildInfoTile(Icons.location_on, "Konum", "${user['city']}, ${user['district']}"),

                    const SizedBox(height: 40),

                    // Düzenle ve Çıkış Butonları
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          'Düzenle',
                          Colors.green,
                          () async {
                            final updatedInfo = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfilePage(
                                  currentUsername: user['username'],
                                  currentName: user['name'],
                                  currentSurname: user['surname'],
                                  currentEmail: user['email'],
                                  currentPhone: user['phone'],
                                  currentCity: user['city'],
                                  currentDistrict: user['district'],
                                ),
                              ),
                            );
                            if (updatedInfo != null) {
                              setState(() {});
                            }
                          },
                        ),
                        _buildActionButton(
                          'Oturumu Kapat',
                          Colors.grey,
                          () {
                            _authService.signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Bilgileri şık şekilde göstermek için tile widget'ı
  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(icon, color: Colors.green),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }

  // Buton oluşturmak için yardımcı fonksiyon
  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
    );
  }
}
