import 'package:flutter/material.dart';
import 'package:notesapp/Pages/BuyMeACoffee/payments.dart';
import 'package:notesapp/Pages/FilesVault/file_vault.dart';
import 'package:notesapp/Pages/GroupProject/group_project_home.dart';
import 'package:notesapp/Pages/home_page.dart';
import 'package:notesapp/Pages/whatsnew/whatsnew.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  String name = 'Help us fund this project.';
  String image =
      'https://pbs.twimg.com/profile_images/1496172645959999489/Mfzyjk9N_400x400.jpg';
  int price = 5000;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 240.0,
      color: Colors.black,
      child: Container(
        // color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 16.0, left: 16, bottom: 16),
                        child: Image.asset(
                          'assets/Images/proactive_logo.png',
                          height: 78.0,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ],
                  ),
                  _SideMenuIconTab(
                    beta: false,
                    iconData: Icons.home,
                    title: 'Home',
                    onTap: () {},
                  ),
                  _SideMenuIconTab(
                    beta: false,
                    iconData: Icons.calendar_today_rounded,
                    title: 'Calendar',
                    onTap: () {},
                  ),
                  _SideMenuIconTab(
                    beta: false,
                    iconData: Icons.local_post_office_outlined,
                    title: 'Files Vault',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FileValut()));
                    },
                  ),
                  _SideMenuIconTab(
                    beta: true,
                    iconData: Icons.group_add,
                    title: 'Group Project',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GroupProject()));
                    },
                  ),
                  _SideMenuIconTab(
                    beta: false,
                    iconData: Icons.error_outline,
                    color: Colors.green,
                    title: 'What\'s New',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => WhatsNew()));
                    },
                  ),
                  _SideMenuIconTab(
                    beta: false,
                    iconData: Icons.group_rounded,
                    title: 'Contributions',
                    onTap: () {},
                  ),
                  _SideMenuIconTab(
                    beta: true,
                    iconData: Icons.payment,
                    title: 'Buy me a coffee',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Webpayment(
                                name: name, image: image, price: price),
                          ));
                    },
                  ),
                ],
              ),
            ),

            // const SizedBox(height: 190.0),
            if (MediaQuery.of(context).size.height > 560)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  height: 42,
                  width: 150,
                  // color: Colors.blue,
                  child: Center(
                      child: Column(
                    children: [
                      Text(
                        '© 2022 - 2023',
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Proactive Inc.',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class _SideMenuIconTab extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback onTap;
  final Color? color;
  final bool? beta;
  const _SideMenuIconTab(
      {Key? key,
      required this.iconData,
      required this.title,
      required this.onTap,
      required this.beta,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      if (beta == true)
        Positioned(
            top: 33,
            left: 67,
            child: Container(
                height: 14,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(2)),
                child: Center(
                  child: Text('BETA',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10)),
                ))),
      ListTile(
        leading: Icon(
          iconData,
          color: color == null ? Colors.white : color,
          // color: Theme.of(context).iconTheme.color,
          size: 28.0,
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
        onTap: onTap,
      ),
    ]);
  }
}

class Checkout extends StatelessWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
