import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/api_constants.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/style.dart';
import '../../../services/api_service.dart';
import '../../base/custom_button.dart';
import '../../base/custom_text.dart';
import '../../base/custom_text_field.dart';
import 'InnerWidget/dotted_border_container.dart';
import 'controller/addEventController.dart';

// ─── Models ─────────────────────────────────────────────────────────────────

class CategoryModel {
  final String id;
  final String name;
  final String? imageUrl;
  CategoryModel({required this.id, required this.name, this.imageUrl});
  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'],
        name: json['name'],
        imageUrl: json['imageUrl'] ?? json['image'],
      );
}

class SubCategoryModel {
  final String id;
  final String name;
  final String? imageUrl;
  SubCategoryModel({required this.id, required this.name, this.imageUrl});
  factory SubCategoryModel.fromJson(Map<String, dynamic> json) =>
      SubCategoryModel(
        id: json['id'],
        name: json['name'],
        imageUrl: json['imageUrl'] ?? json['image'],
      );
}

class ProgramModel {
  final String id;
  final String name;
  ProgramModel({required this.id, required this.name});
  factory ProgramModel.fromJson(Map<String, dynamic> json) =>
      ProgramModel(id: json['id'], name: json['name']);
}

// ─── Form ────────────────────────────────────────────────────────────────────

class Steponeform extends StatefulWidget {
  const Steponeform({super.key});

  @override
  State<Steponeform> createState() => _SteponeformState();
}

class _SteponeformState extends State<Steponeform> {
  final TextEditingController organizerController = TextEditingController();
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventPortalController = TextEditingController();
  final TextEditingController registrationPortalController = TextEditingController();
  final TextEditingController descriptionCRTL = TextEditingController();
  final TextEditingController noteCRTL = TextEditingController();
  final TextEditingController sessionNumberController = TextEditingController();
  final TextEditingController programController = TextEditingController();

  Uint8List? coverImage;
  ProgramModel? _selectedProgram;

  List<String> get yearList {
    final currentYear = DateTime.now().year;
    return List.generate(9, (i) => (currentYear - 4 + i).toString());
  }

  final List<String> sessionFrequencyList = ['Daily', 'Weekly', 'Monthly', 'Quarterly', 'Yearly'];
  final Map<String, List<String>> sessionSubOptions = {
    'Daily': ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
    'Weekly': ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
    'Monthly': ['January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'],
    'Quarterly': ['Q1', 'Q2', 'Q3', 'Q4'],
    'Yearly': [],
  };

  bool _isRepeated = false;
  String? _selectedRepeatOption;
  final List<String> repeatOptions = ["Don't Repeat", 'Daily', 'Weekly', 'Monthly', 'Quarterly', 'Yearly'];
  String? _selectedYear;
  String? _selectedSessionFrequency;
  String? _selectedSessionSubOption;

  final Addeventcontroller addEventController = Get.find<Addeventcontroller>();
  final ApiService _apiService = Get.find<ApiService>();

  @override
  void initState() {
    super.initState();
    // Initialize from controller
    _isRepeated = addEventController.isRepeated.value;
    _selectedRepeatOption = addEventController.repeatOption;
    sessionNumberController.text = addEventController.sessionNumber ?? "";
    _selectedYear = addEventController.year;
    _selectedSessionFrequency = addEventController.sessionFrequency;
    _selectedSessionSubOption = addEventController.sessionSubOption;
    organizerController.text = addEventController.organizer ?? "";
    eventNameController.text = addEventController.eventName ?? "";
    eventPortalController.text = addEventController.eventPortal ?? "";
    registrationPortalController.text = addEventController.registrationPortal ?? "";
    descriptionCRTL.text = addEventController.description ?? "";
    noteCRTL.text = addEventController.note ?? "";
    // Edit mode: prefill program name from the existing event
    if (addEventController.programId != null && addEventController.programName != null) {
      _selectedProgram = ProgramModel(
        id: addEventController.programId!,
        name: addEventController.programName!,
      );
      programController.text = addEventController.programName!;
    }
  }

  // ─── API calls ────────────────────────────────────────────────────────────

  Future<List<CategoryModel>> _fetchCategories() async {
    final body = await _apiService.get(ApiConstants.categoriesEvent);
    return (body['data'] as List)
        .map((e) => CategoryModel.fromJson(e))
        .toList();
  }

  Future<List<SubCategoryModel>> _fetchSubCategories(String categoryId) async {
    final url = '${ApiConstants.apiUrl}/subcategories?categoryId=$categoryId';
    final body = await _apiService.get(url);
    return (body['data'] as List)
        .map((e) => SubCategoryModel.fromJson(e))
        .toList();
  }

  Future<List<ProgramModel>> _fetchProgramsByCategory(String categoryId) async {
    final url = '${ApiConstants.apiUrl}/programs?categoryId=$categoryId';
    final body = await _apiService.get(url);
    return (body['data'] as List)
        .map((e) => ProgramModel.fromJson(e))
        .toList();
  }

  Future<List<ProgramModel>> _fetchProgramsBySubCategory(String subcategoryId) async {
    final url = '${ApiConstants.apiUrl}/programs?subcategoryId=$subcategoryId';
    final body = await _apiService.get(url);
    return (body['data'] as List)
        .map((e) => ProgramModel.fromJson(e))
        .toList();
  }

  // ─── Popup flow ──────────────────────────────────────────────────────────

  Future<void> _openCategoryPopup() async {
    _showLoadingDialog();
    List<CategoryModel> categories = [];
    try {
      categories = await _fetchCategories();
    } catch (e) {
      _dismissLoading();
      _showErrorSnack('Failed to load categories: $e');
      return;
    }
    _dismissLoading();
    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SelectionPopup(
        title: 'Select Category',
        items: categories.map((c) => _PopupItem(id: c.id, name: c.name)).toList(),
        onSelect: (item) async {
          Navigator.pop(context);
          await _handleCategorySelected(item.id);
        },
      ),
    );
  }

  Future<void> _handleCategorySelected(String categoryId) async {
    _showLoadingDialog();
    List<SubCategoryModel> subCategories = [];
    try {
      subCategories = await _fetchSubCategories(categoryId);
    } catch (e) {
      _dismissLoading();
      _showErrorSnack('Failed to load subcategories: $e');
      return;
    }
    _dismissLoading();
    if (!mounted) return;

    if (subCategories.isEmpty) {
      await _openProgramPopup(categoryId: categoryId);
    } else {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _SelectionPopup(
          title: 'Select Sub Category',
          items: subCategories.map((s) => _PopupItem(id: s.id, name: s.name)).toList(),
          onSelect: (item) async {
            Navigator.pop(context);
            await _openProgramPopup(subcategoryId: item.id);
          },
        ),
      );
    }
  }

  Future<void> _openProgramPopup({String? categoryId, String? subcategoryId}) async {
    _showLoadingDialog();
    List<ProgramModel> programs = [];
    try {
      programs = subcategoryId != null
          ? await _fetchProgramsBySubCategory(subcategoryId)
          : await _fetchProgramsByCategory(categoryId!);
    } catch (e) {
      _dismissLoading();
      _showErrorSnack('Failed to load programs: $e');
      return;
    }
    _dismissLoading();
    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SelectionPopup(
        title: 'Select Program',
        items: programs.map((p) => _PopupItem(id: p.id, name: p.name)).toList(),
        onSelect: (item) {
          Navigator.pop(context);
          setState(() {
            _selectedProgram = ProgramModel(id: item.id, name: item.name);
            programController.text = item.name;
          });
        },
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
  }

  void _dismissLoading() {
    if (mounted) Navigator.of(context, rootNavigator: true).pop();
  }

  void _showErrorSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red.shade600));
  }

  Future _pickImage(Function(Uint8List) setImage) async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final bytes = await pickedImage.readAsBytes();
      addEventController.coverImagePath = pickedImage.path;
      addEventController.coverImageBytes = bytes;
      addEventController.coverImageFileName = pickedImage.name;
      setImage(bytes);
    }
  }

  void _updateSessionNumber() {
    String year = _selectedYear ?? "";
    String session = _selectedSessionSubOption ?? _selectedSessionFrequency ?? "";
    if (year.isNotEmpty && session.isNotEmpty) {
      if (session == 'Yearly') {
        sessionNumberController.text = year;
      } else {
        sessionNumberController.text = '$year-$session';
      }
    } else if (year.isNotEmpty) {
      sessionNumberController.text = year;
    }
  }

  void _saveDataToController() {
    addEventController.isRepeated.value = _isRepeated;
    addEventController.repeatOption = _selectedRepeatOption;
    addEventController.sessionNumber = sessionNumberController.text;
    addEventController.year = _selectedYear;
    addEventController.sessionFrequency = _selectedSessionFrequency;
    addEventController.sessionSubOption = _selectedSessionSubOption;
    addEventController.programId = _selectedProgram?.id;
    addEventController.programName = _selectedProgram?.name; // keep name for re-init
    addEventController.organizer = organizerController.text;
    addEventController.eventName = eventNameController.text;
    addEventController.eventPortal = eventPortalController.text;
    addEventController.registrationPortal = registrationPortalController.text;
    addEventController.description = descriptionCRTL.text;
    addEventController.note = noteCRTL.text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("This is a shared community. All events are public", style: AppStyles.fontSize12(color: AppColors.colorD9A951)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Step 1: Basic', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          ),
          DottedBorderContainer(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: coverImage != null
                  ? Image.memory(coverImage!, fit: BoxFit.cover)
                  : (addEventController.existingCoverImageUrl != null &&
                          addEventController.existingCoverImageUrl!.isNotEmpty)
                      ? GestureDetector(
                          onTap: () => _pickImage((img) => setState(() => coverImage = img)),
                          child: Image.network(
                            addEventController.existingCoverImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _addImageButton(() => _pickImage((img) => setState(() => coverImage = img))),
                          ),
                        )
                      : _addImageButton(() => _pickImage((img) => setState(() => coverImage = img))),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Text('Is Repeated ?', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                if (_isRepeated && _selectedRepeatOption != null) ...[
                  SizedBox(width: 8.w),
                  Text('($_selectedRepeatOption)', style: TextStyle(fontSize: 12.sp, color: const Color(0xFF4C7E95), fontWeight: FontWeight.w500)),
                ]
              ]),
              GestureDetector(
                onTap: () => setState(() { _isRepeated = !_isRepeated; if (!_isRepeated) _selectedRepeatOption = null; }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 46.w, height: 26.h,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(13.r), color: _isRepeated ? const Color(0xFF4C7E95) : Colors.grey.shade400),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: _isRepeated ? Alignment.centerRight : Alignment.centerLeft,
                    child: Padding(padding: EdgeInsets.symmetric(horizontal: 3.w), child: Container(width: 20.w, height: 20.h, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white))),
                  ),
                ),
              ),
            ],
          ),

          if (_isRepeated) ...[
            SizedBox(height: 12.h),
            _buildDropdown(value: _selectedRepeatOption, hint: 'Select Repeat Option', items: repeatOptions, onChanged: (v) => setState(() => _selectedRepeatOption = v)),
          ],

          SizedBox(height: 23.h),

          if (!_isRepeated)
            DottedBorderContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Session Number', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                    SizedBox(height: 8.h),
                    CustomTextField(controller: sessionNumberController, hintText: 'Enter Session Number', height: 50.h),
                    SizedBox(height: 12.h),
                    Row(children: [
                      Expanded(child: Text('Year', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600))),
                      SizedBox(width: 8.w),
                      Expanded(child: Text('Session', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600))),
                    ]),
                    Row(children: [
                      Expanded(child: _buildDropdown(value: _selectedYear, hint: 'Year', items: yearList, onChanged: (v) => setState(() { _selectedYear = v; _updateSessionNumber(); }))),
                      SizedBox(width: 8.w),
                      Expanded(child: _buildDropdown(value: _selectedSessionFrequency, hint: 'Session', items: sessionFrequencyList, onChanged: (v) => setState(() { _selectedSessionFrequency = v; _selectedSessionSubOption = null; _updateSessionNumber(); }))),
                    ]),
                    if (_selectedSessionFrequency != null && (sessionSubOptions[_selectedSessionFrequency!]?.isNotEmpty ?? false)) ...[
                      SizedBox(height: 12.h),
                      Text(_selectedSessionFrequency!, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                      SizedBox(height: 8.h),
                      _buildDropdown(value: _selectedSessionSubOption, hint: 'Select ${_selectedSessionFrequency!}', items: sessionSubOptions[_selectedSessionFrequency!]!, onChanged: (v) => setState(() { _selectedSessionSubOption = v; _updateSessionNumber(); })),
                    ],
                  ],
                ),
              ),
            ),

          SizedBox(height: 16.h),
          Text('Program', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: _openCategoryPopup,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(color: AppColors.fillColor, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: AppColors.primaryColor, width: 1)),
              height: 50.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(programController.text.isEmpty ? 'Select Program' : programController.text, style: AppStyles.fontSize14(color: programController.text.isEmpty ? AppColors.color414141 : Colors.black)),
                  SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.primaryColor),
                ],
              ),
            ),
          ),

          SizedBox(height: 16.h),
          Text('Organizer', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          CustomTextField(controller: organizerController, hintText: 'Type Organizer', height: 50.h),

          SizedBox(height: 16.h),
          Text('Event Name', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          CustomTextField(controller: eventNameController, hintText: 'Type Event Name', height: 50.h),

          SizedBox(height: 16.h),
          Text('Event Portal', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          CustomTextField(controller: eventPortalController, hintText: 'Type Event Portal', height: 50.h),

          SizedBox(height: 16.h),
          Text('Registration Portal', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          CustomTextField(controller: registrationPortalController, hintText: 'Type Registration Portal', height: 50.h),

          SizedBox(height: 16.h),
          Text('Description', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          CustomTextField(maxLines: 3, controller: descriptionCRTL, hintText: 'Type your Description...'),

          SizedBox(height: 16.h),
          Text('Note', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          CustomTextField(maxLines: 3, controller: noteCRTL, hintText: 'Type your event note'),

          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 166.w, child: CustomButton(onTap: () { if (addEventController.activeStepIndex.value > 0) addEventController.activeStepIndex.value--; }, text: "Back", borderColor: AppColors.buttonColor, color: AppColors.fillColor, textColor: Colors.black)),
              SizedBox(width: 166.w, child: CustomButton(onTap: () { _saveDataToController(); if (addEventController.activeStepIndex.value < 4) addEventController.activeStepIndex.value++; }, text: "Next", borderColor: AppColors.buttonColor, textColor: Colors.white, color: AppColors.buttonColor)),
            ],
          ),
          SizedBox(height: 25.h),
        ],
      ),
    );
  }

  Widget _buildDropdown({required String? value, required String hint, required List<String> items, required void Function(String?) onChanged}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(color: AppColors.fillColor, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: AppColors.primaryColor, width: 1)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value, dropdownColor: AppColors.fillColor, borderRadius: BorderRadius.circular(8.r),
          hint: Text(hint, style: AppStyles.fontSize14(color: AppColors.color414141)),
          icon: SvgPicture.asset(AppIcons.downArrowIcon, width: 16.w, color: AppColors.primaryColor),
          isExpanded: true,
          items: items.map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(color: Colors.black)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _addImageButton(VoidCallback onPressed) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(onPressed: onPressed, icon: Icon(Icons.add_circle_outlined, color: AppColors.primaryColor, size: 20.w)),
          CustomText(text: AppStrings.addCoverPhoto, color: Colors.grey),
        ]));
  }
}

class _PopupItem { final String id; final String name; _PopupItem({required this.id, required this.name}); }

class _SelectionPopup extends StatelessWidget {
  final String title; final List<_PopupItem> items; final void Function(_PopupItem item) onSelect;
  const _SelectionPopup({required this.title, required this.items, required this.onSelect});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w, bottom: MediaQuery.of(context).viewInsets.bottom + 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2.r)))),
          SizedBox(height: 16.h),
          Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
          SizedBox(height: 12.h),
          if (items.isEmpty) Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 32.h), child: Text('No items available', style: TextStyle(fontSize: 14.sp, color: Colors.grey))))
          else ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 320.h),
              child: ListView.separated(
                shrinkWrap: true, itemCount: items.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
                itemBuilder: (_, index) {
                  final item = items[index];
                  return InkWell(onTap: () => onSelect(item), borderRadius: BorderRadius.circular(8.r), child: Padding(padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w), child: Text(item.name, style: TextStyle(fontSize: 14.sp, color: Colors.black87))));
                },
              ),
            ),
        ],
      ),
    );
  }
}
