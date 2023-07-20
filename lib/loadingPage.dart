import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';
import 'package:ttt/cryptoData.dart';
import 'package:ttt/homePage.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Wellcome To Binance",
          style: TextStyle(
              color: Color.fromARGB(221, 255, 182, 55),
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('images/Binance.png'),
                width: 180,
              ),
              SpinKitFadingCircle(
                color: Color.fromARGB(221, 255, 182, 55),
                size: 40,
              )
            ],
          ),
        ),
      ),
    );
  }

  getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets/');

    List<Crypto> cryptoList = response.data['data']
        .map<Crypto>(
          (jsonData) => Crypto.dataFromJson(jsonData),
        )
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          cryptoList: cryptoList,
        ),
      ),
    );
  }
}
