import 'package:buscapet/tabs/animals_tab.dart';
import 'package:buscapet/tabs/home_tab.dart';
import 'package:buscapet/tabs/places_tab.dart';
import 'package:buscapet/widgets/custom_drawer.dart';
import 'package:buscapet/widgets/pets_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[

        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: PetsButton(),
        ),

        Scaffold(
          appBar: AppBar(
            title: Text("Animais"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),        
          body: AnimalsTab(),         
        ),

        Scaffold(
          appBar: AppBar(
            title: Text("Institutos"),
            centerTitle: true,
          ),
          body: PlacesTab(),
          drawer: CustomDrawer(_pageController),
        )

      ],
    );
  }
}
