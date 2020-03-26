import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/screens/login.dart';
import 'package:dashboard/utils/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  // final userdata;
  // HomePage(this.userdata);

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
    // return HomePageState(userdata);
  }
}

class HomePageState extends State<HomePage> {
  // final userdata;
  // HomePageState(this.userdata);

  int selectedItem = 1;
  TextStyle style1 = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  //list of users and booking
  List<DocumentSnapshot> _listOfUsers;
  // List<DocumentSnapshot> _listOfBooking;
  List<DocumentSnapshot> _listOfTaskers;
  //total transaction
  double totaltransaction = 0;
  //selectedWidget
  Widget selectedWidget;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    _listOfUsers = await CustomFirestore.getAllUserData();
    // _listOfBooking = await  CustomFirestore.getAllBookingData();
    // find list of taskers
    _listOfTaskers = await CustomFirestore.getAllTaskerData();
    getAllTransactionValue();
    selectedWidget = allUserDataList();
    setState(() {});
  }

  getAllTransactionValue() {
    Firestore.instance.collection('book').snapshots().listen((snapshot) {
      double total = snapshot.documents
          .fold(0, (tot, doc) => tot + double.parse(doc.data['price']));
      setState(() {
        totaltransaction = total;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: <Widget>[
        firstHalf(),
        secondHalf(),
      ],
    ));
  }

  firstHalf() {
    return Expanded(
      flex: 1,
      child: Container(
        color: Colors.blueAccent,
        child: Column(
          children: <Widget>[
            //heading
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 4, bottom: 10),
                  child: Text(
                    'Liderfacilities',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                )),
            //Divider
            Divider(),
            //dashboard
            Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedItem = 1;
                      selectedWidget = allUserDataList();
                    });
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 4, bottom: 10),
                    child: Text(
                      'Dashboard',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color:
                              selectedItem == 1 ? Colors.white : Colors.black),
                    ),
                  ),
                )),
            //Divider
            Divider(),
            //all taskers
            Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedItem = 2;
                      selectedWidget = allTaskerDataList();
                    });
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 4, bottom: 10),
                    child: Text(
                      'All taskers',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color:
                              selectedItem == 2 ? Colors.white : Colors.black),
                    ),
                  ),
                )),
            //Divider
            Divider(),
            //all users
            Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedItem = 3;
                      selectedWidget = allUserDataList();
                    });
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 4, bottom: 10),
                    child: Text(
                      'All users',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color:
                              selectedItem == 3 ? Colors.white : Colors.black),
                    ),
                  ),
                )),
            //Divider
            Divider(),
          ],
        ),
      ),
    );
  }

  secondHalf() {
    return Expanded(
      flex: 5,
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                //top bar
                topBar(),
                //Divider
                Divider(),
                //Data
                countData(),
                //all user data
                _listOfUsers != null
                    ? selectedWidget
                    : Container(
                        width: 0,
                        height: 0,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  topBar() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Text(
            'Liderfacilities dashboard',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          Spacer(),
          Text(
            'Admin',
            style: TextStyle(fontSize: 24),
          ),
           GestureDetector(
             onTap: () {
               print('admin icon');
               logOutDropDown();
             },
                      child: Icon(
              Icons.account_circle,
              size: 40,
            ),
          )
        ],
      ),
    );
  }

  countData() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          //all users
          Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          'All Users',
                          style: style1,
                        ),
                      ),
                      Text(
                          _listOfUsers != null
                              ? _listOfUsers.length.toString()
                              : '0',
                          style: style1)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 40, top: 15, bottom: 15, right: 15),
                  child: Icon(
                    Icons.people,
                    color: Colors.blueAccent,
                    size: 45,
                  ),
                )
              ],
            ),
          ),
          //all taskers
          Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text('All taskers', style: style1),
                      ),
                      Text(
                          _listOfTaskers != null
                              ? _listOfTaskers.length.toString()
                              : '0',
                          style: style1)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 40, top: 15, bottom: 15, right: 15),
                  child: Icon(
                    Icons.card_travel,
                    color: Colors.blueAccent,
                    size: 45,
                  ),
                )
              ],
            ),
          ),
          //all taskers
          Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text('All transactions', style: style1),
                      ),
                      Text(
                          totaltransaction != null
                              ? totaltransaction.toString()
                              : '0',
                          style: style1)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 40, top: 15, bottom: 15, right: 15),
                  child: Icon(
                    Icons.attach_money,
                    color: Colors.blueAccent,
                    size: 45,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  allUserDataList() {
    return Padding(
      padding: const EdgeInsets.only(left: 45, right: 45, top: 30),
      child: Container(
        color: Colors.white,
        // child: ListView(shrinkWrap: true, children: getUserName()),
        child: getUserName(),
      ),
    );
  }

  getUserName() {
    List<DataRow> rows = [];

    if (_listOfUsers != null) {
      _listOfUsers.map((doc) {
        rows.add(DataRow(cells: [
          DataCell(
            Text(doc[('name')]),
          ),
          DataCell(Text(doc["phonenumber"] != null
              ? doc["phonenumber"].toString()
              : 'Not added yet')),
          DataCell(Text(doc["email"])),
          DataCell(Text(doc["address"] != null
              ? doc["address"].toString()
              : 'Not added yet')),
        ]));
      }).toList();
    } else {
      rows = [];
    }

    return DataTable(
      columns: [
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Phone Number')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Address')),
      ],
      rows: rows,
    );
  }

  allTaskerDataList() {
    return Padding(
      padding: const EdgeInsets.only(left: 45, right: 45, top: 30),
      child: Container(
        color: Colors.white,
        // child: ListView(shrinkWrap: true, children: getUserName()),
        child: taskerList(),
      ),
    );
  }

  taskerList() {
    List<DataRow> rows = [];

    if (_listOfTaskers != null) {
      _listOfTaskers.map((doc) {
        rows.add(DataRow(cells: [
          DataCell(
            Text(doc[('name')]),
          ),
          DataCell(Text(doc["phonenumber"] != null
              ? doc["phonenumber"].toString()
              : 'Not added yet')),
          DataCell(Text(doc["email"])),
          DataCell(Text(doc["address"] != null
              ? doc["address"].toString()
              : 'Not added yet')),
        ]));
      }).toList();
    } else {
      rows = [];
    }

    return DataTable(
      columns: [
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Phone Number')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Address')),
      ],
      rows: rows,
    );
  }

  logOutDropDown() {
    return new DropdownButton<String>(
      items: <String>['Logout', 'Login'].map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(value),
        );
      }).toList(),
      onChanged: (select) {
        signOut();
        navigateToLoginPage();
      },
    );
  }

  signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  void navigateToLoginPage() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return LoginPage();
      },
    ));
  }
}
