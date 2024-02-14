import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  getData() async {
    // 외외처리!
    try {
      var result = await firestore
          .collection('product')
          .doc('0rY8mjBT7mZ1gwFUP35Q')
          .get();
      print(result['price']);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("진짜 샵페이지"),
    );
  }
}
