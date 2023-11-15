import 'package:flutter/material.dart';
import 'style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'notification.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (c) => Store1(),
    child: MaterialApp(
        // <style><style> 같은거임
        theme: theme,
        home: MyApp()),
  ));
}

var a = TextStyle(backgroundColor: Colors.black, color: Colors.white);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];
  var userImage;

  saveData() async {
    var storage = await SharedPreferences.getInstance();
    storage.setString('이름', '데이터');
    var result = storage.get('이름');
    print(result);
  }

  getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    if (result.statusCode == 200) {
      print('성공');
    } else {
      print('실패');
    }
    setState(() => data = jsonDecode(result.body));
  }

  @override
  void initState() {
    super.initState();
    getData();
    initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNotification();
        },
      ),
      appBar: AppBar(
        title: Text("Instagram"),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () async {
              var picker = ImagePicker();
              var image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                setState(() {
                  userImage = File(image.path);
                });
              }

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => Upload(userImage: userImage)));
            },
            iconSize: 30,
          )
        ],
      ),
      body: [MyPost(data: data), Text('샵페이지')][tab],
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (i) {
            setState(() {
              tab = i;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "홈"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined), label: "샵")
          ]),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MyPost extends StatefulWidget {
  const MyPost({this.data, super.key});
  final data;

  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  var scroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scroll.addListener(() {
      print(scroll.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      return ListView.builder(
          itemCount: 3,
          controller: scroll,
          itemBuilder: (c, i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Text(
                    widget.data[i]['user'],
                  ),
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (c) => Profile()));
                  },
                ),
                Image.network(widget.data[i]['image']),
                Text(
                  widget.data[i]['content'],
                )
              ],
            );
          });
    } else {
      return CircularProgressIndicator();
    }
  }
}

class Upload extends StatelessWidget {
  const Upload({this.userImage, super.key});
  final userImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(userImage),
            Text('이미지 업로드 화면'),
            TextField(),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ));
  }
}

class Store1 extends ChangeNotifier {
  var name = 'john kim';
  changeName() {
    name = 'john park';
    notifyListeners();
  }
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<Store1>().name)),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                context.read<Store1>().changeName();
              },
              child: Text('버튼'))
        ],
      ),
    );
  }
}
