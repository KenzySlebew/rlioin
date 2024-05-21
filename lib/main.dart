// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD SQLite',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override

// ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DBHelper dbHelper = DBHelper();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _refreshUsers();
  }

  void _refreshUsers() async {
    final data = await dbHelper.queryAllUsers();
    setState(() {
      _users = data;
    });
  }

  void _showForm(int? id) {
    if (id != null) {
      final existingUser = _users.firstWhere((element) => element['id'] == id);
      _nameController.text = existingUser['name'];
      _addressController.text = existingUser['address'];
    } else {
      _nameController.clear();
      _addressController.clear();
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        builder: (_) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Address'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      child: Text(id == null ? 'Create' : 'Update'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (id == null) {
                            _addUser();
                          } else {
                            _updateUser(id);
                          }
                          Navigator.of(context).pop();
                        }
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  Future<void> _addUser() async {
    await dbHelper.insertUser({
      'name': _nameController.text,
      'address': _addressController.text,
    });
    _refreshUsers();
  }

  Future<void> _updateUser(int id) async {
    await dbHelper.updateUser({
      'id': id,
      'name': _nameController.text,
      'address': _addressController.text,
    });
    _refreshUsers();
  }

  void _deleteUser(int id) async {
    await dbHelper.deleteUser(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('User deleted')));
    _refreshUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter CRUD with SQLite'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.all(15),
          child: ListTile(
            title: Text(_users[index]['name']),
            subtitle: Text(_users[index]['address']),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showForm(_users[index]['id']),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteUser(_users[index]['id']),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
