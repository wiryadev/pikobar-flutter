import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:google_maps_webservice/places.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TravelHistory extends StatefulWidget {
  @override
  _TravelHistory createState() => _TravelHistory();
}

class _TravelHistory extends State<TravelHistory> {
  static const kGoogleApiKey = "AIzaSyAxCyXB5TyKZNoxwJLvXInU2T26ti0RMjY";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController mapController;
  List<PlacesSearchResult> places = [];
  bool isLoading = false;
  String errorMessage;
  Completer<GoogleMapController> _controller = Completer();
  LatLng _currentPosition = LatLng(-6.902735, 107.618782);
  Map<String, Marker> markers = <String, Marker>{};

  @override
  void initState() {
    _initializeLocation();
    markers["new"] = Marker(
      markerId: MarkerId("Bandung"),
      position: _currentPosition,
      icon: BitmapDescriptor.defaultMarker,
    );
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) async {
    Position position = await Geolocator.getCurrentPosition();
    LatLng currentLocation = LatLng(position.latitude, position.longitude);
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: currentLocation, zoom: 15.5),
      ),
    );
    getNearbyPlaces(currentLocation);
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    Widget expandedChild;
    if (isLoading) {
      expandedChild = Center(child: CircularProgressIndicator(value: null));
    } else if (errorMessage != null) {
      expandedChild = Center(
        child: Text(errorMessage),
      );
    } else {
      expandedChild = buildPlacesList();
    }

    return Scaffold(
      key: homeScaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: RoundedButton(
            title: Dictionary.selfReportTravelHistory,
            elevation: 0.0,
            color: ColorBase.green,
            borderRadius: BorderRadius.circular(8),
            textStyle: TextStyle(
                fontFamily: FontsFamily.roboto,
                fontSize: 12.0,
                fontWeight: FontWeight.w900,
                color: Colors.white),
            onPressed: () {}),
      ),
      appBar: CustomAppBar.animatedAppBar(
        showTitle: true,
        title: Dictionary.travelHistoryReport,
      ),
      body: SlidingUpPanel(
        minHeight: MediaQuery.of(context).size.height * 0.3,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        panel: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(
                      bottom: Dimens.padding, top: Dimens.padding),
                  height: 6,
                  width: 60.0,
                  decoration: BoxDecoration(
                      color: ColorBase.menuBorderColor,
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                Dictionary.setLocationTravelHistory,
                style: TextStyle(
                    fontFamily: FontsFamily.roboto,
                    color: Colors.grey[800],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  child: expandedChild),
              Expanded(
                  child: Column(
                children: [],
              ))
            ],
          ),
        ),
        body: Container(
            child: SizedBox(
                height: 200.0,
                child: GoogleMap(
                    mapType: MapType.normal,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition,
                      zoom: 16.0,
                    ),
                    markers: Set<Marker>.of(markers.values),
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true))),
      ),
    );
    //  Column(
    //   children: <Widget>[
    //     Container(
    //         child: SizedBox(
    //             height: 200.0,
    //             child: GoogleMap(
    //                 mapType: MapType.normal,
    //                 onMapCreated: _onMapCreated,
    //                 initialCameraPosition: CameraPosition(
    //                   target: _currentPosition,
    //                   zoom: 16.0,
    //                 ),
    //                 markers: Set<Marker>.of(markers.values),
    //                 myLocationButtonEnabled: true,
    //                 myLocationEnabled: true))),
    //     Expanded(child: expandedChild)
    //   ],
    // ));
  }

  void getNearbyPlaces(LatLng center) async {
    setState(() {
      this.isLoading = true;
      this.errorMessage = null;
    });

    final location = Location(center.latitude, center.longitude);
    final result = await _places.searchNearbyWithRadius(location, 2500);

    setState(() {
      this.isLoading = false;
      if (result.status == "OK") {
        this.places = result.results;
        // result.results.forEach((f) {
        //   final markerOptions = MarkerOptions(
        //       position:
        //           LatLng(f.geometry.location.lat, f.geometry.location.lng),
        //       infoWindowText: InfoWindowText("${f.name}", "${f.types?.first}"));
        //   mapController.addMarker(markerOptions);
        // });
      } else {
        this.errorMessage = result.errorMessage;
      }
    });
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  // Future<void> _handlePressButton() async {
  //   try {
  //     final center = await getUserLocation();
  //     Prediction p = await PlacesAutocomplete.show(
  //         context: context,
  //         strictbounds: center == null ? false : true,
  //         apiKey: kGoogleApiKey,
  //         onError: onError,
  //         mode: Mode.fullscreen,
  //         language: "en",
  //         location: center == null
  //             ? null
  //             : Location(center.latitude, center.longitude),
  //         radius: center == null ? null : 10000);

  //     showDetailPlace(p.placeId);
  //   } catch (e) {
  //     return;
  //   }
  // }

  // Future<Null> showDetailPlace(String placeId) async {
  //   if (placeId != null) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => PlaceDetailWidget(placeId)),
  //     );
  //   }
  // }

  ListView buildPlacesList() {
    return ListView.builder(
        itemCount: places.length + 1,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int i) {
          if (i == places.length ) {
            return Padding(
              padding: EdgeInsets.only(top: 4.0, bottom: 4.0, right: 8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200])),
                child: InkWell(
                  onTap: () {
                    // showDetailPlace(f.placeId);
                  },
                  highlightColor: Colors.lightBlueAccent,
                  splashColor: Colors.red,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            children: [
                              Image.asset(
                                '${Environment.iconAssets}pin_location_red.png',
                                scale: 4.5,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(Dictionary.noLocation,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.grey[800],
                                        fontFamily: FontsFamily.roboto,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 2.0),
                          child: Text(
                            places[i].vicinity,
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontFamily: FontsFamily.roboto,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.only(top: 4.0, bottom: 4.0, right: 8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200])),
              child: InkWell(
                onTap: () {
                  // showDetailPlace(f.placeId);
                },
                highlightColor: Colors.lightBlueAccent,
                splashColor: Colors.red,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          children: [
                            Image.asset(
                              '${Environment.iconAssets}pin_location_red.png',
                              scale: 4.5,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(places[i].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      fontFamily: FontsFamily.roboto,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.0),
                        child: Text(
                          places[i].vicinity,
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontFamily: FontsFamily.roboto,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _initializeLocation() async {
    final GoogleMapController controller = await _controller.future;
    Position position = await Geolocator.getCurrentPosition();

    LatLng currentLocation = LatLng(position.latitude, position.longitude);

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: currentLocation, zoom: 15.5),
      ),
    );
  }
}
