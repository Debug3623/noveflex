import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartScreen extends StatefulWidget {
  const PieChartScreen({Key? key}) : super(key: key);

  @override
  State<PieChartScreen> createState() => _PieChartScreenState();
}

class _PieChartScreenState extends State<PieChartScreen> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [
      _ChartData('1m', 12),
      _ChartData('2m', 15),
      _ChartData('3m', 30),
      _ChartData('4m', 35),
      _ChartData('5m', 14),
      _ChartData('6m', 40),
      _ChartData('7m', 70),
      _ChartData('8m', 50),
      _ChartData('9m', 4),
      _ChartData('10', 65),
      _ChartData('11m', 10),
      _ChartData('12m', 70)
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color(0xffebf5f9),
        appBar: AppBar(
          backgroundColor: const Color(0xffebf5f9),
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black54,
              )),
        ),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.all(8.0),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              height: _height * 0.4,
              child: SfCartesianChart(
                  borderColor: Colors.blue,
                  title: ChartTitle(text: "Subscribers and Views Analysis"),
                  backgroundColor: Color(0xffffffff),
                  primaryXAxis: CategoryAxis(
                      title: AxisTitle(text: "Views and Subscribers")),
                  primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: 100,
                      interval: 10,
                      title: AxisTitle(text: "Monthly %")),
                  tooltipBehavior: _tooltip,
                  series: <ChartSeries<_ChartData, String>>[
                    ColumnSeries<_ChartData, String>(
                        dataSource: data,
                        xValueMapper: (_ChartData data, _) => data.x,
                        yValueMapper: (_ChartData data, _) => data.y,
                        name: 'Gold',
                        color: Color(0xff3a6c83))
                  ]),
            ),
            SizedBox(
              height: _height * 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: _width*0.45,
                  height: _height*0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: const Color(0xffffffff)),
                  child: Padding(
                    padding:  EdgeInsets.only(left: _width*0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.person_outline,color:  const Color(0xff3a6c83),),
                        Row(
                          children: [
                            Text(
                                "790",
                                style: const TextStyle(
                                    color:  const Color(0xff3a6c83),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Alexandria",
                                    fontStyle:  FontStyle.normal,
                                    fontSize: 23.0
                                ),
                                textAlign: TextAlign.left
                            ),
                            SizedBox(width: _width*0.1,),
                            Text(
                                "+%35.4",
                                style: const TextStyle(
                                    color:  const Color(0xff00bb23),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Alexandria",
                                    fontStyle:  FontStyle.normal,
                                    fontSize: 13.0
                                ),
                                textAlign: TextAlign.left
                            )
                          ],
                        ),
                        Text("Followers",
                            style: const TextStyle(
                                color: const Color(0xff1e2022),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Alexandria",
                                fontStyle: FontStyle.normal,
                                fontSize: 13.0),
                            textAlign: TextAlign.left)
                      ],
                    ),
                  ),
                ),
                Container(
                  width: _width*0.45,
                  height: _height*0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: const Color(0xffffffff)),
                  child: Padding(
                    padding:  EdgeInsets.only(left: _width*0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.auto_graph_outlined,color:  const Color(0xff3a6c83),),
                        Row(
                          children: [
                            Text(
                              "3465",
                              style: const TextStyle(
                                  color:  const Color(0xff3a6c83),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Alexandria",
                                  fontStyle:  FontStyle.normal,
                                  fontSize: 23.0
                              ),
                              textAlign: TextAlign.left),
                            SizedBox(width: _width*0.1,),
                            Text(
                              "-%3.4",
                              style: const TextStyle(
                                  color:  const Color(0xffd10606),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Alexandria",
                                  fontStyle:  FontStyle.normal,
                                  fontSize: 13.0
                              ),
                              textAlign: TextAlign.left)

                              ],
                        ),
                        Text("Views",
                            style: const TextStyle(
                                color: const Color(0xff1e2022),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Alexandria",
                                fontStyle: FontStyle.normal,
                                fontSize: 13.0),
                            textAlign: TextAlign.left)
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
