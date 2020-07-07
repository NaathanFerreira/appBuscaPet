import 'package:buscapet/screens/animals_screen.dart';
import 'package:flutter/material.dart';

IconData pets = IconData(0xe91d, fontFamily: 'MaterialIcons');

class PetsButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return FloatingActionButton(
      child: Icon(Icons.pets, color: Colors.white),
      onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AnimalScreen()));
      },
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}