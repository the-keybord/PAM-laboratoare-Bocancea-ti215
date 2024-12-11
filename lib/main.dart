import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final jsonData = await rootBundle.rootBundle.loadString('assets/data.json');
    setState(() {
      data = jsonDecode(jsonData);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    List<String> imageList = List<String>.from(data!['imageList']);
    List<String> locations = List<String>.from(data!['locations']);
    List<dynamic> categories = data!['categories'];
    List<dynamic> medicalCenters = data!['medicalCenters'];
    List<dynamic> doctors = data!['doctors'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<String>(
              value: locations.first,
              items: locations.map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: (value) {},
            ),
            Icon(Icons.notifications_active, color: Colors.black),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CarouselSlider(
                  items: imageList.map((image) {
                    return Container(
                      width: double.infinity,
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover, // Crop the image
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    height: 200,
                    enlargeCenterPage: true,
                  ),
                ),
              ),
            ),

            // Categories Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Categories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 20,
                runSpacing: 16,
                children: categories.map((category) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                        child: Container(
                          width: 75,
                          height: 75,
                          color: Colors.white,
                          child: Image.asset(
                            'assets/images/categories/${category['icon']}.png',
                            fit: BoxFit.cover, // Crop image
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      // Text with specific width and truncation if it overflows
                      Container(
                        width: 60, // Set a specific width for the text
                        child: Text(
                          category['label'],
                          style: TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis, // Truncate text with ellipsis
                          maxLines: 1, // Ensure it's a single line
                          textAlign: TextAlign.center, // Optional: Center the text
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            )
,

            // Medical Centers Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Nearby Medical Centers",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: medicalCenters.map((center) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        center['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover, // Crop the image to fit the container
                      ),
                    ),
                    title: Text(center['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(center['address']),
                        Text(center['distance'], style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        Text("${center['rating']}"),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            // Doctors Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Doctors",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: doctors.map((doctor) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        doctor['image'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover, // Crop the image
                      ),
                    ),
                    title: Text(doctor['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(doctor['specialty']),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
