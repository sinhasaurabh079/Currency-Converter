import 'package:currency_converter/components/anytoany.dart';
import 'package:currency_converter/components/usdtoany.dart';
import 'package:currency_converter/functions/fetchrates.dart';
import 'package:currency_converter/models/allCurrencies.dart';
import 'package:currency_converter/models/ratesmodel.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<RatesModel> result;
  late Future<Map> allCurrencies;

  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    result = fetchrates();
    allCurrencies = fetchcurrencies();
  }

  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Currency Converter'),
        centerTitle: true,
      ),
      body: Container(
        height: h,
        width: w,
        padding: EdgeInsets.only(top: 65, left: 15, right: 15),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/money_wallpaper.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: FutureBuilder<RatesModel>(
                future: result,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Center(
                    child: FutureBuilder<Map>(
                      future: allCurrencies,
                      builder: (context, currSnapshot) {
                        if (currSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Column(
                          children: [
                            UsdToAny(
                                rates: snapshot.data!.rates,
                                currencies: currSnapshot.data!),
                            const SizedBox(
                              height: 75,
                            ),
                            AnyToAny(
                                rates: snapshot.data!.rates,
                                currencies: currSnapshot.data!),
                          ],
                        );
                      },
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
