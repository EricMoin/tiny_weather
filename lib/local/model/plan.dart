import 'package:hive_ce_flutter/adapters.dart';
import 'package:tiny_weather/local/model/info.dart';

/// 用于周期性进行的任务
/// 如每天的8:00提醒开始背单词
class Plan extends BaseInfo {
  int triggerTime;
  Plan({
    required super.uuid,
    required super.firstCreateTime,
    required super.lastModifiedTime,
    required super.startAt,
    required super.endAt,
    required super.state,
    required this.triggerTime,
    super.title,
    super.content,
  });
}