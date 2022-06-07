import 'package:flutter/material.dart';

import '../../../api/jsonplaceholder/model/jsonplaceholder_photo.dart';

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  const PhotosList({Key? key, required this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 1,
      padding: const EdgeInsets.all(16.0),
      // ield identifies the size of the items based on an aspect ratio (width over height).
      childAspectRatio: 8.0 / 10.0,
      children: _buildGridCards2(context, photos),
    );
  }

  /////////////////////////////////////////////////////////////////////////////////////

  List<Widget> _buildGridCards2(BuildContext context, List<Photo> pPhotos) {
    return pPhotos.map((photo) {
      return _createPhotoCard(context, photo);
    }).toList();
  }

  Widget _createPhotoCard(BuildContext context, Photo pPhoto) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) => _dialogBuilderTap(context, pPhoto),
      ),
      onLongPress: () => showDialog(
          context: context,
          builder: (context) => _dialogBuilderLongPress(context, pPhoto)),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18.0 / 11.0,
              child: Image.network(pPhoto.thumbnailUrl, fit: BoxFit.fitWidth),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Title: ' + pPhoto.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Id: ' + pPhoto.id.toString(),
                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.red,
                        ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text('Third Text'),
                  const SizedBox(height: 8.0),
                  const Text('Fourth Text'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialogBuilderTap(BuildContext pContext, Photo pPhoto) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(16),
      children: <Widget>[
        Text(
          "Photo Tapped: " + pPhoto.title,
          style: Theme.of(pContext).textTheme.titleSmall,
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(pContext);
                },
                child: const Text("Pop"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(pContext, '/');
                },
                child: const Text("Push"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(pContext, ModalRoute.withName('/'));
                },
                child: const Text("PopUntil"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.amber),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      pContext, '/', ModalRoute.withName('/'));
                },
                child: const Text("Replace"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dialogBuilderLongPress(BuildContext pContext, Photo pPhoto) {
    return SimpleDialog(
      children: <Widget>[
        Text("Photo Long Pressed: " + pPhoto.title),
      ],
    );
  }
}
