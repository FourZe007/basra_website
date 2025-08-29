import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/controller/Login_controller.dart';
import 'package:stsj/core/models/AuthModel/Auth_Model.dart';
import 'package:stsj/core/models/AuthModel/DataAuth.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/dashboard-fixup/utilities/utils.dart';
import 'package:stsj/global/font.dart';

import 'package:stsj/router/router_const.dart';

class LoginPages extends StatefulWidget {
  const LoginPages({Key? key}) : super(key: key);

  // static const String route = '/login'; // Define the route name

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  final formKey = GlobalKey<FormState>();

  final idController = TextEditingController();
  final passwordController = TextEditingController();

  bool _passwordVisible = false; // Initialize _passwordVisible as a hook

  bool isLoading = false;
  int statuslogin = 0;
  bool canEntered = false;

  bool _onKey(KeyEvent event) {
    final key = event.logicalKey;

    if (event is KeyDownEvent && key == LogicalKeyboardKey.enter) {
      loginHandler(context, Provider.of<MenuState>(context, listen: false));
    }

    return false;
  }

  Future<void> fetchData(MenuState state) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      bool status = prefs.getBool("Status") ?? false;

      if (status == true) {
        state.userId = prefs.getString("UserID") ?? '';
        state.entryLevelId = prefs.getString("EntryLevelID") ?? '';
        state.entryLevelName = prefs.getString("EntryLevelName") ?? '';
        state.password = prefs.getString("Password") ?? '';
        state.companyName = prefs.getString('CompanyName') ?? '';

        // ~:Load All Static Data:~
        // await state.fetchSalesmanList();
        print('a');
        await state.fetchSISDriver();
        await state.fetchProvinces();
        // Added before go to menu page too to make sure branch name changed
        state.fetchSISBranches();
        print(state.branchList.length);
        print('b');
        await state
            .fetchUserAccess(state.getCompanyName, state.getEntryLevelId)
            .then((data) async {
          state.userAccessList.addAll(data);

          // SIP - Salesman
          // await state.fetchSipSalesBranches(); --> moved after home menu pressed
          await state.fetchSipSalesman();

          // ~:Header Privillage Preprocessing:~
          String category = '';
          for (var userAccess in data) {
            if (userAccess.isAllow == 1) {
              category = userAccess.category;
              break;
            }
          }
          print('First Category: $category');
          if (category == 'DASHBOARD') {
            state.setStaticMenuNotifier('dashboard');
          } else if (category == 'SALES ACTIVITY') {
            state.setStaticMenuNotifier('activity');
          } else if (category == 'AUTHORIZATION') {
            state.setStaticMenuNotifier('authorization');
          } else if (category == 'INFORMATION') {
            state.setStaticMenuNotifier('report');
          } else if (category == 'TOOLS') {
            state.setStaticMenuNotifier('tools');
          } else {
            state.setStaticMenuNotifier('');
          }

          state.headerList.clear();
          state.headerList.addAll(data.map((e) {
            if (e.isAllow == 1) {
              return e.category;
            } else {
              return '-';
            }
          }).toList());
          if (state.headerList.isEmpty) {
            state.headerList.add('dashboard');
          }
          await prefs.setStringList('header', state.headerList);
          print('~:List of Header:~');
          for (var header in state.getHeaderList) {
            print(header);
          }

          state.subHeaderList.clear();
          state.subHeaderList.addAll(data.map((e) {
            if (e.isAllow == 1) {
              return e.menuNumber;
            } else {
              return '-';
            }
          }));

          await prefs.setStringList('subheader', state.subHeaderList);

          print('~:List of Sub Header:~');
          for (var value in state.getSubHeaderList) {
            print(value);
          }

          print('');
          List<Map<String, String>> temp = [];
          for (Map<String, String> e in dashboardList) {
            if (state.getSubHeaderList.contains(e['acc']) &&
                e['acc'] != '000') {
              print('${e['acc']} added');
              temp.add(e);
            } else if (e['acc'] == '000') {
              print('${e['acc']} added');
              temp.add(e);
            } else {
              // do nothing
            }
          }
          state.setFilteredDashboardList(temp);

          print('~:Filtered FPM Dashboard Access Result:~');
          for (var value in state.getFilteredDashboardList) {
            print('${value['text']}');
          }
        });
      } else {
        // Handle the case where "Status" is not true or data is missing
        print("Data di SharedPreferences kosong atau Status tidak benar.");
      }
    } catch (e) {
      // Handle any exceptions here
      print('Error: ${e.toString()}');
    }
  }

  void loginHandler(
    BuildContext context,
    MenuState state,
  ) async {
    print("LoginHanlder");
    // set laodng

    setState(() {
      statuslogin = 1;
      isLoading = true;
    });

    try {
      print('Start Login Process');
      List<DataLogin> listdatalogin = await DataLoginController.login(
        idController.text,
        passwordController.text,
      );

      if (listdatalogin.isNotEmpty &&
          listdatalogin[0].memo == "LOGIN BERHASIL") {
        // ~:Login succeed:~
        await DataLoginController.setIntoSharedPreferences(
          listdatalogin[0].userID,
          listdatalogin[0].entryLevelID,
          listdatalogin[0].entryLevelName,
          listdatalogin[0].dataDT[0].pt,
        );

        await Auth.saveDataToSharedPreferences(listdatalogin[0].dataDT);
        state.userCompanyAccList.addAll(listdatalogin[0].dataDT);

        canEntered = true;

        if (canEntered) {
          // loginModel.setUser([
          //   listdatalogin[0].userID,
          //   listdatalogin[0].entryLevelID,
          //   listdatalogin[0].entryLevelName,
          // ]);

          await fetchData(state);

          setState(() {
            isLoading = false;
          });

          if (context.mounted) {
            print('Current route: ${GoRouterState.of(context).name}');
            context.pushReplacementNamed(RoutesConstant.homepage);
          }
        }
      } else {
        // ~:Login failed:~
        setState(() {
          canEntered = false;
          isLoading = false;
          statuslogin = -1;
        });

        Fluttertoast.showToast(
          msg: "Invalid Credential", // message
          toastLength: Toast.LENGTH_LONG, // length
          gravity: ToastGravity.CENTER, // location
          webPosition: "center",
          webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
          timeInSecForIosWeb: 2, // duration
        );
      }

      // debugPrint('loginData: $listdatalogin');
    } catch (error) {
      // ~:Error occured during login:~
      Fluttertoast.showToast(
        msg: "$error", // message
        toastLength: Toast.LENGTH_LONG, // length
        gravity: ToastGravity.CENTER, // location
        webPosition: "center",
        webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
        timeInSecForIosWeb: 2, // duration
      );

      setState(() {
        statuslogin = -1;
        isLoading = false;
      });

      // debugPrint('loginData: $error');
    }
  }

  @override
  void initState() {
    super.initState();

    ServicesBinding.instance.keyboard.addHandler(_onKey);
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MenuState>(context);

    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Warna bayangan
                spreadRadius: 3, // Menyebar lebar bayangan
                blurRadius: 7, // Blur bayangan
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.015,
            vertical: MediaQuery.of(context).size.height * 0.015,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Company Logo
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.03,
                      ),
                      child: Image.asset(
                        'assets/images/stsj.png',
                        fit: BoxFit.contain,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.175,
                      ),
                    ),

                    Wrap(
                      runSpacing: MediaQuery.of(context).size.height * 0.025,
                      children: [
                        // User Text Fields
                        Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.01,
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: <Widget>[
                                // Username Text Field
                                Expanded(
                                  child: TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    controller: idController,
                                    autofocus: true,
                                    inputFormatters: [
                                      UppercaseTextInputFormatter()
                                    ],
                                    decoration: InputDecoration(
                                      filled: true, //<-- SEE HERE
                                      fillColor: Colors.white70,
                                      labelText: "Username", //babel text
                                      hintText: 'Masukan username perusahaan',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: BorderSide(width: 0.5),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter userid';
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.015,
                                ),

                                // Password Text Field
                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      UppercaseTextInputFormatter()
                                    ],
                                    controller: passwordController,
                                    obscureText: !_passwordVisible,
                                    decoration: InputDecoration(
                                      labelText: "Password", //babel text
                                      hintText: 'Masukan password perusahaan',

                                      filled: true, //<-- SEE HERE
                                      fillColor: Colors.white70,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: BorderSide(width: 0.5),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          _passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        ),
                                        onPressed: () {
                                          // Update the state i.e. toogle the state of passwordVisible variable
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter password';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Login Button
                        ElevatedButton(
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(
                              EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),
                            ),
                            backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).primaryColorLight,
                            ),
                          ),
                          onPressed: () {
                            // if (formKey.currentState!.validate()) {
                            //   formKey.currentState!.save();
                            //   loginHandler(context, state);
                            // }
                            loginHandler(context, state);
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Builder(
                              builder: (context) {
                                if (isLoading) {
                                  return Center(
                                    heightFactor: 1,
                                    widthFactor: 1,
                                    child: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: CircularProgressIndicator(
                                        backgroundColor:
                                            Color.fromARGB(255, 4, 101, 237),
                                        strokeWidth: 5,
                                      ),
                                    ),
                                  );
                                } else {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.login, color: Colors.black),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Login',
                                        style: TextStyle(color: Colors.black),
                                      )
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ~:Website Version:~
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Text(
                  'v1.0.15',
                  style: GlobalFont.mediumbigfontR,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UppercaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
