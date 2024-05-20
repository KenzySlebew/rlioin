import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'detail_page.dart';
import 'package:google_fonts/google_fonts.dart'; // Adjust the import path as necessary

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio Form',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return const PortfolioForm(title: 'Submit Your Portfolio');
  }
}

class PortfolioForm extends StatefulWidget {
  const PortfolioForm({super.key, required this.title});

  final String title;

  @override
  State<PortfolioForm> createState() => _PortfolioFormState();
}

class ItemCard extends StatelessWidget {
  final String email;
  final String contact;
  final String experience;
  final String imagePath;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const ItemCard({
    super.key,
    required this.email,
    required this.contact,
    required this.experience,
    required this.imagePath,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(email),
            subtitle: Text(contact),
          ),
          Text('Experience: $experience'),
          imagePath.isNotEmpty
              ? Image.file(File(imagePath))
              : const Text('No image selected.'),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onUpdate,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PortfolioFormState extends State<PortfolioForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _contact = '';
  String _experience = '';
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Assuming you have a route to navigate after form submission
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPage(
            email: _email,
            contact: _contact,
            experience: _experience,
            imagePath: _image?.path ?? '',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Contact',
                  labelText: 'Contact',
                ),
                keyboardType: TextInputType.number, // Set keyboard type to number
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your contact';
                  }
                  return null;
                },
                onSaved: (value) => _contact = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Experience',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Experience';
                  }
                  return null;
                },
                onSaved: (value) => _experience = value!,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: OutlinedButton(
                  onPressed: _pickImage,
                  child: const Text('Upload Image'),
                ),
              ),
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.file(File(_image!.path)),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    'Submit',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 16, // Optional: Adjust the font size
                        fontWeight: FontWeight.w500, // Optional: Adjust the font weight
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
