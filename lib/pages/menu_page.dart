import 'package:flutter/material.dart';
import 'package:tutorial/components/my_menu_button.dart';
import 'package:tutorial/pages/input_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {

    Future callAlertDialog(){
      return showDialog(context: context, 
      builder: (context){
        return  AlertDialog(
          title: const Text('Salir'),
          content: const Text('Quieres salir de la aplicación?'),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text('NO')),
            TextButton(onPressed: (){
              Navigator.pop(context);
              Navigator.pop(context);
            }, child: const Text('Sí')),
          ]
        );
        },
      );

    }


    return Scaffold(
      appBar: AppBar(title: const Text('Menu', style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.cyan,
      automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyMenuButton(title: 'Alert Dialog', onTap: callAlertDialog),
              const SizedBox(height: 40,),
              MyMenuButton(title: 'Input', onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const InputPage(),),);} ),
              const SizedBox(height: 40,),
              MyMenuButton(title: 'Get Value', onTap: (){}),
              const SizedBox(height: 40,),
              MyMenuButton(title: 'Parameters', onTap: (){}),
              const SizedBox(height: 40,),
              MyMenuButton(title: 'Video', onTap: (){}),
              const SizedBox(height: 40,),
              MyMenuButton(title: 'Map', onTap: (){}),
            ],
          ),
        ),
      ),
    );
  }
}