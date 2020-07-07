import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenbp/blocs/pet_bloc.dart';
import 'package:gerenbp/validators/pet_validator.dart';
import 'package:gerenbp/widgets/images_widget.dart';

class PetScreen extends StatefulWidget {

  final String animalId; // Cachorro, gato
  final DocumentSnapshot pet;


  PetScreen({this.animalId, this.pet});

  @override
  _PetScreenState createState() => _PetScreenState(animalId, pet);
}

class _PetScreenState extends State<PetScreen> with PetValidator {

  final PetBloc _petBloc;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _PetScreenState(String animalId, DocumentSnapshot pet) : _petBloc = PetBloc(animalId: animalId, pet: pet);

  @override
  Widget build(BuildContext context) {

    InputDecoration _buildDecoration(String label){
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey)
      );
    }

    final _fieldStyle = TextStyle(
      color: Colors.white,
      fontSize: 16
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.deepPurple[800],
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<bool>(
          stream: _petBloc.outCreated,
          initialData: false,
          builder: (context, snapshot) {
            return Text(snapshot.data ? "Editar pet" : "Adicionar Pet");
          }
        ),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _petBloc.outCreated,
            initialData: false,
            builder: (context, snapshot){
              if(snapshot.data) {
                return StreamBuilder<bool>(
                  stream: _petBloc.outLoading,
                  initialData: false,
                  builder: (context, snapshot) {
                    return IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: snapshot.data ? null : (){
                        _petBloc.deletePet();
                        Navigator.of(context).pop();
                      },
                    );
                  }
                );
              } else {
                return Container();
              }
            },
          ),

          StreamBuilder<bool>(
            stream: _petBloc.outLoading,
            initialData: false,
            builder: (context, snapshot) {
              return IconButton(
                icon: Icon(Icons.save),
                onPressed: snapshot.data ? null : savePet,
              );
            }
          ),

        ],
      ),
      body: Stack(
        children: <Widget>[
              Form(
            key: _formKey,
            child: StreamBuilder<Map>(
              stream: _petBloc.outData,
              builder: (context, snapshot) {
                if(!snapshot.hasData) return Container();
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: <Widget>[
                    Text("Imagens", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ImagesWidget(
                      context: context,
                      initialValue: snapshot.data["images"],
                      onSaved: _petBloc.saveImages,
                      validator: validateImages,
                    ),

                    TextFormField(
                      initialValue: snapshot.data["name"],
                      style: _fieldStyle,
                      maxLines: 1,
                      decoration: _buildDecoration("Nome"),
                      onSaved: _petBloc.saveName,
                      validator: validateName,
                    ),

                    TextFormField(
                      initialValue: snapshot.data["description"],
                      style: _fieldStyle,
                      maxLines: 7,
                      decoration: _buildDecoration("Descrição"),
                      onSaved: _petBloc.saveDescription,
                      validator: validateDescription,     
                    ),

                    TextFormField(
                      initialValue: snapshot.data["history"],
                      style: _fieldStyle,
                      maxLines: 7,
                      decoration: _buildDecoration("História"),
                      onSaved: _petBloc.saveHistory,
                      validator: validateHistory,
                    ),
                  ],
                );
              }
            ),
          ),
          StreamBuilder<bool>(
            stream: _petBloc.outLoading,
            initialData: false,
            builder: (context, snapshot) {
              return IgnorePointer(
                ignoring: !snapshot.data,
                child: Container(
                  color: snapshot.data ? Colors.black54 : Colors.transparent
                ),
              );
            }
          ),
        ],
      )
    );
  }

  void savePet() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Salvando pet...", style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.redAccent,
        )
      );

      bool success = await _petBloc.savePet();

      _scaffoldKey.currentState.removeCurrentSnackBar();

      print(success);

      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text(success ? "Pet salvo!" : "Erro ao salvar pet!", style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.redAccent,
          )
      );
    }
  }

}