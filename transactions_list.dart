import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './transactionitem.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deletetx;

  TransactionList(this.transactions, this.deletetx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraint) {
              return Column(
                children: <Widget>[
                  Text(
                    "No transactions added yet",
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    //adds an empty box or space in betn 2 objs
                    height: 20,
                  ),
                  Container(
                      height: constraint.maxHeight * 0.6,
                      child: Image.asset(
                        'assets/images/hello.png',
                        fit: BoxFit.cover,
                      )), //adding image
                ],
              );
            },
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Transactionitem(
                  transactions: transactions[index], deletetx: deletetx);
            },
            itemCount: transactions.length,
          );
  }
}
