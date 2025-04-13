import 'package:flutter/material.dart';
import 'log.dart';

class SplashScreen  extends StatefulWidget{
  @override

  _SplashScreenState createState()=> _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen>{

void initState(){
  super.initState();

  Future.delayed(Duration(seconds:3), (){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder:(context)=>Log())
    );

  });
  }
@override
Widget build(BuildContext context){
  return Scaffold(
    body:Center(child: Row(children: [
      InkWell(
        onTap:(){},
        child:Card(
          color:Colors.blue,
          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(16)),
          child:Padding(padding:const EdgeInsets.all(16),
          child:Text('SH',style:TextStyle(fontSize:20, fontWeight:FontWeight.bold))
          )
        )
      ),SizedBox(width:10),
      Text('Swine-Health', style:TextStyle(fontSize:25, color:Colors.blue, fontWeight:FontWeight.bold))
    ],),)
  );
}
}
