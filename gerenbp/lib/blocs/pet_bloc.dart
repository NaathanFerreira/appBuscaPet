import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class PetBloc extends BlocBase {

  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  String animalId;
  DocumentSnapshot pet;

  Map<String, dynamic> unsavedData;

  PetBloc({this.animalId, this.pet}){
    if(pet != null){
      unsavedData = Map.of(pet.data); // clona os dados do pet e passa para o unsavedData
      unsavedData["images"] = List.of(pet.data["images"]);

      _createdController.add(true);
    } else { // se caso tenha clickado em adicionar novo pet
      unsavedData = {
        "name": null, "description": null, "history": null, "images": []
      };

      _createdController.add(false);
    }

    _dataController.add(unsavedData);
  }

  void saveName(String name){
    unsavedData["name"] = name;
  }

  void saveDescription(String description){
    unsavedData["description"] = description;
  }

  void saveHistory(String history){
    unsavedData["history"] = history;
  }

  void saveImages(List images){
    unsavedData["images"] = images;
  }

  Future<bool> savePet() async {

    _loadingController.add(true);


    try {
      if(pet != null){
        await _uploadImages(pet.documentID);
        await pet.reference.updateData(unsavedData);
      } else {
        DocumentReference dr = await Firestore.instance.collection("pets").document(animalId).
          collection("items").add(Map.from(unsavedData)..remove("images"));
        await _uploadImages(dr.documentID);
        await dr.updateData(unsavedData);
      }

      _createdController.add(true);
      _loadingController.add(false);
      return true;
    } catch (e){
      _loadingController.add(false);
      return false;
    }
  }

  Future _uploadImages(String animalId) async {
    for(int i = 0; i < unsavedData["images"].length; i++){
      if(unsavedData["images"][i] is String) continue;
      
      StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child(animalId).
        child(animalId).child(DateTime.now().millisecondsSinceEpoch.toString()).
        putFile(unsavedData["images"][i]);

      StorageTaskSnapshot s = await uploadTask.onComplete;
      String downloadUrl = await s.ref.getDownloadURL();

      unsavedData["images"][i] = downloadUrl;
    }
  }

  void deletePet(){
    pet.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }

}