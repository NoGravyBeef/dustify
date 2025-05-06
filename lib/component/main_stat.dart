import 'dart:ui';
import 'package:flutter/material.dart' hide DateUtils;
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

import '../model/stat_model.dart';
import '../utils/status_utils.dart';
import '../utils/date_utils.dart';

class MainStat extends StatelessWidget {
  final Color mainColor;
  final Region selectedRegion;
  final bool isExpanded;

  const MainStat({
    super.key,
    required this.selectedRegion,
    required this.mainColor,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      expandedHeight: 280,
      title:
          isExpanded
              ? null
              : Text(
                selectedRegion.krName,
                style: const TextStyle(color: Colors.white),
              ),
      flexibleSpace: FlexibleSpaceBar(
        background: FutureBuilder<StatModel?>(
          future:
              GetIt.I<Isar>().statModels
                  .filter()
                  .regionEqualTo(selectedRegion)
                  .itemCodeEqualTo(ItemCode.PM10)
                  .sortByDateTimeDesc()
                  .findFirst(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final stat = snapshot.data!;
            final status = StatusUtils.getStatusModelFromStat(statModel: stat);

            return Padding(
              padding: const EdgeInsets.only(
                top: kToolbarHeight + 32,
                left: 24,
                right: 24,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedRegion.krName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateUtils.DateTimeToString(dateTime: stat.dateTime),
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Image.asset(status.imagePath, width: 80),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  status.label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  status.comment,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
