import 'package:flutter/material.dart';
import 'package:finance_apk/backend/accounts.dart';

class AccountsPage extends StatefulWidget {
  final Function(String) onAccountSelected;

  AccountsPage({required this.onAccountSelected});

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Account'),
      ),
      body: ListView.separated(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accounts[index].color,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8), // Optional: to make the corners rounded
              ),
              child: Icon(
                accounts[index].accountType.icon,
                color: Colors.white,
              ),
            ),
            title: Text(accounts[index].name,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                )),
            subtitle: Text(accounts[index].accountType.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                )),
            onTap: () {
              widget.onAccountSelected(accounts[index].name);
              Navigator.pop(context);
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }
}