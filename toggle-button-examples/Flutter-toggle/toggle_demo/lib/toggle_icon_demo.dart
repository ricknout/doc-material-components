// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

enum GridDemoTileStyle {
  oneLine,
}

typedef BannerTapCallback = void Function(Photo photo);

/// Each tile has a photo within it. The photo is used to toggle the
/// icon between on and off.
class Photo {
  Photo({
    this.assetName,
    this.isFavorite = false,
  });

  final String assetName;
  bool isFavorite;
  String get tag => assetName; // Assuming that all asset names are unique.
}


/// This class is each tile within the Grid. It represents the individual items
/// you see.
class GridDemoPhotoItem extends StatelessWidget {
  GridDemoPhotoItem({
    Key key,
    @required this.photo,
    @required this.onBannerTap,
  }) :assert(onBannerTap != null),
        super(key: key);

  final Photo photo;
  final BannerTapCallback onBannerTap; // User taps on the photo's header or footer.

  @override
  Widget build(BuildContext context) {
    final Widget image = GestureDetector(
      child: Hero(
        key: Key(photo.assetName),
        tag: photo.tag,
        child: Image.asset(
          photo.assetName,
          fit: BoxFit.cover,
        ),
      ),
    );

    final IconData icon =
    photo.isFavorite ? Icons.favorite : Icons.favorite_border;

    return GridTile(
        header: GestureDetector(
          onTap: () { onBannerTap(photo); },
          child: GridTileBar(
            leading: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
        child: image
    );
  }
}

class ToggleIconDemo extends StatefulWidget {
  ToggleIconDemo({Key key, this.title}) : super(key: key);

  final String title;
  @override
  ToggleIconDemoState createState() => ToggleIconDemoState();
}

class ToggleIconDemoState extends State<ToggleIconDemo> {
  List<Photo> photos = <Photo>[
    Photo(assetName: 'assets/images/image1.jpeg'),
    Photo(assetName: 'assets/images/image2.jpeg'),
    Photo(assetName: 'assets/images/image3.jpeg'),
    Photo(assetName: 'assets/images/image4.jpeg'),

    /// Uncomment this to get more photos imported to the project.
//    Photo(assetName: 'assets/images/image1.jpeg'),
//    Photo(assetName: 'assets/images/image2.jpeg'),
//    Photo(assetName: 'assets/images/image3.jpeg'),
//    Photo(assetName: 'assets/images/image4.jpeg'),
//    Photo(assetName: 'assets/images/image1.jpeg'),
//    Photo(assetName: 'assets/images/image2.jpeg'),
//    Photo(assetName: 'assets/images/image3.jpeg'),
//    Photo(assetName: 'assets/images/image4.jpeg'),
  ];

  void changePage(){
    Navigator.of(context).pushReplacementNamed('/toggleBarPage');
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.pages),
            tooltip: 'Change Page',
            onPressed: changePage
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SafeArea(
              top: false,
              bottom: false,
              child: GridView.count(
                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                padding: const EdgeInsets.all(4.0),
                childAspectRatio: (orientation == Orientation.portrait) ? 1.0 : 1.3,
                children: photos.map<Widget>((Photo photo) {
                  return GridDemoPhotoItem(
                    photo: photo,
                    onBannerTap: (Photo photo) {
                      setState(() {
                        photo.isFavorite = !photo.isFavorite;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}