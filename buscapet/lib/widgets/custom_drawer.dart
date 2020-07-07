import 'package:buscapet/models/user.dart';
import 'package:buscapet/screens/login_screen.dart';
import 'package:buscapet/tiles/drawer_tile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {

  final PageController pagecontroller;
  CustomDrawer(this.pagecontroller);

  @override
  Widget build(BuildContext context) {

    const IconData pets = IconData(0xe91d, fontFamily: 'MaterialIcons');

    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 215, 0),
            Colors.white
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        )
      ),
    );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0),
            children: <Widget>[
              Container(
                // header do drawer
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170,
                child: Stack(
                  children: <Widget>[ 
                    Container(
                        height: 200,
                        child: Image.asset("lib/images/buscapet1.png"),
                    ),
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child: ScopedModelDescendant<User>(
                        builder: (context, child, model){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Olá, ${!model.isLoggedIn() ? "" : model.userData["name"]}", 
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)
                              ),
                              GestureDetector(
                                child: Text(
                                  !model.isLoggedIn() ?
                                  "Entre ou cadastre-se" : "Sair", 
                                  style: TextStyle(color: Color.fromARGB(255, 4, 125, 140), fontSize: 16.0, fontWeight: FontWeight.bold)
                                ),
                                onTap: (){
                                  if(!model.isLoggedIn())
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                                  else
                                    model.signOut();
                                },
                              )
                            ],
                          );
                        },
                      )
                    )
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, "Início", pagecontroller, 0),
              DrawerTile(pets, "Pets", pagecontroller, 1),
              DrawerTile(Icons.location_on, "Institutos", pagecontroller, 2),
            ],
          )
        ],
      ),
    );
  }
}