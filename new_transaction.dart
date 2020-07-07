import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addtx;
  NewTransaction(this.addtx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final texcontroller = TextEditingController();
  final amountcontroller = TextEditingController();
  DateTime _selectedDate;

  void submitdata() {
    final enteredtext = texcontroller.text;
    final enteredamt = double.parse(amountcontroller.text);

    if (enteredtext.isEmpty || enteredamt <= 0 || _selectedDate == null)
      return null;
    else {
      widget.addtx(
        enteredtext,
        enteredamt,
        _selectedDate,
      );
      Navigator.of(context).pop(); //Closes modal sheet
    }
  }

  void _presentDatepicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: "Title"),
                controller: texcontroller,
                onSubmitted: (_) => submitdata,
                // onChanged: (val) {
                //   //Taking user input
                //   titleinput = val;
                // },
              ),
              TextField(
                decoration: InputDecoration(labelText: "Amount"),
                controller: amountcontroller,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitdata,
                // onChanged: (value) {
                //   amountinput = value;
                // },
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No date chosen!'
                            : 'Picked Date : ${DateFormat.yMd().format(_selectedDate)}',
                      ),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: _presentDatepicker,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: submitdata,
                child: Text("Add Transaction"),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
