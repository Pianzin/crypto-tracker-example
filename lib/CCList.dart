import 'dart:convert';

import 'package:cctracker/CCData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CCList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CCListState();
  }
}

class CCListState extends State<CCList> {
  List<CCData> dataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Tracker'),
      ),
      body: Container(
        child: ListView(
          children: _buildList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => _loadCC(),
      ),
    );
  }

  List<Widget> _buildList() {
    return dataList.map((CCData it) => ListTile(
      title: Text(it.name),
      subtitle: Text(it.symbol),
      leading: CircleAvatar(child: Text(it.rank.toString())),
      trailing: Text('\$${it.price.toStringAsFixed(5)}'),
    )).toList();
  }

  _loadCC() async {
    final response = await http.get('https://api.coincap.io/v2/assets?limit=100');

    if (response.statusCode == 200) {
      var allData = (json.decode(response.body) as Map)['data'];
      var ccDataList = List<CCData>();

      allData.forEach((val) {
        ccDataList.add(CCData(
            name: val['name'],
            symbol: val['symbol'],
            price: double.parse(val['priceUsd']),
            rank: int.parse(val['rank'])));
      });

      setState(() {
        dataList = ccDataList;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCC();
  }

}