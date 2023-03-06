import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novelflex/localization/Language/languages.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

import '../Provider/UserProvider.dart';
import '../Utils/ApiUtils.dart';
import '../Utils/Constants.dart';
import '../Utils/toast.dart';

class PieChartScreen extends StatefulWidget {
  const PieChartScreen({Key? key}) : super(key: key);

  @override
  State<PieChartScreen> createState() => _PieChartScreenState();
}

class _PieChartScreenState extends State<PieChartScreen> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  bool _isLoading = false;
  bool _isInternetConnected = true;
  var Followers;
  var gifts;

  @override
  void initState() {
    _checkInternetConnection();

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
      body: _isInternetConnected
          ? _isLoading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      height: _height * 0.4,
                      child: SfCartesianChart(
                          borderColor: Colors.blue,
                          title: ChartTitle(
                              text: "Followers and Gifts Analysis"),
                          backgroundColor: Color(0xffffffff),
                          primaryXAxis: CategoryAxis(
                              title: AxisTitle(text: "Gifts and Followers")),
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
                          width: _width * 0.45,
                          height: _height * 0.15,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: const Color(0xffffffff)),
                          child: Padding(
                            padding: EdgeInsets.only(left: _width * 0.05),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  color: const Color(0xff3a6c83),
                                ),
                                Row(
                                  children: [
                                    Text(Followers.toString(),
                                        style: const TextStyle(
                                            color: const Color(0xff3a6c83),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Alexandria",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 23.0),
                                        textAlign: TextAlign.left),
                                    SizedBox(
                                      width: _width * 0.1,
                                    ),
                                    Text("+%${Followers/100*120}",
                                        style: const TextStyle(
                                            color: const Color(0xff00bb23),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Alexandria",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 13.0),
                                        textAlign: TextAlign.left)
                                  ],
                                ),
                                Text(Languages.of(context)!.followers,
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
                          width: _width * 0.45,
                          height: _height * 0.15,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: const Color(0xffffffff)),
                          child: Padding(
                            padding: EdgeInsets.only(left: _width * 0.05),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.auto_graph_outlined,
                                  color: const Color(0xff3a6c83),
                                ),
                                Row(
                                  children: [
                                    Text(gifts.toString(),
                                        style: const TextStyle(
                                            color: const Color(0xff3a6c83),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Alexandria",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 23.0),
                                        textAlign: TextAlign.left),
                                    SizedBox(
                                      width: _width * 0.1,
                                    ),
                                    Text("+%${gifts/50*100}",
                                        style: const TextStyle(
                                            color: const Color(0xffd10606),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Alexandria",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 13.0),
                                        textAlign: TextAlign.left)
                                  ],
                                ),
                                Text(Languages.of(context)!.gift,
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
                )
          : Center(
              child: Constants.InternetNotConnected(_height * 0.03),
            ),
    );
  }

  Future TotalFollowers() async {
    final response =
        await http.get(Uri.parse(ApiUtils.TOTAL_FOLLOWERS_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('user_payment_response${response.body}');
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        setState(() {
          Followers = jsonData1['totalFollower'];
        });
        TotalGifts();
      } else {
        ToastConstant.showToast(context, jsonData1['success'].toString());
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future TotalGifts() async {
    final response =
        await http.get(Uri.parse(ApiUtils.TOTAL_GIFTS_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('user_payment_response${response.body}');
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        setState(() {
          gifts = jsonData1['totalAuthorGifts'];
          _isLoading = false;
        });
      } else {
        ToastConstant.showToast(context, jsonData1['success'].toString());
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future _checkInternetConnection() async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      Constants.showToastBlack(context, "Internet not connected");
      if (this.mounted) {
        setState(() {
          _isLoading = false;
          _isInternetConnected = false;
        });
      }
    } else {
      TotalFollowers();
    }
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
