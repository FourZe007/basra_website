import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stsj/activity_point/services/api.dart';

class ImageFS extends StatefulWidget {
  const ImageFS(this.tag, this.branch, this.shop, this.actId, this.tgl, {super.key});
  final String tag;
  final String branch;
  final String shop;
  final String actId;
  final String tgl;

  @override
  State<ImageFS> createState() => _ImageFSState();
}

class _ImageFSState extends State<ImageFS> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.tag,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: FutureBuilder(
            future: ApiPoint.getFotoFS(widget.branch, widget.shop, widget.actId, widget.tgl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.indigo,
                    valueColor: AlwaysStoppedAnimation(Colors.cyan.shade200),
                    strokeWidth: 5.0,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'ERROR: ${snapshot.error}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty || snapshot.data == '') {
                return Center(
                  child: Text(
                    'TERJADI KESALAHAN PADA GAMBAR',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                );
              } else {
                return InteractiveViewer(child: Image.memory(base64Decode(snapshot.data!), fit: BoxFit.cover));
              }
            },
          ),
        ),
      ),
    );
  }
}
