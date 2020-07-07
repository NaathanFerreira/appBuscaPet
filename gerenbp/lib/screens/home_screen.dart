import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerenbp/blocs/user_bloc.dart';
import 'package:gerenbp/tabs/animals_tab.dart';
import 'package:gerenbp/tabs/users_tab.dart';
import 'package:gerenbp/widgets/edit_animal_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

const IconData pets = IconData(0xe91d, fontFamily: 'MaterialIcons');

class _HomeScreenState extends State<HomeScreen> {

  PageController _pageController;
  int _page = 0;

  UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _userBloc = UserBloc();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[800],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.redAccent,
          primaryColor: Colors.white,
          textTheme: Theme.of(context).textTheme.copyWith(
            caption: TextStyle(color: Colors.white)
          )
        ),
        child: BottomNavigationBar(
          currentIndex: _page,
          onTap: (pag){
            _pageController.animateToPage(
              pag,
              duration: Duration(milliseconds: 500),
              curve: Curves.ease
            );
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text("Usuários")
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pets),
              title: Text("Animais")
            )
          ],
        ),
      ),

      body: SafeArea(
        child: BlocProvider<UserBloc>(
          bloc: _userBloc,
          child: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (pag){
              setState(() {
                _page = pag;
              });
            },
            children: <Widget>[
              UsersTab(),
              AnimalsTab(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),
    ); 
  }

  Widget _buildFloating(){
    switch(_page){
      case 0:
        return null;
      case 1:
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.redAccent,
          onPressed: (){
            showDialog(context: context, builder: (context) => EditAnimalDialog());
          },
        );
    }
  }
}