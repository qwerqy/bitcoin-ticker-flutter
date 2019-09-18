import 'dart:convert';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Map<String, double> selectedPrice = {};
  bool isLoading = false;
  List<String> cryptoCurrency = ['BTC', 'LTC', 'BCH', 'ETH'];

  DropdownButton<String> androidPicker() {
    List<DropdownMenuItem<String>> list = [];

    for (String currency in currenciesList) {
      list.add(
        DropdownMenuItem(
          child: Text(currency),
          value: currency,
        ),
      );
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: list,
      onChanged: (value) {
        setState(() {
          for (var i = 0; i < cryptoCurrency.length; i++) {
            getPrice(cryptoCurrency[i]);
          }
          selectedCurrency = value;
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> list = [];

    for (String currency in currenciesList) {
      list.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        String currency = currenciesList[selectedIndex];
        setState(() {
          for (var i = 0; i < cryptoCurrency.length; i++) {
            getPrice(cryptoCurrency[i]);
          }
          selectedCurrency = currency;
        });
      },
      children: list,
    );
  }

  getPrice(String crypto) async {
    isLoading = true;
    var response = await http.get(
        'https://apiv2.bitcoinaverage.com/indices/global/ticker/$crypto$selectedCurrency');
    setState(() {
      selectedPrice[crypto] = jsonDecode(response.body)['last'];
      isLoading = false;
    });
  }

  List<Widget> getTickerList(List<String> cryptoList) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < cryptoList.length; i++) {
      list.add(
        Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 ${cryptoList[i]} = ${isLoading ? '-' : selectedPrice[cryptoList[i]].toString()} $selectedCurrency',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(children: getTickerList(cryptoCurrency)),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: iOSPicker(),
          )
        ],
      ),
    );
  }
}
