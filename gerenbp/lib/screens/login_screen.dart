import 'package:flutter/material.dart';
import 'package:gerenbp/blocs/login_bloc.dart';
import 'package:gerenbp/screens/home_screen.dart';
import 'package:gerenbp/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();

    _loginBloc.outState.listen((state){
      switch(state){
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
          break;
        case LoginState.FAIL:
          showDialog(context: context, builder: (context) => AlertDialog(
            title: Text("ERRO"),
            content: Text("Você não é admin"),
          ));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:      
      }
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[800],
      body: StreamBuilder<LoginState>(
        stream: _loginBloc.outState,
        initialData: LoginState.LOADING,
        builder: (context, snapshot) {
          switch(snapshot.data){
            case LoginState.LOADING:
              return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent)));
            case LoginState.FAIL:
            case LoginState.SUCCESS:
            case LoginState.IDLE:
              return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(),
                SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 300,
                          child: Image.asset("images/buscapet1.png"),
                        ),

                        InputField(
                          icon: Icons.person_outline,
                          hint: "Usuário",
                          obscure: false,
                          stream: _loginBloc.outEmail,
                          onChanged: _loginBloc.changeEmail,
                        ),

                        InputField(
                          icon: Icons.lock_outline,
                          hint: "Senha",
                          obscure: true,
                          stream: _loginBloc.outPassword,
                          onChanged: _loginBloc.changePassword,
                        ),

                        SizedBox(height: 16),

                        StreamBuilder<bool>(
                          stream: _loginBloc.outButtonValid,
                          builder: (context, snapshot) {
                            return RaisedButton(
                              color: Colors.redAccent,
                              child: Text("Entrar"),
                              onPressed: snapshot.hasData ? _loginBloc.submit : null,
                              textColor: Colors.white,
                              disabledColor: Colors.redAccent.withAlpha(140),
                            );
                          }
                        )

                      ],
                    ),
                  ),
                ),
              ],
            );
          }        
        }
      )
    );
  }
}