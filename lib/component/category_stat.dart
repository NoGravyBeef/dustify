import 'package:dustify/model/stat_model.dart';
import 'package:dustify/utils/status_utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

class CategoryStat extends StatelessWidget {
  final Color darkColor;
  final Color lightColor;
  final Region region;

  const CategoryStat({
    super.key,
    required this.region,
    required this.darkColor,
    required this.lightColor,
  });

  @override
  Widget build(BuildContext context) {
    final itemOrder = [
      ItemCode.PM10,
      ItemCode.PM25,
      ...ItemCode.values.where((e) => e != ItemCode.PM10 && e != ItemCode.PM25),
    ];

    final maxValues = {
      ItemCode.PM10: 200.0,
      ItemCode.PM25: 100.0,
      ItemCode.SO2: 0.3,
      ItemCode.NO2: 0.2,
      ItemCode.CO: 10.0,
      ItemCode.O3: 0.2,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: lightColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.2),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            ...itemOrder.map(
              (itemCode) => FutureBuilder<StatModel?>(
                future:
                    GetIt.I<Isar>().statModels
                        .filter()
                        .regionEqualTo(region)
                        .itemCodeEqualTo(itemCode)
                        .sortByDateTimeDesc()
                        .findFirst(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final statModel = snapshot.data!;
                  final statusModel = StatusUtils.getStatusModelFromStat(
                    statModel: statModel,
                  );

                  final max = maxValues[itemCode]!;
                  final ratio = (statModel.stat / max).clamp(0.0, 1.0);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                itemCode.krName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                statModel.stat.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: ratio,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                statusModel.primaryColor,
                              ),
                              minHeight: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Image.asset(
                          statusModel.imagePath,
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// import 'package:dustify/model/stat_model.dart';
// import 'package:dustify/utils/status_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:isar/isar.dart';

// class CategoryStat extends StatelessWidget {
//   final Color darkColor;
//   final Color lightColor;
//   final Region region;

//   const CategoryStat({
//     super.key,
//     required this.region,
//     required this.darkColor,
//     required this.lightColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 160,
//       //기준 높이 지정
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: LayoutBuilder(
//             builder: (context, constraint) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: darkColor,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(16),
//                         topRight: Radius.circular(16),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4),
//                       child: Text(
//                         '종류별 통계',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     //expanded로 남은 높이 쓰겠다 선언
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: lightColor,
//                         borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(16),
//                           bottomRight: Radius.circular(16),
//                         ),
//                       ),
//                       child: ListView(
//                         // physics: PageScrollPhysics(),
//                         scrollDirection: Axis.horizontal,
//                         children:
//                             ItemCode.values
//                                 .map(
//                                   (e) => FutureBuilder(
//                                     future:
//                                         GetIt.I<Isar>().statModels
//                                             .filter()
//                                             .regionEqualTo(region)
//                                             .itemCodeEqualTo(e)
//                                             .sortByDateTimeDesc()
//                                             .findFirst(),
//                                     builder: (context, snapshot) {
//                                       if (snapshot.hasError) {
//                                         return Center(
//                                           child: Text(
//                                             snapshot.error.toString(),
//                                           ),
//                                         );
//                                       }
//                                       if (!snapshot.hasData) {
//                                         return CircularProgressIndicator();
//                                       }

//                                       final statModel = snapshot.data;
//                                       final statusModel =
//                                           StatusUtils.getStatusModelFromStat(
//                                             statModel: statModel!,
//                                           );

//                                       return SizedBox(
//                                         width: constraint.maxWidth / 3,
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Text(e.krName),
//                                             SizedBox(height: 8),
//                                             Image.asset(
//                                               statusModel.imagePath,
//                                               width: 50,
//                                             ),
//                                             SizedBox(height: 8),
//                                             Text(statModel.stat.toString()),
//                                           ],
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 )
//                                 .toList(),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
