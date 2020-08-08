import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './widgets/chart.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import 'models/transaction.dart';
import 'dart:io';

void main() {
  // Device Orientation sadece portrait modda çalışsın istersek, aşağıdaki kodu yazıyoruz.
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      // Uyguylama bazlı temayı yönettiğimiz yer
      theme: ThemeData(
          // primaryColor sadece bir color üzerinden gider, swatch ise o rengin kombinasyonlarını içerir.
          primarySwatch: Colors.lightBlue,
          // Floating Button gibi bazı widget'ların renklerinin alternatif olarak ayarlanması için kullanılır.
          accentColor: Theme.of(context).primaryColorDark,
          errorColor: Colors.red,
          // pubspec.yaml dosyasındaki font adı ile eşleşir.
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              button: TextStyle(color: Colors.white)),

          // Ana temadan ziyade, tüm başlıklara font atadık ve size'i 20 yaptık.
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold)))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    // Transaction(
    //     id: 't2',
    //     title: 'Weekly Groceries',
    //     amount: 16.53,
    //     date: DateTime.now()),
  ];

  bool _showChart = false;

// Son 7 gündeki transactionlar
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime txDate) {
    final newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: txDate,
        id: DateTime.now().toString());

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
          // return GestureDetector(
          //   onTap: () {},
          //   child: NewTransaction(_addNewTransaction),
          //   behavior: HitTestBehavior.opaque,
          // );
        });
  }

  void _deleteTransanction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Aşağıdaki şekilde mediaQuery' i bu şekilde kullanmak, performans için önemlidir!
    final mediaQuery = MediaQuery.of(context);

    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: Text('Personal Expenses'),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              )
            ],
          );

    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransanction));

    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Show Chart'),
                // Adaptive, iki platformda da çalışabilen widget'lar için kullanılır.
                Switch.adaptive(
                  activeColor: Theme.of(context).accentColor,
                  value: _showChart,
                  onChanged: (val) {
                    setState(() {
                      _showChart = val;
                    });
                  },
                ),
              ],
            ),
          if (!isLandscape)
            Container(
                child: Chart(_recentTransactions),
                height: (mediaQuery.size.height -
                        // application bar tarafını kasteder.
                        appBar.preferredSize.height -
                        // Ekranın en üstündeki system tarafındaki barı kasteder.
                        mediaQuery.padding.top) *
                    0.3),
          if (!isLandscape) txListWidget,
          if (isLandscape)
            _showChart
                ? Container(
                    child: Chart(_recentTransactions),
                    height: (mediaQuery.size.height -
                            // application bar tarafını kasteder.
                            appBar.preferredSize.height -
                            // Ekranın en üstündeki system tarafındaki barı kasteder.
                            mediaQuery.padding.top) *
                        0.7)
                : txListWidget
        ],
      ),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(child: pageBody, navigationBar: appBar)
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
