import 'package:flutter/material.dart';
import 'package:farmer_alert/services/auth_service.dart';

class EditProfilePage extends StatefulWidget {
  final String currentUsername;
  final String currentName;
  final String currentSurname;
  final String currentEmail;
  final String currentPhone;
  final String currentCity;
  final String currentDistrict;

  const EditProfilePage({
    super.key,
    required this.currentUsername,
    required this.currentName,
    required this.currentSurname,
    required this.currentEmail,
    required this.currentPhone,
    required this.currentCity,
    required this.currentDistrict,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController usernameController;
  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController cityController;
  late TextEditingController districtController;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.currentUsername);
    nameController = TextEditingController(text: widget.currentName);
    surnameController = TextEditingController(text: widget.currentSurname);
    emailController = TextEditingController(text: widget.currentEmail);
    phoneController = TextEditingController(text: widget.currentPhone);
    cityController = TextEditingController(text: widget.currentCity);
    districtController = TextEditingController(text: widget.currentDistrict);
  }

  @override
  void dispose() {
    usernameController.dispose();
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    cityController.dispose();
    districtController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final userId = _authService.getCurrentUserId();

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kullanıcı oturumu bulunamadı.")),
      );
      return;
    }

    try {
      await _authService.supabase
          .from('users')
          .update({
            'username': usernameController.text,
            'name': nameController.text,
            'surname': surnameController.text,
            'phone': phoneController.text,
            'city': cityController.text,
            'district': districtController.text,
          })
          .eq('userId', userId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil başarıyla güncellendi.")),
      );

      Navigator.pop(context, true); // Profilin başarıyla güncellendiğini sinyal gönder
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profili Düzenle"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "Kullanıcı Adı",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "İsim",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: surnameController,
                decoration: const InputDecoration(
                  labelText: "Soyisim",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "E-posta",
                  border: OutlineInputBorder(),
                ),
                enabled: false, // E-posta alanını düzenlenemez yap
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "Telefon",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: "İl",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: districtController,
                decoration: const InputDecoration(
                  labelText: "İlçe",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text("Kaydet"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
