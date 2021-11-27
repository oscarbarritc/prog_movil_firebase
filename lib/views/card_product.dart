import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/providers/firebase_providers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.Dart' as Path;

class CardProduct extends StatefulWidget {
  const CardProduct({Key? key, required this.productDocument})
      : super(key: key);
  final DocumentSnapshot productDocument;

  @override
  State<CardProduct> createState() => _CardProductState();
}

class _CardProductState extends State<CardProduct> {
  late FirebaseProvider _firebaseProvider;

  @override
  void initState() {
    super.initState();
    _firebaseProvider = FirebaseProvider();
  }

  @override
  Widget build(BuildContext context) {
    final _card = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: CachedNetworkImage(
            imageUrl: widget.productDocument['imgprod'],
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.contain,
            height: 230.0,
            fadeInDuration: Duration(milliseconds: 100),
          ),
        ),
        Opacity(
          opacity: .6,
          child: Container(
            height: 55.0,
            color: Colors.black,
            child: Row(
              children: [
                Text(
                  widget.productDocument['cveprod'],
                  style: TextStyle(color: Colors.white),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Confirmación'),
                            content: Text('¿Estas segudo de borrar: ${widget.productDocument['cveprod']}?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    deleteFireBaseStorageItem(
                                      widget.productDocument['imgprod']);
                                    _firebaseProvider.deleteProduct(widget.productDocument.id);
                                    ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                              'El registro se ha elimindo')));
                                    setState(() {});
                                  },
                                  child: Text('Si')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('No'))
                            ],
                          );
                        }
                      );                    
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        )
      ],
    );
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(.2),
            offset: Offset(0.0, 5.0),
            blurRadius: 1.0)
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: _card,
      ),
    );
  }

  void deleteFireBaseStorageItem(String fileUrl) async {
    print('antes');
    print(fileUrl);
    var name = Uri.decodeFull(Path.basename(fileUrl));

    
    name = name.replaceAll(
      'https://firebasestorage.googleapis.com/v0/b/patm2021-2b7e2.appspot.com/o/Post%20Images/',
      '');
    // name = name.
    // replaceAll(
    //   '?',
    //   '');
    name = name.replaceAll(
      '%',
      ' ');

    List<String> parts = name.split("?");


    String part1 = parts[0];
    String part2 = parts[1];
    print('despues');
    print(part1);

    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(part1);
    await firebaseStorageRef.delete();
  }
}
