import 'package:firebase/screens/chat_screen.dart';

import 'package:firebase/screens/products_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/add_product_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
   title: 'Navigation Basics',
   home: MyApp(),
   debugShowCheckedModeBanner: false,
 ));
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firebase'),
          actions: [
            IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AgregarProductoScreen()));
                      
              }
                 
              , 
              icon: Icon(Icons.add)
            ),
            IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatBotScreen()));
                      
              }
                 
              , 
              icon: Icon(Icons.chat)
            )
          ],
        ),
        body: ListProducts(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}