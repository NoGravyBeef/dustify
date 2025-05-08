import 'package:dio/dio.dart';
import 'package:dustify/model/stat_model.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

class StatRepository {
  /// 현재 시각 기준으로 ISAR에 데이터가 없으면 API에서 데이터를 받아와 저장하는 함수
  static Future<void> loadData() async {
    final isarInstance = GetIt.I<Isar>();
    final currentHour = DateTime.now();
    final targetTime = DateTime(
      currentHour.year,
      currentHour.month,
      currentHour.day,
      currentHour.hour,
    );

    final existingCount =
        await isarInstance.statModels
            .filter()
            .dateTimeEqualTo(targetTime)
            .count();

    if (existingCount > 0) {
      print('이미 데이터가 존재합니다: $existingCount 개');
      return;
    }

    for (final item in ItemCode.values) {
      await _loadDataByItem(item);
    }
  }

  /// 특정 ItemCode(대기질 항목)에 대해 API에서 데이터를 받아와 ISAR에 저장하는 함수
  static Future<List<StatModel>> _loadDataByItem(ItemCode itemCode) async {
    final dio = Dio();
    final response = await dio.get(
      'http://apis.data.go.kr/B552584/ArpltnStatsSvc/getCtprvnMesureLIst',
      queryParameters: {
        'serviceKey':
            'MyfKZoP1NoGBBlIcw27fMA6M1PaRW1sEZpZAHNCMR5ecbVHpjSGQez/Kylr20crzEuDTUphAh9KkpZW3AFLkRA==',
        'returnType': 'json',
        'numOfRows': 100,
        'pageNo': 1,
        'itemCode': itemCode.name,
        'dataGubun': 'HOUR',
        'searchCondition': 'WEEK',
      },
    );

    final items =
        (response.data['response']['body']['items'] as List)
            .cast<Map<String, dynamic>>();
    final excludeKeys = ['dataGubun', 'dataTime', 'itemCode'];

    final List<StatModel> result = [];

    for (final entry in items) {
      final parsedDate = DateTime.parse(entry['dataTime']);
      for (final key in entry.keys) {
        if (excludeKeys.contains(key)) continue;

        final value = double.tryParse(entry[key]) ?? 0.0;
        final region = Region.values.firstWhere((r) => r.name == key);

        final model = StatModel(
          region: region,
          stat: value,
          dateTime: parsedDate,
          itemCode: itemCode,
        );

        final isar = GetIt.I<Isar>();

        final exists =
            await isar.statModels
                .filter()
                .regionEqualTo(region)
                .statEqualTo(value)
                .dateTimeEqualTo(parsedDate)
                .itemCodeEqualTo(itemCode)
                .count();

        if (exists > 0) continue;

        await isar.writeTxn(() async {
          await isar.statModels.put(model);
        });

        result.add(model);
      }
    }

    return result;
  }
}
