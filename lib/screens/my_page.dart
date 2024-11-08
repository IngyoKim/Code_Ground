import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          'My Page',
        ),
      ),
      body: SingleChildScrollView(
        // Scroll 기능 추가
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
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Catcat',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          print('Logout button clicked');
                        },
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
              Divider(
                height: 50.0,
                color: Colors.grey[850],
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
              const SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(right: 20),
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Divider(
                height: 10.0,
                color: Colors.grey[850],
                thickness: 0.5,
                endIndent: 20.0,
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                title: const Text('Setting'),
                onTap: () {
                  print('Settings is clicked');
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                ),
              ),
              Divider(
                height: 10.0,
                color: Colors.grey[850],
                thickness: 0.5,
                endIndent: 20.0,
              ),
              ListTile(
                leading: const Icon(
                  Icons.info,
                  color: Colors.black,
                ),
                title: const Text('About'),
                onTap: () {
                  print('About is clicked');
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                ),
              ),
              Divider(
                height: 10.0,
                color: Colors.grey[850],
                thickness: 0.5,
                endIndent: 20.0,
              ),
              ListTile(
                leading: const Icon(
                  Icons.help,
                  color: Colors.black,
                ),
                title: const Text('Help'),
                onTap: () {
                  print('Help is clicked');
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                ),
              ),
              Divider(
                height: 10.0,
                color: Colors.grey[850],
                thickness: 0.5,
                endIndent: 20.0,
              ),
              ListTile(
                leading: const Icon(
                  Icons.question_answer,
                  color: Colors.black,
                ),
                title: const Text('FAQ'),
                onTap: () {
                  print('FAQ is clicked');
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                ),
              ),
              Divider(
                height: 10.0,
                color: Colors.grey[850],
                thickness: 0.5,
                endIndent: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
