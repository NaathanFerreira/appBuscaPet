import 'package:buscapet/data/animals_data.dart';
import 'package:buscapet/screens/pet_screen.dart';
import 'package:flutter/material.dart';

class PetTile extends StatelessWidget {

  final String type;
  final AnimalsData animal;
  PetTile(this.type, this.animal);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PetScreen(animal)));
      },
      child: Card(
        child: type == "grid" ? 
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 0.8,
                  child: Image.network(
                    animal.images[0],
                    fit: BoxFit.cover,
                  ), 
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.all(8.0),
                    child: Text(animal.name, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                  ),
                )
              ],
            )
            : Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Image.network(
                    animal.images[0],
                    fit: BoxFit.cover,
                    height: 250,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    child: Text(animal.name, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                  ),
                )
              ],
            )
      ),
    );
  }
}