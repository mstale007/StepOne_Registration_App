import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:reg_app/post.dart';

import 'package:qr_flutter/qr_flutter.dart';

String mobile = "";
void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(Regsiter());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("My title"),
    content: Text("This is my message."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

String validateMobile(String value) {
  if (value.length != 10)
    return 'Mobile Number must be of 10 digit';
  else
    return null;
}

fetchData(BuildContext context, String mobile) async {
  if (mobile.length != 10) {
    return;
  }
  final response = await http.get(
      Uri.parse("https://steponexp.net/game12/details.php?Number=" + mobile));

  String name;
  String number;
  String id;
  if (response.statusCode == 200) {
    print(response.body);
    try {
      id = json.decode(response.body)["response"][0];
      name = json.decode(response.body)["response"][1];
      number = json.decode(response.body)["response"][4];
      print(id + name + number);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                UserProfile(name: name, number: number, id: id)),
      );
    } catch (e) {}
    // If server returns an OK response, parse the JSON.

  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

class Regsiter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Registration App",
      home: Scaffold(
        body: Container(
          color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 15,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      onChanged: (text) {
                        mobile = text;
                        print('First text field: $mobile');
                      },
                      keyboardType: TextInputType.phone,
                      validator: validateMobile,
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                elevation: 10,
                color: Colors.white,
                child: RegisterButton(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        fetchData(context, mobile);
      },
      child: Text("Register",
          style: TextStyle(
            color: Colors.red,
          )),
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({
    Key key,
    @required this.name,
    @required this.number,
    @required this.id,
  }) : super(key: key);

  final String name;
  final String number;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxHeight: 500, minHeight: 400),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 15,
              child: Center(
                child: ListView(
                  children: [
                    Center(child: Text("Name: " + name)),
                    Center(child: Text("Number: " + number)),
                    Center(
                      child: QrImage(
                        data: id,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Go back",
                          style: TextStyle(color: Colors.red),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
