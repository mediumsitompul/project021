import 'package:flutter/material.dart';
import 'main.dart';

class LoginFailed extends StatelessWidget {
  const LoginFailed({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Attention Please..."))),
      body:
      Column(children:[
      Center(child: Text('Login Failed.....'),),

      TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyApp()));
                },
                child: const Text('BACK TO LOGIN'),
              ),
      ],
      ),
    );
  }
}
