import 'package:flutter/material.dart';
import 'package:logisticapp/screens/account-page/account.dart';
import 'package:logisticapp/screens/home-page/app_style.dart';
import 'package:logisticapp/screens/home-page/home.dart';
import 'package:logisticapp/screens/order-page/order.dart';
import 'package:logisticapp/screens/payment-page/wallet_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        currentTab = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(140),
          child: AppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            shadowColor: const Color(0xFF30b9b2),
            elevation: 8,
            backgroundColor: const Color(0xFF30b9b2),
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
            ),
            title: Text(
              'EasyLogistics',
              style: appStyle(20, Colors.white, FontWeight.w600),
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
              tabAlignment: TabAlignment.center,
              padding: const EdgeInsets.only(bottom: 20),
              dividerColor: Colors.transparent,
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              isScrollable: true,
              onTap: (index) {
                setState(() {
                  currentTab = index;
                });
              },
              tabs: [
                Tab(
                  child: Row(
                    children: [
                      Icon(
                        Icons.home,
                        size: (currentTab == 0) ? 24 : 20,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Home",
                        style: TextStyle(fontSize: (currentTab == 0) ? 20 : 16),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: [
                      Icon(
                        Icons.delivery_dining_rounded,
                        size: (currentTab == 1) ? 24 : 20,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Orders",
                        style: TextStyle(fontSize: (currentTab == 1) ? 20 : 16),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: [
                      Icon(
                        Icons.wallet_rounded,
                        size: (currentTab == 2) ? 24 : 20,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Wallet",
                        style: TextStyle(fontSize: (currentTab == 2) ? 20 : 16),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: (currentTab == 3) ? 24 : 20,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Account",
                        style: TextStyle(fontSize: (currentTab == 3) ? 20 : 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            const HomePage(),
            const OrderPage(),
            myWallet(),
            const MyAccount(),
          ],
        ),
      ),
    );
  }
}
