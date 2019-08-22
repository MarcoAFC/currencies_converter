import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
const request = "https://api.hgbrasil.com/finance?format=json-cors&key=54f7098f";

void main() async {

  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
      ),
    ));
}

Future<Map> getData() async{
   http.Response response = await(http.get(request));
   return(json.decode(response.body));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
  
}

class _HomeState extends State<Home> {
  double dollar;
  double euro;
  double peso;

  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();
  final pesoController = TextEditingController();

  void _realChanged(String text){
    if (text.isEmpty){
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dollarController.text = ((real/dollar)).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
    pesoController.text = (real/peso).toStringAsFixed(2);

  }
  void _dollarChanged(String text){
    if (text.isEmpty){
      _clearAll();
      return;
    }
    double dollar = double.parse(text);
    realController.text = ((dollar * this.dollar)).toStringAsFixed(2);
    euroController.text = (dollar * this.dollar/euro).toStringAsFixed(2);
    pesoController.text = (dollar * this.dollar/peso).toStringAsFixed(2);

  }
  
  void _euroChanged(String text){
    if (text.isEmpty){
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = ((euro * this.euro)).toStringAsFixed(2);
    dollarController.text = (euro * this.euro/dollar).toStringAsFixed(2);
    pesoController.text = (euro * this.euro/peso).toStringAsFixed(2);
  }

  void _pesoChanged(String text){
    if (text.isEmpty){
      _clearAll();
      return;
    }
    double peso = double.parse(text);
    realController.text = ((peso * this.peso)).toStringAsFixed(2);
    dollarController.text = (peso * this.peso/dollar).toStringAsFixed(2);
    euroController.text = (peso * this.peso/euro).toStringAsFixed(2);

  }
  void _clearAll(){
    realController.text = "";
    euroController.text = "";
    dollarController.text = "";
    pesoController.text = "";

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor de Moedas \$",
         style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _clearAll
          )
        ],
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando dados...",
                 style: TextStyle(
                   color: Colors.amber,
                   fontSize: 25.0,
                    
                   )),
              );
            default:
              if(snapshot.hasError){
                return Center(
                child: Text("Erro ao carregar dados :C",
                 style: TextStyle(
                   color: Colors.amber,
                   fontSize: 25.0,
                    
                   )),
              ); 
              }
              else{
                dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                peso = snapshot.data["results"]["currencies"]["ARS"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                      buildTextField("Reais", "R\$ ", realController, _realChanged),
                      Divider(),
                      buildTextField("Dólares", "US\$ ", dollarController, _dollarChanged),
                      Divider(),
                      buildTextField("Euros", "€ ", euroController, _euroChanged),
                      Divider(),
                      buildTextField("Pesos", "ARS\$ ", pesoController, _pesoChanged),

                      
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController controller, Function textChange){
  return TextField( 
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.amber),
              border: OutlineInputBorder(),
              prefixText: prefix

            ),
            style: TextStyle(
              color: Colors.amber,
              fontSize: 25.0,

            ),
            onChanged: textChange,
            keyboardType: TextInputType.number,
          );
}

