import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {


  final testButtonController = TextEditingController();
  final String valuess = TextEditingController().text;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("data"),
        centerTitle: true,
      ),

      body: Center( child: Column(
        children: [
          ElevatedButton(onPressed: (){}, child: Text("test button"))

        ],
      ),
      ),
    );
  }
}