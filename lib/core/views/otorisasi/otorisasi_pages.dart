import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_grid/simple_grid.dart';
import 'package:stsj/router/router_const.dart';
import 'package:stsj/global/widget/app_bar.dart';

class OtoriasiPages extends StatefulWidget {
  const OtoriasiPages({super.key});

  @override
  State<OtoriasiPages> createState() => _OtoriasiPagesState();
}

class _OtoriasiPagesState extends State<OtoriasiPages> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controller untuk mengendalikan nilai-nilai bidang input teks
  TextEditingController tokenController = TextEditingController();
  TextEditingController transactionNoController = TextEditingController();
  TextEditingController actionController = TextEditingController();
  TextEditingController requestFromController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const double spacing = 8.0;
    const double hintSize = 12.0;

    double sizeBox = 1200;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            56,
          ),
          child: CustomAppBar(goBack: RoutesConstant.menu),
        ),
        backgroundColor: Color.fromARGB(255, 231, 230, 230),
        body: Center(
          child: SpGrid(
            children: [
              SpGridItem(
                  xs: 12,
                  sm: 12,
                  md: 12,
                  lg: 12,
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255,
                                255), // Add your desired background color here
                            border: Border.all(
                              color: Colors
                                  .grey, // You can choose the border color you want
                              width: 1.0, // Adjust the border width as needed
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Warna bayangan
                                spreadRadius: 5, // Menyebar lebar bayangan
                                blurRadius: 7, // Blur bayangan
                                offset: Offset(0, 3), // Offset bayangan
                              ),
                            ],
                            // Add border radius
                          ),
                          width: sizeBox,
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          height: 620,
                          child: Form(
                            key: _formKey,
                            child: ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(16.0),
                              children: [
                                // Bidang input teks untuk TOKEN
                                SizedBox(height: 8.0),

                                Wrap(
                                  spacing:
                                      16.0, // Menambahkan jarak horizontal antara elemen-elemen dalam Wrap
                                  runSpacing:
                                      8.0, // Menambahkan jarak vertikal antara baris dalam Wrap
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'TOKEN',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        SizedBox(
                                          child: TextFormField(
                                            controller: tokenController,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'Enter your TOKEN',
                                              hintStyle: TextStyle(
                                                fontSize:
                                                    hintSize, // Ganti ukuran font sesuai keinginan Anda
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter TOKEN';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'TRANSACTION NO',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        SizedBox(
                                          child: TextFormField(
                                            controller: transactionNoController,
                                            enabled: false,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'TRANSACTION NO',
                                              hintStyle: TextStyle(
                                                fontSize:
                                                    hintSize, // Ganti ukuran font sesuai keinginan Anda
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter TRANSACTION NO';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                SizedBox(height: spacing),

                                const Text(
                                  'REASON',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),

                                TextFormField(
                                  controller: reasonController,
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize:
                                          hintSize, // Ganti ukuran font sesuai keinginan Anda
                                    ),
                                    border: OutlineInputBorder(),
                                    hintText: 'REASON',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Harap masukkan REASON';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: spacing),
                                const Text(
                                  'REQUEST FROM',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextFormField(
                                  controller: requestFromController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'REQUEST FROM',
                                    hintStyle: TextStyle(
                                      fontSize:
                                          hintSize, // Ganti ukuran font sesuai keinginan Anda
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Harap masukkan REQUEST FROM';
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(height: spacing),

                                Text(
                                  'PASSWORD',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize:
                                          hintSize, // Ganti ukuran font sesuai keinginan Anda
                                    ),
                                    border: OutlineInputBorder(),
                                    hintText: 'PASSWORD',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Harap masukkan PASSWORD';
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(height: spacing),

                                const Text(
                                  'REASON',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),

                                TextFormField(
                                  controller: actionController,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize:
                                          hintSize, // Ganti ukuran font sesuai keinginan Anda
                                    ),
                                    border: OutlineInputBorder(),
                                    hintText: 'ACTION',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter ACTION';
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(height: spacing),

                                // Tombol untuk mengirimkan formulir
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: FilledButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        // Lakukan sesuatu dengan nilai-nilai bidang input teks
                                        print('TOKEN: ${tokenController.text}');
                                        print(
                                            'TRANSACTION NO: ${transactionNoController.text}');
                                        print(
                                            'ACTION: ${actionController.text}');
                                        print(
                                            'REQUEST FROM: ${requestFromController.text}');
                                        print(
                                            'REASON: ${reasonController.text}');
                                        print(
                                            'PASSWORD: ${passwordController.text}');
                                      }
                                    },
                                    child: Text('Generate'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ));
  }
}
