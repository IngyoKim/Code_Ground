import 'package:flutter/material.dart';

void main() => runApp(Myapp());
String name = 'cating';

class Myapp extends StatelessWidget {
  const Myapp({super.key});

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
                  // MyPage로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPage()),
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
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0, left: 10.0),
          child: Column(
            children: [
              // 프로필 이미지, 이름, 이메일, 로그아웃 버튼을 가로로 배치
              Padding(
                padding: const EdgeInsets.only(top: 0.0, left: 10.0),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // 요소들을 수직으로 중앙 정렬
                  children: [
                    // 프로필 이미지
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('asset/cat.png'),
                    ),
                    SizedBox(width: 20), // 프로필 이미지와 텍스트 사이 간격
                    // 사용자 이름과 이메일을 세로로 배치하기 위한 Column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                      children: [
                        // 사용자 이름
                        Text(
                          'Catcat',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        // SizedBox(height: 5), // 이름과 이메일 사이 간격
                        // // 사용자 이메일
                        // Text(
                        //   'Catcat@mail.com',
                        //   style: TextStyle(
                        //     fontSize: 18.0,
                        //     color: Colors.grey[600],
                        //   ),
                        // ),
                      ],
                    ),
                    //SizedBox(width: 50),
                    Spacer(),
                    // 로그아웃 버튼
                    Container(
                      margin: EdgeInsets.only(right: 20), // 오른쪽 20px 여백
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
              // 밑에 선
              Divider(
                height: 50.0,
                color: Colors.grey[850],
                thickness: 0.5,
                endIndent: 20.0,
              ),
              // 왼쪽 20px, 오른쪽 20px 떨어진 위치의 사각형 (높이 20px)
              Container(
                width: double.infinity, // 화면 전체 너비
                margin: EdgeInsets.only(right: 20), // 좌우 20px 여백
                height: 30, // 높이 20px
                decoration: BoxDecoration(
                  color: Colors.grey, // 사각형 색상
                  borderRadius: BorderRadius.circular(10), // 둥근 모서리
                ),
                child: Center(
                  child: Text(
                    '+', // '+' 텍스트 추가
                    style: TextStyle(
                      fontSize: 24, // 텍스트 크기
                      color: Colors.white, // 텍스트 색상
                      fontWeight: FontWeight.bold, // 텍스트 굵게
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity, // 화면 전체 너비
                margin: EdgeInsets.only(right: 20), // 좌우 20px 여백
                height: 150, // 높이 20px
                decoration: BoxDecoration(
                  color: Colors.blue, // 사각형 색상
                  borderRadius: BorderRadius.circular(10), // 둥근 모서리
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
      ),
    );
  }
}
