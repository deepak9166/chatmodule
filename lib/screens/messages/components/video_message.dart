import 'package:flutter/material.dart';

import '../../../constants.dart';

class ImageVideoMessage extends StatelessWidget {
  ImageVideoMessage({this.link = "", this.isVideo = false});
  final String link;
  final isVideo;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45, // 45% of total width
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: link.isNotEmpty ? Image.network(link) : SizedBox(),
            ),
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: isVideo
                  ? Icon(
                      Icons.play_arrow,
                      size: 16,
                      color: Colors.white,
                    )
                  : SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}
