import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'second_page.dart';
import 'package:validators/validators.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String _title = 'Bacon Ipsum API';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const Center(
          child: MyStatefulWidget(),
        ),
      ),
    );
  }
}

enum MeatType { allMeat, meatAndFiller }

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final _controller = TextEditingController();
  bool _textError = false;

  MeatType? _type = MeatType.allMeat;
  int? _sentences = 1;

  @override
  void initState() {
    super.initState();
    _controller.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: ListTile(
            title: const Text('All Meat'),
            leading: Radio<MeatType>(
              value: MeatType.allMeat,
              groupValue: _type,
              onChanged: (MeatType? value) {
                setState(() {
                  _type = value;
                });
              },
            ),
          ),
        ),
        Center(
          child: ListTile(
            title: const Text('Meat and Filler'),
            leading: Radio<MeatType>(
              value: MeatType.meatAndFiller,
              groupValue: _type,
              onChanged: (MeatType? value) {
                setState(() {
                  _type = value;
                });
              },
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: 200.0,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    labelText: "Enter a number of sentences",
                    errorText: _textError
                        ? 'Paste the number between 1 and 15'
                        : null),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            )),
        Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15.0),
                    textStyle: const TextStyle(fontSize: 20)),
                child: const Text("Get Text"),
                onPressed: () {
                  _sentences = int.parse(_controller.text);

                  if (_controller.text.isEmpty ||
                      _sentences! < 1 ||
                      _sentences! > 15) {
                    setState(() {
                      _textError = true;
                    });
                  } else {
                    setState(() {
                      _textError = false;
                    });

                    String finalType = "all-meat";
                    switch (_type) {
                      case (MeatType.allMeat):
                        finalType = "all-meat";
                        break;
                      case (MeatType.meatAndFiller):
                        finalType = "meat-and-filler";
                        break;
                      case (null):
                        break;
                    }

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            TextPage(type: finalType, sentences: _sentences)));

                    _controller.clear();
                  }
                })),
      ],
    );
  }
}
