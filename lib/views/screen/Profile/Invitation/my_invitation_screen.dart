
import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyInvitationPage extends StatefulWidget {
  @override
  _MyInvitationPageState createState() => _MyInvitationPageState();
}

class _MyInvitationPageState extends State<MyInvitationPage> {
  // List of invitees
  final List<Map<String, dynamic>> invitees = [
    {
      'name': 'Bashar Iskam',
      'location': 'Canada, Elm St',
      'avatarColor': Colors.teal,
      'checked': false
    },
    {
      'name': 'Iskam',
      'location': 'Canada, Elm St',
      'avatarColor': Colors.purpleAccent,
      'checked': false
    },
    {
      'name': 'Alax Tom',
      'location': 'Canada, Elm St',
      'avatarColor': Colors.lightGreenAccent,
      'checked': false
    },
    {
      'name': 'Jihon',
      'location': 'Canada, Elm St',
      'avatarColor': Colors.amberAccent,
      'checked': false
    },
    {
      'name': 'Bashar Iskam',
      'location': 'Canada, Elm St',
      'avatarColor': Colors.grey,
      'checked': false
    },
  ];

  void _toggleCheckbox(int index, bool? value) {
    setState(() {
      invitees[index]['checked'] = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invitation'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: invitees.length,
              itemBuilder: (context, index) {
                final invitee = invitees[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: invitee['avatarColor'],
                  ),
                  title: Text(
                    invitee['name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(invitee['location']),
                  trailing: Checkbox(
                    value: invitee['checked'],
                    onChanged: (bool? value) {
                      _toggleCheckbox(index, value);
                    },
                  ),
                );
              },
            ),
          ),
       Padding(
         padding: const EdgeInsets.all(8.0),
         child: CustomButton(
           onTap: (){
             Get.toNamed(AppRoutes.shareInvitationPage);
           },
           text: 'Share',
           borderColor: AppColors.buttonA47059,
           color: AppColors.buttonA47059,
           textColor: AppColors.textColor,
         ),
       )
        ],
      ),
    );
  }
}
