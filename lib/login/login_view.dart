import 'package:bloc_ft_provider_flutter_demo/home/home_view.dart';
import 'package:bloc_ft_provider_flutter_demo/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider(
          create: (context) => LoginBloc(), child: BodyWidget()),
    );
  }
}

class BodyWidget extends StatefulWidget {
  BodyWidget({Key key}) : super(key: key);

  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      LoginBloc.of(context).emailSink.add(emailController.text);
    });
    passController.addListener(() {
      LoginBloc.of(context).passSink.add(passController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = LoginBloc.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StreamBuilder<String>(
              stream: loginBloc.emailStream,
              builder: (context, snapshot) {
                return TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: "example@gmail.com",
                    labelText: "Email *",
                    errorText: snapshot.data,
                  ),
                );
              }),
          SizedBox(height: 20),
          StreamBuilder<String>(
              stream: loginBloc.passStream,
              builder: (context, snapshot) {
                return TextFormField(
                  obscureText: true,
                  controller: passController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: "Password *",
                    errorText: snapshot.data,
                  ),
                );
              }),
          SizedBox(height: 40),
          SizedBox(
            width: 200,
            height: 45,
            child: StreamBuilder<bool>(
                stream: loginBloc.btnStream,
                builder: (context, snapshot) {
                  return RaisedButton(
                    onPressed: snapshot.data == true
                        ? () {
                            // call login api
                            print("call login api");
                            // navigate home page
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          }
                        : null,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.blue,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
