import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MagnifierDemo extends StatefulWidget {
  const MagnifierDemo({super.key});

  @override
  State<MagnifierDemo> createState() => _MagnifierDemoState();
}

class _MagnifierDemoState extends State<MagnifierDemo> {
  Offset dragGesturePosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Raw Magnifier"),
          centerTitle: true,
        ),
        body: Center(
          child:
          Stack(
            children: <Widget>[
              GestureDetector(
                  onPanUpdate: (DragUpdateDetails details) =>
                      setState(
                            () {
                          dragGesturePosition = details.localPosition;
                        },
                      ),
                  child: Container(
                    // adding margin
                    margin: const EdgeInsets.all(10.0),
                    // adding padding
                    padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15),
                    // height should be fixed for vertical scrolling
                    height: MediaQuery.of(context).size.height*0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      // adding borders around the widget
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 2.0,
                      ),
                    ),
                    child:  Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                    ),
                  )

              ),
              Positioned(
                left: dragGesturePosition.dx,
                top: dragGesturePosition.dy,
                child: const RawMagnifier(
                  decoration: MagnifierDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 3),
                    ),
                  ),
                  size: Size(180, 70),
                  magnificationScale: 1.4,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
