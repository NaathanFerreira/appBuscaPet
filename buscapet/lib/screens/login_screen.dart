import 'package:buscapet/models/user.dart';
import 'package:buscapet/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Registrar",
              style: TextStyle(
                fontSize: 15.0
              ),
            ),
            textColor: Colors.white,
            onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignUpScreen()));
            },
          )
        ],
      ),
      
      body: ScopedModelDescendant<User>(
        builder: (context, child, model){ // permite acesso ao modelo User
          if(model.isLoading) return Center(child: CircularProgressIndicator());
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: 250,
                  child: Image.asset("lib/images/buscapet1.png"),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 4),
                  child: Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),

                TextFormField(
                  controller: _emailController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "exemplo@hotmail.com"
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text){
                    if(text.isEmpty) return "Campo obrigatório";
                    else return null;
                  },
                ),

                SizedBox(height: 8.0),

                Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 4),
                  child: Text(
                    "Senha",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),

                TextFormField(
                  controller: _passController,
                  autocorrect: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Digite sua senha aqui",             
                  ),
                  validator: (text){
                    if(text.isEmpty) return "Campo obrigatório";
                    else return null;
                  },
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: (){
                      if(_emailController.text.isEmpty) {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text("Insira seu email para recuperação !"),
                          backgroundColor: Colors.redAccent,
                          duration: Duration(seconds: 2))
                        );                  
                      }
                      else {
                        model.recoverPass(_emailController.text);
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text("Confira seu email"),
                          backgroundColor: Theme.of(context).primaryColor,
                          duration: Duration(seconds: 2))
                        );
                      }
                    },
                    child: Text("Esqueci minha senha", textAlign: TextAlign.right),
                    padding: EdgeInsets.zero,
                  ),
                ),

                SizedBox(height: 10.0),

                RaisedButton(
                  onPressed: (){
                    if(_formKey.currentState.validate()){
                      
                    }
                    model.signIn(
                      email: _emailController.text, 
                      pass: _passController.text, 
                      onSuccess: _onSuccess, 
                      onFail: _onFail
                    );
                  },
                  child: Text("Entrar", style: TextStyle(fontSize: 18.0)),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                )
              ],
            )
          );
        },
      )
    );
  }

  void _onSuccess(){
    Navigator.of(context).pop();
  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text("Falha ao Entrar !"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2))
    );
  }

}