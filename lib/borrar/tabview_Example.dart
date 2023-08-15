import 'package:flutter/material.dart';

class TabviewExample extends StatefulWidget {
  const TabviewExample({Key? key}) : super(key: key);

  @override
  State<TabviewExample> createState() => _TabviewExampleState();
}

class _TabviewExampleState extends State<TabviewExample> {
  // This function show the sliver app bar
  // It will be called in each child of the TabBarView
  SliverAppBar showSliverAppBar(String screenTitle) {
    return SliverAppBar(
      backgroundColor: Colors.purple,
      floating: true,
      pinned: true,
      snap: false,
      title: Text(screenTitle),
      bottom: const TabBar(
        tabs: [
          Tab(
            icon: Icon(Icons.home),
            text: 'Home',
          ),
          Tab(
            icon: Icon(Icons.settings),
            text: 'Setting',
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: TabBarView(
          children: [
            // HOME TAB
            CustomScrollView(
              slivers: [
                showSliverAppBar('Kindacode Home'),

                // Anther sliver widget: SliverList
                SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(
                      height: 400,
                      child: Center(
                        child: Text(
                          'Home Tab',
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                    Container(
                      height: 1500,
                      color: Colors.green,
                    ),
                  ]),
                ),
              ],
            ),

            // SETTINGS TAB
            CustomScrollView(
              slivers: [
                showSliverAppBar('Settings Screen'),

                // Show other sliver stuff
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      height: 600,
                      color: Colors.blue[200],
                      child: const Center(
                        child: Text(
                          'Settings Tab',
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                    Container(
                      height: 1200,
                      color: Colors.pink,
                    ),
                  ]),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
