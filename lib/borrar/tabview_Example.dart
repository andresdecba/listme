import 'package:flutter/material.dart';

class TabviewExample extends StatefulWidget {
  const TabviewExample({Key? key}) : super(key: key);

  @override
  State<TabviewExample> createState() => _TabviewExampleState();
}

class _TabviewExampleState extends State<TabviewExample> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: const Text('screenTitle'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.settings), text: 'Setting'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1
            Container(
              height: 400,
              color: Colors.yellow,
              child: const Center(
                child: Text(
                  'Home Tab 1',
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),

            // TAB 2
            Container(
              height: 400,
              color: Colors.green,
              child: const Center(
                child: Text(
                  'Home Tab 2',
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
