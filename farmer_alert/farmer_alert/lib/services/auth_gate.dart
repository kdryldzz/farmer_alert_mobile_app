/*
AUTH GATE - This will continuously listen for auth state changes

---------------------------------------------------------------------

unauthhenticated -> Login page
authhenticated -> pofile page

*/

import 'package:farmer_alert/view/home_page.dart';
import 'package:farmer_alert/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
//lsiten to the authstate changes
      stream: Supabase.instance.client.auth.onAuthStateChange,
// Build appropriate page based on auth state
      builder: (context, snapshot) {
        //loading..
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
//check if there is a valid session currently
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return  HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
