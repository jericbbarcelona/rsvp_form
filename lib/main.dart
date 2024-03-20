// ignore_for_file: prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primaryColorDark: Colors.blueGrey,
        useMaterial3: false,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top, // Shows Status bar and hides Navigation bar
      ],
    );

    void showCustomDialog(BuildContext context, String message) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                height: size.height * 0.3,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Text('THANK YOU',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Color(0xff00A6B8))),
                      SizedBox(height: 10),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            width: size.width * 0.8,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Ok",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.white70, width: 1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: Color(0xff00A6B8),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                  textStyle: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    }

    Future<void> postRsvpForm(String firstName, String lastName, String contactNo, String email) async {
      Map<String, String> queryParameters = {
        'ApiKey': '123456',
        'FirstName': firstName,
        'LastName': lastName,
        'ContactNo': contactNo,
        'Email': email,
      };
      final uri = Uri.parse('https://integration.micaresvc.com/interviewapi/AssessmentTestRSVP').replace(queryParameters: queryParameters);
      await http.get(uri).then((value) =>
        showCustomDialog(context, value.body)
      ).catchError((error) => {
        Fluttertoast.showToast(
            msg: "Error Message: $error",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white
        )
      });
  }

  return Scaffold(
    body: Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                color: Color(0xffFE4046),
                child: Column(children: [
                  SizedBox(height: size.height * 0.07),
                  Text('RSVP Form', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30)),
                  SizedBox(height: size.height * 0.015),
                  Image.asset(
                  'assets/line.png',
                  height: 45.0,
                  color: Colors.white,
                  fit: BoxFit.cover,
                ),
                  SizedBox(height: size.height * 0.02),
                  Text('Kindy respond by February 06, 2021', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('We look forward to celebrate with you', style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
                ),
              )
            ),
            Expanded(flex: 6, child: Container(color: Colors.white)),
          ],
        ),
        Align(
          alignment: Alignment(0, 0.5),
          child: Container(
            width: size.width * 0.9,
            height: size.height * 0.65,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white, width: 1), borderRadius: BorderRadius.circular(10),),
                child: Container(
                  padding: EdgeInsets.all(20),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Please enter all the fields.',
                            style: TextStyle(
                                color: Color(0xff00A6B8),
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: size.height * 0.03),
                        FormBuilder(
                          key: _fbKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'First Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff636363)),
                              ),
                              FormBuilderTextField(
                                name: 'firstName',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                    hintText: 'First Name',
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold, color: Colors.grey)),
                                validator: FormBuilderValidators.compose(
                                    [FormBuilderValidators.required()]),
                                keyboardType: TextInputType.name,
                              ),
                              SizedBox(height: size.height * 0.025),
                              Text(
                                'Last Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff636363)),
                              ),
                              FormBuilderTextField(
                                name: 'lastName',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                    hintText: 'Last Name',
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold, color: Colors.grey)),
                                validator: FormBuilderValidators.compose(
                                    [FormBuilderValidators.required()]),
                                keyboardType: TextInputType.name,
                              ),
                              SizedBox(height: size.height * 0.025),
                              Text(
                                'Contact Number',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff636363)),
                              ),
                              FormBuilderTextField(
                                name: 'contactNumber',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                    hintText: 'Contact Number',
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold, color: Colors.grey)),
                                validator: FormBuilderValidators.compose(
                                    [FormBuilderValidators.required()]),
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: size.height * 0.025),
                              Text(
                                'Email',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff636363)),
                              ),
                              FormBuilderTextField(
                                name: 'email',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold, color: Colors.grey)),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.email()
                                ]),
                                keyboardType: TextInputType.emailAddress,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.all(10),
              width: size.width * 0.8,
              child: ElevatedButton(
                child: Text(
                  'Submit',
                ),
                onPressed: () {
                  if (_fbKey.currentState!.saveAndValidate()) {
                    String firstName = _fbKey.currentState!.value['firstName'].toString();
                    String lastName = _fbKey.currentState!.value['lastName'].toString();
                    String contactNo = _fbKey.currentState!.value['contactNo'].toString();
                    String email = _fbKey.currentState!.value['email'].toString();
                    postRsvpForm(firstName, lastName, contactNo, email);
                  }
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Color(0xff00A6B8),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
