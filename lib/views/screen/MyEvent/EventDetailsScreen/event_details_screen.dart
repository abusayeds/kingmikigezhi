import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/models/event_model.dart';
import 'package:event_sharing/services/api_service.dart';
import 'package:event_sharing/utils/api_constants.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/app_images.dart';
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
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  EventModel? event;
  bool isLoading = true;
  String? error;
  String? _createdAtDisplay;

  final List<String> _agesList = [
    'Age up to 10 years old',
    'Age up to 15 years old'
  ];
  String? _selectedAge;

  @override
  void initState() {
    super.initState();
    _fetchEventDetails();
  }

  String? _formatCreatedAtOnly(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) {
      return DateFormat('yyyy-MM-dd').format(value.toUtc());
    }
    final raw = value.toString().trim();
    if (raw.isEmpty) return null;
    final parsed = DateTime.tryParse(raw);
    if (parsed != null) {
      return DateFormat('yyyy-MM-dd').format(parsed.toUtc());
    }
    // Fallback for ISO strings like 2026-06-22T09:28:46.091Z
    if (raw.length >= 10 && RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(raw)) {
      return raw.substring(0, 10);
    }
    return null;
  }

  Future<void> _fetchEventDetails() async {
    final dynamic args = Get.arguments;
    String? eventId;
    EventModel? argEvent;

    if (args is EventModel) {
      eventId = args.id;
      argEvent = args;
      _createdAtDisplay = _formatCreatedAtOnly(args.createdAt);
    } else if (args is String) {
      eventId = args;
    } else if (args is Map) {
      eventId = args['id']?.toString() ?? args['eventId']?.toString();
      _createdAtDisplay = _formatCreatedAtOnly(args['createdAt'] ?? args['created_at']);
    }

    if (eventId == null) {
      setState(() {
        isLoading = false;
        error = 'No event ID provided';
      });
      return;
    }

    try {
      final apiService = Get.find<ApiService>();
      final response = await apiService.get(
        ApiConstants.getEventsDetails.replaceAll(':eventId', eventId),
      );

      if (response['success'] == true) {
        final rawData = response['data'];
        final Map<String, dynamic> data = rawData is Map<String, dynamic>
            ? rawData
            : Map<String, dynamic>.from(rawData as Map);

        final parsedEvent = EventModel.fromJson(data);
        final createdAtFromApi = _formatCreatedAtOnly(
          parsedEvent.createdAt ?? data['createdAt'] ?? data['created_at'],
        );

        setState(() {
          event = parsedEvent;
          _createdAtDisplay = createdAtFromApi ??
              _formatCreatedAtOnly(argEvent?.createdAt) ??
              _createdAtDisplay;
          isLoading = false;
        });
      } else {
        setState(() {
          error = response['message'] ?? 'Failed to load event details';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('d-M-yyyy').format(date);
  }

  String _formatTime(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (error != null) {
      return Scaffold(body: Center(child: Text(error!, style: const TextStyle(color: Colors.red))));
    }

    if (event == null) {
      return const Scaffold(body: Center(child: Text('Event not found')));
    }

    final schedule = event!.schedule;
    final program = event!.program;
    final creator = event!.creator;

    return Scaffold(
      //=======================> App Bar Section <============================
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
      //=======================> Body Section <============================
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //=======================> Event Image Section <============================
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: event!.coverImage != null &&
                            event!.coverImage!.isNotEmpty
                        ? Image.network(
                            event!.coverImage!,
                            height: 180.h,
                            width: 345.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              AppImages.logo,
                              height: 180.h,
                              width: 345.w,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            AppImages.logo,
                            height: 180.h,
                            width: 345.w,
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(event!.eventName ?? 'Unknown Event',
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
                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.colorEDF2F4,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () {},
                              child: Center(child: SvgPicture.asset(AppIcons.editIcon))),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.colorEDF2F4,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: Center(
                              child: Icon(
                                size: 20,
                                Icons.done,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.colorEDF2F4,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.myInvitationPage);
                          },
                          child: SvgPicture.asset(AppIcons.share)),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12.h),
                            _buildInfoRow('Program', program?.name ?? 'N/A'),
                            SizedBox(height: 17.h),
                            _buildInfoRow('Type', schedule?.eventType ?? 'N/A'),
                            SizedBox(height: 17.h),
                            _buildInfoRow('Location', event!.location ?? 'N/A'),
                            SizedBox(height: 18.h),
                            _buildInfoRowWithDateTime(
                                'Deadline',
                                _formatDate(schedule?.deadline),
                                _formatTime(schedule?.deadline)),
                            SizedBox(height: 18.h),
                            _buildInfoRow('Final Deadline', _formatDate(schedule?.finalDeadline)),
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
                            _buildInfoRowWithDateTime(
                                'Registration Open',
                                _formatDate(schedule?.registrationDate),
                                _formatTime(schedule?.registrationDate)),
                            SizedBox(height: 17.h),
                            _buildInfoRow('Repeat Function', event!.repeatConfig?.frequency ?? 'Never'),
                            SizedBox(height: 18.h),
                            _buildInfoRowWithCheck('Cost', '\$${schedule?.cost ?? '0'}'),
                            SizedBox(height: 18.h),
                            _buildInfoRowWithCheck('Late Fee', '\$${schedule?.lateFee ?? '0'}'),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 24.h),
              Text(AppStrings.description,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
              Text(
                event!.description ?? 'No description available',
                maxLines: 20,
                textAlign: TextAlign.start,
                style: AppStyles.fieldContent(color: AppColors.color414141),
              ),
              SizedBox(height: 16.w),
              Text(AppStrings.note,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
              Text(
                event!.note ?? 'No note available',
                maxLines: 20,
                textAlign: TextAlign.start,
                style: AppStyles.fieldContent(color: AppColors.color414141),
              ),
              SizedBox(height: 16.h),
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
                  child: DropdownButton<String>(
                    padding: EdgeInsets.symmetric(vertical: 5.w),
                    iconDisabledColor: AppColors.primaryColor,
                    iconEnabledColor: AppColors.primaryColor,
                    isExpanded: true,
                    value: _selectedAge,
                    style: AppStyles.fontSize18(
                        color: AppColors.blackColor, fontWeight: FontWeight.w500),
                    hint: CustomText(text: 'Select Ages', fontsize: 13.sp),
                    icon: SvgPicture.asset(
                      AppIcons.downArrowIcon,
                      width: 16.w,
                      color: AppColors.blackColor,
                    ),
                    items: (event?.groups?.map((g) => g.name ?? 'Group').toList() ?? [])
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedAge = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              if (event?.groups != null)
                ...event!.groups!
                    .where((group) =>
                        _selectedAge == null ||
                        _selectedAge == (group.name ?? 'Group'))
                    .map((group) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text('${group.name ?? 'Group'} (Value: ${group.value ?? 0})',
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
                      ),
                      if (group.rounds != null)
                        ...group.rounds!.map((round) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.myEventIcon,
                                    color: AppColors.primaryColor,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(round.roundType ?? 'Round',
                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
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
                                        Row(
                                          children: [
                                            SvgPicture.asset(AppIcons.dotIconForFamily),
                                            SizedBox(width: 5.w),
                                            Text('Deadline: ',
                                                style: AppStyles.fontSize12(fontWeight: FontWeight.w600)),
                                            Text(_formatDate(round.deadline), style: AppStyles.fontSize12()),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(AppIcons.dotIconForFamily),
                                            const SizedBox(width: 5),
                                            Text('Cost: ',
                                                style: AppStyles.fontSize12(fontWeight: FontWeight.w600)),
                                            Text('\$${round.cost ?? '0'}', style: AppStyles.fontSize12()),
                                            const SizedBox(width: 10),
                                          ],
                                        ),
                                        if (round.hasFinalDeadline == true)
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.blueGrey,
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            padding: const EdgeInsets.all(4),
                                            child: const Icon(Icons.check, color: Colors.white, size: 10),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      children: [
                                        SvgPicture.asset(AppIcons.dotIconForFamily),
                                        const SizedBox(width: 5),
                                        Text('Description: ',
                                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp)),
                                        Expanded(
                                          child: Text(round.description ?? 'N/A',
                                              style: AppStyles.fontSize12()),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          );
                        }),
                    ],
                  );
                }),
              SizedBox(height: 16.h),
              // ── Previous Events / History ──────────────────────────
              if (event!.previousEvents != null && event!.previousEvents!.isNotEmpty) ...[
                const Divider(thickness: 1, color: Colors.grey),
                SizedBox(height: 8.h),
                Text(
                  'History :',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: event!.previousEvents!.map((prev) {
                    // Extract year from the date field if available
                    final yearStr = prev.date != null
                        ? prev.date!.year.toString()
                        : '';
                    final record = prev.recordName ?? '';
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        children: [
                          SvgPicture.asset(AppIcons.dotIconForFamily),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: Text(
                              yearStr.isNotEmpty
                                  ? '$yearStr - $record'
                                  : record,
                              style: AppStyles.fieldContent(
                                  color: AppColors.color414141),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 15.h),
              ],
              const Divider(thickness: 1, color: Colors.grey),
              Padding(
                padding: EdgeInsets.only(left: 7.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estimation Total Cost',
                        style: AppStyles.fontSize12(fontWeight: FontWeight.w600).copyWith(fontSize: 13.sp)),
                    SizedBox(height: 8.h),
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('Created By',
                                style: GoogleFonts.poppins(fontSize: 12.sp, color: AppColors.color414141)),
                            SizedBox(width: 8.w),
                            CircleAvatar(
                              radius: 30.r,
                              backgroundImage: AssetImage(AppImages.logo),
                              foregroundImage: (creator?.profilePicture?.isNotEmpty ?? false)
                                  ? NetworkImage(creator!.profilePicture!)
                                  : null,
                              onForegroundImageError: (_, __) {},
                            ),
                          ],
                        ),
                        Text(
                          'Created at\n${_createdAtDisplay ?? 'N/A'}',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(fontSize: 12.sp, color: AppColors.color414141),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      'Has already contribute or verification by (${event!.eventApplieds?.length ?? 0}) Users',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: (event!.eventApplieds?.take(4).map((applied) {
                            return Transform.translate(
                              offset: Offset(-(event!.eventApplieds!.indexOf(applied) * 15.0), 0),
                              child: CircleAvatar(
                                radius: 25.r,
                                backgroundImage: AssetImage(AppImages.logo),
                              ),
                            );
                          }).toList() ??
                          []),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Latest active ${_formatDate(event!.updatedAt)}',
                      style: TextStyle(fontSize: 13.sp, color: AppColors.color414141),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: 164.w,
                            child: CustomButton(
                              borderColor: AppColors.buttonColor,
                              onTap: () async {
                                // Wait for the edit screen to finish.
                                // If the update succeeded, the controller passes
                                // back the fresh EventModel as the navigation result.
                                final result = await Get.toNamed(
                                  AppRoutes.createEventOne,
                                  arguments: event,
                                );
                                if (!mounted) return;
                                if (result is EventModel) {
                                  // Instantly update the UI with the fresh data
                                  // returned from the update API response.
                                  setState(() {
                                    event = result;
                                    _createdAtDisplay = _formatCreatedAtOnly(result.createdAt);
                                  });
                                } else {
                                  // Fallback: re-fetch from API in case result
                                  // wasn't an EventModel (e.g. back without saving)
                                  _fetchEventDetails();
                                }
                              },
                              text: "Edit & Verify",
                              color: AppColors.fillColor,
                              textColor: Colors.black,
                            )),
                        SizedBox(
                            width: 164.w,
                            child: CustomButton(
                              onTap: () {
                                Get.toNamed(AppRoutes.appliedSearchEventListScreen, arguments: event);
                              },
                              text: "Apply",
                              textColor: Colors.white,
                              color: AppColors.buttonColor,
                            )),
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
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(children: [
          SizedBox(height: 4.h),
          SvgPicture.asset(AppIcons.dotIconForFamily, height: 12.h, width: 12.h)
        ]),
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
        Column(children: [
          SizedBox(height: 4.h),
          SvgPicture.asset(AppIcons.dotIconForFamily, height: 12.h, width: 12.h)
        ]),
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
            Column(children: [
              SizedBox(height: 4.h),
              SvgPicture.asset(AppIcons.dotIconForFamily, height: 12.h, width: 12.h)
            ]),
            SizedBox(width: 5.w),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(Icons.check, color: Colors.white, size: 10),
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
