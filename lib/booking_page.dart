import 'dart:async';

import 'package:errands/video_call_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(21.2033406, 72.7873944);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Set<Marker> _markers;
  BitmapDescriptor pinLocationIcon;


  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/plumber.png');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _markers = Set.from([]);

    setCustomMapPin();

    createMarker();

    _markers..add(
        Marker(
          markerId: MarkerId('Current Location'),
          draggable: false,
          position: LatLng(21.2033406, 72.7873944),
        )
    );

  }

  createMarker(){
    if(pinLocationIcon == null){
      BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(Image.asset('assets/plumber.png').width,Image.asset('assets/plumber.png').height)), 'assets/plumber.png').then((icon){
        setState(() {
          pinLocationIcon = icon;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
        GoogleMap(
          onCameraMoveStarted: (){
            setState(() {
              _markers.add(Marker(
                markerId: MarkerId('Plumber'),
                icon: pinLocationIcon,
                position: LatLng(21.2035406, 72.7878944),
              ));
            });
          },
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 20.0,
          ),
          myLocationButtonEnabled: true,
          markers: Set.from(_markers),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Container(
              height: 190.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            radius: 30.0,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "John Deo",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                "Plumber",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 40.0,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.orangeAccent,
                          ),
                          Text(
                            "4.5",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                RaisedButton(
                                  padding: EdgeInsets.all(10.0),
                                  onPressed: () {},
                                  color: Colors.blueAccent,
                                  child: Icon(
                                    Icons.call,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                RaisedButton(
                                  padding: EdgeInsets.all(10.0),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            CallPage(channelName: '18710527017',)
                                    ));
                                  },
                                  color: Colors.blueAccent,
                                  child: Icon(
                                    Icons.video_call,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}