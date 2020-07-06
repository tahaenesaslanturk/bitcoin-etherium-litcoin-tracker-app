import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = "USD";
  String currencyPriceBTC = "";
  String currencyPriceETH = "";
  String currencyPriceLTC = "";

  Future<double> getSpecificBTC(currency) async {
    CoinData coinData = CoinData();
    var currencyData =
        await coinData.getCoinData(currency: currency, base: "BTC");
    double currencyRate = currencyData["rate"];
    currencyPriceBTC = currencyRate.toStringAsFixed(4);
  }

  Future<double> getSpecificETH(currency) async {
    CoinData coinData = CoinData();
    var currencyData =
        await coinData.getCoinData(currency: currency, base: "ETH");
    double currencyRate = currencyData["rate"];
    currencyPriceETH = currencyRate.toStringAsFixed(4);
  }

  Future<double> getSpecificLTC(currency) async {
    CoinData coinData = CoinData();
    var currencyData =
        await coinData.getCoinData(currency: currency, base: "LTC");
    double currencyRate = currencyData["rate"];
    currencyPriceLTC = currencyRate.toStringAsFixed(4);
  }

  DropdownButton getDropdown(String base) {
    List<DropdownMenuItem> dropdownItems = [];
    for (String currency in currenciesList) {
      DropdownMenuItem newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton(
      value: selectedCurrency,
      onChanged: (value) async {
        await getSpecificBTC(value);
        await getSpecificETH(value);
        await getSpecificLTC(value);

        setState(() {
          selectedCurrency = value;
        });
      },
      items: dropdownItems,
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      Widget newItem = Text(currency);
      pickerItems.add(newItem);
    }
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: 19),
      backgroundColor: Colors.blue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) async {
        String myCurrency = currenciesList[selectedIndex];
        await getSpecificBTC(myCurrency);
        await getSpecificETH(myCurrency);
        await getSpecificLTC(myCurrency);

        setState(() {
          selectedCurrency = myCurrency;
        });
      },
      children: pickerItems,
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iOSPicker();
    } else if (Platform.isAndroid) {
      return getDropdown("BTC");
    }
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
          MyCard(
            basePrice: currencyPriceBTC,
            currency: selectedCurrency,
            name: "BTC",
          ),
          MyCard(
            basePrice: currencyPriceETH,
            currency: selectedCurrency,
            name: "ETH",
          ),
          MyCard(
            basePrice: currencyPriceLTC,
            currency: selectedCurrency,
            name: "LTC",
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: iOSPicker(),
          ),
        ],
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  String name;
  String basePrice;
  String currency;
  MyCard({this.currency, this.basePrice, this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            '1 $name = $basePrice $currency',
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
}
