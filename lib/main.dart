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
  String _display = '0'; // Default to '0' instead of empty string
  double? _num1;
  double? _num2;
  String? _operator;
  bool _isTypingSecondNumber = false; // Fixes disappearing numbers

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
        if (_display != '0') {
          _display =
              _display.startsWith('-') ? _display.substring(1) : '-$_display';
        }
      } else if (value == '.' && !_display.contains('.')) {
        _display += value;
      } else if (value == '+' || value == '-' || value == '*' || value == '/') {
        if (_num1 == null) {
          _num1 = double.parse(_display);
        } else if (_operator != null && _isTypingSecondNumber) {
          _num2 = double.parse(_display);
          _num1 = _calculateResult();
          _display = _formatResult(_num1!);
        }
        _operator = value;
        _isTypingSecondNumber = true; // Start entering the second number
      } else if (value == '=') {
        if (_operator != null && _num1 != null) {
          _num2 = double.parse(_display);
          _display = _formatResult(_calculateResult());
          _num1 = null;
          _operator = null;
          _isTypingSecondNumber = false;
        }
      } else {
        if (_display == '0' || _isTypingSecondNumber) {
          _display = value; // Replace screen text if starting a new number
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

  String _formatResult(double result) {
    if (result.isNaN) {
      return "Error";
    } else if (result == result.toInt()) {
      return result.toInt().toString(); // Remove decimal if whole number
    } else {
      return result.toStringAsFixed(2); // Limit to 2 decimal places
    }
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
