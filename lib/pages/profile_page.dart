import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.settings,
        'text': 'Setting',
        'onTap': () => print('Settings is clicked')
      },
      {
        'icon': Icons.info,
        'text': 'About',
        'onTap': () => print('About is clicked')
      },
      {
        'icon': Icons.help,
        'text': 'Help',
        'onTap': () => print('Help is clicked')
      },
      {
        'icon': Icons.question_answer,
        'text': 'FAQ',
        'onTap': () => print('FAQ is clicked')
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('My Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0.0, left: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/userIcon.png'),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      'Catcat',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: ElevatedButton(
                        onPressed: () => print('Logout button clicked'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 50.0,
                color: Colors.grey,
                thickness: 0.5,
                endIndent: 20.0,
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(right: 20),
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(right: 20),
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 30),
              ...menuItems.map((item) => Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          item['icon'],
                          color: Colors.black,
                        ),
                        title: Text(item['text']),
                        onTap: item['onTap'],
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                        ),
                      ),
                      const Divider(
                        height: 10.0,
                        color: Colors.grey,
                        thickness: 0.5,
                        endIndent: 20.0,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
