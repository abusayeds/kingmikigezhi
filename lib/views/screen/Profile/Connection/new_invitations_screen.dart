import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewInvitationScreen extends StatefulWidget {
  const NewInvitationScreen({super.key});

  @override
  State<NewInvitationScreen> createState() => _NewInvitationScreenState();
}

class _NewInvitationScreenState extends State<NewInvitationScreen> {
  final List<Map<String, dynamic>> invitations = [
    {
      "name": "Alax Tom",
      "accountID": 2010,
      "contribution": 100,
    },
    {
      "name": "Mahafujer",
      "accountID": 2011,
      "contribution": 150,
    },
    {
      "name": "Rahman MunnA",
      "accountID": 2012,
      "contribution": 200,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: invitations.length,
        itemBuilder: (context, index) {
          final invitation = invitations[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.grey.shade300,
                        child: Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            invitation['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(AppIcons.dotIconForFamily),
                              SizedBox(width: 4),
                              Text("Account ID: ${invitation['accountID']}"),
                            ],
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(AppIcons.dotIconForFamily),
                              SizedBox(width: 4),
                              Text("Contribution: ${invitation['contribution']}"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child:CustomButton(
                            onTap: (){},
                            text: 'Ignore',textStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                            color: AppColors.fillColor,
                            borderColor: AppColors.buttonA47059,
                            textColor: AppColors.blackColor,
                          )
                      ),
                      SizedBox(width: 10),
                      Expanded(
                          child:CustomButton(
                            onTap: (){},
                            text: 'Accept',textStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                            color: AppColors.buttonA47059,
                            borderColor: AppColors.buttonA47059,
                            textColor: AppColors.textColor,
                          )
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:  Divider(thickness: .5,color: AppColors.greyColor,),
                  )
                ],

              ),

            ),
          );
        },
      ),
    );
  }
}
