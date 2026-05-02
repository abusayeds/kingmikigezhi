import 'package:event_sharing/controllers/event_controller.dart';
import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/models/event_model.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EventDetailsScreen extends StatefulWidget {
  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late EventController _eventController;
  Group? _selectedGroup;

  @override
  void initState() {
    super.initState();
    _eventController = Get.find<EventController>();
    
    // Use post-frame callback to ensure arguments are available and trigger fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dynamic args = Get.arguments;
      if (args is String) {
        _eventController.fetchEventDetails(args);
      } else if (args is EventModel && args.id != null) {
        _eventController.fetchEventDetails(args.id!);
      }
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('d-M-yyyy').format(date);
  }

  String _formatTime(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('h:mm a').format(date);
  }

  String _getTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    final duration = DateTime.now().difference(dateTime);
    if (duration.inDays > 0) {
      return '${duration.inDays} days ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hours ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18.w),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        title: Text('Event Details',
            style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_eventController.isLoadingDetails.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final event = _eventController.eventDetails.value;
        if (event == null) {
          return const Center(child: Text('Event details not found'));
        }

        final schedule = event.schedule;
        final groups = schedule?.groups ?? [];
        
        // Default to first group if not selected
        if (_selectedGroup == null && groups.isNotEmpty) {
           // We keep it null until user selects or we can default it
           // For now let's keep it null to show hint
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //=======================> Event Image Section <============================
                Container(
                  height: 180.h,
                  width: 345.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: event.coverImage != null && event.coverImage!.isNotEmpty
                          ? NetworkImage(event.coverImage!)
                          : const AssetImage('assets/images/concert.jpg') as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(event.eventName ?? 'Unknown Event',
                        style: AppStyles.headTitle().copyWith(
                          fontSize: 15.sp,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.black,
                          decorationThickness: 1.0,
                        )),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildActionButton(AppIcons.editIcon, () {}),
                        SizedBox(width: 10.w),
                        Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.colorEDF2F4,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.done,
                              size: 20,
                              color: event.isVerified == true ? AppColors.primaryColor : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    _buildActionButton(AppIcons.share, () {
                      Get.toNamed(AppRoutes.myInvitationPage);
                    }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12.h),
                          _buildInfoRow('Program', event.program?.name ?? 'N/A'),
                          SizedBox(height: 17.h),
                          _buildInfoRow('Type', schedule?.eventType ?? 'N/A'),
                          SizedBox(height: 17.h),
                          _buildInfoRow('Location', event.location ?? 'N/A'),
                          SizedBox(height: 18.h),
                          _buildInfoRowWithDateTime('Deadline', _formatDate(schedule?.deadline), _formatTime(schedule?.deadline)),
                          SizedBox(height: 18.h),
                          _buildInfoRow('Final Deadline', schedule?.hasFinalDeadline == true ? _formatDate(schedule?.finalDeadline) : 'None'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12.h),
                          _buildInfoRow('Competition Level', schedule?.competitionLevel ?? 'N/A'),
                          SizedBox(height: 17.h),
                          _buildInfoRowWithDateTime('Registration Open', _formatDate(schedule?.registrationDate), _formatTime(schedule?.registrationDate)),
                          SizedBox(height: 17.h),
                          _buildInfoRow('Repeat Function', event.repeatConfig?.frequency ?? 'DontRepeat'),
                          SizedBox(height: 18.h),
                          _buildInfoRowWithCheck('Cost', '\$${schedule?.cost ?? "0"}'),
                          SizedBox(height: 18.h),
                          _buildInfoRowWithCheck('Late Fee', '\$${schedule?.lateFee ?? "0"}'),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Text(AppStrings.description,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 8.h),
                Text(
                  event.description ?? 'No description provided.',
                  maxLines: 20,
                  textAlign: TextAlign.start,
                  style: AppStyles.fieldContent(color: AppColors.color414141),
                ),
                SizedBox(height: 16.w),
                Text(AppStrings.note,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 8.h),
                Text(
                  event.note ?? 'No notes provided.',
                  maxLines: 20,
                  textAlign: TextAlign.start,
                  style: AppStyles.fieldContent(color: AppColors.color414141),
                ),
                SizedBox(height: 16.h),
                
                // Group Dropdown
                if (groups.isNotEmpty)
                InputDecorator(
                  decoration: InputDecoration(
                    fillColor: AppColors.fillColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.buttonColor, width: 1.w),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.buttonColor, width: 1.w),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.buttonColor, width: 1.w),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Group>(
                      padding: EdgeInsets.symmetric(vertical: 5.w),
                      iconDisabledColor: AppColors.primaryColor,
                      iconEnabledColor: AppColors.primaryColor,
                      isExpanded: true,
                      value: _selectedGroup,
                      style: AppStyles.fontSize18(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w500),
                      hint: CustomText(text: 'Select Group', fontsize: 13.sp),
                      icon: SvgPicture.asset(
                        AppIcons.downArrowIcon,
                        width: 16.w,
                        color: AppColors.blackColor,
                      ),
                      items: groups.map((Group group) {
                        return DropdownMenuItem<Group>(
                          value: group,
                          child: Text(group.name ?? 'Unnamed Group'),
                        );
                      }).toList(),
                      onChanged: (Group? newValue) {
                        setState(() {
                          _selectedGroup = newValue;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                
                // Display Rounds for Selected Group
                if (_selectedGroup != null && _selectedGroup!.rounds != null)
                  ..._selectedGroup!.rounds!.map((round) => _buildRoundSection(round)).toList(),

                // History Section
                Padding(
                  padding: EdgeInsets.only(left: 7.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(thickness: 1, color: Colors.grey),
                      Text('History',
                          style: AppStyles.fontSize12(fontWeight: FontWeight.w600).copyWith(fontSize: 13.sp)),
                      SizedBox(height: 8.h),
                      if (event.results == null || event.results!.isEmpty)
                        Text('No history available', style: TextStyle(color: AppColors.color414141, fontSize: 12.sp))
                      else
                        ...event.results!.map((result) => _buildHistoryItem(result.toString())).toList(),
                      
                      SizedBox(height: 16.h),
                      const Divider(thickness: 1, color: Colors.grey),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.w),
                          decoration: BoxDecoration(
                            color: AppColors.fillColor,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Estimation Total Cost: ${schedule?.estimatedCost?.totalEstimatedCost ?? 0}',
                                  style: AppStyles.fontSize14(
                                    color: AppColors.color414141,
                                    fontWeight: FontWeight.w500,
                                  ).copyWith(fontSize: 10.sp)),
                              SizedBox(width: 8.w),
                              SvgPicture.asset(AppIcons.editIcon, height: 12.w, width: 12.w),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      _buildCreatorSection(event),
                      SizedBox(height: 15.h),
                      Text('Has already contribute or verification by (${event.applicationCount ?? 0}) Users', style: TextStyle(fontSize: 12.sp)),
                      SizedBox(height: 10.h),
                      if (event.applicationCount != null && event.applicationCount! > 0)
                        _buildUserAvatars()
                      else
                        const SizedBox(),
                      SizedBox(height: 10.h),
                      Text('Latest active ${_getTimeAgo(event.updatedAt)}', style: TextStyle(fontSize: 13.sp, color: AppColors.color414141)),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildBottomButton("Edit & Verify", AppColors.fillColor, Colors.black, AppColors.buttonColor, () {}),
                          _buildBottomButton("Apply", AppColors.buttonColor, Colors.white, AppColors.buttonColor, () {
                            Get.toNamed(AppRoutes.appliedSearchEventListScreen);
                          }),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      CustomButton(
                          color: AppColors.colorD9A951,
                          borderColor: AppColors.colorD9A951,
                          textColor: AppColors.white,
                          onTap: () {},
                          text: 'Delete')
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildActionButton(String icon, VoidCallback onTap) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.colorEDF2F4,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(onTap: onTap, child: Center(child: SvgPicture.asset(icon))),
      ),
    );
  }

  Widget _buildRoundSection(Round round) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(AppIcons.myEventIcon, color: AppColors.primaryColor),
            SizedBox(width: 8.w),
            Text(round.roundType ?? 'Round', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
          ],
        ),
        SizedBox(height: 15.h),
        Padding(
          padding: EdgeInsets.only(left: 7.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRoundInfo('Deadline: ', _formatDate(round.deadline)),
                  _buildRoundInfo('Cost: ', '\$${round.cost ?? "0"}'),
                  _buildRoundCheck(),
                ],
              ),
              SizedBox(height: 8.h),
              _buildRoundInfo('Type: ', round.roundType ?? 'N/A'),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(AppIcons.dotIconForFamily),
                  SizedBox(width: 5.w),
                  Text('Description: ', style: TextStyle(fontWeight: FontWeight.w600)),
                  Expanded(
                    child: Text(round.description ?? 'No description', style: AppStyles.fontSize12()),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(thickness: 1, color: Colors.grey),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildRoundInfo(String label, String value) {
    return Row(
      children: [
        SvgPicture.asset(AppIcons.dotIconForFamily),
        SizedBox(width: 5.w),
        Text(label, style: AppStyles.fontSize12(fontWeight: FontWeight.w600)),
        Text(value, style: AppStyles.fontSize12()),
      ],
    );
  }

  Widget _buildRoundCheck() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(Icons.check, color: Colors.white, size: 10),
      padding: const EdgeInsets.all(4),
    );
  }

  Widget _buildHistoryItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Container(
            width: 6.w,
            height: 6.h,
            decoration: const BoxDecoration(color: Colors.blueGrey, shape: BoxShape.circle),
          ),
          SizedBox(width: 8.w),
          Text(text, style: TextStyle(color: AppColors.color414141)),
        ],
      ),
    );
  }

  Widget _buildCreatorSection(EventModel event) {
    final creator = event.creator;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text('Created By', style: GoogleFonts.poppins(fontSize: 12.sp, color: AppColors.color414141)),
            SizedBox(width: 8.w),
            CircleAvatar(
              radius: 20.r,
              backgroundImage: creator?.profilePicture != null
                  ? NetworkImage(creator!.profilePicture!)
                  : const NetworkImage('https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg'),
            ),
          ],
        ),
        Text('Created at\n${_formatDate(event.createdAt)}',
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(fontSize: 12.sp, color: AppColors.color414141)),
      ],
    );
  }

  Widget _buildUserAvatars() {
    // Show some placeholder avatars for now if count > 0, as real avatar list is not in response
    return Row(
      children: [
        _buildAvatar('https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg', 0),
        _buildAvatar('https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400', -15),
        _buildAvatar('https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', -30),
        _buildAvatar('https://images.pexels.com/photos/733872/pexels-photo-733872.jpeg?auto=compress&cs=tinysrgb&w=400', -50),
      ],
    );
  }

  Widget _buildAvatar(String url, double offset) {
    return Transform.translate(
      offset: Offset(offset, 0),
      child: CircleAvatar(
        radius: 20.r,
        backgroundImage: NetworkImage(url),
      ),
    );
  }

  Widget _buildBottomButton(String text, Color color, Color textColor, Color borderColor, VoidCallback onTap) {
    return SizedBox(
        width: 164.w,
        child: CustomButton(
          borderColor: borderColor,
          onTap: onTap,
          text: text,
          color: color,
          textColor: textColor,
        ));
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(children: [SizedBox(height: 4.h), SvgPicture.asset(AppIcons.dotIconForFamily, height: 12.h, width: 12.h)]),
        SizedBox(width: 5.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 5.h),
              Text(value, style: AppStyles.fieldContent(color: Colors.grey.shade600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRowWithDateTime(String label, String date, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(children: [SizedBox(height: 4.h), SvgPicture.asset(AppIcons.dotIconForFamily, height: 12.h, width: 12.h)]),
        SizedBox(width: 5.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 5.h),
              Row(children: [
                Text(date, style: AppStyles.fieldContent(color: Colors.grey.shade600)),
                SizedBox(width: 5.w),
                Text(time, style: AppStyles.fieldContent(color: Colors.grey.shade600)),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRowWithCheck(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [SizedBox(height: 4.h), SvgPicture.asset(AppIcons.dotIconForFamily, height: 12.h, width: 12.h)]),
            SizedBox(width: 5.w),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                  Container(
                    decoration: BoxDecoration(color: Colors.blueGrey, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(4)),
                    child: const Icon(Icons.check, color: Colors.white, size: 10),
                    padding: const EdgeInsets.all(4),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Padding(
          padding: EdgeInsets.only(left: 17.w),
          child: Text(value, style: AppStyles.fieldContent(color: Colors.grey.shade600)),
        ),
      ],
    );
  }
}
