
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'addnote.dart';
import 'dates.dart';

class DateList extends StatefulWidget {
  final String data;
  final int page;
  const DateList({Key? key, required this.data, required this.page}) : super(key: key);
  @override
  _DateListState createState() => _DateListState();
}

class _DateListState extends State<DateList> {

  late TimeOfDay time;
  late String resultTime;
  late TimeOfDay picked;
  late String text;
  late DateTime? pickedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    time = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    var tempTitle = widget.data.split('');
    var title = '';

    for (var i = 7; i < tempTitle.length; i++){
      title+=tempTitle[i];
    }

    _deleteNote(name, tempList, counter, context){
        showDialog(context: context, builder: (BuildContext context1) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 4 * 3,
              height: MediaQuery.of(context).size.height / 5,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(
                        'Удалить запись $name?',
                        style: TextStyle(fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,),
                  Row(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context1);
                          },
                          child: Text(
                            'Нет',
                            style: TextStyle(fontSize: 20),
                          )),
                      TextButton(
                          onPressed: (){
                            deleteFromDB(widget.data, counter-5);
                            setState(() {
                              tempList.removeAt(counter-5);
                              tempList.removeAt(counter-5);
                              tempList.removeAt(counter-5);
                              tempList.removeAt(counter-5);
                              tempList.removeAt(counter-5);
                              Navigator.pop(context);
                            });
                          },
                          child: Text(
                              'Да',
                              style: TextStyle(fontSize: 20))),
                    ],),
                ],
              ),
            ),
          );
        });
    }

    Future<Null> pickDate (BuildContext context) async{
      pickedDate = (await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2025),
      ));
      if (pickedDate != null){
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => Pages(initPage: extractDate(pickedDate)),
        ));
      }
    }

    Future<Null> pickTime (BuildContext context, counter) async{
      picked = (await showTimePicker(
          context: context,
          initialTime: time

      )
      )!;
      if (picked != null){
        setState(() {
          time = picked;
          text = 'Выбранное время: ';
          text+=time.hour.toString() + ':';
          resultTime = time.hour.toString() + ':';
          if (time.minute.toString() == '0') {resultTime+='00'; text+='00';}
          else if(time.minute.toString() == '1') {resultTime+='01'; text+='01';}
          else if(time.minute.toString() == '2') {resultTime+='02'; text+='02';}
          else if(time.minute.toString() == '3') {resultTime+='03'; text+='03';}
          else if(time.minute.toString() == '4') {resultTime+='04'; text+='04';}
          else if(time.minute.toString() == '5') {resultTime+='05'; text+='05';}
          else if(time.minute.toString() == '6') {resultTime+='06'; text+='06';}
          else if(time.minute.toString() == '7') {resultTime+='07'; text+='07';}
          else if(time.minute.toString() == '8') {resultTime+='08'; text+='08';}
          else if(time.minute.toString() == '9') {resultTime+='09'; text+='09';}
          else {resultTime+=time.minute.toString(); text+=time.minute.toString();}
          replaceInDB(widget.data, counter, resultTime);
        });
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(onPressed: (){
              pickDate(context);
            }, icon: Icon(Icons.calendar_today)),
          ]
        ),
        body: FutureBuilder(
              future: getFromDB(widget.data),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData){
                  if (snapshot.data.isEmpty) {
                    return Column(
                      children: [
                        TextButton(onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddNote(data: widget.data, page: widget.page,)));
                        }, child: Container(
                          height: 40,
                          width: 3000,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.green)),
                          child: Center(child: Text('Добавить запись', style: TextStyle(color: Colors.green),)),),
                        ),
                        const Center(child: Text('Нет записей!'))],
                    );
                  }
                }
                if (snapshot.hasData) {
                  var tempList = snapshot.data;
                  tempList = sortTime(tempList);
                  int notesCount = tempList.length ~/ 5;
                  var notesIndexses = [5, 10, 15, 20];
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      if (notesCount > index){
                        var iconPath;
                        var name = tempList[notesIndexses[index]-5];
                        if (name.length > 11){
                          var tempName = name.split('');
                          name = '';
                          for (var i = 0; i < 11; i++){
                            name+=tempName[i];
                          }
                          name+='...';
                        }
                        switch(tempList[notesIndexses[index]-2]){
                          case 'Facebook':
                            iconPath = 'icons/fcbkicon.png';
                            break;
                          case 'Instagram':
                            iconPath = 'icons/insticon.png';
                            break;
                          case 'Whatsapp':
                            iconPath = 'icons/wtspicon.png';
                            break;
                          case 'SMS':
                            iconPath = 'icons/smsicon.png';
                            break;
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTapUp: (TapUpDetails details) {
                              var posList = onTapUp(details);
                              showMenu(context: context,
                                  position: RelativeRect.fromLTRB(posList[0], posList[1], posList[0], 0),
                                  items: [
                                    PopupMenuItem(
                                        child: TextButton(child: Text('Изменить время',),
                                        onPressed: (){
                                          Navigator.pop(context);
                                          pickTime(context, notesIndexses[index]-4);
                                        },)),
                                    PopupMenuItem(
                                        child: TextButton(child: Text('Переместить вверх',),
                                          onPressed: (){
                                            Navigator.pop(context);
                                            setState(() {
                                              replaceNoteUp(widget.data, notesIndexses[index]);
                                            });
                                          },)),
                                    PopupMenuItem(
                                        child: TextButton(child: Text('Переместить вниз',),
                                          onPressed: (){
                                            Navigator.pop(context);
                                            setState(() {
                                              replaceNoteDown(widget.data, notesIndexses[index]);
                                            });
                                          },)),
                                    PopupMenuItem(
                                        child: TextButton(child: Text('Удалить',),
                                          onPressed: (){
                                            Navigator.pop(context);
                                            _deleteNote(name, tempList, notesIndexses[index], context);
                                          },)),
                              ],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(color: Colors.blue)
                                  ));
                            },

                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 100,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Stack(
                                children: [
                                  Positioned(child: Text(name, style: TextStyle(fontSize: 24),), top: 0, left: 0,),
                                  Positioned(child: Text(tempList[notesIndexses[index]-4], style: TextStyle(fontSize: 20),), top: 0, right: 0,),
                                  Positioned(child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(tempList[notesIndexses[index]-3], style: TextStyle(fontSize: 16, height: 0.8), textAlign: TextAlign.center,),
                                      ),
                                    ],
                                  ),),
                                  Positioned(
                                    bottom: 0,
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        child: Image(image: AssetImage(iconPath),))),
                                  Positioned(
                                    bottom: 5,
                                      left: 30,
                                      child: Text(tempList[notesIndexses[index]-1]))
                                ],
                              ),
                            ),
                          ),
                          ));
                      }
                      else {
                        return TextButton(onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddNote(data: widget.data, page: widget.page,)));
                        }, child: Container(
                          height: 40,
                          width: 3000,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.green)),
                          child: Center(child: Text('Добавить запись', style: TextStyle(color: Colors.green),)),),
                        );
                      }
                    },
                    itemCount: notesCount + 1,
                  );
                }
                return Center(child: Text('Нет записей!'));
              }
          ),
    );
  }
}


onTapUp(TapUpDetails details) {
  var x = details.globalPosition.dx;
  var y = details.globalPosition.dy;
  var result = [x, y];
  return result;
}

extractDate(DateTime? date){
  dynamic tempStr;
  dynamic tempDayInt;
  dynamic monthInt;
  for (var i = 0; i < dates.length; i++){
    tempStr = dates[i].split('');
    String tempYearInt = tempStr[0] + tempStr[1] + tempStr[2] + tempStr[3];
    tempDayInt = int.parse(tempStr[7]).toString() + int.parse(tempStr[8]).toString();
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

    if (date?.day == int.parse(tempDayInt) && date?.month == monthInt && date?.year == int.parse(tempYearInt)){
      return i;
    }
  }
}


sortTime(list) {
  var tempTimes = [];
  var tempList1 = <String>[];
  var counter = 0;
  for (var i = 1; i < list.length; i += 5) {
    try {
      var tempStr = list[i].split('');
      var tempHours = tempStr[0] + tempStr[1];
      var tempMinutes = tempStr[3] + tempStr[4];
      DateTime tempTime =
      DateTime(2021, 1, 1, int.parse(tempHours), int.parse(tempMinutes));
      counter++;
      tempTimes.add(tempTime.toString() + ' ' + counter.toString());
    } catch (e) {}
  }
  tempTimes.sort((a, b) => a.compareTo(b));
  for (var i = 0; i < list.length ~/ 5; i++) {
    try {
      var listNum = int.parse(tempTimes[i].split('')[24]);
      listNum *= 5;
      tempList1.add(list[listNum - 5]);
      tempList1.add(list[listNum - 4]);
      tempList1.add(list[listNum - 3]);
      tempList1.add(list[listNum - 2]);
      tempList1.add(list[listNum - 1]);
    } catch (e) {}
  }

  return tempList1;
}

