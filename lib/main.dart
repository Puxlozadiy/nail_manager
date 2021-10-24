import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addnote.dart';
import 'dates.dart';
import 'datelist.dart';

void main() async{
  runApp(MaterialApp(
    initialRoute: '/',
      routes: <String, WidgetBuilder>{
    '/': (BuildContext context) => Pages(initPage: getInitPage(dates),)
    }
  ));
  SharedPreferences prefs = await SharedPreferences.getInstance();
}

bool initialized = false;

getInitPage(List<String> dates){
  var todayDate = DateTime.now();
  dynamic tempStr;
  dynamic tempDayInt;
  dynamic monthInt;
  for (var i = 0; i < dates.length; i++){
    tempStr = dates[i].split('');
    String tempYearInt = tempStr[0] + tempStr[1] + tempStr[2] + tempStr[3];
    tempDayInt = tempStr[7] + tempStr[8];
    if (tempStr[10] == 'Я') monthInt = 1;
    else if (tempStr[10] == 'Ф') monthInt = 2;
    else if (tempStr[10] == 'М') monthInt = 3;
    else if (tempStr[10] == 'А' && tempStr[11] == 'п') monthInt = 4;
    else if (tempStr[10] == 'М') monthInt = 5;
    else if (tempStr[10] == 'И' && tempStr[12] == 'н') monthInt = 6;
    else if (tempStr[10] == 'И' && tempStr[12] == 'л') monthInt = 7;
    else if (tempStr[10] == 'А' && tempStr[11] == 'в') monthInt = 8;
    else if (tempStr[10] == 'С') monthInt = 9;
    else if (tempStr[10] == 'О') monthInt = 10;
    else if (tempStr[10] == 'Н') monthInt = 11;
    else if (tempStr[10] == 'Д') monthInt = 12;

    if (todayDate.day == int.parse(tempDayInt) && todayDate.month == monthInt && todayDate.year == int.parse(tempYearInt)){
      return i;
    }
  }
  return 1;
}

passToDB(key, data) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var tempData = prefs.getStringList(key) ?? [];
  tempData.add(data);
  prefs.setStringList(key, tempData);
}

getFromDB(key) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var tempData = prefs.getStringList(key) ?? [];
  return tempData;
}

deleteFromDB(key, pos) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var tempData = prefs.getStringList(key) ?? [];
  tempData.removeAt(pos);
  tempData.removeAt(pos);
  tempData.removeAt(pos);
  tempData.removeAt(pos);
  tempData.removeAt(pos);
  prefs.setStringList(key, tempData);
}

replaceInDB(key, pos, item) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var tempData = prefs.getStringList(key) ?? [];
  tempData.removeAt(pos);
  tempData.replaceRange(pos, pos + 1, [item, tempData[pos]]);
  prefs.setStringList(key, tempData);
}

replaceNoteUp(key, pos) async{
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tempData = prefs.getStringList(key) ?? [];
    var tempList1 = [tempData[pos - 10], tempData[pos - 4], tempData[pos - 8], tempData[pos - 7], tempData[pos - 6]
    ];
    var tempList2 = [tempData[pos - 5], tempData[pos - 9], tempData[pos - 3], tempData[pos - 2], tempData[pos - 1]
    ];
    tempData.replaceRange(pos - 10, pos - 5, tempList2);
    tempData.replaceRange(pos - 5, pos, tempList1);
    prefs.setStringList(key, tempData);
  }
  catch(e){}
}

replaceNoteDown(key, pos) async{
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tempData = prefs.getStringList(key) ?? [];
    var tempList1 = [tempData[pos - 5], tempData[pos + 1], tempData[pos - 3], tempData[pos - 2], tempData[pos - 1]
    ];
    var tempList2 = [tempData[pos], tempData[pos - 4], tempData[pos + 2], tempData[pos + 3], tempData[pos + 4]
    ];
    tempData.replaceRange(pos - 5, pos, tempList2);
    tempData.replaceRange(pos, pos + 5, tempList1);
    prefs.setStringList(key, tempData);
  }
  catch (e){}
}

class Pages extends StatelessWidget {
  final initPage;
  const Pages({Key? key, required this.initPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    for(var i = 0; i < dates.length; i++){
      widgetList.add(DateList(data: dates[i], page: i,));
    }
    return PageView(
      controller: PageController(initialPage: initPage),
      children: widgetList,
    );
  }
}
