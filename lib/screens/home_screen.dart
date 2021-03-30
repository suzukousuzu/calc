import 'package:flutter/material.dart';
import 'test_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<DropdownMenuItem<int>> _menuItems = List();
  int numberOfQuestion = 0;

  @override
  void initState() {
    super.initState();
    setMenuItems();
    numberOfQuestion = _menuItems[0].value;
  }

  void setMenuItems() {
    _menuItems.add(DropdownMenuItem(value: 10, child: Text('10')));
    _menuItems.add(DropdownMenuItem(value: 20, child: Text('20')));
    _menuItems.add(DropdownMenuItem(value: 30, child: Text('30')));
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Image.asset('assets/images/image_title.png'),
                SizedBox(height: 40.0),
                Text('計算脳トレにようこそ'),
                SizedBox(height: 80.0,),
                DropdownButton(
                    items: _menuItems,
                    value: numberOfQuestion,
                    onChanged: (selectedValue){
                      setState(() {
                        numberOfQuestion = selectedValue;
                      });
                    }),

                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: RaisedButton.icon(
                      color: Colors.red,
                      icon: Icon(Icons.skip_next),
                      label: Text('スタート'),
                      onPressed: () => startTestScreen(context),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  startTestScreen(BuildContext) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TestScreen(numberOfQuestion:numberOfQuestion)));
  }
}


