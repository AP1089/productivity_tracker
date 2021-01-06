import 'package:click_up/common/shared_strings.dart';
import 'package:click_up/features/status_management_with_sqlite/ui/status_management_with_sqlite_widget.dart';
import 'package:click_up/navigation/bottom_bar_item_model.dart';
import 'package:click_up/features/status_management_with_api/ui/status_management_with_api_widget.dart';
import 'package:click_up/theme/app_style.dart';
import 'package:flutter/material.dart';

const _sharedStrings = SharedStrings();

class BottomNavigationContainer extends StatefulWidget {
  BottomNavigationContainer();
  @override
  _BottomNavigationContainerState createState() =>
      _BottomNavigationContainerState();
}

class _BottomNavigationContainerState extends State<BottomNavigationContainer>
    with TickerProviderStateMixin {
  int currentTabIndex = 0;
  List<Widget> _tabLandingPages;

  final bottomBarModels = <BottomBarItemModel>[
    BottomBarItemModel(
        icon: Icons.alt_route,
        barItemTitle: Text(_sharedStrings.api,
            style: TextStyle(
                fontFamily: AppStyle.font,
                fontSize: 16,
                color: AppStyle.black54)),
        barItemColor: AppStyle.purple),
    BottomBarItemModel(
        icon: Icons.table_rows_outlined,
        barItemTitle: Text(_sharedStrings.sqlite,
            style: TextStyle(
                fontFamily: AppStyle.font,
                fontSize: 16,
                color: AppStyle.black54)),
        barItemColor: AppStyle.blue)
  ];

  @override
  void initState() {
    super.initState();

    _tabLandingPages = [
      StatusManagementWithApiWidget(),
      StatusManagementWithSQLiteWidget(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var bottomBarItems = <BottomNavigationBarItem>[];
    for (int i = 0; i < bottomBarModels.length; i++) {
      bottomBarItems.add(
        BottomNavigationBarItem(
          icon: Column(
            children: [
              Icon(bottomBarModels[i].icon),
              bottomBarModels[i].barItemTitle,
            ],
          ),
          label: "",
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
          color: AppStyle.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: AppStyle.black12,
                offset: Offset(-10, 10),
                blurRadius: 20,
                spreadRadius: 10)
          ]),
      child: Scaffold(
        backgroundColor: AppStyle.transparent,
        body: _tabLandingPages[currentTabIndex],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Stack(
            children: <Widget>[
              BottomNavigationBar(
                selectedIconTheme: IconThemeData(
                  color: bottomBarModels[currentTabIndex].barItemColor,
                  size: 35,
                ),
                unselectedItemColor: AppStyle.gray,
                elevation: 0,
                currentIndex: currentTabIndex,
                items: bottomBarItems,
                onTap: onTabTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTabTap(int newIndex) {
    setState(() {
      currentTabIndex = newIndex;
    });
  }
}
