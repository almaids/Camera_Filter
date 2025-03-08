import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'BiodataSevice.dart'; // Perbaiki nama file
import 'package:camera/camera.dart';
import 'takepicture_screen.dart';

class MyHomePage extends StatefulWidget {
  final CameraDescription camera;

  const MyHomePage({super.key, required this.camera});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BiodataService? service;
  String? selectedDocId;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    service = BiodataService(FirebaseFirestore.instance);
  }

  void clearFields() {
    nameController.clear();
    ageController.clear();
    addressController.clear();
    setState(() {
      selectedDocId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Biodata App",
          style: TextStyle(color: Colors.pink),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Enter Your Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(hintText: 'Enter Your Age'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(hintText: 'Enter Your Address'),
              ),
              const SizedBox(height: 30),
              
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Show Data",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Tambahkan garis pembatas
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: service?.getBiodata(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No data available'));
                    }

                    final documents = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        var doc = documents[index];
                        return ListTile(
                          title: Text(doc['name']),
                          subtitle: Text("${doc['age']} - ${doc['address']}"),
                          onTap: () {
                            if (mounted) {
                              setState(() {
                                selectedDocId = doc.id;
                                nameController.text = doc['name'];
                                ageController.text = doc['age'];
                                addressController.text = doc['address'];
                              });
                            }
                          },
                          trailing: IconButton(
                            onPressed: () {
                              service?.delete(doc.id);
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.pink,
            child: const Icon(Icons.camera_alt, color: Colors.white),
            onPressed: () async {
              try {
                final imagePath = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TakePictureScreen(camera: widget.camera),
                  ),
                );

                if (imagePath != null && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Picture saved at: $imagePath')),
                  );
                }
              } catch (e) {
                print("Error opening camera: $e");
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to open camera")),
                  );
                }
              }
            },
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            backgroundColor: Colors.pink,
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              final name = nameController.text.trim();
              final age = ageController.text.trim();
              final address = addressController.text.trim();

              if (name.isEmpty || age.isEmpty || address.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All fields must be filled')),
                );
                return;
              }

              if (selectedDocId != null) {
                service?.update(selectedDocId!, {'name': name, 'age': age, 'address': address});
              } else {
                service?.add({'name': name, 'age': age, 'address': address});
              }
              clearFields();
            },
          ),
        ],
      ),
    );
  }
}