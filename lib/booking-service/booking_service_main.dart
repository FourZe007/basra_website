import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/booking-service/admin/acceptance.dart';
import 'package:stsj/booking-service/admin/browse_account.dart';
import 'package:stsj/booking-service/admin/create_account.dart';
import 'package:stsj/booking-service/admin/whatsapp.dart';

import 'package:stsj/booking-service/global/global.dart';
import 'package:stsj/booking-service/progressindicator/circle_loading.dart';
import 'package:stsj/booking-service/state_management/state_admin.dart';
import 'package:stsj/booking-service/workshops.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';

class BookingServiceMainPage extends StatefulWidget {
  const BookingServiceMainPage({super.key});

  @override
  State<BookingServiceMainPage> createState() => _BookingServiceMainPageState();
}

class _BookingServiceMainPageState extends State<BookingServiceMainPage> {
  Future<String> getData(AdminState adminState) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (adminState.getUsername == '') {
      final user =
          prefs.getString('adminid') ?? prefs.getString('UserID') ?? '';
      adminState.setUsername(user);
    }

    return adminState.getUsername;
  }

  Widget _buildTab(IconData icon, String label) {
    return Tab(
      height: 46,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  @override
  void dispose() {
    GlobalVar.listBrowseBooking = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AdminState>(context);

    if (GlobalVar.isLoading == true) {
      return const Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Center(child: CircleLoading()),
      );
    }

    return DefaultTabController(
      length: 5,
      child: FutureBuilder(
        future: getData(state),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: AppColors.primaryBackground,
              body: Center(child: CircleLoading()),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.primaryBackground,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: CustomAppBar(
                goBack: RoutesConstant.menu,
              ),
            ),
            body: Column(
              children: [
                // ── Top Page Header & Tab Navigation Bar ─────────────────────
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.softCharcoal,
                    border: Border(
                      bottom: BorderSide(color: AppColors.border, width: 1.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 14, 24, 6),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(AppRadii.sm),
                              child: Image.asset(
                                'assets/images/FixUp-Logo.png',
                                width: 36,
                                height: 36,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryMaroon,
                                    borderRadius:
                                        BorderRadius.circular(AppRadii.sm),
                                  ),
                                  child: const Icon(
                                    Icons.calendar_month_rounded,
                                    color: AppColors.primaryRed,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'FixUP Moto - Admin',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TabBar(
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          dividerColor: Colors.transparent,
                          indicatorColor: AppColors.primaryRed,
                          indicatorWeight: 3.0,
                          labelColor: AppColors.primaryRed,
                          unselectedLabelColor: AppColors.textSecondary,
                          labelStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          tabs: [
                            _buildTab(
                              Icons.assignment_turned_in_outlined,
                              'Daftar Booking',
                            ),
                            _buildTab(
                              Icons.storefront_outlined,
                              'Daftar Bengkel & Booking',
                            ),
                            _buildTab(
                              Icons.person_add_alt_1_outlined,
                              'Buat Akun Member',
                            ),
                            _buildTab(
                              Icons.manage_search_rounded,
                              'Cari Akun Member',
                            ),
                            _buildTab(
                              Icons.chat_outlined,
                              'Status WhatsApp',
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Tab Content Area ─────────────────────────────────────────
                const Expanded(
                  child: TabBarView(
                    children: [
                      AdminAcceptance(),
                      Workshops(),
                      CreateUserAccount(),
                      BrowseUserAccount(),
                      WhatsappPage(),

                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
