import 'package:flutter/material.dart';

class ParametersPage extends StatefulWidget {
  const ParametersPage({super.key});

  @override
  State<ParametersPage> createState() => _ParametersPageState();
}

class _ParametersPageState extends State<ParametersPage> {
  List<String> options = ['Madrid', 'Barcelona', 'Bilbao', 'Sevilla'];
  late String currentOption;
  bool? isUno=false, isDos=false, isTres=false, isCuatro=false;
  double sliderValue = 0.0; 

  @override
  void initState() {
    super.initState();
    currentOption = options[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan, 
        title: const Text('Parameters'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Center(child: Text('Radio Group')),
                ListTile(
                  title: const Text('Madrid'),
                  leading: Radio(
                    value: options[0], 
                    groupValue: currentOption, 
                    onChanged: (value) {
                      setState(() {
                        currentOption = value.toString();
                      });
                  },),
                ),
                ListTile(
                  title: const Text('Barcelona'),
                  leading: Radio(
                    value: options[1], 
                    groupValue: currentOption, 
                    onChanged: (value) {
                      setState(() {
                        currentOption = value.toString();
                      });
                  },),
                ),
                ListTile(
                  title: const Text('Bilbao'),
                  leading: Radio(
                    value: options[2], 
                    groupValue: currentOption, 
                    onChanged: (value) {
                      setState(() {
                        currentOption = value.toString();
                      });
                  },),
                ),
                ListTile(
                  title: const Text('Sevilla'),
                  leading: Radio(
                    value: options[3], 
                    groupValue: currentOption, 
                    onChanged: (value) {
                      setState(() {
                        currentOption = value.toString();
                      });
                  },),
                ),
                const SizedBox(height: 20,),
                const Center(child: Text('CheckBox Group'),),
                CheckboxListTile(
                  value: isUno, 
                  title: const Text('Uno'),
                  onChanged: (value) {
                  setState(() {
                    isUno = value;
                  });
                },),
                CheckboxListTile(
                  value: isDos, 
                  title: const Text('Dos'),
                  onChanged: (value) {
                  setState(() {
                    isDos = value;
                  });
                },),
                CheckboxListTile(
                  value: isTres, 
                  title: const Text('Tres'),
                  onChanged: (value) {
                  setState(() {
                    isTres = value;
                  });
                },),
                CheckboxListTile(
                  value: isCuatro, 
                  title: const Text('Cuatro'),
                  onChanged: (value) {
                  setState(() {
                    isCuatro = value;
                  });
                },),
                const SizedBox(height: 20,),
                const Center(child: Text('Slider Bar')),
                Slider(
                  divisions: 100,
                  min: 0,
                  max: 100,
                  label: sliderValue.toStringAsFixed(1),
                  value: sliderValue, 
                  onChanged: (value) {
                  setState(() {
                    sliderValue = value.roundToDouble();
                  });
                },),
                const SizedBox(height: 30,),
                InkWell(
                  onTap: () {
                    List<String> checkBoxResults = [];
                    if(isUno!){checkBoxResults.add('Uno');}
                    if(isDos!){checkBoxResults.add('Dos');}
                    if(isTres!){checkBoxResults.add('Tres');}
                    if(isCuatro!){checkBoxResults.add('Cuatro');}
                    String message = 'Ciudad:  $currentOption, CheckBox: $checkBoxResults, SliderBar: $sliderValue';
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Mensaje'),
                          content: Text(message),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Cierra el diálogo
                              },
                              child: Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text('Enviar'),
                  ),
                )
            ]),
          )
        ,),
      )
    );
  }
}