import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CountryPage extends StatefulWidget {
  const CountryPage({super.key});

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counrty App',
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(242, 232, 201, 1),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(60, 125, 166, 1),
          title: const Text("Country App",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color.fromRGBO(64, 18, 1, 1))),
        ),
        body: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController countryEditor = TextEditingController();
  String desc = "";
  var capital = "";
  var surfaceArea = 0.0;
  var currencyName = "";
  var currencyCode = "";
  var gdp = 0.0;
  var imports = 0.0;
  var exports = 0.0;
  var alpha2Code = "";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            const Text("Search a Country",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(64, 18, 1, 1))),
            const SizedBox(height: 10),
            TextField(
              controller: countryEditor,
              decoration: InputDecoration(
                  hintText: "Search",
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(115, 91, 47, 1), width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  )),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _getCountry,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(60, 125, 166, 1)),
                child: const Text(
                  "Load Country",
                  style: TextStyle(color: Color.fromRGBO(150, 210, 217, 1)),
                )),
            const SizedBox(height: 10),
            Card(
                color: const Color.fromRGBO(242, 232, 201, 1),
                elevation: 10,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    color: Color.fromRGBO(115, 91, 47, 1),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                ),
                child: SizedBox(
                  width: 400,
                  height: 500,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [buildCountryInfo(), buildCountryFlag()],
                  ),
                ))
          ]),
        ),
      ),
    );
  }

  Future<void> _getCountry() async {
    String country = countryEditor.text;
    var url = Uri.parse('https://api.api-ninjas.com/v1/country?name=$country');
    var response = await http.get(url, headers: {
      'X-Api-Key': 'wssRAkCcq3MElBls+6wcaA==uvDPLtpGRfAamDwR',
    });
    var rescode = response.statusCode;
    if (rescode == 200) {
      try {
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);
        var countryData = parsedJson[0];
        setState(() {
          capital = countryData['capital'];
          surfaceArea = countryData['surface_area'];
          currencyName = countryData['currency']['name'];
          currencyCode = countryData['currency']['code'];
          gdp = countryData['gdp'];
          imports = countryData['imports'];
          exports = countryData['exports'];
          alpha2Code = countryData['iso2'];
          desc =
              "Capital: $capital\nSurface Area: $surfaceArea\nCurrencies: $currencyCode/$currencyName\nGDP: $gdp\nImports: $imports\nExports: $exports";
        });
      } catch (e) {
        setState(() {
          desc = "No record found";
          alpha2Code = "";
        });
      }
    } else {
      setState(() {
        desc = "No record found";
        alpha2Code = "";
      });
    }
  }

  Widget buildCountryInfo() {
    if (countryEditor.text.isEmpty) {
      return const Text(
        "No record found",
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      );
    } else {
      return Text(
        desc,
        style: const TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      );
    }
  }

  Widget buildCountryFlag() {
    if (alpha2Code.isNotEmpty && countryEditor.text.isNotEmpty) {
      return Image.network(
        "https://flagsapi.com/$alpha2Code/flat/64.png",
        scale: 0.5,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
