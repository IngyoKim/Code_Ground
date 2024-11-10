import 'package:flutter/material.dart';
import 'MyPage.dart';
import 'QuizPage.dart';

void main() => runApp(MyApp());
String name = 'cating';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'opensorce',
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(
          backgroundColor: Colors.amber[700],
          title: Text('Growing cat'),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('asset/cat.png'),
                ),
                accountName: Text('Catcat'),
                accountEmail: Text('Catcat@mail.com'),
                onDetailsPressed: () {
                  print('arrow is clicked');
                },
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 238, 180, 16),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    )),
              ),
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                title: Text('Home'),
                onTap: () {
                  print('Home is clicked');
                },
                trailing: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                title: Text('setting'),
                onTap: () {
                  print('Setting is clicked');
                },
                trailing: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.question_answer,
                  color: Colors.black,
                ),
                title: Text('Q&A'),
                onTap: () {
                  print('Q&A is clicked');
                },
                trailing: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.quiz,
                  color: Colors.black,
                ),
                title: Text('Quiz'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizPage()),
                  );
                },
                trailing: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 40.0,
              ),
              Text(
                'feed a cat',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2.0,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                'name-$name',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2.0,
                  fontSize: 20.0,
                ),
              ),
              Image.asset(
                'asset/cat.png',
                width: 500,
                height: 500,
              ),
              SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 60.0),
                  child: Text(
                    'EXP : ',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyPage()), // MyPage() 호출
                  );
                },
                child: Image.asset(
                  'asset/start.png',
                  width: 200,
                  height: 200,
                ),
              ),
            ],
          ),
        ));
  }
}
