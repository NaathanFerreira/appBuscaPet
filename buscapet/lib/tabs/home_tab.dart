import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Widget _buildBodyBack() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 210, 105, 30),
            Color.fromARGB(255, 252, 181, 68)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        )
      ),
    );

    return Stack(
      children: <Widget>[
        _buildBodyBack(),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true, // ficará "flutuando" por cima da tela
              snap: true, // ao puxar a tela para baixo, a barra desaparece
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Pets"),
                centerTitle: true,
              ),
            ),

            FutureBuilder<QuerySnapshot>(
              future: Firestore.instance.collection('home').orderBy('pos').getDocuments(),
              builder: (context, snapshot){
                if(!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                    ),
                  );
                }
                else {
                  return SliverStaggeredGrid.count(
                    crossAxisCount: 2, // 2 blocos de largura
                    mainAxisSpacing: 1.0, // espaçamento entre as imagens
                    crossAxisSpacing: 1.0,
                    staggeredTiles: snapshot.data.documents.map( // mapeia os documentos
                      (doc){
                        return StaggeredTile.count(doc.data["x"], doc.data["y"]);
                      }
                    ).toList(), //transforma o mapa em lista

                    children: snapshot.data.documents.map(
                      (doc){
                        return FadeInImage.memoryNetwork( // imagem aparecerá suavemente na tela
                          placeholder: kTransparentImage, 
                          image: doc.data["image"],
                          fit: BoxFit.cover, // cobre todo espaço possivel na tile da grade
                        );
                      }
                    ).toList(),
                  );
                }
              },
            )
          ],
        )
      ],
    );
  }
}
