import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:hot_desking/core/app_theme.dart';
import 'package:hot_desking/core/widgets/cancel_button.dart';
import 'package:hot_desking/core/widgets/text_widget.dart';
import 'package:hot_desking/features/booking/data/datasource/table_booking_datasource.dart';
import 'package:hot_desking/features/booking/widgets/booking_confirmed_dialog.dart';
import 'package:hot_desking/features/booking/widgets/confirm_button.dart';

class EditBookingDialog extends StatefulWidget {
  final String type;
  // final int tableNo;
  // final int seatNo;
  // final DateTime date;
  // final TimeOfDay startTime;
  const EditBookingDialog({
    Key? key,
    required this.type,
    // required this.date,
    // required this.startTime,
    // required this.tableNo,
    // required this.seatNo,
  }) : super(key: key);

  @override
  State<EditBookingDialog> createState() => _EditBookingDialogState();
}

class _EditBookingDialogState extends State<EditBookingDialog> {
  final TextEditingController dateController =
      TextEditingController(text: '4-1-2022');
  final TextEditingController timeController =
      TextEditingController(text: '11-4pm');
  List<String> members = ['Rajesh', 'Suresh', 'Kamal', 'Manikandan'];

  TimeOfDay? startTime, endTime;
  @override
  void initState() {
    // startTime = widget.startTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 227.h,
      width: 326.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: AppTheme.boxDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              widget.type == 'Table' ? 'Table 1' : 'Room 1',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(
            height: 19.h,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    textWidget('Date'),
                    textWidget('Timing'),
                    if (widget.type == 'Room')
                      SizedBox(
                          height: 100,
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: textWidget('Members'))),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 32.h,
                      width: 170.w,
                      margin: EdgeInsets.symmetric(vertical: 4.5.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: dateController,
                        decoration:
                            AppTheme.textFieldDecoration('Date').copyWith(
                          suffixIcon: Icon(Icons.calendar_month),
                        ),
                      ),
                    ),
                    Container(
                      height: 32.h,
                      width: 170.w,
                      margin: EdgeInsets.symmetric(vertical: 4.5.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime: startTime!,
                          ).then((value) {
                            if (value == null) return;
                            setState(() {
                              startTime = value;
                            });
                          });
                        },
                        child: TextField(
                          controller: timeController,
                          decoration:
                              AppTheme.textFieldDecoration('Time').copyWith(
                            suffixIcon: Icon(Icons.calendar_month),
                          ),
                        ),
                      ),
                    ),
                    if (widget.type == 'Room')
                      Container(
                        height: 100.h,
                        width: 170.w,
                        padding: EdgeInsets.all(8.0),
                        margin: EdgeInsets.symmetric(vertical: 4.5.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(members.join(', ')),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  if (widget.type == 'Room') {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                            child: Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: const BookingConfirmedWidget(
                                message: 'Confirmation Mail\nSent',
                              ),
                            ),
                          );
                        });
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: confirmButton(),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: cancelButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
