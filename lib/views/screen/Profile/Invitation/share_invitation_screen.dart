import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShareInvitationPage extends StatefulWidget {
  @override
  _ShareInvitationPageState createState() => _ShareInvitationPageState();
}

class _ShareInvitationPageState extends State<ShareInvitationPage> {
  final TextEditingController messageController = TextEditingController();

  final TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invitation'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: messageController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                  hintText: 'Message (60 words)',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 20),
            // Row for the social media icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialMediaIcon(Icons.message, "Message",Colors.green),
                _buildSocialMediaIcon(Icons.mail, "WhatsApp",Colors.greenAccent),
                _buildSocialMediaIcon(Icons.mail, "Gmail",Colors.redAccent),
                _buildSocialMediaIcon(Icons.camera_alt, "Instagram",Colors.redAccent),
              ],
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: urlController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
                hintText: 'https://www.event.org',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 30),

            // Copy CustomButton
            CustomButton(onTap: () {
              final url = urlController.text;
              Clipboard.setData(ClipboardData(text: url));
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Copied: $url'))
              );
            },
              text:  'Copy',
              color: AppColors.buttonA47059,
              borderColor: AppColors.buttonA47059,
            )
          ],
        ),
      ),
    );
  }

  // Widget builder for social media icons
  Widget _buildSocialMediaIcon(IconData iconData, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: Icon(iconData, size: 30),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
