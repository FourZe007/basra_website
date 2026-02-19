import 'package:stsj/activity_point/models/model_manager_activities.dart';

class ModelManagerType {
  String dealer;
  ModelManagerActivities morningBriefing;
  ModelManagerActivities visitMarket;
  ModelManagerActivities recruitmentInterview;
  ModelManagerActivities dailyReport;

  ModelManagerType({
    required this.dealer,
    required this.morningBriefing,
    required this.visitMarket,
    required this.recruitmentInterview,
    required this.dailyReport,
  });
}
