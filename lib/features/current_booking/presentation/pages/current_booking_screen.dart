import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:hot_desking/features/booking_history/presentation/widgets/room_card.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_theme.dart';
import '../../../booking_history/presentation/widgets/table_card.dart';

class CurrentBookingScreen extends StatefulWidget {
  const CurrentBookingScreen({Key? key}) : super(key: key);

  @override
  State<CurrentBookingScreen> createState() => _CurrentBookingScreenState();
}

class _CurrentBookingScreenState extends State<CurrentBookingScreen> {
  DateTime? _selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kGreyBackground,
      appBar: AppTheme.appBar('Current Booking', context, false),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
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
              // ),
              TableCard(allowEdit: true, fromCurrentBooking: true),
              RoomCard(allowEdit: true, fromCurrentBooking: true),
              TableCard(allowEdit: true, fromCurrentBooking: true),
              TableCard(allowEdit: true, fromCurrentBooking: true),
            ],
          ),
        ),
      ),
    );
  }
}
