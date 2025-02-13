import 'package:farmer_alert/services/auth_service.dart';
import 'package:flutter/material.dart';

class PrivacySecurityPage extends StatefulWidget {
  const PrivacySecurityPage({super.key});

  @override
  State<PrivacySecurityPage> createState() => _PrivacySecurityPageState();
}

class _PrivacySecurityPageState extends State<PrivacySecurityPage> {
  
  final _authService = AuthService();

void _showDeleteConfirmationDialog() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Hesabı Sil"),
        content: const Text(
            "Hesabınızı silmek istediğinize emin misiniz? Bu işlem yönetici onayı gerektirir.Hesabınız 30 gün içerisinde silinecektir"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Dialog'u kapat
            },
            child: const Text("İptal"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Dialog'u kapat
              try {
                await _authService.requestAccountDeletion();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Hesap silme isteğiniz gönderildi."),
                    backgroundColor: Colors.green,
                  ),
                );
              } 
              catch (e) {
                /*ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Hata: $e"),
                    backgroundColor: Colors.red,
                  ),
                );*/
              }
            },
            child: const Text("Evet"),
          ),
        ],
      );
    },
  );
}


  void _showPasswordResetConfirmation() async {
  // Aktif kullanıcı e-postasını al
  final email = _authService.getCurrentUserEmail();

  if (email == null) {
    // Eğer oturum açmamışsa veya e-posta alınamıyorsa hata mesajı göster
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Aktif kullanıcı e-postası alınamadı."),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  // Onay diyaloğunu göster
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Şifre Yenile"),
        content: Text(
            "Şifre yenileme bağlantısı ${email} adresine gönderilecek. Devam etmek istediğinize emin misiniz?"),
        actions: [
          TextButton(
            child: const Text("İptal"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Evet"),
            onPressed: () {
              Navigator.of(context).pop(); // Diyaloğu kapat
              _resetPassword(email); // Şifre sıfırlama işlemini başlat
            },
          ),
        ],
      );
    },
  );
}

  void _resetPassword(String email) async {
  try {
    await _authService.resetPassword(email); // Supabase'den şifre sıfırla
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Şifre sıfırlama e-postası $email adresine gönderildi."),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Hata: Şifre sıfırlama başarısız oldu. $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gizlilik ve Güvenlik',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bilgilendirici kısım
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              color: Colors.green[50],
              child: const Text(
                'Gizlilik ve güvenlik ayarlarınızı burada yönetebilirsiniz.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),

            // Ayarlar listesi
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildSettingTile(
                  icon: Icons.reset_tv,
                  title: 'Şifre Yenile',
                  onTap: () {
                     _showPasswordResetConfirmation(); // Şifre yenileme diyaloğunu çağır
                  },
                ),
                _buildSettingTile(
                  icon: Icons.delete,
                  title: 'Hesabı Sil',
                  onTap: () {
                    _showDeleteConfirmationDialog(); // Hesap silme işlemi
                  },
                )
              ],
            ),
          ],
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
