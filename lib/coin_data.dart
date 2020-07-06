import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<dynamic> getCoinData({String currency, String base}) async {
    String url =
        "https://rest.coinapi.io/v1/exchangerate/$base/$currency?apikey=(YOUR-API-KEY)";
    http.Response response = await http.get(url);
    var decodedData = jsonDecode(response.body);
    return decodedData;
  }
}

//String baseCurrency = decodedData["asset_id_base"];
//String quoteCurrency = decodedData["asset_id_quote"];
//double currencyRate = decodedData["rate"];
