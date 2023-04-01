import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ข้อมูลผู้ติดต่อ',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> _users = [];

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  Future<void> _getUsers() async {
    try {
      final response =
          await http.get(Uri.parse('https://randomuser.me/api/?results=100'));
      final json = jsonDecode(response.body);
      final results = json['results'];
      setState(() {
        _users = results;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 25, 21, 29),
        title: const Center( child: Text('ข้อมูลผู้ติดต่อ'))
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
           onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    thumbnail: user['picture']['thumbnail'],
                    phone: user['phone'],
                    email: user['email'], 
                    firstName:  user['name']['first'],
                    lastName:  user['name']['last'],
                  ),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user['picture']['thumbnail']),
            ),
            title: Text('${user['name']['first']} ${user['name']['last']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['phone']),
                Text(user['email']),
              ],
            ),
          );
        },
      ),
    );
  }
}



class DetailPage extends StatelessWidget {
  final String thumbnail;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;

  DetailPage({
    required this.thumbnail,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 25, 21, 29),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center( child: Text('ข้อมูลผู้ติดต่อ')),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16.0,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                CircleAvatar(radius: 50.0,backgroundImage: NetworkImage(thumbnail)),
                const SizedBox(height: 16.0),
                Text('$firstName $lastName'),
              ],
            ),
          ),  
          const SizedBox(
            height: 25.0,
          ),
          Row(
            children: [
              SizedBox(width: 20.0),
              Text('เบอร์โทรศัพท์ $phone'),
            ]
          ),
          Row(
            children: [
              SizedBox(width: 20.0),
              Text('อีเมล $email'),
            ]
           )
        ],
      ),
    );
  }
}
