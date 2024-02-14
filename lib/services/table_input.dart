import 'package:flutter/material.dart';
import 'package:tutorial/modules/item_table.dart';

class TableInput extends ChangeNotifier{
  List<ItemTable> tableList = [
    ItemTable(name: 'Eloi', age: 22),
    ItemTable(name: 'Quimet', age: 87),
  ];
  List<ItemTable> getTable(){
    return tableList;
  }

  void addItemTable(ItemTable item){
    tableList.add(item);
    notifyListeners();
  }

  void removeItemTable(ItemTable item){
    tableList.remove(item);
    notifyListeners();
  }
}