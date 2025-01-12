import 'package:flutter/material.dart';

class PlantDetailPage extends StatefulWidget {
  const PlantDetailPage({super.key});

  @override
  State<PlantDetailPage> createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant name"),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
