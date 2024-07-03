import 'dart:convert';
import 'scrollable_widget.dart';
import 'package:flutter/material.dart';
import 'Api.dart';
import 'SideDrawer.dart';

class ChallengesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ChallengesPage();
}

class ChallengesData {
  String message;
  Response response;

  ChallengesData({this.message, this.response});

  ChallengesData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  List<Data> data;

  Response({this.data});

  Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int challengeId;
  String challengeName;
  String challengeDescription;
  String validFromDatetime;
  String validToDatetime;
  String createdDatetime;
  int createdByUserId;

  Data(
      {this.challengeId,
        this.challengeName,
        this.challengeDescription,
        this.validFromDatetime,
        this.validToDatetime,
        this.createdDatetime,
        this.createdByUserId});

  Data.fromJson(Map<String, dynamic> json) {
    challengeId = json['challenge_id'];
    challengeName = json['challenge_name'];
    challengeDescription = json['challenge_description'];
    validFromDatetime = json['valid_from_datetime'];
    validToDatetime = json['valid_to_datetime'];
    createdDatetime = json['created_datetime'];
    createdByUserId = json['created_by_user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['challenge_id'] = this.challengeId;
    data['challenge_name'] = this.challengeName;
    data['challenge_description'] = this.challengeDescription;
    data['valid_from_datetime'] = this.validFromDatetime;
    data['valid_to_datetime'] = this.validToDatetime;
    data['created_datetime'] = this.createdDatetime;
    data['created_by_user_id'] = this.createdByUserId;
    return data;
  }
}

class Challenge {
  final int challenge_id;
  final String challenge_name;
  final String challenge_description;
  final String valid_from_datetime;
  final String valid_to_datetime;

  Challenge({this.challenge_id, this.challenge_name, this.challenge_description,
      this.valid_from_datetime, this.valid_to_datetime});
}


class _ChallengesPage extends State {
  List<Challenge> rows = [];
  List challs = [];
  List<Challenge> selectedChallenges = [];
  void loadChallanges() async {
    var response = await API.getChallenges();

    challs = response['response']['data'];
    List<Challenge> challengesListWork = [];
    for(int i = 0; i<challs.length; i++)
      {
        var chall = challs[i];
        challengesListWork.add(Challenge(challenge_id: chall['challenge_id'],
            challenge_name: chall['challenge_name'],
            challenge_description: chall['challenge_description'],
            valid_from_datetime: chall['valid_from_datetime'].substring(0, 10),
            valid_to_datetime: chall['valid_to_datetime'].substring(0, 10)));

      }

    setState(() {
      rows = challengesListWork;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadChallanges();
  }


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text("Wyzwania", textAlign: TextAlign.center, style: TextStyle(fontSize: 30),),
      backgroundColor: Color(0xff007084),
      foregroundColor: Colors.white,
      shadowColor: Color(0xff65bcc9),
      toolbarHeight: 100,
      centerTitle: true,
    ),
    drawer: SideDrawer(),
    body: rows.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Column(
      children: [
        Expanded(child: ScrollableWidget(child: buildDataTable())),
        buildSubmit(),
      ],
    ),
  );

  Widget buildDataTable(){
      final columns = ['Numer', 'Nazwa', 'Opis', 'Od', 'Do'];

      return DataTable(
          onSelectAll: (isSelectedAll) {
            setState(() => selectedChallenges = isSelectedAll ? rows : []);

            showSnackBar(context, 'All Selected: $isSelectedAll');
          },
        columns: getColumns(columns),
        rows: getRows(rows)
      );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
      label: Expanded(
          child: Text(column,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Color(0xff007084)))
      )
      ))
      .toList();

  List<DataRow> getRows(List<Challenge> rows) => rows
      .map((Challenge row) => DataRow(
      selected: selectedChallenges.contains(row),
      onSelectChanged: (isSelected) => setState(() {
        final isAdding = isSelected != null && isSelected;

        isAdding
            ? selectedChallenges.add(row)
            : selectedChallenges.remove(row);
      }),
      cells: [
        DataCell(Container(
          padding: EdgeInsets.all(10),
          width: 100,
          child: Text(row.challenge_id.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),)

        )),
        DataCell(Container(
          width: 300,
          //height: 100,
          padding: EdgeInsets.all(10),
          child: Text(row.challenge_name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),),
        )),
        DataCell(Container(
          width: 500,
          //height: 500,
          padding: EdgeInsets.all(10),
          child: Text(row.challenge_description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),),
        )),
        DataCell(Container(
          width: 150,
          padding: EdgeInsets.all(10),
          child: Text(row.valid_from_datetime,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),),
        )),
        DataCell(Container(
          width: 150,
          padding: EdgeInsets.all(10),
          child: Text(row.valid_to_datetime,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),),
        )),
      ]
      ))
      .toList();

  Widget buildSubmit() => Container(
    width: double.infinity,
    padding: EdgeInsets.all(12),
   // color: Colors.black,
    child: ElevatedButton(
      style: (ElevatedButton.styleFrom(
      shape: StadiumBorder(),
  minimumSize: Size.fromHeight(40),
        primary: Color(0xff007084),
        onSurface: Color(0xff007084),
        shadowColor: Color(0xff65bcc9)
  )),
      child: Text('Wybrano ${selectedChallenges.length} wyzwań',),
      onPressed: () {
        final names =
        selectedChallenges.map((row) => row.challenge_id).join(', ');

        showSnackBar(context, 'Podjęto wyzwania o numerach: $names ');
      },
  )
  );

  static showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text), backgroundColor: Color(0xff007084),);

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}