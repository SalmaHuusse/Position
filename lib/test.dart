// ignore_for_file: avoid_print, sort_child_properties_last

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Test extends StatefulWidget{
  const Test({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _TestState createState() => _TestState();

}
class _TestState extends State<Test> {

late Position cl;
var lat;
var long;
  CameraPosition? _kGooglePlex;
late StreamSubscription<Position> ps ;

  Future getPer() async{
    bool services ;
    LocationPermission per;

    services = await Geolocator.isLocationServiceEnabled();

    if(services == false){
      AwesomeDialog(
          context: context,
          title: "services",
          body: const Text("Serves Not Enables")).show();

    }
    per = await Geolocator.checkPermission();
    if(per == LocationPermission.denied){
      per = await Geolocator.requestPermission();
      if(per == LocationPermission.always){
        getLatAndLong();
      }
    }
    print("===================");
    print(per);
    print("====================");
    return per;
  }

   Future<void> getLatAndLong() async{
      cl = await Geolocator.getCurrentPosition().then((value) =>  value);
      lat =cl.latitude;
      long = cl.longitude;
      _kGooglePlex = CameraPosition(
        target: LatLng(lat, long),
        zoom: 7.4746,
      );
      mymarker.add(Marker(markerId: MarkerId("1") , position: LatLng(lat, long), ));
      setState((){ });

  }
  @override
  void initState() {
  ps=   Geolocator.getPositionStream().listen(
            (Position position) {
              changemarker(position.latitude , position.longitude);
        });
   getPer();
   getLatAndLong();
    super.initState();
  }
   Completer<GoogleMapController>  _controller =  Completer();
   // محذوف
  late GoogleMapController gmc;

  Set<Marker> mymarker = {


    // Marker(
    //   markerId: MarkerId("2") ,
    //   infoWindow: InfoWindow(title: "2" , onTap: (){
    //     print("2");
    //   }),
    //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
    //   position: LatLng(22.435691820224367, 39.04285166412592),
    // ),
  };
   changemarker(newlat , newlong){
     mymarker.clear();
     mymarker.remove(Marker(markerId: MarkerId("1")));
     mymarker.add(Marker(markerId: MarkerId("1") , position:  LatLng(newlat ,newlong)));
    //gmc.animateCamera(CameraUpdate.newLatLng( LatLng(newlat ,newlong)));
     setState((){
     });

   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Text("Dialog"),
      ),
      body: Column(
        children: [
          _kGooglePlex == null ? CircularProgressIndicator():
          Container(child: GoogleMap(
            markers: mymarker,
            onTap: (LatLng){

            },
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex!,
            onMapCreated: (GoogleMapController controller) {
             gmc = controller;
            },),
          height: 550, width: 400),
          RaisedButton(onPressed: () async {
            //go  to maka
            //LatLng  latlng = LatLng(21.422390, 39.722958);
         //gmc.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latlng , zoom: 8 , )));
           //طباعه احداثيات مكان معين على الخريطه
            var xy = await gmc.getLatLng(ScreenCoordinate(x: 200, y: 200));
            print("===================");
            print(xy);
            print("===================");
          }, child: const Text("show latlng")),
        ],
      ),
    );
  }

}











//حساب المسافه بين منطقتين
//24.327077
//39.631053

//27.547242
//41.741836



//AIzaSyAwGG4sYvNucNOcdOrJwL_yjfQJiggjq7M