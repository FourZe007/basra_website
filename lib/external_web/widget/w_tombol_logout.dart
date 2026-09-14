import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/models/AuthModel/Auth_Model.dart';
import 'package:stsj/router/router_const.dart';

class WTombolLogout extends StatelessWidget {
  const WTombolLogout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Stack(children: [
        CircleAvatar(
            backgroundImage: NetworkImage(
                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'), // Profile Picture
            radius: 20),
        Positioned(
          right: 0,
          child: PopupMenuButton<String>(
              icon: Icon(null),
              onSelected: (value) {
                if (value == 'logout') return;
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Text('Logout'),
                      onTap: () async {
                        await Auth.resetAuth();
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.clear();

                        // ignore: use_build_context_synchronously
                        context.go(RoutesConstant.login);

                        Fluttertoast.showToast(
                            msg: 'Logout berhasil!', // message
                            textColor: Colors.black,
                            toastLength: Toast.LENGTH_LONG, // length
                            gravity: ToastGravity.CENTER, // location
                            webPosition: 'center',
                            webBgColor:
                                'linear-gradient(to right, #00FF00, #00FF00)',
                            timeInSecForIosWeb: 2);
                      },
                    ),
                  ]),
        )
      ]),
    );
  }
}
