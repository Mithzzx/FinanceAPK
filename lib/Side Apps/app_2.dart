import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        secondaryHeaderColor: Colors.tealAccent,
        // Add more custom dark theme properties here
      ), // This sets the dark theme
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'Currency Converter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _refresh()
  {
    return;
  }

  SizedBox _forecastCard(icon,temp,time)
  {
    return SizedBox(
        width:100,
        height: 120,
        child: Card(
          elevation:20,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                icon,
                const SizedBox(height: 4,),
                Text(temp,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20
                  ),
                ),
                const SizedBox(height: 3,),
                Text(time)
              ],
            ),
          ),
        )
    );
  }

  Padding _addInfoCard(image,name,info)
  {
    double iconSize= 50;

    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
            children : [SizedBox(
              width:iconSize,
              height: iconSize,
              child: image,
            ),
              const SizedBox(height: 12),
              Text(name),
              const SizedBox(height: 12),
              Text(info,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                ),)
            ]
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh_sharp))
      ],
        title: const Text("Weather",
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600
          ),
        ),
      ),
      body:Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width:400,
                height: 200,
                child: Card(
                    clipBehavior: Clip.antiAlias,
                    elevation:20,
                    child: Stack(
                      children: [
                        ClipRect(
                          child:  Ink.image(
                            image:const AssetImage('asset/cloud_1.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [],
                              ),
                              Text("Bangalore",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  )
                              )
                            ],
                          ),
                        ),
                        const Padding(
                          padding:EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.cloud),
                                  SizedBox(width: 12,),
                                  Text("Cloudy",
                                    style: TextStyle(
                                      fontSize: 30,
                                    ),),
                                ],
                              ),
                              Text("20°",
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w600,
                                  )
                              )
                            ],
                          ),
                        )
                      ],
                    )
                )
            ),
            const SizedBox(height: 30,),
            const Text("Forecast",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _forecastCard(const Icon(Icons.cloud),"19°","3:00"),
                  _forecastCard(const Icon(Icons.cloud),"18°","4:00"),
                  _forecastCard(const Icon(Icons.cloud),"17°","5:00"),
                  _forecastCard(const Icon(Icons.cloud),"16°","6:00"),
                  _forecastCard(const Icon(Icons.cloud),"15°","7:00"),
                  _forecastCard(const Icon(Icons.cloud),"15°","8:00"),
                  _forecastCard(const Icon(Icons.cloud),"14°","9:00"),
                  _forecastCard(const Icon(Icons.cloud),"13°","10:00"),
                ],
              ),
            ),
            const SizedBox(height: 30,),
            const Text("Additional Information",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _addInfoCard(Image.asset(
                  'asset/001-humidity.png',
                  fit: BoxFit.cover,),"Humidity","000"),
                _addInfoCard(Image.asset(
                  'asset/002-windy.png',
                  fit: BoxFit.cover,),"Wind Speed","000"),
                _addInfoCard(Image.asset(
                  'asset/003-gauge.png',
                  fit: BoxFit.cover,
                  scale: 0.01,),"Pressure","000"),
              ],
            )
          ],
        ),
      ),
    );
  }
}

