import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Business Card QR Code Generator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _houseNumber = TextEditingController();
  final TextEditingController _postcode = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _country = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _birthday = TextEditingController();

  String _meCard = '';

  void _onPressed() {
    if (_formKey.currentState!.validate()) {
      final vcard = BusinessCard(
        _firstName.text,
        _lastName.text,
        _address.text,
        _houseNumber.text,
        _city.text,
        _postcode.text,
        _country.text,
        _email.text,
        _phone.text,
      );
      _meCard = vcard.formatVCard();
    } else {
      _meCard = '';
    }
    log(_meCard);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(flex: 2, child: QField(_firstName, 'First Name', 'Please enter some text')),
                          const SizedBox(width: 8),
                          Expanded(flex: 2, child: QField(_lastName, 'Last Name', 'Please enter some text')),
                          const SizedBox(width: 8),
                          Expanded(flex: 4, child: QField(_address, 'Address', 'Please enter some text')),
                          const SizedBox(width: 8),
                          Expanded(flex: 1, child: QField(_houseNumber, 'No', 'Please enter some text')),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: QField(_postcode, 'Postcode', 'Please enter some text')),
                          const SizedBox(width: 8),
                          Expanded(flex: 3, child: QField(_city, 'City', 'Please enter some text')),
                          const SizedBox(width: 8),
                          Expanded(flex: 3, child: QField(_country, 'Country', 'Please enter some text')),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(flex: 3, child: QField(_email, 'e-mail', 'Please enter some text')),
                          const SizedBox(width: 8),
                          Expanded(flex: 2, child: QField(_phone, 'Phone number', 'Please enter some text')),
                          const SizedBox(width: 8),
                          Expanded(child: QField(_birthday, 'Birthday', 'Please enter some text')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  child: Center(
                    child: QrImage(
                      data: _meCard,
                      size: 300,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressed,
        tooltip: 'Generate QR',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class QField extends TextFormField {
  QField(TextEditingController controller, String hintText, String errorText, {Key? key})
      : super(
            key: key,
            controller: controller,
            decoration: InputDecoration(hintText: hintText),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return errorText;
              }
              return null;
            });
}

class BusinessCard {
  final String firstName;
  final String lastName;
  final String address;
  final String houseNumber;
  final String city;
  final String postCode;
  final String country;
  final String email;
  final String phone;

  BusinessCard(this.firstName, this.lastName, this.address, this.houseNumber, this.city, this.postCode, this.country, this.email, this.phone);

  String formatMECard() {
    final meCard = 'MECARD:N:$firstName;ADR:$address,$city,$postCode,$country;EMAIL:$email;TEL:$phone;;;';
    return meCard;
  }

  String formatVCard() {
    final vCard = '''BEGIN:VCARD
VERSION:4.0
N:$lastName;$firstName
FN:$firstName $lastName
ADR;TYPE=home:;;$address $houseNumber;$city;;$postCode;$country
TEL;TYPE=cell:$phone
EMAIL:$email
END:VCARD
''';

    return vCard;
  }

  String formatExample() {
    const s = '''BEGIN:VCARD
VERSION:4.0
UID:urn:uuid:4fbe8971-0bc3-424c-9c26-36c3e1eff6b1
FN:J. Doe
N:Doe;J.;;;
EMAIL;PID=1.1:jdoe@example.com
EMAIL;PID=2.1:boss@example.com
EMAIL;PID=2.2:ceo@example.com
TEL;PID=1.1;VALUE=uri:tel:+1-555-555-5555
TEL;PID=2.1,2.2;VALUE=uri:tel:+1-666-666-6666
CLIENTPIDMAP:1;urn:uuid:53e374d9-337e-4727-8803-a1e9c14e0556
CLIENTPIDMAP:2;urn:uuid:1f762d2b-03c4-4a83-9a03-75ff658a6eee
END:VCARD''';
    return s;
  }

  String formatExample2() {
    const s = '''BEGIN:VCARD
VERSION:2.1
N:;Company Name
FN:Company Name
ORG:Company Name
TEL;WORK;VOICE;PREF:+16045551212
TEL;WORK;FAX:+16045551213
ADR;WORK;POSTAL;PARCEL;DOM;PREF:;;123 main street;vancouver;bc;v0v0v0;canada
EMAIL;INTERNET;PREF:user@example.com
URL;WORK;PREF:http://www.example.com/
NOTE:http://www.example.com/
CATEGORIES:BUSINESS,WORK
UID:A64440FC-6545-11E0-B7A1-3214E0D72085
REV:20110412165200
END:VCARD''';
    return s;
  }
}
