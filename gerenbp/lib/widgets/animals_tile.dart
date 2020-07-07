import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenbp/screens/pet_screen.dart';
import 'package:gerenbp/widgets/edit_animal_dialog.dart';

class AnimalsTile extends StatelessWidget {

  final DocumentSnapshot animals;

  AnimalsTile(this.animals);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          leading: GestureDetector(
            onTap: (){
              showDialog(context: context, builder: (context) => EditAnimalDialog(
                animal: animals,
              ));
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(animals.data["icon"]),
              backgroundColor: Colors.transparent,
            ),
          ),
          title: Text(
            animals.data["title"],
            style: TextStyle(color: Colors.grey[850], fontWeight: FontWeight.w500),
          ),

          children: <Widget>[ // o que ira aparecer ao abrir o expansiontile
            FutureBuilder<QuerySnapshot>(
              future: animals.reference.collection("items").getDocuments(),
              builder: (context, snapshot){
                if(!snapshot.hasData) return Container();
                return Column(
                  children: snapshot.data.documents.map((doc){

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(doc.data["images"][0]),
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text(doc.data["name"]),
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PetScreen(
                          animalId: animals.documentID,
                          pet: doc,
                        )));
                      },
                    );

                  }).toList()..add( // adiciona mais um widget 
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Icon(Icons.add, color: Colors.redAccent,),
                      ),
                      title: Text("Adicionar"),
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PetScreen(
                          animalId: animals.documentID,
                        )));
                      },
                    )
                  ),
                );
              }
            )
          ],
        ),
      ),
    );
  }
}