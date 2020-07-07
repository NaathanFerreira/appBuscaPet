import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenbp/blocs/animal_bloc.dart';
import 'package:gerenbp/widgets/image_source_sheet.dart';

class EditAnimalDialog extends StatefulWidget {

  final DocumentSnapshot animal;
  EditAnimalDialog({this.animal});

  @override
  _EditAnimalDialogState createState() => _EditAnimalDialogState(animal: animal);
}

class _EditAnimalDialogState extends State<EditAnimalDialog> {
  final AnimalBloc _animalBloc;

  final TextEditingController _controller;

  _EditAnimalDialogState({DocumentSnapshot animal}) : _animalBloc = AnimalBloc(animal),
  _controller = TextEditingController(text: animal != null ? animal.data["title"] : "" );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: GestureDetector(
                onTap: (){
                  showModalBottomSheet(
                    context: context, 
                    builder: (context) => ImageSourceSheet(
                      onImageSelected: (image){
                        Navigator.of(context).pop();
                        _animalBloc.setImage(image);
                      },
                    )
                  );
                },
                child: StreamBuilder(
                  stream: _animalBloc.outImage,
                  builder: (context, snapshot) {
                    if(snapshot.data != null)
                      return CircleAvatar(
                        child: snapshot.data is File ? Image.file(snapshot.data, fit: BoxFit.cover) : 
                        Image.network(snapshot.data, fit: BoxFit.cover),
                        backgroundColor: Colors.transparent,
                      );
                    else return Icon(Icons.image);
                  }
                ),
              ),
              title: StreamBuilder<String>(
                stream: _animalBloc.outTitle,
                builder: (context, snapshot) {
                  return TextField(
                    controller: _controller,
                    onChanged: _animalBloc.setTitle,
                    decoration: InputDecoration(
                      errorText: snapshot.hasError ? snapshot.error : null
                    ),
                  );
                }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StreamBuilder<bool>(
                  stream: _animalBloc.outDelete,
                  builder: (context, snapshot) {
                    if(!snapshot.hasData) return Container();
                    return FlatButton(
                      child: Text("Excluir"),
                      textColor: Colors.red,
                      onPressed: snapshot.data ? (){
                        _animalBloc.delete();
                        Navigator.of(context).pop();
                      } : null,
                    );
                  }
                ),
                StreamBuilder<bool>(
                  stream: _animalBloc.submitValid,
                  builder: (context, snapshot) {
                    return FlatButton(
                      child: Text("Salvar"),
                      onPressed: snapshot.hasData ? () async {
                        await _animalBloc.saveData();
                        Navigator.of(context).pop();
                      } : null,
                    );
                  }
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}