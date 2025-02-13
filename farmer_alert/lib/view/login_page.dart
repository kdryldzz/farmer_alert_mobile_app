import 'package:farmer_alert/services/auth_service.dart';
import 'package:farmer_alert/view/home_page.dart';
import 'package:farmer_alert/view/register_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
   //get  auth
  final authService = AuthService();
  void _resetPassword(String email) async {
  try {
    await authService.resetPassword(email);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Password reset email sent to $email"),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}
void _showPasswordResetDialog() {
  final TextEditingController emailController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Password Reset"),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: "Enter your email",
            hintText: "example@example.com",
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Reset"),
            onPressed: () {
              final email = emailController.text.trim();
              if (email.isNotEmpty) {
                _resetPassword(email);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please enter a valid email"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  // text Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

//login button on pressed
  void login() async {
    //prepare data
    final email = _emailController.text;
    final password = _passwordController.text;

    //attempt login....
    try {
      await authService.SignInWithEmailPassword(email, password);
      await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "You logged in",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("errror message $e")));
        _emailController.clear();
        _passwordController.clear();
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
          child: SizedBox(
            height: MediaQuery.of(context).size.height, // Tam ekran yüksekliği
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  "WELCOME TO ",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
                ),
                const Text(
                  "FARMER ALERT ",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 100,
                ),
                const Center(
                    child: (Text(
                  "LOGIN",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ))),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle:
                        const TextStyle(color: Colors.white, fontSize: 16),
                    hintText: "Enter your email",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.email, color: Colors.white),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.green, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.7)),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.green,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle:
                        const TextStyle(color: Colors.white, fontSize: 16),
                    hintText: "Enter your password",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.green, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.7)),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.green,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed:login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  child: const Text(
                    "if you don't have an account yet click here",
                    style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w900),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
                ),
                SizedBox(height: 20,),
                GestureDetector(
  child: const Text(
    "Forgot your password?",
    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
  ),
  onTap: () {
    _showPasswordResetDialog();
  },
),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
