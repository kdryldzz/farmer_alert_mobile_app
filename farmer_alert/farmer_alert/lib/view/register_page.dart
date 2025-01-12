import 'package:farmer_alert/services/auth_service.dart';
import 'package:farmer_alert/services/city_district_service.dart';
import 'package:farmer_alert/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? selectedGender; 
  String? selectedCity;
  String? selectedDistrict;
  final authService = AuthService();
  Map<String, List<String>> cityDistricts = {};

  @override
  void initState() {
    super.initState();
    // Load city and district data
    loadCityDistricts();
  }

  void loadCityDistricts() async {
    CityDistrictService cityDistrictService = CityDistrictService();
    final data = await cityDistrictService.loadCityDistricts();
    setState(() {
      cityDistricts = data;
    });
  }

  void registerUser() async {
    final supabase = Supabase.instance.client;
    //prepare data
    final name = _nameController.text;
    final surname = _surnameController.text;
    final username = _usernameController.text;
    final city = selectedCity ?? '';
    final district = selectedDistrict ?? '';
    final phoneNumber = _phoneController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final gender = selectedGender;
    // does match password and confirm password
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("your passwords aren't equals")));
      _passwordController.clear();
      _confirmPasswordController.clear();
    }

    // attempt register
    try {
      final response =
          await supabase.auth.signUp(email: email, password: password);
      await authService.registerUser(name, surname, username, city, district, phoneNumber, email, password, gender!);
      await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Register succesfully completed :)",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));

      final userId = response.user!.id;

      // users tablosuna ekleme
      await supabase.from('users').insert({
        'userId': userId, // Foreign key
        'name': name,
        'surname': surname,
        'username': username,
        'city': city,
        'district': district,
        'phone': phoneNumber,
        'email': email,
        'password': password,
        'gender': gender,
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("error: $e")));
        print("error message: $e");
      }
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/login_page.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Text(
                  "CREATE YOUR ACCOUNT",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 40),
                _buildTextField("Name", _nameController, Icons.person),
                const SizedBox(height: 20),
                _buildTextField("Surname", _surnameController, Icons.person_outline),
                const SizedBox(height: 20),
                _buildTextField("Username", _usernameController, Icons.account_circle),
                const SizedBox(height: 20),
                // Gender Dropdown
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: InputDecoration(
                    labelText: "Gender",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                    prefixIcon: Icon(Icons.account_circle, color: Colors.white),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: "Male", child: Text("Male")),
                    DropdownMenuItem(value: "Female", child: Text("Female")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                // City Dropdown
                DropdownButtonFormField<String>(
                  value: selectedCity,
                  decoration: InputDecoration(
                    labelText: "City",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                    prefixIcon: Icon(Icons.location_city, color: Colors.white),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: cityDistricts.keys.map((city) {
                    return DropdownMenuItem(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCity = value;
                      selectedDistrict = null; // Reset district on city change
                    });
                  },
                ),
                const SizedBox(height: 20),
                // District Dropdown (always visible)
                DropdownButtonFormField<String>(
                  value: selectedDistrict,
                  decoration: InputDecoration(
                    labelText: "District",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                    prefixIcon: Icon(Icons.home, color: Colors.white),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: selectedCity != null
                      ? cityDistricts[selectedCity]!.map((district) {
                          return DropdownMenuItem(
                            value: district,
                            child: Text(district),
                          );
                        }).toList()
                      : cityDistricts.values.expand((e) => e).map((district) {
                          return DropdownMenuItem(
                            value: district,
                            child: Text(district),
                          );
                        }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDistrict = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField("Email", _emailController, Icons.email),
                const SizedBox(height: 20),
                _buildTextField("Phone", _phoneController, Icons.phone),
                const SizedBox(height: 20),
                _buildTextField("Password", _passwordController, Icons.lock, obscureText: true),
                const SizedBox(height: 20),
                _buildTextField("Confirm Password", _confirmPasswordController, Icons.lock_outline, obscureText: true),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  child: const Text(
                    "Already have an account? Log in here",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}}



  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white, fontSize: 16),
        hintText: "Enter your $label",
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.black.withOpacity(0.6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.7)),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.green,
    );
  }