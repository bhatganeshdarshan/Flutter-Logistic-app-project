import 'package:flutter/material.dart';
import 'package:logisticapp/screens/account-page/account.dart';
import 'package:logisticapp/screens/home-page/home.dart';
import 'package:logisticapp/screens/order-page/order.dart';
import 'package:logisticapp/screens/payment-page/wallet_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;
  late TabController _tabController;
  List<Widget> screenLists = [
    homePage(),
    myOrder(),
    myWallet(),
    myAccount(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 4,
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(140),
            child: AppBar(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              )),
              shadowColor: const Color(0xff9BCF53),
              elevation: 8,
              backgroundColor: const Color(0xff9BCF53),
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
              ),
              actions: <Widget>[
                IconButton(
                  onPressed: () {},
                  color: Colors.white,
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  color: Colors.white,
                  onPressed: () {},
                  icon: const Icon(Icons.notification_add),
                ),
              ],
              bottom: TabBar(
                dividerColor: Colors.transparent,
                padding: EdgeInsets.only(bottom: 25),
                physics: BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.normal,
                ),
                isScrollable: true,
                onTap: (value) {
                  setState(() {
                    currentTab = value;
                  });
                },
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                tabs: [
                  Tab(
                    child: Text(
                      "Home",
                      style: TextStyle(
                        fontSize: (currentTab == 0) ? 32 : 16,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Orders",
                      style: TextStyle(
                        fontSize: (currentTab == 1) ? 32 : 16,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Wallet",
                      style: TextStyle(
                        fontSize: (currentTab == 2) ? 32 : 16,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Account",
                      style: TextStyle(
                        fontSize: (currentTab == 3) ? 32 : 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: screenLists[currentTab],
        ),
      ),
    );
  }
}
