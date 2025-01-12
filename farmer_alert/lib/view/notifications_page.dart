import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _generalNotifications = true; // Genel bildirimler
  bool _promotionalNotifications = false; // Tanıtım bildirimleri
  bool _soundEnabled = true; // Ses açık mı?
  bool _vibrationEnabled = true; // Titreşim açık mı?

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bildirimler',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bilgilendirici Kısım
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              color: Colors.green[50],
              child: const Text(
                'Bildirim tercihlerinizi aşağıdaki seçeneklerden yönetebilirsiniz.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),

            // Bildirim Ayarları
            SwitchListTile(
              title: const Text('Tüm Bildirimlere İzin Ver'),
              subtitle:
                  const Text('Uygulama ile ilgili bildirimleri alın.'),
              value: _generalNotifications,
              onChanged: (value) {
                setState(() {
                  _generalNotifications = value;
                });
              },
              activeColor: Colors.green,
            ),
            SwitchListTile(
              title: const Text('Tanıtım Bildirimleri'),
              subtitle: const Text(
                  'Promosyonlar ve kampanyalar hakkında bildirimler.'),
              value: _promotionalNotifications,
              onChanged: (value) {
                setState(() {
                  _promotionalNotifications = value;
                });
              },
              activeColor: Colors.green,
            ),
            SwitchListTile(
              title: const Text('Bildirim Sesi'),
              subtitle: const Text('Bildirimlerde ses çalsın.'),
              value: _soundEnabled,
              onChanged: (value) {
                setState(() {
                  _soundEnabled = value;
                });
              },
              activeColor: Colors.green,
            ),
            SwitchListTile(
              title: const Text('Bildirim Titreşimi'),
              subtitle:
                  const Text('Bildirimler sırasında titreşim kullanılsın.'),
              value: _vibrationEnabled,
              onChanged: (value) {
                setState(() {
                  _vibrationEnabled = value;
                });
              },
              activeColor: Colors.green,
            ),

            // Kaydet Butonu
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  // Kullanıcının ayarları kaydedilebilir
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bildirim ayarları kaydedildi!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Kaydet',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
