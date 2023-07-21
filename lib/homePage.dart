import 'package:flutter/material.dart';
import 'package:ttt/cryptoData.dart';
import 'package:ttt/constans.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, this.cryptoList});
  final List<Crypto>? cryptoList;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Crypto>? cryptoList;
  bool showSearchText = false;

  @override
  void initState() {
    super.initState();
    cryptoList = widget.cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "صرافیه آنلاین",
          style: TextStyle(fontFamily: 'mh', fontSize: 16),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: blackColor,
      ),
      backgroundColor: blackColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            var refresh = await _getData();
            setState(() {
              cryptoList = refresh;
            });
          },
          child: Column(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      _fillterList(value);
                    },
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      hintText: "ازر مورد نظر خود را جستجو کنید...",
                      hintStyle: TextStyle(fontSize: 16, fontFamily: 'mh'),
                      filled: true,
                      fillColor: greenColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showSearchText,
                child: Text(
                  "...در حال بروز رسانی",
                  style: TextStyle(
                    color: greenColor,
                    fontSize: 12,
                    fontFamily: 'mh',
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: cryptoList!.length,
                    itemBuilder: (context, index) {
                      return _listTile(cryptoList![index]);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _listTile(Crypto crypto) {
    return ListTile(
      leading: SizedBox(
        width: 50,
        child: Center(
          child: Text(
            crypto.rank,
            style: TextStyle(color: greyColor),
          ),
        ),
      ),
      title: Text(
        crypto.name,
        style: TextStyle(color: greenColor),
      ),
      subtitle: Text(
        crypto.symbol,
        style: TextStyle(color: greyColor),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    crypto.priceUsd.toStringAsFixed(2),
                    style: TextStyle(color: greyColor),
                  ),
                  Text(
                    crypto.changePercent24Hr.toStringAsFixed(2),
                    style: TextStyle(color: greyColor),
                  ),
                ],
              ),
            ),
            _isPriceUsdLowORHigh(crypto.changePercent24Hr),
          ],
        ),
      ),
    );
  }

  _getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets/');

    List<Crypto> cryptoList = response.data['data']
        .map<Crypto>(
          (jsonData) => Crypto.dataFromJson(jsonData),
        )
        .toList();
    return cryptoList;
  }

  _isPriceUsdLowORHigh(double changePercent24hr) {
    if (changePercent24hr > 0) {
      return Icon(
        Icons.trending_up,
        color: greenColor,
      );
    } else {
      return Icon(
        Icons.trending_down,
        color: redColor,
      );
    }
  }

  _fillterList(userInputs) async {
    List<Crypto> userInput = [];
    if (userInputs.isEmpty) {
      setState(() {
        showSearchText = true;
      });
      var result = await _getData();
      setState(() {
        cryptoList = result;
        showSearchText = false;
      });
    }

    userInput = cryptoList!.where((element) {
      return element.name.toLowerCase().contains(
            userInputs.toLowerCase(),
          );
    }).toList();

    setState(() {
      cryptoList = userInput;
    });
  }
}
