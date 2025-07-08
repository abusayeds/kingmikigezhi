import 'package:event_sharing/utils/style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../helpers/route.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_strings.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_text.dart';
import '../../../base/custom_text_field.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isChecked = false;
  String? selectedGender;
  String? selectedYear;
  String? selectedMonth;
  String? selectedDay;
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  List<String> genderList = ['Male', 'Female'];

  // Birthday dropdown data
  List<String> yearList = List.generate(100, (index) => (2024 - index).toString());
  List<String> monthList = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  List<String> dayList = List.generate(31, (index) => (index + 1).toString().padLeft(2, '0'));

  // Location dropdown data
  List<String> countryList = [
    'United States', 'Canada', 'United Kingdom', 'Australia', 'Germany',
    'France', 'Japan', 'South Korea', 'India', 'Brazil', 'Mexico', 'Italy',
    'Spain', 'Netherlands', 'Sweden', 'Norway', 'Denmark', 'Switzerland'
  ];

  Map<String, List<String>> stateMap = {
    'United States': ['California', 'Texas', 'Florida', 'New York', 'Illinois'],
    'Canada': ['Ontario', 'Quebec', 'British Columbia', 'Alberta', 'Manitoba'],
    'United Kingdom': ['England', 'Scotland', 'Wales', 'Northern Ireland'],
    'Australia': ['New South Wales', 'Victoria', 'Queensland', 'Western Australia'],
    'Germany': ['Bavaria', 'North Rhine-Westphalia', 'Baden-Württemberg', 'Lower Saxony'],
    'France': ['Île-de-France', 'Provence-Alpes-Côte d\'Azur', 'Auvergne-Rhône-Alpes', 'Occitanie'],
    'Japan': ['Tokyo', 'Osaka', 'Kyoto', 'Hokkaido', 'Fukuoka'],
    'South Korea': ['Seoul', 'Busan', 'Incheon', 'Daegu', 'Daejeon'],
    'India': ['Maharashtra', 'Karnataka', 'Tamil Nadu', 'Delhi', 'Gujarat'],
    'Brazil': ['São Paulo', 'Rio de Janeiro', 'Minas Gerais', 'Bahia', 'Paraná'],
    'Mexico': ['Mexico City', 'Jalisco', 'Nuevo León', 'Puebla', 'Guanajuato'],
    'Italy': ['Lombardy', 'Lazio', 'Campania', 'Sicily', 'Veneto'],
    'Spain': ['Madrid', 'Catalonia', 'Andalusia', 'Valencia', 'Galicia'],
    'Netherlands': ['North Holland', 'South Holland', 'Utrecht', 'Gelderland', 'North Brabant'],
    'Sweden': ['Stockholm', 'Västra Götaland', 'Skåne', 'Uppsala', 'Östergötland'],
    'Norway': ['Oslo', 'Rogaland', 'Møre og Romsdal', 'Nordland', 'Viken'],
    'Denmark': ['Capital Region', 'Central Denmark', 'North Denmark', 'Zealand', 'Southern Denmark'],
    'Switzerland': ['Zurich', 'Bern', 'Vaud', 'Aargau', 'St. Gallen'],
  };

  Map<String, List<String>> cityMap = {
    // United States
    'California': ['Los Angeles', 'San Francisco', 'San Diego', 'Sacramento'],
    'Texas': ['Houston', 'Dallas', 'Austin', 'San Antonio'],
    'Florida': ['Miami', 'Orlando', 'Tampa', 'Jacksonville'],
    'New York': ['New York City', 'Buffalo', 'Rochester', 'Syracuse'],
    'Illinois': ['Chicago', 'Aurora', 'Peoria', 'Springfield'],

    // Canada
    'Ontario': ['Toronto', 'Ottawa', 'Hamilton', 'London'],
    'Quebec': ['Montreal', 'Quebec City', 'Laval', 'Gatineau'],
    'British Columbia': ['Vancouver', 'Victoria', 'Surrey', 'Burnaby'],
    'Alberta': ['Calgary', 'Edmonton', 'Red Deer', 'Lethbridge'],
    'Manitoba': ['Winnipeg', 'Brandon', 'Steinbach', 'Thompson'],

    // United Kingdom
    'England': ['London', 'Manchester', 'Birmingham', 'Liverpool'],
    'Scotland': ['Edinburgh', 'Glasgow', 'Aberdeen', 'Dundee'],
    'Wales': ['Cardiff', 'Swansea', 'Newport', 'Wrexham'],
    'Northern Ireland': ['Belfast', 'Londonderry', 'Lisburn', 'Newtownabbey'],

    // Australia
    'New South Wales': ['Sydney', 'Newcastle', 'Wollongong', 'Albury'],
    'Victoria': ['Melbourne', 'Geelong', 'Ballarat', 'Bendigo'],
    'Queensland': ['Brisbane', 'Gold Coast', 'Townsville', 'Cairns'],
    'Western Australia': ['Perth', 'Fremantle', 'Bunbury', 'Geraldton'],

    // Germany
    'Bavaria': ['Munich', 'Nuremberg', 'Augsburg', 'Würzburg'],
    'North Rhine-Westphalia': ['Cologne', 'Düsseldorf', 'Dortmund', 'Essen'],
    'Baden-Württemberg': ['Stuttgart', 'Mannheim', 'Karlsruhe', 'Freiburg'],
    'Lower Saxony': ['Hanover', 'Braunschweig', 'Oldenburg', 'Osnabrück'],

    // France
    'Île-de-France': ['Paris', 'Boulogne-Billancourt', 'Saint-Denis', 'Argenteuil'],
    'Provence-Alpes-Côte d\'Azur': ['Marseille', 'Nice', 'Toulon', 'Aix-en-Provence'],
    'Auvergne-Rhône-Alpes': ['Lyon', 'Grenoble', 'Saint-Étienne', 'Villeurbanne'],
    'Occitanie': ['Toulouse', 'Montpellier', 'Nîmes', 'Perpignan'],

    // Japan
    'Tokyo': ['Shibuya', 'Shinjuku', 'Harajuku', 'Ginza'],
    'Osaka': ['Osaka City', 'Sakai', 'Higashiosaka', 'Hirakata'],
    'Kyoto': ['Kyoto City', 'Uji', 'Kameoka', 'Nagaokakyo'],
    'Hokkaido': ['Sapporo', 'Hakodate', 'Asahikawa', 'Kushiro'],
    'Fukuoka': ['Fukuoka City', 'Kitakyushu', 'Kurume', 'Omuta'],

    // South Korea
    'Seoul': ['Gangnam', 'Jongno', 'Jung', 'Mapo'],
    'Busan': ['Haeundae', 'Busanjin', 'Seo', 'Nam'],
    'Incheon': ['Yeonsu', 'Namdong', 'Bupyeong', 'Seo'],
    'Daegu': ['Suseong', 'Dalseo', 'Nam', 'Buk'],
    'Daejeon': ['Yuseong', 'Seo', 'Daedeok', 'Jung'],

    // India
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Nashik'],
    'Karnataka': ['Bangalore', 'Mysore', 'Hubli', 'Mangalore'],
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai', 'Tiruchirappalli'],
    'Delhi': ['New Delhi', 'Delhi Cantonment', 'Karol Bagh', 'Lajpat Nagar'],
    'Gujarat': ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot'],

    // Brazil
    'São Paulo': ['São Paulo City', 'Campinas', 'Santos', 'Ribeirão Preto'],
    'Rio de Janeiro': ['Rio de Janeiro City', 'Niterói', 'Petrópolis', 'Volta Redonda'],
    'Minas Gerais': ['Belo Horizonte', 'Uberlândia', 'Contagem', 'Juiz de Fora'],
    'Bahia': ['Salvador', 'Feira de Santana', 'Vitória da Conquista', 'Camaçari'],
    'Paraná': ['Curitiba', 'Londrina', 'Maringá', 'Ponta Grossa'],

    // Mexico
    'Mexico City': ['Mexico City Central', 'Tlalpan', 'Gustavo A. Madero', 'Álvaro Obregón'],
    'Jalisco': ['Guadalajara', 'Zapopan', 'Tlaquepaque', 'Tonalá'],
    'Nuevo León': ['Monterrey', 'Guadalupe', 'San Nicolás de los Garza', 'Apodaca'],
    'Puebla': ['Puebla City', 'Tehuacán', 'San Martín Texmelucan', 'Atlixco'],
    'Guanajuato': ['León', 'Irapuato', 'Celaya', 'Salamanca'],

    // Italy
    'Lombardy': ['Milan', 'Bergamo', 'Brescia', 'Como'],
    'Lazio': ['Rome', 'Latina', 'Frosinone', 'Viterbo'],
    'Campania': ['Naples', 'Salerno', 'Caserta', 'Benevento'],
    'Sicily': ['Palermo', 'Catania', 'Messina', 'Syracuse'],
    'Veneto': ['Venice', 'Verona', 'Padua', 'Vicenza'],

    // Spain
    'Madrid': ['Madrid City', 'Móstoles', 'Alcalá de Henares', 'Fuenlabrada'],
    'Catalonia': ['Barcelona', 'Hospitalet de Llobregat', 'Badalona', 'Terrassa'],
    'Andalusia': ['Seville', 'Málaga', 'Córdoba', 'Granada'],
    'Valencia': ['Valencia City', 'Alicante', 'Elche', 'Castellón'],
    'Galicia': ['Vigo', 'A Coruña', 'Ourense', 'Lugo'],

    // Netherlands
    'North Holland': ['Amsterdam', 'Haarlem', 'Zaanstad', 'Haarlemmermeer'],
    'South Holland': ['Rotterdam', 'The Hague', 'Leiden', 'Dordrecht'],
    'Utrecht': ['Utrecht City', 'Amersfoort', 'Nieuwegein', 'Veenendaal'],
    'Gelderland': ['Nijmegen', 'Arnhem', 'Apeldoorn', 'Ede'],
    'North Brabant': ['Eindhoven', 'Tilburg', 's-Hertogenbosch', 'Breda'],

    // Sweden
    'Stockholm': ['Stockholm City', 'Huddinge', 'Järfälla', 'Sollentuna'],
    'Västra Götaland': ['Gothenburg', 'Borås', 'Mölndal', 'Trollhättan'],
    'Skåne': ['Malmö', 'Helsingborg', 'Lund', 'Kristianstad'],
    'Uppsala': ['Uppsala City', 'Enköping', 'Håbo', 'Älvkarleby'],
    'Östergötland': ['Linköping', 'Norrköping', 'Motala', 'Mjölby'],

    // Norway
    'Oslo': ['Oslo City', 'Bærum', 'Asker', 'Lørenskog'],
    'Rogaland': ['Stavanger', 'Sandnes', 'Haugesund', 'Karmøy'],
    'Møre og Romsdal': ['Ålesund', 'Molde', 'Kristiansund', 'Volda'],
    'Nordland': ['Bodø', 'Narvik', 'Mo i Rana', 'Fauske'],
    'Viken': ['Drammen', 'Fredrikstad', 'Sarpsborg', 'Moss'],

    // Denmark
    'Capital Region': ['Copenhagen', 'Frederiksberg', 'Gentofte', 'Gladsaxe'],
    'Central Denmark': ['Aarhus', 'Randers', 'Horsens', 'Vejle'],
    'North Denmark': ['Aalborg', 'Hjørring', 'Frederikshavn', 'Thisted'],
    'Zealand': ['Roskilde', 'Næstved', 'Holbæk', 'Køge'],
    'Southern Denmark': ['Odense', 'Esbjerg', 'Kolding', 'Vejle'],

    // Switzerland
    'Zurich': ['Zurich City', 'Winterthur', 'Uster', 'Dübendorf'],
    'Bern': ['Bern City', 'Biel/Bienne', 'Thun', 'Köniz'],
    'Vaud': ['Lausanne', 'Yverdon-les-Bains', 'Montreux', 'Renens'],
    'Aargau': ['Aarau', 'Baden', 'Wettingen', 'Wohlen'],
    'St. Gallen': ['St. Gallen City', 'Rapperswil-Jona', 'Wil', 'Gossau'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 18.w,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //==========================> Sign Up Text Section <=======================
                _signUpTextSection(),
                SizedBox(height: 48.h),
                //==========================> User Name Text Field <=======================
                _textFieldSection('User Name', userNameController,
                    AppIcons.singlePerson, 'Enter your user name'),
                //==========================> First Name Text Field <=======================
                _textFieldSection('First Name', firstNameController,
                    AppIcons.singlePerson, 'Enter your first name'),
                //==========================> Last Name Text Field <=======================
                _textFieldSection('Last Name', lastNameController,
                    AppIcons.singlePerson, 'Enter your last name'),
                //==========================> Gender DropdownButton <=======================
                _genderDropdown(),
                SizedBox(height: 16.h),
                //==========================> Birth Date Dropdown Row <=======================
                _birthdayDropdownSection(),
                SizedBox(height: 16.h),
                //==========================> Location Dropdown Row <=======================
                _locationDropdownSection(),
                SizedBox(height: 16.h),
                //==========================> Password Text Field <=======================
                _textFieldSection(AppStrings.password, passwordController,
                    AppIcons.lockIcon, AppStrings.password, true),
                //==========================> Confirm Password Text Field <=======================
                _textFieldSection(
                    AppStrings.confirmPassword,
                    confirmPasswordController,
                    AppIcons.lockIcon,
                    AppStrings.confirmpasswords,
                    true),
                //==========================> Check Box Section <=======================
                _checkboxSection(),
                SizedBox(height: 24.h),
                //==========================> Sign Up Button <=======================
                _signUpButton(),
                SizedBox(height: 32.h),
                //==========================> Already Have Account Text <=======================
                _alreadyHaveAccountText(),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //==========================> Sign Up Text Widget <=======================
  _signUpTextSection() {
    return Center(
      child: Column(
        children: [
          CustomText(
            text: AppStrings.signUpAn,
            fontWeight: FontWeight.w600,
            fontsize: 22.sp,
          ),
        ],
      ),
    );
  }

  //==========================> Gender Dropdown Widget <=======================
  _genderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Gender',
          fontWeight: FontWeight.w500,
          fontsize: 16.sp,
          bottom: 8.h,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: AppColors.fillColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.primaryColor, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedGender,
              dropdownColor: AppColors.fillColor,
              padding: EdgeInsets.symmetric(vertical: 6.w),
              menuWidth: 240.w,
              borderRadius: BorderRadius.circular(8.r),
              hint: Row(
                children: [
                  Text("Select your Gender", style: AppStyles.fontSize16()),
                ],
              ),
              icon: SvgPicture.asset(
                AppIcons.downArrowIcon,
                width: 16.w,
                color: AppColors.primaryColor,
              ),
              isExpanded: true,
              items: genderList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedGender = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  //==========================> Birthday Dropdown Section <=======================
  _birthdayDropdownSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Birthday',
          fontWeight: FontWeight.w500,
          fontsize: 16.sp,
          bottom: 8.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDropdownField(
              value: selectedYear,
              items: yearList,
              hint: 'Year',
              width: 108.w,
              onChanged: (value) {
                setState(() {
                  selectedYear = value;
                });
              },
            ),
            _buildDropdownField(
              value: selectedMonth,
              items: monthList,
              hint: 'Month',
              width: 108.w,
              onChanged: (value) {
                setState(() {
                  selectedMonth = value;
                });
              },
            ),
            _buildDropdownField(
              value: selectedDay,
              items: dayList,
              hint: 'Day',
              width: 108.w,
              onChanged: (value) {
                setState(() {
                  selectedDay = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  //==========================> Location Dropdown Section <=======================
  _locationDropdownSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Location',
          fontWeight: FontWeight.w500,
          fontsize: 16.sp,
          bottom: 8.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDropdownField(
              value: selectedCountry,
              items: countryList,
              hint: 'Country',
              width: 108.w,
              onChanged: (value) {
                setState(() {
                  selectedCountry = value;
                  selectedState = null; // Reset state when country changes
                  selectedCity = null; // Reset city when country changes
                });
              },
            ),
            _buildDropdownField(
              value: selectedState,
              items: selectedCountry != null ? (stateMap[selectedCountry] ?? []) : [],
              hint: 'State',
              width: 108.w,
              onChanged: (value) {
                setState(() {
                  selectedState = value;
                  selectedCity = null; // Reset city when state changes
                });
              },
            ),
            _buildDropdownField(
              value: selectedCity,
              items: selectedState != null ? (cityMap[selectedState] ?? []) : [],
              hint: 'City',
              width: 108.w,
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  //==========================> Generic Dropdown Field Builder <=======================
  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required String hint,
    required double width,
    required Function(String?) onChanged,
  }) {
    return SizedBox(
      width: width,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.fillColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.primaryColor, width: 1),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            dropdownColor: AppColors.fillColor,
            padding: EdgeInsets.symmetric(vertical: 6.w),
            borderRadius: BorderRadius.circular(8.r),
            hint: Text(
              hint,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
              ),
            ),
            icon: SvgPicture.asset(
              AppIcons.downArrowIcon,
              width: 16.w,
              color: AppColors.primaryColor,
            ),
            isExpanded: true,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: items.isNotEmpty ? onChanged : null,
          ),
        ),
      ),
    );
  }

  //==========================> Text Field Widget <=======================
  _textFieldSection(String label, TextEditingController controller,
      String? icon, String hintText,
      [bool isPassword = false]) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            fontWeight: FontWeight.w500,
            fontsize: 16.sp,
            bottom: 8.h,
          ),
          CustomTextField(
            controller: controller,
            hintText: hintText,
            isPassword: isPassword,
            prifixicon: icon != null
                ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.h),
              child: SvgPicture.asset(icon, color: AppColors.primaryColor),
            )
                : null,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your $label";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  //==========================> Checkbox Section Widget <=======================
  _checkboxSection() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isChecked = !isChecked;
            });
          },
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: isChecked ? AppColors.primaryColor : Colors.transparent,
              border: Border.all(
                color: AppColors.primaryColor,
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: isChecked
                ? Icon(
              Icons.check,
              color: Colors.white,
              size: 14.sp,
            )
                : null,
          ),
        ),
        SizedBox(width: 10.w),
        Text.rich(
          maxLines: 2,
          TextSpan(
            text: 'By creating an account, I accept the',
            style: TextStyle(fontSize: 14.w, fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: 'Terms\n& Conditions',
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14.w,
                    fontWeight: FontWeight.w500),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.toNamed(AppRoutes.termsConditionScreen);
                  },
              ),
              const TextSpan(text: ' & '),
              TextSpan(
                text: 'Privacy Policy.',
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14.w,
                    fontWeight: FontWeight.w500),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.toNamed(AppRoutes.privacyPolicyScreen);
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

  //==========================> Sign Up Button <=======================

  _signUpButton() {
    return CustomButton(
      onTap: () {
        // // First check form validation
        // if (!_formKey.currentState!.validate()) {
        //   return;
        // }
        //
        // // Check if checkbox is checked
        // if (!isChecked) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Please accept the Terms & Conditions and Privacy Policy')),
        //   );
        //   return;
        // }
        //
        // // Additional validation for dropdowns
        // if (selectedGender == null) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Please select your gender')),
        //   );
        //   return;
        // }
        //
        // if (selectedYear == null || selectedMonth == null || selectedDay == null) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Please select your complete birthday')),
        //   );
        //   return;
        // }
        //
        // if (selectedCountry == null) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Please select your country')),
        //   );
        //   return;
        // }
        //
        // // Optional: Check if state is required (depends on your business logic)
        // if (selectedState == null && selectedCountry != null && stateMap[selectedCountry!] != null && stateMap[selectedCountry!]!.isNotEmpty) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Please select your state')),
        //   );
        //   return;
        // }
        //
        // // Optional: Check if city is required (depends on your business logic)
        // if (selectedCity == null && selectedState != null && cityMap[selectedState!] != null && cityMap[selectedState!]!.isNotEmpty) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Please select your city')),
        //   );
        //   return;
        // }
        //
        // // Check if passwords match
        // if (passwordController.text != confirmPasswordController.text) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Passwords do not match')),
        //   );
        //   return;
        // }

        // If all validations pass, proceed with sign up
        print('All validations passed, proceeding with sign up...');
        Get.toNamed(AppRoutes.verificationCodeScreen);
      },
      color: AppColors.buttonColor,
      text: AppStrings.signUp,
      textColor: Colors.white,
    );
  }
  //==========================> Already Have Account Text <=======================
  _alreadyHaveAccountText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: AppStrings.alreadyHaveAccount,
          fontWeight: FontWeight.w400,
        ),
        TextButton(
          onPressed: () {
            Get.toNamed(AppRoutes.signInScreen);
          },
          child: CustomText(
            text: 'Sign In',
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}