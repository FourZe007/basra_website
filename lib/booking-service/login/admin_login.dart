// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/booking-service/global/api.dart';
import 'package:stsj/booking-service/global/global.dart';
import 'package:stsj/booking-service/global/model.dart';
import 'package:stsj/booking-service/label/label_static.dart';
import 'package:stsj/booking-service/popupdialog/kotak_pesan.dart';
import 'package:stsj/booking-service/progressindicator/circle_loading.dart';
import 'package:stsj/booking-service/state_management/state_admin.dart';
import 'package:stsj/booking-service/widget/button/tombol.dart';
import 'package:stsj/booking-service/widget/textfield/customtextfield.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => AdminLoginState();
}

class AdminLoginState extends State<AdminLogin>
    with AutomaticKeepAliveClientMixin<AdminLogin> {
  String username = '';
  String password = '';
  List<ModelLogin> listlogin = [];
  bool isloading = false;

  void setUsername(String value) {
    username = value;
  }

  void setPassword(String value) {
    password = value;
  }

  void login(BuildContext context, AdminState adminState) async {
    setState(() => isloading = true);
    print('Username: $username');
    print('Password: $password');
    listlogin = await GlobalAPI.getLogin(username, password);
    print(listlogin[0].memo);

    if (listlogin[0].memo == 'LOGIN BERHASIL') {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('adminid', username);
      await prefs.setString('password', password);

      if (listlogin[0].flag == 0) {
        GlobalUser.flag = 0;
        await prefs.setInt('flag', 0);
      } else {
        GlobalUser.flag = 1;
        await prefs.setInt('flag', 1);
      }
      adminState.setUsername(prefs.getString('adminid') ?? '');
      adminState.setPassword(prefs.getString('password') ?? '');
      setState(() => isloading = false);
    } else {
      setState(() => isloading = false);
      GlobalFunction.tampilkanDialog(
        context,
        const KotakPesan(
          'INFORMASI',
          'Username atau password salah',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final adminState = Provider.of<AdminState>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 75.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10.0, left: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/FixUp-Logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: (MediaQuery.of(context).size.width <= 1024
                      ? MediaQuery.of(context).size.width / 4
                      : MediaQuery.of(context).size.width * 0.25),
                ),
              ),
              const SizedBox(height: 15.0),
              LabelStatic(
                'LOGIN',
                GlobalFont.titleLoginFontW2C,
              ),
              const SizedBox(height: 40.0),
              CustomTextField(
                setUsername,
                username,
                MediaQuery.of(context).size.width / 3,
                hint: 'Username',
                isAutoFocus: true,
              ),
              CustomTextField(
                setPassword,
                password,
                MediaQuery.of(context).size.width / 3,
                hint: 'Password',
                isPass: true,
              ),
              const SizedBox(height: 80.0),
              SizedBox(
                width: 200,
                height: 40,
                child: Builder(
                  builder: (context) {
                    if (isloading) {
                      return const CircleLoading();
                    } else {
                      return SizedBox(
                        width: 200,
                        height: 40,
                        child: Tombol(
                          'SIGN IN',
                          () => login(context, adminState),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 400,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Belum download Extension 'Allow CORS?"),
                      TextButton(
                        onPressed: () async {
                          if (await canLaunchUrl(
                            Uri.parse(
                              'https://chromewebstore.google.com/detail/allow-cors-access-control/lhobafahddgcelffkeicbaginigeejlf',
                            ),
                          )) {
                            await launchUrl(Uri.parse(
                              'https://chromewebstore.google.com/detail/allow-cors-access-control/lhobafahddgcelffkeicbaginigeejlf',
                            ));
                          } else {
                            throw 'Could not launch Extension Link';
                          }
                        },
                        child: const Text(
                          'Download disini!',
                          style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
