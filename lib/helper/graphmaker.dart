import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:coronaupdate/helper/chartdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Graph{
  final List<charts.Series> seriesList;
  final bool animate;
  List<LineSeries> lineData= List<LineSeries>();
  LineSeries gData= LineSeries();

  factory Graph.withSampleData() {
    return new Graph(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  Graph(this.seriesList, this.animate);
  Future<void> getGData() async{
    String url ="https://pomber.github.io/covid19/timeseries.json";
    var response= await http.get(url);
    var jsonData=jsonDecode(response.body);
      jsonData['India'].forEach((element){
        gData  = LineSeries(date:element['date'], cases:element['confirmed'] ) ;
        lineData.add(gData);




      });}

  static List<charts.Series<LineSeries, int>> _createSampleData() {
    final india = [ lineData.forEach((element){
      LineSeries(element.date, element.cases);

    })
    ];
  }


}
class StackedAreaLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  Graph graph= Graph();
  graph.getGData();


  StackedAreaLineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory StackedAreaLineChart.withSampleData() {
    return new StackedAreaLineChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList,
        defaultRenderer:
        new charts.LineRendererConfig(includeArea: true, stacked: true),
        animate: animate);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LineSeries, int>> _createSampleData() {
    final india = [ graph.lineData.forEach((element){
      LineSeries(element.date, element.cases);

    })
    ];
  }
}
