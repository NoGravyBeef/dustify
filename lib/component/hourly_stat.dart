import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

import '../model/stat_model.dart';
import '../utils/status_utils.dart';

class HourlyStat extends StatelessWidget {
  final Color baseColor;
  final Color accentColor;
  final Region targetRegion;

  const HourlyStat({
    super.key,
    required this.targetRegion,
    required this.baseColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          ItemCode.values.map((code) {
            return FutureBuilder<List<StatModel>>(
              future:
                  GetIt.I<Isar>().statModels
                      .filter()
                      .regionEqualTo(targetRegion)
                      .itemCodeEqualTo(code)
                      .sortByDateTimeDesc()
                      .limit(24)
                      .findAll(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final statList = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          border: Border.all(color: Colors.white30),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '시간별 ${code.krName}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 80,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: statList.length,
                                separatorBuilder:
                                    (_, __) => const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final stat = statList[index];
                                  final level =
                                      StatusUtils.getStatusModelFromStat(
                                        statModel: stat,
                                      );

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${stat.dateTime.hour.toString().padLeft(2, '0')}:00',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Image.asset(level.imagePath, height: 24),
                                      const SizedBox(height: 4),
                                      Text(
                                        level.label,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
    );
  }
}
