import 'package:flutter/material.dart';

void main() {
  runApp(CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      home: CurrencyInputScreen(),
    );
  }
}

class CurrencyInputScreen extends StatefulWidget {
  @override
  _CurrencyInputScreenState createState() => _CurrencyInputScreenState();

}

class _CurrencyInputScreenState extends State<CurrencyInputScreen> {
  final TextEditingController usdController = TextEditingController();
  final TextEditingController cadController = TextEditingController();
  final double exchangeRate = 1.35;

  bool _isEditingUsd = false;
  bool _isEditingCad = false;

  void _onUsdChanged(String value) {
    if (_isEditingCad) return;
    setState(() {
      _isEditingUsd = true;
      double usd = double.tryParse(value) ?? 0;
      cadController.text = (usd * exchangeRate).toStringAsFixed(2);
      _isEditingUsd = false;
    });
  }

  void _onCadChanged(String value) {
    if (_isEditingUsd) return;
    setState(() {
      _isEditingCad = true;
      double cad = double.tryParse(value) ?? 0;
      usdController.text = (cad / exchangeRate).toStringAsFixed(2);
      _isEditingCad = false;
    });
  }

  void _navigateToSummary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversionSummaryScreen(
          usd: usdController.text,
          cad: cadController.text,
          rate: exchangeRate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Currency Converter')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: usdController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'USD'),
              onChanged: _onUsdChanged,
            ),
            TextField(
              controller: cadController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'CAD'),
              onChanged: _onCadChanged,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToSummary,
              child: Text('See Summary'),
            ),
          ],
        ),
      ),
    );
  }
}

class ConversionSummaryScreen extends StatelessWidget {
  final String usd;
  final String cad;
  final double rate;

  const ConversionSummaryScreen({
    required this.usd,
    required this.cad,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Conversion Summary')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('USD: \$${usd}', style: TextStyle(fontSize: 18)),
            Text('CAD: \$${cad}', style: TextStyle(fontSize: 18)),
            Text('Exchange Rate: 1 USD = $rate CAD', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
