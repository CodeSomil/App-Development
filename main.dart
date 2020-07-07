import 'dart:io';
import 'package:flutter/material.dart';
import './widgets/chart.dart';
import './widgets/transactions_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.redAccent,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              //text theme for rest of the content
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                //applies specic font to all appbar titles
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ), //generates shades of color
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleinput;
  // String amountinput;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _usertransaction = [
    // Transaction(
    //   id: "t1",
    //   title: "My Shoes",
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: "t2",
    //   title: "Groceries",
    //   amount: 16.53,
    //   date: DateTime.now(),
    // ),  Empty transaction list without any previous transactions.
  ];

  List<Transaction> get _recentTrans {
    return _usertransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTrans(String txtitle, double txamt, DateTime chosendate) {
    final newtx = Transaction(
      id: DateTime.now().toString(),
      title: txtitle,
      amount: txamt,
      date: chosendate,
    );

    setState(() {
      _usertransaction.add(newtx);
    });
  }

  void _startNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        //will display new transaction window after + icon is pressed
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTrans);
        });
  }

  void _deleteTrans(String id) {
    setState(() {
      _usertransaction.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appbar = AppBar(
      title: Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startNewTransaction(context),
        ),
      ],
    );
    return Scaffold(
      appBar: appbar,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _startNewTransaction(context),
            ),
      body: SingleChildScrollView(
        //Adds scroling functionality
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
                height: (MediaQuery.of(context).size.height -
                        appbar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.3,
                child: Chart(_recentTrans)),
            Container(
                height: (MediaQuery.of(context).size.height -
                        appbar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.7,
                child: TransactionList(_usertransaction, _deleteTrans)),
          ],
        ),
      ),
    );
  }
}
