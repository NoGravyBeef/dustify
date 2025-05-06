// 📄 screen/home_screen.dart
import 'package:dustify/component/category_stat.dart';
import 'package:dustify/component/hourly_stat.dart';
import 'package:dustify/component/main_stat.dart';
import 'package:dustify/model/stat_model.dart';
import 'package:dustify/utils/status_utils.dart';
import 'package:dustify/widget/backgound.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  Region _currentRegion = Region.seoul;
  bool _isHeaderExpanded = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final shouldExpand = _scrollController.offset < 150;
    if (_isHeaderExpanded != shouldExpand) {
      setState(() => _isHeaderExpanded = shouldExpand);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StatModel?>(
      future:
          GetIt.I<Isar>().statModels
              .filter()
              .regionEqualTo(_currentRegion)
              .itemCodeEqualTo(ItemCode.PM10)
              .sortByDateTimeDesc()
              .findFirst(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final stat = snapshot.data!;
        final status = StatusUtils.getStatusModelFromStat(statModel: stat);

        return Scaffold(
          backgroundColor: Colors.transparent,
          drawer: Drawer(
            backgroundColor: const Color.fromARGB(255, 196, 237, 255),
            child: SafeArea(
              child: ListView.builder(
                itemCount: Region.values.length,
                itemBuilder: (context, index) {
                  final region = Region.values[index];
                  return ListTile(
                    selected: region == _currentRegion,
                    selectedTileColor: Colors.white30,
                    selectedColor: Colors.white,
                    title: Text(
                      region.krName,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 171, 168, 168),
                      ),
                    ),
                    onTap: () {
                      setState(() => _currentRegion = region);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ),
          body: Stack(
            children: [
              StatusBackground(status: status),
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  MainStat(
                    selectedRegion: _currentRegion,
                    mainColor: status.primaryColor,
                    isExpanded: _isHeaderExpanded,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          CategoryStat(
                            region: _currentRegion,
                            darkColor: status.darkColor,
                            lightColor: status.lightColor.withOpacity(0.2),
                          ),
                          const SizedBox(height: 16),
                          HourlyStat(
                            targetRegion: _currentRegion,
                            baseColor: status.darkColor,
                            accentColor: status.lightColor.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
