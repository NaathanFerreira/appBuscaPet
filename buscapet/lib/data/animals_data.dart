import 'package:cloud_firestore/cloud_firestore.dart';

class AnimalsData {
  String animal;
  String id;
  String name;
  String description;
  String history;
  List images;

  // Converte os dados do documento no firebase nos dados da classe
  AnimalsData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    name = snapshot.data["name"];
    description = snapshot.data["description"];
    history = snapshot.data["history"];
    images = snapshot.data["images"];
  }
}
