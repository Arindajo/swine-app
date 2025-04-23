import 'package:flutter/material.dart';
import 'dash.dart';
import 'animals.dart';
import 'reports-alerts.dart';
import 'new.dart';
import 'chat_screen.dart';
import 'reportpage.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState()=> _HomeState();
}
class _HomeState extends State<Home>{
  int _selectedIndex = 0;

  final List<Widget> _pages =[
    Dashboard(),
    PigsPage(),
    ChatScreen(),
    //ActivityGaugePage(),
    ReportsPage()
    // Center(child:Text('Home')),
    // Center(child:Text('Search'))
  ];
  void _onItemTapped(int index){
    setState((){
   _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:_pages[_selectedIndex],
        
          
            bottomNavigationBar:BottomNavigationBar(
              currentIndex:_selectedIndex,
              onTap:_onItemTapped,
              items:[
                BottomNavigationBarItem(
                  icon:Icon(Icons.dashboard,color:Colors.blue,),
                  label:'Dashboard'
                ),
                BottomNavigationBarItem(
                  icon:Icon(Icons.pets,color:Colors.blue),
                  label:"Animals"
                  
                ),
                  BottomNavigationBarItem(
                  icon:Icon(Icons.analytics,color:Colors.blue),
                  label:'Monitor'
                ),
                
                  BottomNavigationBarItem(
                  icon:Icon(Icons.message,color:Colors.blue),
                  label:'Chat'
                  ),
                BottomNavigationBarItem(
                  icon:Icon(Icons.report,color:Colors.blue),
                  label:'Reports'
                )
              ]
            )
          
        
      
    );
  }
}