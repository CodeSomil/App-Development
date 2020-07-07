import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);
  List<Map<String, Object>> get groupedtransvalues {
    return List.generate(
      7,
      (index) {
        final weekday = DateTime.now().subtract(
          Duration(days: index),
        );

        var totalsum = 0.0;
        for (var i = 0; i < recentTransactions.length; i++) {
          if (recentTransactions[i].date.day == weekday.day &&
              recentTransactions[i].date.month == weekday.month &&
              recentTransactions[i].date.year == weekday.year) {
            totalsum = totalsum + recentTransactions[i].amount;
          }
        }
        return {
          'day': DateFormat.E().format(weekday).substring(0, 1),
          'amount': totalsum
        };
      },
    ).reversed.toList();
  }

  double get maxspending {
    return groupedtransvalues.fold(0.0, (sum, item) {
      return sum + item['amount']; //total for each day
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedtransvalues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: Chartbar(
                data['day'],
                data['amount'],
                maxspending == 0.0
                    ? 0.0
                    : (data['amount'] as double) / maxspending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
