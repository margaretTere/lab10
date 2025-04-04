import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _usdController = TextEditingController();
  final TextEditingController _cadController = TextEditingController();
  final double _exchangeRate = 1.35;

  bool isTypingUsd = false;
  bool isTypingCad = false;

  void convertFromUsd(String value) {
    if (isTypingCad) return;
    setState(() {
      isTypingUsd = true;
      final usd = double.tryParse(value) ?? 0;
      _cadController.text = (usd * _exchangeRate).toStringAsFixed(2);
      isTypingUsd = false;
    });
  }

  void convertFromCad(String value) {
    if (isTypingUsd) return;
    setState(() {
      isTypingCad = true;
      final cad = double.tryParse(value) ?? 0;
      _usdController.text = (cad / _exchangeRate).toStringAsFixed(2);
      isTypingCad = false;
    });
  }

  void _navigateToBreakDownPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BreakDownPage(
          usd: _usdController.text,
          cad: _cadController.text,
          rate: _exchangeRate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Currency Converter')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _usdController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'USD Amount'),
              onChanged: convertFromUsd,
            ),
            TextField(
              controller: _cadController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'CAD Amount'),
              onChanged: convertFromCad,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToBreakDownPage,
              child: Text('See Breakdown'),
            ),
          ],
        ),
      ),
    );
  }
}

class BreakDownPage extends StatelessWidget {
  final String _usd;
  final String _cad;
  final double _rate;

  const BreakDownPage({
    required String usd,
    required String cad,
    required double rate,
  }) : _rate = rate, _cad = cad, _usd = usd;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transaction break down')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('USD: \$${_usd}', style: TextStyle(fontSize: 18)),
            Text('CAD: \$${_cad}', style: TextStyle(fontSize: 18)),
            Text('Exchange Rate: 1.0 USD = $_rate CAD', style: TextStyle(fontSize: 18)),
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

