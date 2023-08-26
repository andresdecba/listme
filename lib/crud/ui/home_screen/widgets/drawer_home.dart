import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listme/crud/ui/shared_widgets/drawer_elements.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerHome extends StatelessWidget {
  const DrawerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // HEAD
              const DrawerHead(
                text: 'APP options',
              ),

              // OPTION 1
              DrawerTile(
                  texto: 'Share this app',
                  border: const Border(
                    bottom: BorderSide(color: Colors.cyan),
                  ),
                  onTap: () {} // () => shareApp(context),
                  ),
              // OPTION 2
              DrawerTile(
                  texto: 'Rate us',
                  // border: const Border(
                  //   bottom: BorderSide(color: Colors.cyan),
                  // ),
                  onTap: () {} // () => goToPlaystore(context),
                  ),
              // OPTION 3
              // DrawerTile(
              //     leading: SvgPicture.asset(
              //       'assets/svg/premium.svg',
              //       alignment: Alignment.center,
              //       fit: BoxFit.fill,
              //       width: 32,
              //       color: Colors.amber,
              //     ),
              //     texto: 'Get PRO',
              //     onTap: () {} // () => getPro(context),
              //     ),
            ],
          ),
        ),
      ),
    );
  }

  void shareApp(BuildContext context) {
    String message = 'hi! check this app out...\nhttps://play.google.com/store/apps/details?id=listme.theandrewstudio.site';
    Share.share(message);
    context.pop();
  }

  void goToPlaystore(BuildContext context) async {
    Uri url = Uri.parse('https://play.google.com/store/apps/details?id=listme.theandrewstudio.site');
    context.pop();
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void getPro(BuildContext context) {}
}
