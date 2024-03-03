import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(SpinningWheelApp());
}

class SpinningWheelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spinning Wheel Example',
      home: SpinningWheelPage(),
    );
  }
}

class SpinningWheelPage extends StatefulWidget {
  @override
  _SpinningWheelPageState createState() => _SpinningWheelPageState();
}

class _SpinningWheelPageState extends State<SpinningWheelPage> {
  BehaviorSubject<int> selected = BehaviorSubject<int>.seeded(1);
  bool isSpinning = false;
  int lotteryNumber = 5;

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = List<int>.generate(10, (index) => index + 1);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'LOTTERY APP',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
          backgroundColor: Colors.deepPurple,
          toolbarHeight: 90,
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('WINNING NUMBER IS: $lotteryNumber',style: const TextStyle(fontSize: 25),),
              const SizedBox(height: 110),
              Center(
                child: Container(
                  width: 350,
                  height: 350,
                  child: GestureDetector(
                    onTap: () {
                      if (!isSpinning) {
                        _spinWheel(items.length);
                      }
                    },
                    child: FortuneWheel(
                      selected: selected.stream,
                      items: [
                        for (var it in items) FortuneItem(child: Text(it.toString())),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              ElevatedButton(
                onPressed: isSpinning ? null : () => _spinWheel(items.length),
                child: const Text('SPIN',style: TextStyle(fontSize: 20),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _spinWheel(int itemCount) {
    isSpinning = true;
    final random = Fortune.randomInt(0, itemCount - 1);
    selected.add(random);
    Future.delayed(Duration(seconds: 5), () {
      isSpinning = false;
      selected.add(random);
      _showResultDialog(random == (lotteryNumber - 1));
    });
  }

  void _showResultDialog(bool isWinner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Result:',style: TextStyle(fontSize: 30),),
          content: Text(isWinner ? 'You have won!' : 'Try again!',style: const TextStyle(fontSize: 25),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
