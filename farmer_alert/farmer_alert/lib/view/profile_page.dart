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
  String profileImage ="";
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
        body: Padding(
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
              if(user['gender']=='Female'){
                profileImage = "images/profile.jpg"; // Profil fotoğrafı
              }else{
                profileImage = "images/women_profile.jpg"; // Profil fotoğrafı
              }

              return Column(
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
                    "${user['name']} ${user['surname']}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user['email'] ?? "Email adresi yok",
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
                    subtitle: user['phone'] ?? "Telefon bilgisi yok",
                  ),
                  InfoTile(
                    icon: Icons.location_on,
                    title: "Konum",
                    subtitle: "${user['city']}, ${user['district']}",
                  ),
                  const SizedBox(height: 30),

                  // Düzenle ve Çıkış Butonları
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
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
                                currentDistrict: user['district']
                              ),
                            ),
                          );

                          if (updatedInfo != null) {
                            setState(() {});
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Düzenle',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _authService.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Çıkış',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
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
