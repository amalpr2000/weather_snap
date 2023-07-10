import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:weathersnap/constants/constants.dart' as k;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoaded = true;
  String weather = 'Clouds';
  String bgimg = 'sunny.jpg';
  num temp = 0;
  num pressure = 0;
  num humidity = 0;
  num cloudCover = 0;
  String cityName = 'Kochi';
  bool search = false;
  TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchfromDevice();
    // getCurrentLocation();
  }

  Future fetchfromDevice() async {
    bool status = await requestPermission();
    if (status) {
      getCurrentLocation();
    }
  }

  Future requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // title: Text(''),
        title: search
            ? Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.065,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: TextFormField(
                  onFieldSubmitted: (String s) {
                    setState(() {
                      cityName = s;
                      getCityWeather(cityName);
                      isLoaded = false;
                      search = false;
                      cityController.clear();
                    });
                  },
                  controller: cityController,
                  cursorColor: Colors.white,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      hintText: 'Search City',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.8)),
                      prefixIcon: Icon(
                        Icons.location_on_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                      border: InputBorder.none),
                ),
              )
            : InkWell(
                onTap: () {
                  setState(() {
                    search = true;
                  });
                },
                child: Icon(
                  Icons.search_rounded,
                  size: 30,
                ),
              ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Visibility(
        visible: isLoaded,
        child: Container(
          // padding: EdgeInsets.only(top: 30),
          child: Stack(
            children: [
              Image.asset(
                'assets/$bgimg',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
              Container(
                decoration: BoxDecoration(color: Colors.black38),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 90,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    cityName,
                                    style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${temp.toStringAsFixed(1)}℃',
                                style: TextStyle(
                                    fontSize: 85,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.nights_stay_outlined,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Hello',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 40),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white30)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Wind',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    '10',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    'km/h',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        height: 5,
                                        width: 35,
                                        color: Colors.white,
                                      ),
                                      Container(
                                        height: 5,
                                        width: 5,
                                        color: Colors.greenAccent,
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Humidity',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    '${humidity.toStringAsFixed(1)}hPA',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    '%',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        height: 5,
                                        width: 35,
                                        color: Colors.white,
                                      ),
                                      Container(
                                        height: 5,
                                        width: 5,
                                        color: Colors.redAccent,
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rain',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    '10',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    '%',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        height: 5,
                                        width: 35,
                                        color: Colors.white,
                                      ),
                                      Container(
                                        height: 5,
                                        width: 5,
                                        color: Colors.redAccent,
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
            // child: Column(
            //   children: [
            // SizedBox(
            //   height: 30,
            // ),
            // Container(
            //   width: MediaQuery.of(context).size.width * 0.85,
            //   height: MediaQuery.of(context).size.height * 0.065,
            //   padding: EdgeInsets.symmetric(horizontal: 10),
            //   decoration: BoxDecoration(
            //       color: Colors.black.withOpacity(0.3),
            //       borderRadius: BorderRadius.all(Radius.circular(20))),
            //   child: TextFormField(
            //     onFieldSubmitted: (String s) {
            //       setState(() {
            //         cityName = s;
            //         getCityWeather(cityName);
            //         isLoaded = false;
            //         cityController.clear();
            //       });
            //     },
            //     controller: cityController,
            //     cursorColor: Colors.white,
            //     style: TextStyle(
            //       fontSize: 20,
            //       color: Colors.white,
            //     ),
            //     decoration: InputDecoration(
            //         hintText: 'Search City',
            //         prefixIcon: Icon(
            //           Icons.search_rounded,
            //           size: 20,
            //           color: Colors.white.withOpacity(0.7),
            //         ),
            //         border: InputBorder.none),
            //   ),
            // ),
            // SizedBox(
            //   height: 30,
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: [
            //       Icon(
            //         Icons.pin_drop,
            //         color: Colors.red,
            //         size: 40,
            //       ),
            //       SizedBox(
            //         width: 10,
            //       ),
            //       Text(
            //         cityName,
            //         overflow: TextOverflow.ellipsis,
            //         style: TextStyle(
            //             fontSize: 28,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.white),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: 30,
            // ),
            // Container(
            //   width: 300,
            //   height: 70,
            //   color: Colors.amber,
            //   child: Row(
            //     children: [
            //       Icon(Icons.align_horizontal_center_sharp),
            //       SizedBox(
            //         width: 20,
            //       ),
            //       Text(
            //         'Temperature : ${temp.toStringAsFixed(3)}℃',
            //         style: TextStyle(fontSize: 20),
            //       )
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: 30,
            // ),
            // Container(
            //   width: 300,
            //   height: 70,
            //   color: Colors.amber,
            //   child: Row(
            //     children: [
            //       Icon(Icons.align_horizontal_center_sharp),
            //       SizedBox(
            //         width: 20,
            //       ),
            //       Text(
            //         'Pressure : ${pressure.toStringAsFixed(3)}hPa',
            //         style: TextStyle(fontSize: 20),
            //       )
            //     ],
            //   ),
            // )
            // ],
          ),
        ),
        // ),
        replacement: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 30,
            ),
            Text('Searching Your Location ...')
          ],
        )),
      ),
    );
  }

  getCurrentLocation() async {
    var p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        forceAndroidLocationManager: true);
    if (p != null) {
      getCurrentCityWeather(p);
    } else {}
    getCurrentCityWeather(p);
  }

  getCurrentCityWeather(Position position) async {
    var client = http.Client();
    var uri =
        '${k.domain}lat=${position.latitude}&lon=${position.longitude}&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodedData = json.decode(data);
      updateUI(decodedData);
      setState(() {
        isLoaded = true;
        if (weather == 'Clouds') {
          bgimg = 'sunny.jpg';
        } else if (weather == 'rain') {
          bgimg = 'rainy.jpg';
        }
      });
    } else {}
  }

  updateUI(var decodedData) {
    setState(() {
      if (decodedData == null) {
        weather = 'Clouds';
        temp = 0;
        pressure = 0;
        humidity = 0;
        cloudCover = 0;
        cityName = "Not available";
      } else {
        weather = decodedData['weather']['main'];
        temp = decodedData['main']['temp'] - 273;
        pressure = decodedData['main']['pressure'];
        humidity = decodedData['main']['humidity'];
        cloudCover = decodedData['clouds']['all'];
        cityName = decodedData['name'];
      }
    });
  }

  getCityWeather(String cityName) async {
    var client = http.Client();
    var uri = '${k.domain}q=$cityName&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    try {
      var response = await client.get(url);
      if (response.statusCode == 200) {
        var data = response.body;
        var decodedData = json.decode(data);
        updateUI(decodedData);
        setState(() {
          isLoaded = true;
        });
      } else {
        print('status code -> ${response.statusCode}');

        // Future.delayed(Duration(seconds: 3));
        getCurrentLocation();
        snack(context, message: "Not Found", color: Colors.red);

        // Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error  ->  $e');
    }
  }

  void snack(BuildContext context,
      {required String message, required Color color}) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text(message),
        backgroundColor: color,
        elevation: 6,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 21),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    cityController.dispose();
    super.dispose();
  }
}
