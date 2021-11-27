import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase/models/product_dao.dart';
import 'package:firebase/providers/firebase_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AgregarProductoScreen extends StatefulWidget {
  AgregarProductoScreen({Key
  ? key}) : super(key: key);

  @override
  _AgregarProductoScreenState createState() => _AgregarProductoScreenState();
}

class _AgregarProductoScreenState extends State<AgregarProductoScreen> {
  TextEditingController _controllerNombre = TextEditingController();
  TextEditingController _controllerDescripcion = TextEditingController();
  late FirebaseProvider _firebaseProvider;

  @override
  void initState() {
    super.initState();
    _firebaseProvider = FirebaseProvider();
  }

  File? imagen=null;
  final formkey = GlobalKey<FormState>();
  String? url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Producto'),
      ),
      body: Center(child: new 
      ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Center(
            child: imagen == null
            ? Text('Seleccionar imagen')
            : _subirimagen(),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _getimage,
            tooltip: "Agrega imagen",
            child: Icon(Icons.add_a_photo),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: subirdatos,
            child: Text('Guardar Producto'),
          )
        ],
      )
      ),
    );
  }
  
  void subirdatos() async{
    if (_controllerNombre.text.trim().isNotEmpty) {
      if (_controllerDescripcion.text.trim().isNotEmpty) {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference postimage = storage.ref().child("Post Images");
        var timeKey = DateTime.now();
        final UploadTask uploadtask = 
          postimage.child(timeKey.toString()+".jpg").putFile(imagen!);

        var urlimagen = await (await uploadtask).ref.getDownloadURL();
        

        ProductDao producto = ProductDao(
          cveprod: _controllerNombre.text,
          descprod: _controllerDescripcion.text,
          imgprod: urlimagen.toString()
        );
        _firebaseProvider.saveProduct(producto);


        Navigator.pop(context);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor ingrese la descripcion del producto')));
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor ingrese el nombre del producto')));
    }
  }

  Future _getimage() async{   
    ImagePicker _picker = ImagePicker();
    XFile? tempimage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagen = File(tempimage!.path);
    });
  }

  Widget _subirimagen(){
    return Container(
      child: Form(
        key: formkey,
        child: Column(
          children: [
            Image.file(imagen!,height: 300, width: 600),
            SizedBox(height: 10),
            _crearTextFieldNombre(),
            SizedBox(height: 10),
            _crearTextFieldDescripcion(),
          ],
        )
      ),
    );
  }

  Widget _crearTextFieldNombre() {
    return TextField(
      controller: _controllerNombre,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: "Nombre del producto",
      ),
    );
  }

  Widget _crearTextFieldDescripcion() {
    return TextField(
      controller: _controllerDescripcion,
      keyboardType: TextInputType.text,
      maxLines: 5,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: "Descripcion del producto",
          ),
    );
  }

}