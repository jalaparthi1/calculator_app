import 'package:flutter/material.dart';
import 'dart:math';

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
  String _display = '0'; // Full expression shown
  String _input = ''; // Keeps track of user input
  double? _num1;
  double? _num2;
  String? _operator;
  bool _isTypingSecondNumber = false;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = '0';
        _input = '';
        _num1 = null;
        _num2 = null;
        _operator = null;
        _isTypingSecondNumber = false;
      } else if (value == '⌫') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
          _display = _input.isEmpty ? '0' : _input;
        }
      } else if (value == '+/-') {
        if (_input.isNotEmpty) {
          if (_input.startsWith('-')) {
            _input = _input.substring(1);
          } else {
            _input = '-$_input';
          }
          _display = _input;
        }
      }
      // ✅ Prevent multiple decimals in the same number
      else if (value == '.') {
        List<String> parts =
            _input.split(RegExp(r'[\+\-\*/]')); // Split by operators
        if (!parts.last.contains('.')) {
          _input += value;
          _display = _input;
        }
      } else if (value == '+' || value == '-' || value == '*' || value == '/') {
        if (_num1 == null) {
          _num1 = double.tryParse(_input) ?? 0;
        } else if (_operator != null && _isTypingSecondNumber) {
          _num2 = double.tryParse(_input.split(RegExp(r'[\+\-\*/]')).last) ?? 0;
          _num1 = _calculateResult();
        }
        _operator = value;
        _isTypingSecondNumber = true;
        _input += ' $value ';
        _display = _input;
      } else if (value == '=') {
        if (_operator != null && _num1 != null) {
          _num2 = double.tryParse(_input.split(RegExp(r'[\+\-\*/]')).last) ?? 0;
          _display = _calculateResult().toString();
          _input = _display;
          _num1 = null;
          _operator = null;
          _isTypingSecondNumber = false;
        }
      } else {
        if (_display == '0' || _isTypingSecondNumber) {
          _input = value;
          _isTypingSecondNumber = false;
        } else {
          _input += value;
        }
        _display = _input;
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
    return _formatPrecision(result);
  }

  // ✅ Ensures decimal precision is correct
  double _formatPrecision(double value) {
    if (value.isNaN) {
      return double.nan;
    }
    String valueStr = value.toString();
    return double.parse(
        valueStr.length > 15 ? valueStr.substring(0, 15) : valueStr);
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
