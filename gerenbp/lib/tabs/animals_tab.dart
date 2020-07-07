import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenbp/widgets/animals_tile.dart';

class AnimalsTab extends StatefulWidget {
  @override
  _AnimalsTabState createState() => _AnimalsTabState();
}

class _AnimalsTabState extends State<AnimalsTab> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("pets").snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.redAccent,
          ),
        )
        );
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            return AnimalsTile(snapshot.data.documents[index]);
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
