import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const NumberShapesApp());
}

class NumberShapesApp extends StatelessWidget {
  const NumberShapesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Shapes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NumberShapesPage(
        title: 'Number Shapes',
      ),
    );
  }
}

class NumberShapesPage extends StatefulWidget {
  const NumberShapesPage({super.key, required this.title});

  final String title;

  @override
  State<NumberShapesPage> createState() => _NumberShapesPageState();
}

class _NumberShapesPageState extends State<NumberShapesPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
            ),
            child: Text(
              'Please input a number to see if it is square or triangular.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 30,
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _inputController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSimpleDialog(
            int.tryParse(_inputController.text),
          );
        },
        child: const Icon(
          Icons.check,
        ),
      ),
    );
  }

  bool _isSquare(int number) {
    return sqrt(number) == (sqrt(number).toInt());
  }

  bool _isTriangular(int number) {
    final num root = pow(number, 1 / 3).ceil();
    return number == pow(root, 3).ceil();
  }

  Text _dialogMessage(String msg) {
    return Text(
      msg,
      textAlign: TextAlign.justify,
      style: const TextStyle(
        fontSize: 16,
      ),
    );
  }

  Future<void> _showSimpleDialog(int? number) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            '$number',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: number == null
                  ? _dialogMessage(
                      'Please enter a valid number',
                    )
                  : _isSquare(number) && _isTriangular(number)
                      ? _dialogMessage(
                          'Number $number is SQUARE and TRIANGULAR.',
                        )
                      : _isSquare(number)
                          ? _dialogMessage(
                              'Number $number is SQUARE.',
                            )
                          : _isTriangular(number)
                              ? _dialogMessage(
                                  'Number $number is TRIANGULAR.',
                                )
                              : _dialogMessage(
                                  'Number $number is neither SQUARE or TRIANGULAR.',
                                ),
            ),
          ],
        );
      },
    );
  }
}
