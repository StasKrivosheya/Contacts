import 'package:flutter/material.dart';

class MainListPage extends StatefulWidget {
  const MainListPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _MainListPageState();
}

class _MainListPageState extends State<MainListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(widget.title),
        ),
      ),
    );
  }
}