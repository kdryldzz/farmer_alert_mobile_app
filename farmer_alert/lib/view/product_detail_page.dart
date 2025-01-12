import 'package:farmer_alert/models/product.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.green, // Daha nötr bir renk
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors
              .white, // Arka planı sade beyaz yaparak dikkat dağıtmayı engelliyoruz
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Transform.scale(
                  scale: 0.65, // Resmi %25 küçültmek için scale: 0.75
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      product.imageUrl,
                      height: 400,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Siyah metin rengi
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                product.price,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:
                      Colors.green, // Fiyatın yeşil olması daha hoş durabilir
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  final Uri testUri = Uri.parse(product.url);
                  await launchUrl(testUri,
                      mode: LaunchMode.externalApplication);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Buton yeşil
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text('Siteye Git'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
