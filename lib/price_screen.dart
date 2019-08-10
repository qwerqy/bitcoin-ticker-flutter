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
  double selectedPrice = 0;
  bool isLoading = false;

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
          getPrice();
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
          getPrice();
          selectedCurrency = currency;
        });
      },
      children: list,
    );
  }

  getPrice() async {
    isLoading = true;
    var response = await http.get(
        'https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC$selectedCurrency');
    setState(() {
      selectedPrice = jsonDecode(response.body)['last'];
      isLoading = false;
    });
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
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = ${isLoading ? '...' : selectedPrice.toString()} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
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
