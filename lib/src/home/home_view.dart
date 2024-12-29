import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spfa/helpers/AuthenticationHelper.dart';
import 'package:spfa/src/authentication/login_view.dart';
import 'package:spfa/src/components/menu/menu.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Menu(),
      body: Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
