import 'package:flutter/material.dart';
import 'QuizPage.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('asset/cat.png'),
                  ),
                  SizedBox(width: 20),
                  Column(
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
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        print('Logout button clicked');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: Text(
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
              margin: EdgeInsets.only(right: 20),
              height: 30,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
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
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(right: 20),
              height: 150,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Divider(
              height: 10.0,
              color: Colors.grey[850],
              thickness: 0.5,
              endIndent: 20.0,
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.black,
              ),
              title: Text('Setting'),
              onTap: () {
                print('Settings is clicked');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPage()),
                );
              },
              trailing: Icon(
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
              leading: Icon(
                Icons.info,
                color: Colors.black,
              ),
              title: Text('About'),
              onTap: () {
                print('About is clicked');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPage()),
                );
              },
              trailing: Icon(
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
              leading: Icon(
                Icons.help,
                color: Colors.black,
              ),
              title: Text('Help'),
              onTap: () {
                print('Help is clicked');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPage()),
                );
              },
              trailing: Icon(
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
              leading: Icon(
                Icons.question_answer,
                color: Colors.black,
              ),
              title: Text('FAQ'),
              onTap: () {
                print('FAQ is clicked');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPage()),
                );
              },
              trailing: Icon(
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
    );
  }
}
