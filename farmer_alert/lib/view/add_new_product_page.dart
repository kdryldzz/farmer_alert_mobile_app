import 'package:farmer_alert/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddNewProductPage extends StatefulWidget {
  const AddNewProductPage({Key? key}) : super(key: key);

  @override
  State<AddNewProductPage> createState() => _AddNewProductPageState();
}

class _AddNewProductPageState extends State<AddNewProductPage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime? _irrigationDate;
  DateTime? _harvestDate;

  // Sulama aralığı seçenekleri
  final List<String> irrigationOptions = [
    "Plan yok",
    "Günde bir",
    "İki günde bir",
    "Üç günde bir",
    "Haftada bir",
    "Ayda bir",
    "İki ayda bir",
  ];

  String selectedIrrigationPlan = "Plan yok"; // Varsayılan değer

  // Supabase instance
  final supabase = Supabase.instance.client;

  // Tarih seçmek için yardımcı fonksiyon
  Future<void> _selectDate(BuildContext context, DateTime? initialDate,
      Function(DateTime) onDateSelected) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }

  // Sulama tarihlerini hesaplama fonksiyonu
  List<String> _generateIrrigationDates() {
    List<String> irrigationDates = [];
    if (_irrigationDate != null && _harvestDate != null) {
      final duration = _harvestDate!.difference(_irrigationDate!);
      final days = duration.inDays;

      if (selectedIrrigationPlan == "Günde bir") {
        for (int i = 0; i <= days; i++) {
          irrigationDates.add(DateFormat.yMMMMd().format(_irrigationDate!.add(Duration(days: i))));
        }
      } else if (selectedIrrigationPlan == "İki günde bir") {
        for (int i = 0; i <= days; i += 2) {
          irrigationDates.add(DateFormat.yMMMMd().format(_irrigationDate!.add(Duration(days: i))));
        }
      } else if (selectedIrrigationPlan == "Üç günde bir") {
        for (int i = 0; i <= days; i += 3) {
          irrigationDates.add(DateFormat.yMMMMd().format(_irrigationDate!.add(Duration(days: i))));
        }
      } else if (selectedIrrigationPlan == "Haftada bir") {
        for (int i = 0; i <= days; i += 7) {
          irrigationDates.add(DateFormat.yMMMMd().format(_irrigationDate!.add(Duration(days: i))));
        }
      } else if (selectedIrrigationPlan == "Ayda bir") {
        for (int i = 0; i <= days; i += 30) {
          irrigationDates.add(DateFormat.yMMMMd().format(_irrigationDate!.add(Duration(days: i))));
        }
      } else if (selectedIrrigationPlan == "İki ayda bir") {
        for (int i = 0; i <= days; i += 60) {
          irrigationDates.add(DateFormat.yMMMMd().format(_irrigationDate!.add(Duration(days: i))));
        }
      }
    }
    return irrigationDates;
  }

  // Ürün ve sulama tarihlerini Supabase'e kaydetme
Future<void> _saveProductPlan() async {
  final String productName = _productNameController.text;
  final String notes = _notesController.text;

  if (productName.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Lütfen tüm zorunlu alanları doldurun."),
      ),
    );
    return;
  }

  // Mevcut kullanıcının user_id'sini almak
  final user = supabase.auth.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Kullanıcı oturum açmamış."),
      ),
    );
    return;
  }

  final userId = user.id;

  try {
    // 1. Ürün bilgilerini "products" tablosuna kaydet
    final response = await supabase.from('products').insert([
      {
        'user_id': userId,
        'product_name': productName,
        'irrigation_plan': selectedIrrigationPlan,
        'irrigation_start_date': _irrigationDate?.toIso8601String(),
        'harvest_date': _harvestDate?.toIso8601String(),
        'notes': notes,
      }
    ]).select();

    // Ürün kaydedildiyse, yanıtı kontrol et
    if (response.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ürün kaydedilemedi.")),
      );
      return;
    }

    // Ürünü kaydetme işlemi başarılı
    final productId = response[0]['id'];

    // 2. Sulama tarihlerini "irrigation_dates" tablosuna kaydet
    List<String> irrigationDates = _generateIrrigationDates();

// İrrigasyon tarihlerini tek bir INSERT sorgusu ile ekleyebiliriz.
final irrigationDateList = irrigationDates.map((date) {
  // Önce 'DateFormat' ile tarihi DateTime nesnesine çeviriyoruz
  final dateTime = DateFormat('MMMM dd, yyyy').parse(date);  // Örneğin: 'January 16, 2025' formatındaki tarihleri dönüştürür

  return {
    'product_id': productId,
    'irrigation_date': dateTime.toIso8601String(),  // Dönüştürdükten sonra ISO 8601 formatında veritabanına kaydediyoruz
  };
}).toList();

// İrrigasyon tarihlerini ekledikten sonra, Supabase yanıtını kontrol et
await supabase.from('irrigation_dates').insert(irrigationDateList);

// Yanıt kontrolü // Burada hata kontrolü yapmadan devam edebilirsiniz// burada hata var ama yinede ekliyor database'e


    // AlertDialog ile sulama planını göster
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("İlaçlama Planı Oluşturuldu"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: irrigationDates
                .map((date) => Text(date))
                .toList(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
              },
              child: const Text("Kapat"),
            ),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNewProductPage()));
            }, child: Text("yeni ürün ekle"))
          ],
        );
      },
    );

    // Verileri sıfırlama
    setState(() {
      _productNameController.clear();
      _notesController.clear();
      _irrigationDate = null;
      _harvestDate = null;
      selectedIrrigationPlan = irrigationOptions.first;
    });

  } catch (e) {
    // Hata durumunda kullanıcıya bildirim göster
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Hata: $e")),
    );
    print("error message: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Geri tuşuna basıldığında HomePage'e yönlendir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return false; // Varsayılan geri işlevi engelleniyor
      },
    child:  Scaffold(
      appBar: AppBar(
        title: const Text(
          "Yeni Ürün Ekle",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: const Color.fromARGB(255, 54, 116, 215),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ürün Bilgileri",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _productNameController,
                decoration: const InputDecoration(
                  labelText: "Ürün Adı",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "İlaçlama Planı",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedIrrigationPlan,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: irrigationOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedIrrigationPlan = newValue!;
                  });
                },
              ),
              const SizedBox(height: 15),
              const Text(
                "Tarih Bilgileri",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text("İlk ilaçlama Tarihi"),
                subtitle: Text(_irrigationDate == null
                    ? "Henüz seçilmedi"
                    : DateFormat.yMMMMd().format(_irrigationDate!)),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, _irrigationDate,
                      (pickedDate) => setState(() {
                            _irrigationDate = pickedDate;
                          })),
                ),
              ),
              ListTile(
                title: const Text("Tahmini Hasat Tarihi"),
                subtitle: Text(_harvestDate == null
                    ? "Henüz seçilmedi"
                    : DateFormat.yMMMMd().format(_harvestDate!)),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, _harvestDate,
                      (pickedDate) => setState(() {
                            _harvestDate = pickedDate;
                          })),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Ek Notlar",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _notesController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "Notlar",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _saveProductPlan,
                  icon: const Icon(Icons.save),
                  label: const Text("Ürünü Kaydet"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 54, 116, 215),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
