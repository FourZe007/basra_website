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
import 'package:stsj/global/theme/app_theme.dart';
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
  //bool _passwordVisible = false;

  bool isLoading = false;
  int statuslogin = 0;
  bool canEntered = false;

  get backgroundColor => null;

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
          //await state.fetchSipSalesman();

          // ~:Header Privillage Preprocessing:~
          String category = '';
          for (var userAccess in data) {
            if (userAccess.isAllowView == 1) {
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
          } else if (category == 'POWER BI') {
            state.setStaticMenuNotifier('powerbi');
          } else {
            state.setStaticMenuNotifier('');
          }

          state.headerList.clear();
          state.headerList.addAll(data.map((e) {
            if (e.isAllowView == 1) {
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
            if (e.isAllowView == 1) {
              return e.menuNumber;
            } else {
              return '-';
            }
          }));

          state.subHeaderAllowEditList.clear();
          state.subHeaderAllowEditList.addAll(data.map((e) {
            if (e.isAllowEdit == 1) {
              return e.menuNumber;
            } else {
              return '-';
            }
          }));

          await prefs.setStringList('subheader', state.subHeaderList);
          await prefs.setStringList(
              'subheaderallowedit', state.subHeaderAllowEditList);

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
        debugPrint("Data di SharedPreferences kosong atau Status tidak benar.");
      }
    } catch (e) {
      // Handle any exceptions here
      print('Error: ${e.toString()}');
      debugPrint('Error: ${e.toString()}');
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
            listdatalogin[0].employeeid);

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
            context.goNamed(RoutesConstant.homepage);
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
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MenuState>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          color: AppColors.primaryBackground,
          gradient: RadialGradient(
            center: Alignment(0.0, -0.3),
            radius: 1.2,
            colors: [
              AppColors.deepBackground,
              AppColors.primaryBackground,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 420,
                minWidth: 280,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.mutedSurface,
                  borderRadius: BorderRadius.circular(AppRadii.xl),
                  border: Border.all(color: AppColors.border, width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      spreadRadius: 0,
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 36,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo & Branding
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.darkGrey,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.border,
                              width: 1.0,
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/stsj.png',
                            height: 60,
                            width: 60,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 4),
                      const SizedBox(height: 28),

                      // Username Field
                      const Text(
                        'Username',
                        style: TextStyle(
                          
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: idController,
                        autofocus: true,
                        style: const TextStyle(
                          
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                        inputFormatters: [UppercaseTextInputFormatter()],
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                            
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                          prefixIcon: const Icon(
                            Icons.person_outline_rounded,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                          filled: true,
                          fillColor: AppColors.darkGrey,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadii.md),
                            borderSide:
                                const BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadii.md),
                            borderSide:
                                const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadii.md),
                            borderSide: const BorderSide(
                              color: AppColors.accentYellow,
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter userid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),

                      // Password Field
                      const Text(
                        'Password',
                        style: TextStyle(
                          
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: passwordController,
                        obscureText: !_passwordVisible,
                        style: const TextStyle(
                          
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                        inputFormatters: [UppercaseTextInputFormatter()],
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                            
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: AppColors.darkGrey,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadii.md),
                            borderSide:
                                const BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadii.md),
                            borderSide:
                                const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadii.md),
                            borderSide: const BorderSide(
                              color: AppColors.accentYellow,
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),

                      // Login Button
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentYellow,
                            foregroundColor: AppColors.onAccentYellow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadii.md),
                            ),
                            elevation: 0,
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    loginHandler(context, state);
                                  }
                                 },
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.onAccentYellow),
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login_rounded,
                                        size: 20,
                                        color: AppColors.onAccentYellow),
                                    SizedBox(width: 8),
                                    Text(
                                      'Sign In',
                                      style: TextStyle(
                                        
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.onAccentYellow,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Version Indicator & Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accentMint,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'v1.0.15',
                            style: TextStyle(
                              
                              fontSize: 11,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
