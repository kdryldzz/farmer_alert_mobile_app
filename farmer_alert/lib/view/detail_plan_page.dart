import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:farmer_alert/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailPlanPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final List<DateTime> irrigationDates;

  const DetailPlanPage({
    Key? key,
    required this.product,
    required this.irrigationDates,
  }) : super(key: key);

  @override
  _DetailPlanPageState createState() => _DetailPlanPageState();
}

class _DetailPlanPageState extends State<DetailPlanPage> {
  late TextEditingController irrigationPlanController;
  late List<DateTime> updatedIrrigationDates;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    irrigationPlanController = TextEditingController(text: widget.product['irrigation_plan']);
    updatedIrrigationDates = List.from(widget.irrigationDates);
  }

  @override
  void dispose() {
    irrigationPlanController.dispose();
    super.dispose();
  }

Future<void> _saveUpdatedPlan() async {
  final userId = _authService.getCurrentUserId();
  final productId = widget.product['id'];

  if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Kullanıcı oturumu bulunamadı.")),
    );
    return;
  }

  try {
    // Ürüne ait sulama planını güncelle
    await _authService.supabase
        .from('products')
        .update({
          'irrigation_plan': irrigationPlanController.text,
        })
        .eq('id', productId);

    // Önceki sulama tarihlerini sil
    await _authService.supabase
        .from('irrigation_dates')
        .delete()
        .eq('product_id', productId);

    // Yeni sulama tarihlerini ekle
    for (var date in updatedIrrigationDates) {
      await _authService.supabase.from('irrigation_dates').insert({
        'product_id': productId,
        'irrigation_date': date.toIso8601String(),
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Plan başarıyla güncellendi.")),
    );

    Navigator.pop(context, true); // Güncellenen planla sayfayı kapat
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Hata: ${e.toString()}")),
    );
  }
}


  Future<void> _pickDate(int index) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: updatedIrrigationDates[index],
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != updatedIrrigationDates[index]) {
      setState(() {
        updatedIrrigationDates[index] = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Detayları', style: TextStyle(fontSize: 24)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 54, 116, 215),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF54A0FF), Color(0xFF1E88E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product['product_name'],
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sulama Planı: ${widget.product['irrigation_plan']}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sulama Tarihleri',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E88E5),
                      ),
                    ),
                    const SizedBox(height: 10),
                    updatedIrrigationDates.isEmpty
                        ? const Text('Sulama tarihi bulunmamaktadır.',
                            style: TextStyle(fontSize: 18, color: Colors.grey))
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: updatedIrrigationDates.length,
                            itemBuilder: (context, index) {
                              final date = updatedIrrigationDates[index];
                              return GestureDetector(
                                onTap: () => _pickDate(index),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.date_range,
                                        color: Color(0xFF1E88E5),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        DateFormat.yMMMMd().format(date),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveUpdatedPlan,
                child: const Text(
                  'Planı Güncelle',
                  style: TextStyle(fontSize: 18,color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
