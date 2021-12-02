import 'package:bubble/bubble.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBotScreen extends StatefulWidget {
  ChatBotScreen({Key? key}) : super(key: key);

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  void sendMessage(String text) async {
    print("mensaje que se enviara");
    print(text);

    DialogAuthCredentials credentials =
        await DialogAuthCredentials.fromFile('assets/dialog_flow_auth.json');

    DialogFlowtter _dialogFlowtter = DialogFlowtter(
      credentials: credentials,
    );

    if (text.isEmpty) {
      return;
    }

    setState(() {
      Message userMessage = Message(text: DialogText(text: [text]));
      addMessage(userMessage, true);
    });

    QueryInput query = QueryInput(text: TextInput(text: text));

    print('query');
    print(query);

    DetectIntentResponse res = await _dialogFlowtter.detectIntent(
      queryInput: query,
    );
    
    print('respuesta mensage');
    print(res);

   

    String? textResponse = res.text;
    print('respuesta');
    print(textResponse);

    if (textResponse == null) {
      print("respuesta vacio");
      return;
    }
    ;

    setState(() {
      addMessage(res.message);
    });
    
  }

  void addMessage(Message? message, [bool isUserMessage = false]) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text('Chatbot'),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 15, bottom: 10),
              child: Text(
                'Hoy, ${DateFormat("Hm").format(DateTime.now())}',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),

          /// Esta parte se asegura que la caja de texto se posicione hasta abajo de la pantalla
          Expanded(
            child: _MessagesList(messages: messages),
          ),

          Divider(
            height: 5,
            color: Colors.black,
          ),

          Container(
            child: ListTile(
              title: Container(
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color.fromRGBO(220, 220, 220, 1)),
                padding: EdgeInsets.only(left: 15),
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Ingresa un mensaje",
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.send, size: 30, color: Colors.blue),
                onPressed: () {
                  if (_controller.text.isEmpty) {
                    print('Mensaje Vacio');
                  } else {
                    setState(() {
                      print("enviar mensaje");
                      print(_controller.text);
                      sendMessage(_controller.text.trim());
                      _controller.clear();
                    });
                  }
                },
              ),
            ),
          ),

          //container funcionando bien
          // Container(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 10,
          //     vertical: 5,
          //   ),
          //   color: Colors.blue,
          //   child: Row(
          //     children: [
          //       /// El Widget [Expanded] se asegura que el campo de texto ocupe
          //       /// toda la pantalla menos el ancho del [IconButton]
          //       Expanded(
          //         child: TextField(
          //           style: TextStyle(color: Colors.white),
          //           /// Agrégalo dentro del [TextField]
          //           controller: _controller,
          //         ),
          //       ),
          //       IconButton(
          //         color: Colors.white,
          //         icon: Icon(Icons.send),
          //         onPressed: () {
          //           /// Mandamos a llamar la función [sendMessage]
          //           print("enviar mensaje");
          //           print(_controller.text);
          //           sendMessage(_controller.text);
          //           /// Limpiamos nuestro campo de texto
          //           _controller.clear();
          //         },
          //       ),
          //     ],
          //   ), // Fin de la fila
          // ), // Fin del contenedor
        ],
      ), // Fin de la columna
    );
  }
}

class _MessagesList extends StatelessWidget {
  /// El componente recibirá una lista de mensajes
  final List<Map<String, dynamic>> messages;

  const _MessagesList({
    Key? key,

    /// Le indicamos al componente que la lista estará vacía en
    /// caso de que no se le pase como argumento alguna otra lista
    this.messages = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Regresaremos una [ListView] con el constructor [separated]
    /// para que después de cada elemento agregue un espacio
    return ListView.separated(
      /// Indicamos el número de items que tendrá
      itemCount: messages.length,

      // Agregamos espaciado
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),

      /// Indicamos que agregue un espacio entre cada elemento
      separatorBuilder: (_, i) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        var obj = messages[messages.length - 1 - i];
        return _MessageContainer(
          message: obj['message'],
          isUserMessage: obj['isUserMessage'],
        );
      },
      reverse: true,
    );
  }
}

class _MessageContainer extends StatelessWidget {
  final Message? message;
  final bool isUserMessage;

  const _MessageContainer({
    Key? key,

    /// Indicamos que siempre se debe mandar un mensaje
    required this.message,
    this.isUserMessage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      /// Cambia el lugar del mensaje
      mainAxisAlignment:
          isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        isUserMessage == false
          ? Container(
              height: 60,
              width: 60,
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/bot.jpg"),
              ),
            )
          : Container(),
        Padding(
          padding: EdgeInsets.all(10),
          child: Bubble(
            radius: Radius.circular(20),
            color: isUserMessage ? Colors.blue : Colors.orange,
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 250),
                      child: Text(
                        message?.text!.text![0] ?? '',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        isUserMessage
          ? Container(
              height: 60,
              width: 60,
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/comida.jpg"),
              ),
            )
          : Container(),
      ],
    );
  }
}
