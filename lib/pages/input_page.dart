import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial/modules/item_table.dart';
import 'package:tutorial/services/table_input.dart';

class InputPage extends StatelessWidget {
  const InputPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Page'),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
            children: [
              MyInputField(title: 'Name: ' , textEditingInput: nameController),
              const SizedBox(height: 20,),
              MyInputField(title: 'Age: ' , textEditingInput: ageController),
              const SizedBox(height: 40,),
              InkWell(
                onTap: (){
                  try{
                    Provider.of<TableInput>(context,listen: false).addItemTable(
                    ItemTable(
                      name: nameController.text, 
                      age: int.parse(ageController.text)
                    )
                  );
                  nameController.clear();
                  ageController.clear();
                  }
                  catch(e){
                    nameController.clear();
                    ageController.clear();
                  }
                },
                child: Container(
                  height: 50,
                  width: 120,
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
                  alignment: Alignment.center,
                  child: const Text('enter new user', style: TextStyle(color: Colors.white),),
                ),
              ),
              const SizedBox(height: 40,),
              SizedBox(
                height: MediaQuery.sizeOf(context).height*0.55,
                child: Consumer<TableInput>(builder: (context, value, child) {
                  return ListView.builder(
                    itemCount: value.tableList.length,
                    itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${value.tableList[index].name}, ${value.tableList[index].age}'),
                      trailing: IconButton(icon: 
                      const Icon(Icons.delete_forever_rounded), 
                      onPressed: () => value.removeItemTable(value.tableList[index]),)
                    );
                  },);
                },)
              )
            ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyInputField extends StatelessWidget {
  final String title;
  final TextEditingController textEditingInput;
  const MyInputField({super.key, required this.title, required this.textEditingInput});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        Expanded(child: TextField(controller: textEditingInput,))
      ],
    );
  }
}