import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// void main(){
//   // Class olarak kullanılmak istenirse MyApp, object olarak instantiate edilmek istenirse sonuna parantez
//   // eklemek yeterlidir.
//     runApp(MyApp());
// }

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Text('Hello!'),
    );
  }



}