import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/CustomBottomSheet.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';

class TravelHistoryScreen extends StatefulWidget {
  @override
  _TravelHistoryScreenState createState() => _TravelHistoryScreenState();
}

class _TravelHistoryScreenState extends State<TravelHistoryScreen> {

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(title: Dictionary.historyTravel.replaceAll('\n', '')),
      body: Container(),
    );
  }

  checkLocationPermission() async {
    if (!await Permission.locationAlways.isGranted) {
      showWidgetBottomSheet(context: context, isScrollControlled: true, isDraggable: false, isDismissible: false, child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Dictionary.activateLocation,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: FontsFamily.lato,
                fontSize: 14.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: Dimens.padding),
          Text(Dictionary.permissionLocationAgreement2,
            textAlign: TextAlign.start,
            style: TextStyle(
                fontFamily: FontsFamily.lato,
                fontSize: 12.0,
                color: Colors.grey[600]),
          ),
          SizedBox(height: Dimens.verticalPadding),
          RoundedButton(
              title: Dictionary.activateGPS,
              textStyle: TextStyle(
                  fontFamily: FontsFamily.lato,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              color: ColorBase.green,
              elevation: 0.0,
              onPressed: () {
                Navigator.of(context).pop();
              }),
          SizedBox(height: Dimens.fieldMarginTop),
          RoundedButton(
              title: Dictionary.later,
              textStyle: TextStyle(
                  fontFamily: FontsFamily.lato,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: ColorBase.darkGrey),
              color: Colors.white,
              borderSide: BorderSide(
                  color: ColorBase.darkGrey),
              elevation: 0.0,
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      ));
    }
  }
}
