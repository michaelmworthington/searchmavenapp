import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:searchmavenapp/api/centralsearchapi.dart';

class FourthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("fourth screen")),
      body: FutureBuilder<List<Photo>>(
        future: GetData().fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PhotosList(photos: snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner
          return CircularProgressIndicator();
        }
      )
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  Widget _dialogBuilderTap(BuildContext pContext, Photo pPhoto){
    return SimpleDialog(
      contentPadding: EdgeInsets.all(16),
      children: <Widget>[
        Text("Photo Tapped: " + pPhoto.title, style: Theme.of(pContext).textTheme.title),
        SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(pContext);
                },
                child: Text("Close")
              ),
              RaisedButton(
                onPressed: () {},
                child: Text("OK")
              )
            ]
          )
        )
      ]
    );
  }

  Widget _dialogBuilderLongPress(BuildContext pContext, Photo pPhoto){
    return SimpleDialog(
      children: <Widget>[
        Text("Photo Long Pressed: " + pPhoto.title)
      ]
    );
    
  }

  Widget _createPhotoCard(BuildContext context, Photo pPhoto){
    return GestureDetector(
      onTap: () => 
        showDialog(context: context,
          builder: (context) => _dialogBuilderTap(context, pPhoto)),
      onLongPress: () =>
        showDialog(context: context,
          builder: (context) => _dialogBuilderLongPress(context, pPhoto)),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18.0 / 11.0,
              child: Image.network(pPhoto.thumbnailUrl, 
                                  fit: BoxFit.fitWidth
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Title: ' + pPhoto.title,
                    style: Theme.of(context).textTheme.headline,
                    maxLines: 3,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Id: ' + pPhoto.id.toString(),
                    style: Theme.of(context).textTheme.subhead.copyWith(fontStyle: FontStyle.italic, color: Colors.red),
                  ),
                  SizedBox(height: 8.0),
                  Text('Third Text'),
                  SizedBox(height: 8.0),
                  Text('Fourth Text'),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  List<Widget> _buildGridCards2(BuildContext context, List<Photo> pPhotos){
    return pPhotos.map( (photo) {
      return _createPhotoCard(context, photo);
    }).toList();
  }
    
  @override
  Widget build(BuildContext context) {
    
    return GridView.count(
      crossAxisCount: 1,
      padding: EdgeInsets.all(16.0),
      // ield identifies the size of the items based on an aspect ratio (width over height).
      childAspectRatio: 8.0 / 10.0,
      children: _buildGridCards2(context, photos),
    );
  }
}