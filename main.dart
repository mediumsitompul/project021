import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:email_otp/email_otp.dart';
import 'login_success.dart';
import 'login_failed.dart';

main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Login with OTP')),
        ),
        body: MyOtp(),
      ),
    );
  }
}

class MyOtp extends StatefulWidget {
  MyOtp({Key? key}) : super(key: key);

  @override
  State<MyOtp> createState() => _MyOtpState();
}

class _MyOtpState extends State<MyOtp> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController otp = TextEditingController();
  EmailOTP myAuth = EmailOTP();
  bool status_SendOTP_For_Login = false;
  bool status_otp_has_been_sent = false;

  //..................................................................................
  Future<void> _login() async {
    //00000
    final url = Uri.parse(
      'http://192.168.100.100:8087/flutter/login4.php',
    );
    var response = await http.post(url, body: {
      "username": email.text,
      "password": password.text,
    });

    //..................................................................................
    var datauser = jsonDecode(response.body); //select * from t_user
    print(datauser);

    if (datauser.toString() != '') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginSuccess()),
      );
    }

    if (datauser.toString() == ''.toString()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginFailed()),
      );
    }
  }
  //..................................................................................

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Image(
              image: AssetImage("assets/images/medium.jpg"),
              height: 100,
              width: 100,
            ),
          ),
          TextFormField(
            controller: email,
            decoration: const InputDecoration(
              labelText: "Username",
              hintText: "What is your email?",
              icon: Icon(Icons.person),
            ),
          ),
          TextFormField(
            obscureText: true,
            controller: password,
            decoration: const InputDecoration(
              labelText: "Password",
              hintText: "What is your password?",
              icon: Icon(Icons.password),
            ),
          ),
          Container(
            //padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
            child: ElevatedButton(
              onPressed: () async {
                myAuth.setConfig(
                  appName: "Email OTP",
                  appEmail: "me@rohitchouhan.com",
                  userEmail: email.text,
                  otpLength: 6,
                  otpType: OTPType.digitsOnly,
                );

                if (await myAuth.sendOTP() == true) {
                  setState(() {
                    status_otp_has_been_sent = true;
                    status_SendOTP_For_Login = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("OTP has been sent to your email"),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Oops, OTP send failed"),
                  ));
                }
              },
              child: (status_SendOTP_For_Login == true)
                  ? Container()
                  : const Text("SendOTP For Login"),
            ),
          ),

          //++++++++++++++++++++++++++++++++++++++++++++++ AFTER username/password +++++++++++++++++++++
          status_otp_has_been_sent == false
              ? Container()
              :
              //++++++++++++++++++++++++++++++++++++++++++++++ AFTER username/password +++++++++++++++
              Column(
                  children: [
                    const SizedBox(
                      height: 0,
                    ),
                    TextFormField(
                      //ddd
                      obscureText: true,
                      controller: otp,
                      obscuringCharacter: '*',
                      decoration: const InputDecoration(
                        icon: Icon(Icons.password_rounded),
                        hintText: 'What is your otp?',
                        labelText: 'Enter OTP *',
                      ),

                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },

                      validator: (String? value) {
                        return (value != null && value.contains('@'))
                            ? 'Do not use the @ char.'
                            : null;
                      },
                    ),
                    ElevatedButton(
                      //eee
                      onPressed: () async {
                        if (await myAuth.verifyOTP(otp: otp.text) == true) {
                          print('otp.text');
                          print(otp.text);

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("OTP is verified..."),
                          ));

                          //....................................
                          //LOGIN PROCESS HERE
                          //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WelcomePage(email: email.text, password: password.text,)));
                          _login();
                        }

                        //else {
                        if (await myAuth.verifyOTP(otp: otp.text) == false) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Invalid OTP"),
                          ));
                        }
                      },

                      child: Container(
                          width: 110,
                          padding: const EdgeInsets.all(8),
                          child: const Center(child: Text("Login / Verify"))),
                    ),
                  ],
                ),
          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        ],
      ),
    );
  }
}
