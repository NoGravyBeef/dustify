import 'package:dustify/model/stat_model.dart';
import 'package:dustify/utils/status_utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

class HourlyStat extends StatelessWidget {
  final Color darkColor;
  final Color lightColor;
  final Region region;

  const HourlyStat({
    super.key,
    required this.region,
    required this.darkColor,
    required this.lightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          ItemCode.values
              .map(
                (e) => FutureBuilder(
                  future:
                      GetIt.I<Isar>().statModels
                          .filter()
                          .regionEqualTo(region)
                          .itemCodeEqualTo(e)
                          .sortByDateTimeDesc()
                          .limit(24)
                          .findAll(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    final statModelList = snapshot.data;

                    return SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Card(
                          color: lightColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: darkColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    '시간별 ${e.krName}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              ...statModelList!.map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${e.dateTime.hour.toString().padLeft(2, '0')}:00',
                                        ),
                                      ),
                                      Expanded(
                                        child: Image.asset(
                                          StatusUtils.getStatusModelFromStat(
                                            statModel: e,
                                          ).imagePath,
                                          height: 20,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          StatusUtils.getStatusModelFromStat(
                                            statModel: e,
                                          ).label,
                                          textAlign: TextAlign.right,
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
                  },
                ),
              )
              .toList(),
    );
  }
}
