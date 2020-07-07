import 'package:buscapet/tabs/animals_tab.dart';
import 'package:flutter/material.dart';

class AnimalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animais"),
        centerTitle: true,
      ),
      body: AnimalsTab(),
    );
  }
}
