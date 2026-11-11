import 'package:flutter/material.dart';
import 'package:stsj/booking-service/global/api.dart';
import 'package:stsj/booking-service/global/model.dart';

class WorkshopState extends ChangeNotifier {
  List<ModelBooking> browseBookList = [];

  List<ModelBooking> get getBrowseBookList => browseBookList;

  List<BranchDetail> branchesList = [];

  List<BranchDetail> get getBranchesList => branchesList;

  List<Widget> rows = [];

  List<Widget> get getRows => rows;

  Future<List<BranchDetail>> loadBranches() async {
    branchesList.addAll(await GlobalAPI.fetchBranches('BRANCHSHOP'));

    return branchesList;
  }
}
