import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: const Center(child: UserData()),
      ),
    );
  }
}

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  String name = 'Loading..';
  String gender = 'Loading..';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse('https://randomuser.me/api/?results=15');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = data['results'][0];
        setState(() {
          name = '${user['name']['first']} ${user['name']['last']}';
          gender = user['gender'];
        });
      } else {
        setState(() {
          name = 'Failed to load';
          gender = '';
        });
      }
    } catch (e) {
      setState(() {
        name = 'Error';
        gender = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Name: $name'),
          Text('Gender: $gender'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: fetchData,
            child: const Text('Fetch Data'),
          ),
        ],
      ),
    );
  }
}