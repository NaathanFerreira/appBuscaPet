import 'package:buscapet/data/animals_data.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class PetScreen extends StatefulWidget {
  final AnimalsData animal;
  PetScreen(this.animal);

  @override
  _PetScreenState createState() => _PetScreenState(animal);
}

class _PetScreenState extends State<PetScreen> {
  final AnimalsData animal;
  _PetScreenState(this.animal);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(animal.name),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: animal.images.map((url) {
                // transforma as urls das imagens que estão em forma de string em um NetworkImage
                return NetworkImage(url);
              }).toList(),
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  animal.name,
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                  maxLines: 3,
                ),
                SizedBox(height: 16.0),
                Text(
                  "Características:",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  animal.description.replaceAll("-", "\n"),
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
                Text(
                  "História:",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  animal.history,
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text("Quero adotar !",
                        style: TextStyle(fontSize: 18.0)),
                    color: primaryColor,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
