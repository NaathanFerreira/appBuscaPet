import 'package:buscapet/models/user.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _cityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Registrar"),
        centerTitle: true,
      ),

      body: ScopedModelDescendant<User>(
        builder: (context, child, model){
          if(model.isLoading) return Center(child: CircularProgressIndicator());
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 4),
                  child: Text(
                    "Nome",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),

                TextFormField(
                  controller: _nameController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Exemplo: Nathan Ferreira"
                  ),
                  validator: (text){
                    if(text.isEmpty) return "Campo obrigatório";
                    else return null;
                  },
                ),

                SizedBox(height: 8.0),

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

                SizedBox(height: 8.0),

                Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 4),
                  child: Text(
                    "Cidade",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),

                TextFormField(
                  controller: _cityController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Cida em que mora atualmente"
                  ),
                  validator: (text){
                    if(text.isEmpty) return "Campo obrigatório";
                    else return null;
                  },
                ),

                SizedBox(height: 12.0),

                RaisedButton(
                  onPressed: (){
                    if(_formKey.currentState.validate()){

                      Map<String, dynamic> userData = {
                        "name": _nameController.text,
                        "email": _emailController.text,
                        "city": _cityController.text
                      };

                      model.signUp(
                        userData: userData, 
                        pass: _passController.text, 
                        onSuccess: _onSuccess, 
                        onFail: _onFail
                      );
                    }
                  },
                  child: Text("Registrar", style: TextStyle(fontSize: 18.0)),
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
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text("Usuário criado com sucesso!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2))
    );
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });
  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text("Falha ao criar usuário!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2))
    );
  }

}