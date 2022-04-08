import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:hot_desking/features/current_booking/data/datasource/booked_ds.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_theme.dart';
import '../../../booking_history/presentation/widgets/table_card.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:hot_desking/core/widgets/rc.dart';

class CurrentBookingScreen extends StatefulWidget {
  const CurrentBookingScreen({Key? key}) : super(key: key);

  @override
  State<CurrentBookingScreen> createState() => _CurrentBookingScreenState();
}

class _CurrentBookingScreenState extends State<CurrentBookingScreen> {
  DateTime? _selectedValue;
  bool _processing = true;
  bool _error = false;
  List _data = [];
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    //print("in load data");
    DateTime now = new DateTime.now();
    // var tim = now.hour.toString() + ':' + now.minute.toString();
    String cd = AppHelpers.formatDate(now);
    //String cd = now.toString();
    Map ct = await BookedDataSource.getCurrentHistory(cd, '');
    //print("ct down");
    //print(ct['data']);
    if (ct['flag'] == false) {
      _error = true;
    } else {
      _data = ct['data'];

      // _data=d.toList
      _error = false;
    }
    _processing = false;
    setState(() {});
  }

  Widget _drawBody() {
    if (_error == true) return Center(child: Text("Error Occured"));
    print("in drawbody");
    print(_data.length);
    if (_data.length == 0) return Center(child: Text("No Record to show"));

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
            height: Get.height * 0.9,
            child: ListView.builder(
                itemCount: _data.length,
                itemBuilder: (BuildContext context, int index) {
                  var node = _data[index];
                  print(node);
                  return Rc(node);
                })));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.kGreyBackground,
        appBar: AppTheme.appBar('Current Booking', context, false),
        body: _processing == true
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(child: _drawBody())
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 20.h),
        //   child: DatePicker(
        //     DateTime.now(),
        //     initialSelectedDate: DateTime.now(),
        //     selectionColor: Colors.black,
        //     selectedTextColor: Colors.white,
        //     onDateChange: (date) {
        //       // New date selected
        //       setState(() {
        //         _selectedValue = date;
        //         print(_selectedValue);
        //       });
        //     },
        //   ),

        );
  }
}
