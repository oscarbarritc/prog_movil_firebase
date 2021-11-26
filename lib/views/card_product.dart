import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CardProduct extends StatelessWidget {
  const CardProduct({
    Key? key,
    required this.productDocument
  }) : super(key: key);

  final DocumentSnapshot productDocument;

  @override
  Widget build(BuildContext context) {
    final _card = Stack(
    alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: FadeInImage(
            placeholder: AssetImage('assets/activity_indicator.gif'),
            image: NetworkImage(productDocument['imgprod'] == null ? 
            'https://assets.stickpng.com/thumbs/580b57fcd9996e24bc43c325.png'
            :productDocument['imgprod']),
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 100),
            height: 230.0,
          ),
        ),
        Opacity(
          opacity: .6,
          child: Container(
            height: 55.0,
            color: Colors.black,
            child: Row(
              children: [
                Text(productDocument['cveprod'], style: TextStyle(color: Colors.white),)
              ],
            ),
          ),
        )
      ],
    );
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.2),
            offset: Offset(0.0,5.0),
            blurRadius: 1.0
          )
        ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: _card,
      ),
    );
  }
}