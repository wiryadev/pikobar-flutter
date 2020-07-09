import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/blocs/authentication/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/GeocoderRepository.dart';
import 'package:pikobar_flutter/screens/checkDistribution/components/LocationPicker.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';

class SelfReportScreen extends StatefulWidget {
  @override
  _SelfReportScreenState createState() => _SelfReportScreenState();
}

class _SelfReportScreenState extends State<SelfReportScreen> {
  final AuthRepository _authRepository = AuthRepository();
  AuthenticationAuthenticated profileLoaded;

  // ignore: close_sinks
  AuthenticationBloc _authenticationBloc;
  LatLng latLng;
  String addressMyLocation;
  bool hasLogin = false;

  @override
  void initState() {
    addressMyLocation = '-';
    getDataToken();
    super.initState();
  }

  getDataToken() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
            create: (BuildContext context) => _authenticationBloc =
                AuthenticationBloc(authRepository: _authRepository)
                  ..add(AppStarted())),
      ],
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationFailure) {
            setState(() {
              hasLogin = false;
            });
          }
          if (state is AuthenticationLoading) {
            setState(() {
              hasLogin = false;
            });
          }
          if (state is AuthenticationUnauthenticated) {
            setState(() {
              hasLogin = false;
            });
          }

          if (state is AuthenticationAuthenticated) {
            setState(() {
              profileLoaded = state;
              hasLogin = true;
            });
          }
        },
        child: Scaffold(
            appBar: CustomAppBar.defaultAppBar(
              title: Dictionary.titleSelfReport,
            ),
            body: StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance
                    .collection('users')
                    .document(
                        profileLoaded != null ? profileLoaded.record.uid : null)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError)
                    // Show error ui when unable to get data
                    return ErrorContent(error: snapshot.error);
                  switch (snapshot.connectionState) {
                    // Show loading while get data
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      // Show content when data is ready
                      return snapshot.data.exists
                          ? _buildContent(snapshot)
                          : _buildContent(null);
                  }
                })),
      ),
    );
  }

  bool showProfileNotComplete(AsyncSnapshot<DocumentSnapshot> state) {
    if (state != null &&
        state.data['name'].toString().isNotEmpty &&
        state.data['email'].toString().isNotEmpty &&
        state.data['phone_number'].toString().isNotEmpty &&
        state.data['address'].toString().isNotEmpty &&
        state.data['birthdate'].toString().isNotEmpty &&
        state.data['gender'].toString().isNotEmpty &&
        state.data['city_id'].toString().isNotEmpty &&
        state.data['location'].toString().isNotEmpty &&
        state.data['health_status'] == null &&
        state.data['name'] != null &&
        state.data['email'] != null &&
        state.data['phone_number'] != null &&
        state.data['address'] != null &&
        state.data['birthdate'] != null &&
        state.data['gender'] != null &&
        state.data['city_id'] != null &&
        state.data['location'] != null) {
      return false;
    } else {
      return true;
    }
  }

  bool showIsHealty(AsyncSnapshot<DocumentSnapshot> state) {
    if (state.data['health_status'].toString().isNotEmpty &&
        state.data['health_status'] != null &&
        state.data['health_status'].toString() != 'null') {
      if (state.data['health_status'].toString() == 'HEALTHY') {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  Widget _buildContent(AsyncSnapshot<DocumentSnapshot> state) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          hasLogin
              ? showProfileNotComplete(state)
                  ? buildAnnouncement(state)
                  : Container()
              : Container(),
          SizedBox(
            height: 10,
          ),
          location(state),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildContainer(
                  '${Environment.iconAssets}calendar_disable.png',
                  '${Environment.iconAssets}calendar_enable.png',
                  Dictionary.dailyMonitoring,
                  2, () {
                if (latLng == null ||
                    addressMyLocation == '-' ||
                    addressMyLocation.isEmpty ||
                    addressMyLocation == null) {
                  Fluttertoast.showToast(
                      msg: Dictionary.alertLocationSelfReport,
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      fontSize: 16.0);
                } else {}
              },
                  hasLogin
                      ? !showProfileNotComplete(state) && !showIsHealty(state)
                          ? hasLogin
                          : false
                      : false),
              _buildContainer(
                  '${Environment.iconAssets}history_contact_disable.png',
                  '${Environment.iconAssets}history_contact_disable.png',
                  Dictionary.historyContact,
                  2,
                  () {},
                  false),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              Dictionary.educationContent,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontsFamily.lato,
                  fontSize: 14.0),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              Dictionary.educationContentdesc,
              style: TextStyle(
                color: Colors.black,
                fontFamily: FontsFamily.lato,
                fontSize: 12.0,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: OutlineButton(
              splashColor: Colors.green,
              highlightColor: Colors.white,
              padding: EdgeInsets.all(0.0),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                    child: CachedNetworkImage(
                        imageUrl: '',
                        imageBuilder: (context, imageProvider) =>
                            Image.network(''),
                        placeholder: (context, url) =>
                            Center(child: CupertinoActivityIndicator()),
                        errorWidget: (context, url, error) => Container(
                              child: Image.asset(
                                '${Environment.imageAssets}default_image_education.png',
                                height: 80,
                                width: 80,
                              ),
                            )),
                  ),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.padding, 5.0, 5.0, 5.0),
                    child: Text(
                      'Klik disini untuk mengunduh file Edukasi isolasi Mandiri',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: FontsFamily.lato,
                        fontSize: 12.0,
                        height: 1.2,
                      ),
                    ),
                  )),
                  InkWell(
                    child: Container(
                        margin: EdgeInsets.only(right: Dimens.padding),
                        child: Image.asset(
                          '${Environment.iconAssets}download_icon.png',
                          height: 20,
                          width: 20,
                        )),
                    onTap: () {},
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildAnnouncement(AsyncSnapshot<DocumentSnapshot> state) {
    return Container(
      width: (MediaQuery.of(context).size.width),
      margin: EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
          color: Color(0xffFFF3CC), borderRadius: BorderRadius.circular(8.0)),
      child: Stack(
        children: <Widget>[
          Image.asset('${Environment.imageAssets}intersect.png', width: 73),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Dictionary.profileNotComplete,
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.lato),
                  ),
                  SizedBox(height: 15),
                  Container(
                      child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: Dictionary.descProfile1,
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                            fontFamily: FontsFamily.lato),
                      ),
                      TextSpan(
                          text: Dictionary.descProfile2,
                          style: TextStyle(
                              fontSize: 12.0,
                              color: ColorBase.blue,
                              fontFamily: FontsFamily.lato,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(
                                  context, NavigationConstrants.Edit,
                                  arguments: state);
                            }),
                      TextSpan(
                        text: Dictionary.descProfile3,
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                            fontFamily: FontsFamily.lato),
                      ),
                    ]),
                  ))
                ]),
          ),
        ],
      ),
    );
  }

  Widget location(AsyncSnapshot<DocumentSnapshot> state) {
    if (state != null) {
      if (state.data['address'] != null) {
        addressMyLocation = state.data['address'].toString();
      }
      if (state.data['location'] != null) {
        latLng = new LatLng(
            state.data['location'].latitude, state.data['location'].longitude);
      }
    }
    return GestureDetector(
      child: Card(
        elevation: 0,
        color: Colors.grey[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '${Dictionary.currentLocationTitleSelfReport}',
                    style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                      height: 1.2,
                    ),
                  ),
                  Container(
                      child: Icon(
                    Icons.expand_more,
                    color: Colors.black,
                    size: 17,
                  )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Image.asset(
                    '${Environment.iconAssets}pin_location_red.png',
                    scale: 3,
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      addressMyLocation,
                      style: TextStyle(
                        fontFamily: FontsFamily.lato,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        height: 1.2,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      onTap: () {
        hasLogin
            ? !showIsHealty(state)
                ? _handleLocation()
                // ignore: unnecessary_statements
                : null
            // ignore: unnecessary_statements
            : null;
      },
    );
  }

  _buildContainer(String imageDisable, String imageEnable, String title,
      int length, GestureTapCallback onPressed, bool isShowMenu) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: OutlineButton(
        splashColor: Colors.green,
        highlightColor: Colors.white,
        padding: EdgeInsets.all(0.0),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          width: (MediaQuery.of(context).size.width / length),
          padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 30, bottom: 30),
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: 60,
                  child: Image.asset(isShowMenu ? imageEnable : imageDisable)),
              Container(
                margin: EdgeInsets.only(top: 15, left: 5.0),
                child: Text(title,
                    style: TextStyle(
                        fontSize: 13.0,
                        color: Color(0xff333333),
                        fontFamily: FontsFamily.lato)),
              )
            ],
          ),
        ),
        onPressed: isShowMenu ? onPressed : null,
      ),
    ));
  }

  // Function to get location user
  Future<void> _handleLocation() async {
    //Checking permission status
    var permissionService =
        Platform.isIOS ? Permission.locationWhenInUse : Permission.location;

    if (await permissionService.status.isGranted) {
      // Permission allowed
      await _openLocationPicker();
    } else {
      // Permission disallowed
      // Show dialog to ask permission
      showDialog(
          context: context,
          builder: (BuildContext context) => DialogRequestPermission(
                image: Image.asset(
                  '${Environment.iconAssets}map_pin.png',
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
                description: Dictionary.permissionLocationSpread,
                onOkPressed: () async {
                  Navigator.of(context).pop();
                  if (await permissionService.status.isDenied) {
                    await AppSettings.openLocationSettings();
                  } else {
                    permissionService.request().then((status) {
                      _onStatusRequested(context, status);
                    });
                  }
                },
                onCancelPressed: () {
                  AnalyticsHelper.setLogEvent(
                      Analytics.permissionDismissLocation);
                  Navigator.of(context).pop();
                },
              ));
    }
  }

  // Function to get lat long user and auto complete address field
  Future<void> _openLocationPicker() async {
    latLng = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => LocationPicker()));
    final String address = await GeocoderRepository().getAddress(latLng);
    if (address != null) {
      setState(() {
        addressMyLocation = address;
      });
    }
  }

  // Function to get status for access location
  void _onStatusRequested(
      BuildContext context, PermissionStatus statuses) async {
    if (statuses.isGranted) {
      _openLocationPicker();
      AnalyticsHelper.setLogEvent(Analytics.permissionGrantedLocation);
    } else {
      AnalyticsHelper.setLogEvent(Analytics.permissionDeniedLocation);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
