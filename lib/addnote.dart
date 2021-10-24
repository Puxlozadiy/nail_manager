import 'package:flutter/cupertino.dart';

import 'main.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  final String data;
  final int page;
  const AddNote({Key? key, required this.data, required this.page}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  late TimeOfDay time;
  late String resultTime;
  late dynamic picked;
  late String text;
  late String type;
  String? name;
  String? nickname;
  String? contactType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    time = TimeOfDay.now();
    text = 'Выбрать время';
    type = 'Маникюр';
    nickname = '';
    contactType = 'Instagram';
    picked = '';
  }


  Future<Null> pickTime (BuildContext context) async{
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
      });
    }
  }

  throwException(context, text){
    showDialog(context: context, builder: (BuildContext context){
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
                  Material(
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 20),
                      maxLines: 1,
                    ),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,),
              Row(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: (){
                          Navigator.pop(context);
                        },
                      child: Text(
                          'Ок',
                          style: TextStyle(fontSize: 20))),
                ],),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String type2;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Добавить запись',), centerTitle: true,),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width-40,
                      height: 50,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Имя'
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.blue)
                      ),
                      child: TextButton(
                          onPressed: () {pickTime(context);},
                          child: Text(text,style: TextStyle(fontSize: 20),)),

                    ),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.blue)
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: DropdownButton<String>(
                                value: type,
                                icon: const Icon(Icons.arrow_drop_down_outlined),
                                iconSize: 24,
                                elevation: 3,
                                borderRadius: BorderRadius.circular(10),
                                style: const TextStyle(color: Colors.blue),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    type = newValue!;
                                  });
                                },
                                items: <String>['Маникюр', 'Педикюр', 'Маникюр + Педикюр',]
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value)
                                  );
                                }).toList(),
                              ),)
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.blue)
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: DropdownButton<String>(
                                  value: contactType,
                                  icon: const Icon(Icons.arrow_drop_down_outlined),
                                  iconSize: 24,
                                  elevation: 16,
                                  borderRadius: BorderRadius.circular(10),
                                  style: const TextStyle(color: Colors.blue),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      contactType = newValue!;
                                    });
                                  },
                                  items: <String>['Instagram', 'Facebook', 'Whatsapp', 'SMS',]
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value)
                                    );
                                  }).toList(),
                                ),)
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30,),
                    Container(
                      width: MediaQuery.of(context).size.width-40,
                      height: 50,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            nickname = value;
                          });
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Псевдоним или номер'
                        ),
                      ),
                    ),
          ],),
              ],
            ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Pages(initPage: widget.page)));
                      },
                      child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
                          height: 40,
                          width: 160,
                          child: Center(child: Text('ОТМЕНА', style: TextStyle(color: Colors.blue),))),
                      style: ButtonStyle(),
                    ),
                    TextButton(
                      onPressed: (){
                        if (name == '' || name == null) throwException(context, 'Имя не указано!');
                        else if (picked == '') throwException(context, 'Время не указано!');
                          else {
                          passToDB(widget.data, name.toString());
                          passToDB(widget.data, resultTime.toString());
                          type2 = type.toString();
                          if (type2.toString().indexOf('+') > 0) {
                            type2 = 'Манкюр \n+ \nПедикюр';
                            passToDB(widget.data, type2.toString());
                          }
                          else
                            passToDB(widget.data, type2.toString());
                            passToDB(widget.data, contactType);
                            passToDB(widget.data, nickname);
                            Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) =>
                                  Pages(initPage: widget.page)));
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.green)),
                          height: 40,
                          width: 160,
                          child: Center(child: Text('ДОБАВИТЬ ЗАПИСЬ', style: TextStyle(color: Colors.green),))),
                      style: ButtonStyle(),
                    ),
                  ],
                )
      ])),
    );
  }
}