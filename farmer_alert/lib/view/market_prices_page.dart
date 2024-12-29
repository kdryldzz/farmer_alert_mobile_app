import 'package:farmer_alert/models/product.dart';
import 'package:farmer_alert/view/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class MarketPrices extends StatefulWidget {
  @override
  _MarketPricesState createState() => _MarketPricesState();
}

class _MarketPricesState extends State<MarketPrices> {
  List<Product> products = [];

  Future<void> loadProducts() async {
    final jsonString = await rootBundle.loadString('datas/gubre_products.json');
    final jsonData = json.decode(jsonString) as List;
    setState(() {
      products = jsonData.map((data) => Product.fromJson(data)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ÜRÜN LİSTESİ",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
        ),
        backgroundColor:
            Color.fromARGB(255, 54, 116, 215), // Uyarlanmış başlık rengi
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/login_page.jpg"), // Arka plan resmi
            fit: BoxFit.cover,
          ),
        ),
        child: products.isEmpty
            ? Center(
                child:
                    CircularProgressIndicator()) // Veriler yüklenirken gösterilecek animasyon
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 10,
                    color: Colors.white.withOpacity(0.8),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(15),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          product.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color:
                              Color.fromARGB(255, 54, 116, 215), // Başlık rengi
                        ),
                      ),
                      subtitle: Text(
                        product.price,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward,
                        color: Color.fromARGB(255, 54, 116, 215),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(product: product),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
