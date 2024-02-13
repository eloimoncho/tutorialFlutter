import 'package:flutter/material.dart';
import 'package:tutorial/components/my_menu_button.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menu', style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.cyan,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyMenuButton(title: 'First', onTap: (){}),
              const SizedBox(height: 40,),
              MyMenuButton(title: 'Second', onTap: (){}),
              const SizedBox(height: 40,),
              MyMenuButton(title: 'Third', onTap: (){})
            ],
          ),
        ),
      ),
    );
  }
}