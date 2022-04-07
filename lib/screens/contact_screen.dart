import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_drawer.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.lightGreen,
        ),
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text(
          'Contact Us',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.lightGreen,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.grey.shade400,
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawer: AppDrawer(),
      drawerScrimColor: Colors.black87,
      body: Container(
        height: height,
        width: Get.width,
        child: ListView(
          children: [
            Image.asset(
              'assets/images/contact.png',
              width: Get.width,
              height: Get.width * 0.7,
              fit: BoxFit.fitWidth,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
              ),
              child: AutoSizeText(
                'Welcome to',
                minFontSize: 1,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                bottom: 10,
              ),
              child: AutoSizeText(
                'Karmac Customer Support',
                minFontSize: 1,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'Karmac is focused on the fastest solution to your concern. We want our customers and partners to have the best experience with us; if you\'re facing any difficulty or issues on our platform, please reach out to us at ',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          String? encodeQueryParameters(
                              Map<String, String> params) {
                            return params.entries
                                .map((e) =>
                                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                .join('&');
                          }

                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'support@karmac.in',
                            query: encodeQueryParameters(
                                <String, String>{'subject': 'Support!'}),
                          );

                          launch(emailLaunchUri.toString());
                        },
                      text: 'support@karmac.in',
                      style: TextStyle(
                        color: Colors.lightGreen,
                        fontSize: 12,
                      ),
                    ),
                    TextSpan(
                      text: '; We\'ll correct it at the earliest.',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
              ),
              child: AutoSizeText(
                'We\'re thankful for your patience.',
                minFontSize: 1,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                top: 20,
              ),
              child: AutoSizeText(
                'Quick Links',
                minFontSize: 1,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.shade800,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {},
                      title: AutoSizeText(
                        'My Orders',
                        minFontSize: 1,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      subtitle: AutoSizeText(
                        'Order updates, notifications and view an order',
                        minFontSize: 1,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.list,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.lightGreen,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: Divider(
                        color: Colors.grey.shade600,
                        height: 0,
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      title: AutoSizeText(
                        'My Cars',
                        minFontSize: 1,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      subtitle: AutoSizeText(
                        'Manage your cars information, car health status',
                        minFontSize: 1,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: FaIcon(
                          FontAwesomeIcons.car,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.lightGreen,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: Divider(
                        color: Colors.grey.shade600,
                        height: 0,
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      title: AutoSizeText(
                        'Payments and Transactions',
                        minFontSize: 1,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      subtitle: AutoSizeText(
                        'View past transactions and payment details',
                        minFontSize: 1,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.payment,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.lightGreen,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: Divider(
                        color: Colors.grey.shade600,
                        height: 0,
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      title: AutoSizeText(
                        'Account Settings',
                        minFontSize: 1,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      subtitle: AutoSizeText(
                        'Edit address and personal details',
                        minFontSize: 1,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.person,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.lightGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                top: 15,
              ),
              child: AutoSizeText(
                'Didn\'t find the solution to your query?',
                minFontSize: 1,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: (Get.width - 16) / 2,
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 8,
                    left: 4,
                    right: 4,
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      color: Color.fromRGBO(26, 26, 26, 1),
                      shadowColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 10,
                          right: 10,
                          bottom: 10,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.chat,
                              color: Colors.grey.shade400,
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                alignment: Alignment.center,
                                child: AutoSizeText(
                                  'Chat with us',
                                  minFontSize: 5,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: (Get.width - 16) / 2,
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 8,
                    left: 4,
                    right: 4,
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      color: Color.fromRGBO(26, 26, 26, 1),
                      shadowColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 10,
                          right: 10,
                          bottom: 10,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: Colors.grey.shade400,
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                alignment: Alignment.center,
                                child: AutoSizeText(
                                  'Talk to us',
                                  minFontSize: 5,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
