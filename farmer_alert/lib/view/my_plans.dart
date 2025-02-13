import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'detail_plan_page.dart';

class MyPlansPage extends StatefulWidget {
  const MyPlansPage({Key? key}) : super(key: key);

  @override
  _MyPlansPageState createState() => _MyPlansPageState();
}

class _MyPlansPageState extends State<MyPlansPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> products = [];
  Map<int, List<DateTime>> irrigationDates = {};

  @override
  void initState() {
    super.initState();
    _loadUserPlans();
  }

  Future<void> _loadUserPlans() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final productResponse = await supabase
          .from('products')
          .select('*')
          .eq('user_id', user.id);

      if (productResponse.isEmpty) {
        throw Exception('Ürün bulunamadı');
      }

      products = List<Map<String, dynamic>>.from(productResponse);

      for (var product in products) {
        final productId = product['id'];

        final irrigationResponse = await supabase
            .from('irrigation_dates')
            .select('irrigation_date')
            .eq('product_id', productId);

        if (irrigationResponse.isEmpty) {
          throw Exception('plan verileri alınamadı');
        }

        irrigationDates[productId] = (irrigationResponse as List)
            .map((date) => DateTime.parse(date['irrigation_date']))
            .toList();
      }

      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PLANLARIM',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 54, 116, 215),
        elevation: 5,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/login_page.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: products.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final productId = product['id'];
                  final irrigationList = irrigationDates[productId] ?? [];

                  return GestureDetector(
                    onTap: () {
                      // Detay sayfasına yönlendir
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPlanPage(
                            product: product,
                            irrigationDates: irrigationList,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.lightGreen.withOpacity(0.7),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(20),
                        title: Text(
                          product['product_name'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              'İlaçlama Planı: ${product['irrigation_plan']}',
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            const SizedBox(height: 15),
                            if (irrigationList.isNotEmpty)
                              const Text(
                                'İlaçlama Tarihleri:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            const SizedBox(height: 5),
                            ...irrigationList.map((date) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    const Icon(Icons.date_range, color: Colors.blue, size: 16),
                                    const SizedBox(width: 5),
                                    Text(
                                      DateFormat.yMMMMd().format(date),
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
