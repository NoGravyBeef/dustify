import 'package:dustify/component/category_stat.dart';
import 'package:dustify/component/hourly_stat.dart';
import 'package:dustify/component/main_stat.dart';
import 'package:dustify/model/stat_model.dart';
import 'package:dustify/repository/stat_repository.dart';
import 'package:dustify/utils/status_utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController scrollController = ScrollController();
  bool isExpanded = false;
  Region region = Region.seoul;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    StatRepository.fetchData();
    getCount();

    scrollController.addListener(() {
      bool isExpandedNow = scrollController.offset < (499 - kToolbarHeight);

      if (isExpandedNow != isExpanded) {
        setState(() {
          isExpanded = isExpandedNow;
        });
      }
    });
  }

  getCount() async {
    print(await GetIt.I<Isar>().statModels.count());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StatModel?>(
      future:
          GetIt.I<Isar>().statModels
              .filter()
              .regionEqualTo(region)
              .itemCodeEqualTo(ItemCode.PM10)
              .sortByDateTimeDesc()
              .findFirst(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(body: CircularProgressIndicator());
        }

        final statModel = snapshot.data!;
        final statusModel = StatusUtils.getStatusModelFromStat(
          statModel: statModel,
        );
        return Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                // DrawerHeader(child: Text('지역 선택')),
                ...Region.values.map(
                  (e) => ListTile(
                    selected: e == region,
                    tileColor: Colors.white,
                    selectedTileColor: statusModel.lightColor,
                    selectedColor: Colors.black,
                    onTap: () {
                      setState(() {
                        region = e;
                      });
                      Navigator.of(context).pop();
                    },
                    title: Text(e.krName),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: statusModel.primaryColor,
          body: CustomScrollView(
            controller: scrollController,
            slivers: [
              MainStat(
                region: region,
                primaryColor: statusModel.primaryColor,
                isExpanded: isExpanded,
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    CategoryStat(
                      region: region,
                      darkColor: statusModel.darkColor,
                      lightColor: statusModel.lightColor,
                    ),
                    HourlyStat(
                      region: region,
                      darkColor: statusModel.darkColor,
                      lightColor: statusModel.lightColor,
                    ),
                  ],
                ),
              ),
            ],
            // Column(
            //   children: [
            //     MainStat(region: region),
            //     CategoryStat(
            //       region: region,
            //       darkColor: statusModel.darkColor,
            //       lightColor: statusModel.lightColor,
            //     ),
            //     HourlyStat(
            //       region: region,
            //       darkColor: statusModel.darkColor,
            //       lightColor: statusModel.lightColor,
            //     ),
            //   ],
            // ),
          ),
        );
      },
    );
  }
}
