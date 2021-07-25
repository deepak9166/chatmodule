import 'package:flutter/material.dart';

import '../../../constants.dart';

class ImageVideoMessage extends StatelessWidget {
  ImageVideoMessage(
      {this.link = "",
      this.isVideo = false,
      this.loading = false,
      this.localFile});
  final String link;
  final isVideo;
  final bool loading;
  final localFile;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: loading
                  ? Center(
                      child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.file(localFile),
                        CircularProgressIndicator(),
                      ],
                    ))
                  : link.isNotEmpty
                      ? Image.network(link)
                      : SizedBox(),
            ),
            isVideo
                ? Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      size: 16,
                      color: Colors.white,
                    ))
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
