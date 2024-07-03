import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'SideDrawer.dart';
import 'Api.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _StatisticsPage();
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key key,
    @required this.text,
    @required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      minimumSize: Size.fromHeight(40),
      primary: Color(0xff007084),
    ),
    child: FittedBox(
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ),
    onPressed: onClicked,
  );
}

class SleepData {
  String message;
  Response response;

  SleepData({this.message, this.response});

  SleepData.fromJson(Map<String, dynamic> json) {
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
  Data data;

  Response({this.data});

  Response.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  Stats stats;
  List<Values> values;

  Data({this.stats, this.values});

  Data.fromJson(Map<String, dynamic> json) {
    stats = json['stats'] != null ? new Stats.fromJson(json['stats']) : null;
    if (json['values'] != null) {
      values = new List<Values>();
      json['values'].forEach((v) {
        values.add(new Values.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stats != null) {
      data['stats'] = this.stats.toJson();
    }
    if (this.values != null) {
      data['values'] = this.values.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stats {
  String active;
  String lay;
  String sleep;

  Stats({this.active, this.lay, this.sleep});

  Stats.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    lay = json['lay'];
    sleep = json['sleep'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['lay'] = this.lay;
    data['sleep'] = this.sleep;
    return data;
  }
}

class Values {
  int dATE;
  int hR;
  String sTATE;
  int vM;

  Values({this.dATE, this.hR, this.sTATE, this.vM});

  Values.fromJson(Map<String, dynamic> json) {
    dATE = json['DATE'];
    hR = json['HR'];
    sTATE = json['STATE'];
    vM = json['VM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DATE'] = this.dATE;
    data['HR'] = this.hR;
    data['STATE'] = this.sTATE;
    data['VM'] = this.vM;
    return data;
  }
}

class Diagram {
  String name;
  int val;
  Color colorval;

  Diagram(this.name, this.val, this.colorval);
}

class LineChart{
  DateTime date;
  int hr;

  LineChart(this.date, this.hr);
}

class _StatisticsPage extends State {
  List values = [];
  List dateList = [];
  List hrList = [];
  List vmList = [];
  List<charts.Series<Diagram,String>> _diagramData = [];
  List<charts.Series<LineChart, DateTime>> _seriesLineData = [];
  List<LineChart> lineDataHR = [];
  DateTimeRange dateRange;


  void loadStatistics() async {
    var response = await API.getSleepStatistics();

    // if (response['message'] != 'success') {
    //
    //   return;
    // }
    final statistics = response['response']['data']['stats'];
    values = response['response']['data']['values'];

    //LINE LISTS

    for(int i = 0; i < values.length; i++){
      var value = values[i];
      dateList.add(value['DATE']);
      hrList.add(value['HR']);
      vmList.add(value['VM']);
    }



    List<LineChart> lineDataHR = [];
    for(int i = 0; i<dateList.length; i++)
      {
        lineDataHR.add(new LineChart(DateTime.fromMillisecondsSinceEpoch(dateList[i]), hrList[i]));
      }

    List<charts.Series<LineChart, DateTime>> _seriesLineDataWork = [];

    _seriesLineDataWork.add(
    charts.Series(
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff009999)),
      id: 'Puls',
      data: lineDataHR,
      domainFn: (LineChart hr, _) => hr.date,
      measureFn: (LineChart hr, _) => hr.hr,
    )
    );

    //DIAGRAM

    var diagData=[
      new Diagram('Aktywność', double.parse(statistics['active']).round(), Color(
          0xffbf57bf)),
      new Diagram('Spoczynek', double.parse(statistics['lay']).round(), Color(
          0xffeab92d)),
      new Diagram('Sen', double.parse(statistics['sleep']).round(), Color(
          0xff56dbbb)),
    ];

    List<charts.Series<Diagram,String>> _diagramDataWork = [];

    _diagramDataWork.add(
      charts.Series(
        domainFn: (Diagram diag, _) => diag.name,
        measureFn: (Diagram diag, _) => diag.val,
        colorFn: (Diagram diag, _) =>
            charts.ColorUtil.fromDartColor(diag.colorval),
        id: 'Sen',
        data: diagData,
        labelAccessorFn: (Diagram row, _) => '${row.val}%',
      ),
    );



    setState(() {
      _diagramData = _diagramDataWork; //update chart
      _seriesLineData = _seriesLineDataWork;
    });

  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _diagramData =  List<charts.Series<Diagram, String>>();
    _seriesLineData = List<charts.Series<LineChart, DateTime>>();
    loadStatistics();
  }



  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 24 * 2)),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDateRange: dateRange ?? initialDateRange,
    );

    if (newDateRange == null) return;

    setState(() => dateRange = newDateRange);
  }

  String getFrom() {
    if (dateRange == null) {
      return 'Od';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateRange.start);
    }
  }

  String getUntil() {
    if (dateRange == null) {
      return 'Do';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateRange.end);
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: SideDrawer(),
          appBar: AppBar(
            title: Text('Statystyki snu', textAlign: TextAlign.center, style: TextStyle(fontSize: 30)),
            backgroundColor: Color(0xff007084),
            foregroundColor: Colors.white,
            shadowColor: Color(0xff65bcc9),
            toolbarHeight: 100,
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Color(0xff65bcc9),
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.calendarDay),
                ),
                Tab(icon: Icon(FontAwesomeIcons.chartPie)),
                Tab(icon: Icon(FontAwesomeIcons.chartLine)),
              ],
            ),

          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Wybór dnia',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: ButtonWidget(
                                  text: getFrom(),
                                  onClicked: () => pickDateRange(context),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.white),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ButtonWidget(
                                  text: getUntil(),
                                  onClicked: () => pickDateRange(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Twój sen',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                        SizedBox(height: 10.0),
                        Row(children: [SizedBox(height: 18.0, width: 18.0, child: DecoratedBox(decoration: BoxDecoration(color: Color(
                            0xffbf57bf)),)),
                            Text("Aktywność", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)]),
                        Row(children: [SizedBox(height: 18.0, width: 18.0, child: DecoratedBox(decoration: BoxDecoration(color: Color(
                            0xff56dbbb)),)),
                          Text("Sen", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)]),
                        Row(children: [SizedBox(height: 18.0, width: 18.0, child: DecoratedBox(decoration: BoxDecoration(color: Color(
                            0xffeab92d)),)),
                          Text("Spoczynek", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)]),
                        Expanded(
                          child: charts.PieChart(
                              _diagramData,
                              animate: true,
                              animationDuration: Duration(seconds: 3),
                              //
                              defaultRenderer: new charts.ArcRendererConfig(
                                  arcWidth: 120,
                                  arcRendererDecorators: [
                                    new charts.ArcLabelDecorator(
                                        labelPosition: charts.ArcLabelPosition.inside
                                        )
                                  ],),
                                  /*behaviors: [
                                    new charts.DatumLegend(
                                      entryTextStyle: charts.TextStyleSpec(
                                          fontSize: 15),
                                    )
                                 ],*/
                              )
                          )

                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Rytm serca',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                        Expanded(
                          child: charts.TimeSeriesChart(
                            _seriesLineData,
                            animationDuration: Duration(seconds: 2),
                            dateTimeFactory: const charts.LocalDateTimeFactory(),
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

