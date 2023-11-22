import 'package:http/http.dart' as http;
import 'package:currency_converter/models/ratesmodel.dart';
import 'package:currency_converter/utils/key.dart';
import 'package:currency_converter/models/allCurrencies.dart';

Future<RatesModel> fetchrates() async {
  final response = await http.get(
      Uri.parse('https://openexchangerates.org/api/latest.json?app_id=' + key));
  print(response.body);
  final result = ratesModelFromJson(response.body);

  return result;
}

Future<Map> fetchcurrencies() async {
  final response = await http.get(Uri.parse(
      'https://openexchangerates.org/api/currencies.json?app_id=5c18f3f323e34f4a9896d78251dfef20'));
  final allcurrencies = allCurrenciesFromJson(response.body);
  return allcurrencies;
}

String convertusd(Map exchangeRates, String usd, String currency) {
  String output = ((double.parse(usd) * exchangeRates[currency]))
      .toStringAsFixed(2)
      .toString();
  return output;
}

String convertany(Map exchangeRates, String amount, String currencybase,
    String currencyfinal) {
  String output = ((double.parse(amount) / exchangeRates[currencybase]) *
          exchangeRates[currencyfinal])
      .toStringAsFixed(2)
      .toString();
  return output;
}
