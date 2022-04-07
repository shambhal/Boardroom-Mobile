import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:hot_desking/core/app_theme.dart';
import 'package:hot_desking/core/widgets/show_snackbar.dart';
import 'package:hot_desking/features/booking/data/datasource/room_booking_datasource.dart';
import 'package:hot_desking/features/booking/widgets/booking_confirmed_dialog.dart';
import 'package:hot_desking/features/booking/widgets/confirm_button.dart';
import 'package:hot_desking/features/floors/level3/level_3_layout.dart';
import 'package:hot_desking/features/booking/widgets/seat_selection_dialog.dart';
import 'package:hot_desking/features/floors/level3/level_3_room.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../../floors/level14/level14_room.dart';
import '../../widgets/time_slot_dialog.dart';
import 'book_desk_second_screen.dart';

class RoomBookingScreen extends StatefulWidget {
  final String type;
  const RoomBookingScreen({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  _RoomBookingScreenState createState() => _RoomBookingScreenState();
}

class _RoomBookingScreenState extends State<RoomBookingScreen> {
  final List<String> _levelsList = [
    'Floor 3',
    'Floor 14',
  ];
  final List<String> _paxList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
  ];
  String? _selectedLevel = 'Floor 3';
  DateTime? _dateTime;
  TimeOfDay? _startTime, _endTime;
  String? _formattedDate, _formattedStartTime, _formattedEndTime;
  late int _selectedCategory;
  String? _selectedPax = '1';
  int? tableNo, seatNo, roomId;

  String firstName =
      AppHelpers.SHARED_PREFERENCES.getString('firstName') ?? 'John';
  String lastName =
      AppHelpers.SHARED_PREFERENCES.getString('lastName') ?? 'Doe';

  @override
  void initState() {
    if (widget.type == 'meeting room') {
      _selectedCategory = 0;
    } else {
      _selectedCategory = 1;
    }
    super.initState();
  }

  var black600TextStyle = TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: Colors.black.withOpacity(0.5));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kGreyBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          // controller: controller,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    Image.asset(
                      'assets/welcome_screen/log_out.png',
                      height: 30,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/welcome_screen/person_emoji.png',
                      height: 55,
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 22.sp),
                        children: [
                          const TextSpan(
                            text: 'Welcome ',
                            style: TextStyle(
                              color: AppColors.kAubergine,
                            ),
                          ),
                          TextSpan(
                            text: '$firstName $lastName',
                            style: const TextStyle(
                              color: AppColors.kEvergreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Reserve Your \nCozy working space',
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 34.h,
                      width: 152.w,
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            value: _selectedLevel,
                            style: black600TextStyle,
                            hint: Text(
                              'Level',
                              style: black600TextStyle,
                            ),
                            isExpanded: true,
                            iconEnabledColor: Colors.black.withOpacity(0.5),
                            items: _levelsList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value.toString(),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? val) {
                              setState(() {
                                _selectedLevel = val!;
                              });
                            }),
                      ),
                    ),
                    // paxSelector(),
                    startDateSelector(context),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    fromDateSelector(context, setState),
                    toDateSelector(context, setState),
                    // Container(
                    //   height: 34.h,
                    //   width: 152.w,
                    //   padding: const EdgeInsets.symmetric(
                    //       vertical: 6, horizontal: 14),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     color: Colors.white,
                    //   ),
                    //   child: InkWell(
                    //     onTap: () {
                    //       Get.bottomSheet(
                    //         timeBottomSheet(),
                    //       );
                    //       // showTimePicker(
                    //       //   context: context,
                    //       //   initialTime: TimeOfDay.now(),
                    //       // ).then((value) {
                    //       //   if (value == null) return;
                    //       //   setState(() {
                    //       //     _formattedTime = AppHelpers.formatTime(value);
                    //       //     _timeOfDay = value;
                    //       //   });
                    //       // });
                    //     },
                    //     child: Center(
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text(
                    //             _formattedStartTime ?? 'Select Time',
                    //             style: black600TextStyle,
                    //           ),
                    //           Icon(
                    //             Icons.arrow_drop_down,
                    //             color: Colors.black.withOpacity(0.5),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(
                  height: 25.h,
                ),
                // Text(
                //   _selectedLevel ?? 'Select Level',
                //   style: AppTheme.black500TextStyle(18),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                //   child: Row(
                //     children: const [
                //       Text(
                //         'Desk: ',
                //         style: TextStyle(
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //       Expanded(
                //           child: Text(
                //         '50 available',
                //         style: TextStyle(
                //           color: AppColors.kMint,
                //           fontWeight: FontWeight.w500,
                //         ),
                //       )),
                //     ],
                //   ),
                // ),
                Center(
                  child: Text(
                    'Available Room in the selected Time Slot',
                    style: AppTheme.black600TextStyle(18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Room No',
                        style: AppTheme.black600TextStyle(14),
                      ),
                      Text(
                        'No of Pax',
                        style: AppTheme.black600TextStyle(14),
                      ),
                      Text(
                        'Available          ',
                        style: AppTheme.black600TextStyle(14),
                      ),
                    ],
                  ),
                ),
                if (_formattedDate != null &&
                    _startTime != null &&
                    _endTime != null)
                  ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Room A',
                                style: AppTheme.black500TextStyle(14),
                              ),
                              Text(
                                '8',
                                style: AppTheme.black500TextStyle(14),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.bottomSheet(
                                    timeBottomSheet(),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 20.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: AppColors.kEvergreen,
                                  ),
                                  child: Center(
                                      child: Text(
                                    'Available',
                                    style: AppTheme.black500TextStyle(14),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                // _selectedLevel == 'Floor 14'
                //     ? Level14Room(
                //         selectedRoom: (s) {
                //           roomId = s;
                //           print(roomId);
                //         },
                //       )
                //     : Level3Room(selectedRoom: (s) {
                //         roomId = s;
                //         print(roomId);
                //       }),
                // Center(
                //   child: TextButton(
                //     onPressed: () {
                //       showDialog(
                //           context: context,
                //           builder: (context) {
                //             return BackdropFilter(
                //               filter:
                //                   ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                //               child: Dialog(
                //                 shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(20.0)),
                //                 child: SeatSelection(),
                //               ),
                //             );
                //           });
                //     },
                //     child: const Text('Seat Selection'),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget timeBottomSheet() {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: [
            transparentWhiteContainer(
                child: const Text(
              'Time Slot',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w500,
              ),
            )),
            const SizedBox(
              height: 15,
            ),
            transparentWhiteContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Room Amenities',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.kRed,
                          size: 15,
                        ),
                        Text(
                          '   Meeting Amenities',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.kRed,
                          size: 15,
                        ),
                        Text(
                          '   Projector',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.kRed,
                          size: 15,
                        ),
                        Text(
                          '   Available (If Any)',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            transparentWhiteContainer(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'From: $_formattedStartTime',
                      style: AppTheme.black500TextStyle(14),
                    ),
                    Text(
                      'To: $_formattedEndTime',
                      style: AppTheme.black500TextStyle(14),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    paxSelector(),
                    Text(
                      'Date: $_formattedDate',
                      style: AppTheme.black500TextStyle(14),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      if (_selectedLevel != null &&
                          _dateTime != null &&
                          _startTime != null &&
                          _endTime != null) {
                        RoomBookingDataSource()
                            .createRoomBooking(
                                roomId: roomId!,
                                date: _formattedDate!,
                                fromTime: _formattedStartTime!,
                                toTime: _formattedEndTime!)
                            .then((value) {
                          if (value) {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 2.5, sigmaY: 2.5),
                                    child: Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      child: const BookingConfirmedWidget(),
                                    ),
                                  );
                                });
                            RoomBookingDataSource().viewAllRoomBooking();
                          } else {
                            Navigator.pop(context);
                          }
                        });
                      } else {
                        showSnackBar(
                            context: context, message: 'Select All Fields');
                      }
                    },
                    child: confirmButton(),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ))
          ],
        ),
      );
    });
  }

  Widget startDateSelector(BuildContext context) {
    return Container(
      height: 34.h,
      width: 152.w,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: () {
          showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 180)))
              .then((value) {
            if (value == null) return;
            setState(() {
              _formattedDate = AppHelpers.formatDate(value);
              _dateTime = value;
            });
          });
        },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formattedDate ?? 'Select Date',
                style: black600TextStyle,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fromDateSelector(
      BuildContext context, void Function(void Function()) setState) {
    return Container(
      height: 34.h,
      width: 152.w,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: () {
          showTimePicker(context: context, initialTime: TimeOfDay.now())
              .then((value) {
            if (value == null) return;
            setState(() {
              _formattedStartTime = AppHelpers.formatTime(value);
              _startTime = value;
            });
          });
        },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formattedStartTime ?? 'From Time',
                style: black600TextStyle,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget toDateSelector(
      BuildContext context, void Function(void Function()) setState) {
    return Container(
      height: 34.h,
      width: 152.w,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: () {
          showTimePicker(context: context, initialTime: TimeOfDay.now())
              .then((value) {
            if (value == null) return;
            setState(() {
              _formattedEndTime = AppHelpers.formatTime(value);
              _endTime = value;
            });
          });
        },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formattedEndTime ?? 'End Time',
                style: black600TextStyle,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget paxSelector() {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        height: 34.h,
        width: 152.w,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
              value: _selectedPax,
              style: black600TextStyle,
              hint: Text(
                'No. of pax',
                style: black600TextStyle,
              ),
              isExpanded: true,
              iconEnabledColor: Colors.black.withOpacity(0.5),
              items: _paxList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value.toString(),
                  ),
                );
              }).toList(),
              onChanged: (String? val) {
                setState(() {
                  _selectedPax = val!;
                });
              }),
        ),
      );
    });
  }

  Widget transparentWhiteContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: child,
    );
  }
}
