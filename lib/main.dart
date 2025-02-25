import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0'; // Display for full expression
  double? _num1;
  double? _num2;
  String? _operator;
  bool _isTypingSecondNumber = false;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = '0';
        _num1 = null;
        _num2 = null;
        _operator = null;
        _isTypingSecondNumber = false;
      } else if (value == '⌫') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
        }
      } else if (value == '+/-') {
        if (_display.isNotEmpty && !_display.contains(' ')) {
          _display =
              _display.startsWith('-') ? _display.substring(1) : '-$_display';
        }
      }
      // ✅ Fix: Prevent multiple decimal points in a single number
      else if (value == '.') {
        List<String> parts = _display.split(' '); // Split by operators
        String lastPart = parts.last; // Get last number
        if (!lastPart.contains('.')) {
          _display += value;
        }
      } else if (value == '+' || value == '-' || value == '*' || value == '/') {
        if (_num1 == null) {
          _num1 = double.parse(_display);
          _display += ' $value '; // Show operator on screen
        } else if (_operator != null && _isTypingSecondNumber) {
          _num2 = double.parse(_display.split(' ').last);
          _num1 = _calculateResult();
          _display = _num1!.toString() + ' $value ';
        }
        _operator = value;
        _isTypingSecondNumber = true;
      } else if (value == '=') {
        if (_operator != null && _num1 != null) {
          _num2 = double.parse(_display.split(' ').last);
          _display = _calculateResult().toString();
          _num1 = null;
          _operator = null;
          _isTypingSecondNumber = false;
        }
      } else {
        if (_display == '0' || _isTypingSecondNumber) {
          _display = value;
          _isTypingSecondNumber = false;
        } else {
          _display += value;
        }
      }
    });
  }

  double _calculateResult() {
    double result = 0;
    if (_num1 != null && _num2 != null) {
      switch (_operator) {
        case '+':
          result = _num1! + _num2!;
          break;
        case '-':
          result = _num1! - _num2!;
          break;
        case '*':
          result = _num1! * _num2!;
          break;
        case '/':
          result = _num2 != 0 ? _num1! / _num2! : double.nan;
          break;
      }
    }
    return result;
  }

  Widget _buildButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () => _onButtonPressed(text),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        shape: CircleBorder(),
        backgroundColor: color,
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:
            Text('Calculator', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                _display,
                style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Column(
              children: [
                _buildRow(['C', '⌫', '+/-', '/'], Colors.redAccent),
                _buildRow(['7', '8', '9', '*'], Colors.orange),
                _buildRow(['4', '5', '6', '-'], Colors.orange),
                _buildRow(['1', '2', '3', '+'], Colors.orange),
                _buildRow(['.', '0', '='], Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> buttons, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((text) => _buildButton(text, color)).toList(),
    );
  }
}
