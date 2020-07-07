import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class AnimalBloc extends BlocBase {

  final _titleController = BehaviorSubject<String>();
  final _imageController = BehaviorSubject();
  final _deleteController = BehaviorSubject<bool>();

  Stream<String> get outTitle => _titleController.stream.transform(
    StreamTransformer<String, String>.fromHandlers(
      handleData: (title, sink){
        if(title.isEmpty)
          sink.addError("Insira um título");
        else
          sink.add(title);
      }
    )
  );
  Stream get outImage => _imageController.stream;
  Stream<bool> get outDelete => _deleteController.stream;

  Stream<bool> get submitValid => Observable.combineLatest2(
    outTitle, outImage, (a, b) => true
  );

  DocumentSnapshot animal;

  String title;
  File image;

  AnimalBloc(this.animal){
    if(animal != null){
      title = animal.data["title"];

      _titleController.add(animal.data["title"]);
      _imageController.add(animal.data["icon"]);
      _deleteController.add(true);
    } else {
      _deleteController.add(false);
    }
  }

  void setImage(File file){
    image = file;
    _imageController.add(file);
  }

  void setTitle(String title){
    this.title = title;
    _titleController.add(title);
  }

  void delete(){
    animal.reference.delete();
  }

  Future saveData() async {
    if(image == null && animal != null && title == animal.data["title"]) return;

    Map<String, dynamic> dataToUpdate = {};

    if(image != null){
      StorageUploadTask task = FirebaseStorage.instance.ref().child("icons")
          .child(title).putFile(image);
      StorageTaskSnapshot snap = await task.onComplete;
      dataToUpdate["icon"] = await snap.ref.getDownloadURL();
    }

    if(animal == null || title != animal.data["title"]){
      dataToUpdate["title"] = title;
    }

    if(animal == null){
      await Firestore.instance.collection("pets").document(title.toLowerCase())
          .setData(dataToUpdate);
    } else {
      await animal.reference.updateData(dataToUpdate);
    }

  }

  @override
  void dispose() {
    _titleController.close();
    _imageController.close();
    _deleteController.close();
  }



}