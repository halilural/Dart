import 'package:flutter/material.dart';
import 'package:personal_expense_app/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      height: 300,
      child: transactions.isEmpty
          ? LayoutBuilder(
              builder: (ctx, constraints) {
                return Column(
                  children: [
                    Text(
                      'No Transactions added yet!',
                      style: Theme.of(context).textTheme.title,
                    ),
                    // İki widget arasına space koymak için
                    SizedBox(
                      height: 10,
                    ),
                    // Image birden fazla kaynaktan gelebilir, network, url, assets, file
                    // Image'in boyu üzerinde bulunduğu parent boyunu yada genişliğini aştığında hata vereceği için
                    // Bir container ile onu wrap'larız sonra o parent'a height veririz.
                    Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset(
                        'assets/images/waiting.png',
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                );
              },
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                            child: Text('\$${transactions[index].amount}')),
                      ),
                    ),
                    title: Text(
                      transactions[index].title,
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Text(
                        DateFormat.yMMMd().format(transactions[index].date)),
                    // Ekran genişliği 360 pixel'den yüksek ise,
                    trailing: mediaQuery.size.width > 360
                        ? FlatButton.icon(
                            color: Theme.of(context).errorColor,
                            onPressed: () => deleteTx(transactions[index].id),
                            icon: Icon(Icons.delete),
                            label: Text('Delete'))
                        : IconButton(
                            onPressed: () => deleteTx(transactions[index].id),
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                          ),
                  ),
                );
              },
              itemCount: transactions.length),
    );
  }
}
