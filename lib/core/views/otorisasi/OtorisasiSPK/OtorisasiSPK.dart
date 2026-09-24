import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_grid/simple_grid.dart';
import 'package:stsj/core/controller/Otorisasi_Controller.dart';
import 'package:stsj/core/models/AuthModel/BSLoginModel.dart';
import 'package:stsj/core/models/SPKModel/SpkOverDiscModel.dart';
import 'package:stsj/router/router_const.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/core/views/errorHandling_pages.dart';
import 'package:stsj/core/views/Otorisasi/OtorisasiSPK/OtorisasiDetailCard.dart';
import 'package:stsj/core/views/Otorisasi/component/CellSPK..dart';

class OtorisasiSPK extends StatefulWidget {
  OtorisasiSPK({super.key});

  @override
  State<OtorisasiSPK> createState() => _OtorisasiSPK();
}

class _OtorisasiSPK extends State<OtorisasiSPK> {
  bool isLoading = true;
  String pt = "";
  String bsCode = "";
  String namaUserID = '';
  bool isError = false;
  String error = '';

  List listBSMap = [];
  Map ddvalue = {};

  void isiPtBS(String ptbs) {
    final splitptbs = ptbs.split(",");
    bsCode = splitptbs[0];
    pt = splitptbs[1];
  }

  void fetchData() async {
    SharedPreferences namaLoginPref = await SharedPreferences.getInstance();
    if (namaLoginPref.getBool("Status") == true) {
      namaUserID = namaLoginPref.getString("UserID")!;

      try {
        final listBranchShop =
            await ServiceOtorisasi.getDataBSLogin(namaUserID);

        // print(listBranchShop);

        listBranchShop.forEach((BSLogin branchshop) {
          if (branchshop.bSName != "" &&
              branchshop.branch != "00" &&
              branchshop.shop != "00") {
            listBSMap.add({
              'value': branchshop.branch.toString() +
                  branchshop.shop.toString() +
                  "," +
                  branchshop.pT.toString(),
              'teks': branchshop.bSName.toString()
            });
          }
        });

        if (listBSMap.isNotEmpty) {
          ddvalue = listBSMap.first;

          isiPtBS(listBSMap.first["value"]);
        }
      } catch (e, stacktrace) {
        // print('$e');
        // print(stacktrace);

        error = '$e';
        isError = true;
      } finally {
        isLoading = false;

        setState(() {});
      }
    }
  }

  @override
  void initState() {
    fetchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dataview(AsyncSnapshot<List<SpkOverDisc>> snapshot) {
      // print("dataview");
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: snapshot.data!.map((spk) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10.0, top: 7.0),
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              elevation: 4.0,
              child: InkWell(
                splashColor: Colors.black, //StyleService.primaryColor,
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OtorisasiDetailCard(
                              spkOverDisc: spk, userID: namaUserID)))
                },
                borderRadius: BorderRadius.circular(10.0),
                child: CellSPK(spk),
              ),
            ),
          );
        }).toList(),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(56),
        child: CustomAppBar(
          goBack: RoutesConstant.menu,
        ),
      ),
      body: !isError
          ? Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Warna bayangan
                    spreadRadius: 5, // Menyebar lebar bayangan
                    blurRadius: 7, // Blur bayangan
                    offset: Offset(0, 3), // Offset bayangan
                  ),
                ],
              ),
              child: SpGrid(children: [
                SpGridItem(
                    xs: 12,
                    sm: 12,
                    md: 12,
                    lg: 12,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: const [
                          Text(
                            "SPK OTORISASI",
                            style: TextStyle(
                                fontSize: 24,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w700),
                          ),
                          Divider(color: Colors.black)
                        ],
                      ),
                    )),
                SpGridItem(
                    xs: 12,
                    sm: 12,
                    md: 12,
                    lg: 12,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin:
                              EdgeInsetsDirectional.symmetric(horizontal: 20),
                          child: Text(
                            "Dealer",
                            style: TextStyle(
                              fontSize: 18,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.2,
                              ),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: isLoading == false
                                ? DropdownButtonHideUnderline(
                                    child: DropdownButton<Map<String, dynamic>>(
                                      value: listBSMap.first,
                                      hint: Text('Select an option'),
                                      onChanged:
                                          (Map<String, dynamic>? newValue) {
                                        isiPtBS(ddvalue["value"]);

                                        setState(() {});
                                      },
                                      items: listBSMap.map((item) {
                                        return DropdownMenuItem<
                                            Map<String, dynamic>>(
                                          value: item,
                                          child: Text(item['teks']),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                : LinearProgressIndicator()),
                      ],
                    )),
                SpGridItem(
                  xs: 12,
                  sm: 12,
                  md: 12,
                  child: Container(
                    height: 500,
                    child: FutureBuilder<List<SpkOverDisc>>(
                      future: ServiceOtorisasi.getDataSpkOverDisc(
                          namaUserID, pt, bsCode),
                      builder: (context, snapshot) {
                        try {
                          if (snapshot.connectionState !=
                              ConnectionState.waiting) {
                            // print(snapshot.data);
                            if (snapshot.data!.isNotEmpty) {
                              return dataview(snapshot);
                            } else {
                              return ErrorWidgetComponent(
                                message: 'Tidak ada Data',
                                onRetry: fetchData,
                              );
                            }
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        } catch (error) {
                          // Tangani error di sini
                          print('Error: $error');
                          return ErrorWidgetComponent(
                            message: 'Terjadi kesalahan: $error',
                            onRetry: fetchData,
                          );
                        }
                      },
                    ),
                  ),
                )
              ]),
            )
          : ErrorWidgetComponent(
              message: 'Terjadi kesalahan: $error',
              onRetry: fetchData,
            ),
    );
  }
}
