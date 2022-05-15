import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Johannes Milke - https://youtu.be/Pp3zoNDGZUI  - API FutureBuilder & Await (HTTP GET API)
class SampleFifthPage extends StatefulWidget {
  const SampleFifthPage({Key? key}) : super(key: key);

  @override
  State<SampleFifthPage> createState() => _SampleFifthPageState();
}

class _SampleFifthPageState extends State<SampleFifthPage> {
  late Future<int> dataFuture;
  late Future<int?> dataFutureNullable;

  @override
  void initState() {
    super.initState();

    dataFuture = getDataAPI();
    dataFutureNullable = getDataNull();
  }

////////////////////////////////////////////////////////////////////////////////////////////////////
//    Test Case 1 - return static value right away
////////////////////////////////////////////////////////////////////////////////////////////////////
  int getData() {
    return 7;
  }

////////////////////////////////////////////////////////////////////////////////////////////////////
//    Test Case 2 - wait some time to load data
////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<int> getDataLater() async {
    await Future.delayed(const Duration(seconds: 4));

    return 4;
  }

////////////////////////////////////////////////////////////////////////////////////////////////////
//    Test Case 3 - wait some time to load data
////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<int> getDataError() async {
    await Future.delayed(const Duration(seconds: 4));

    throw 'Failed';
  }

////////////////////////////////////////////////////////////////////////////////////////////////////
//    call an API that takes some time to return a value
//        Test Case 4 - (bad) call the api from the build method
//        Test Case 5 - (better) call the api from init state or in handler, then call set state
////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<int> getDataAPI() async {
    final result = await http.get(
      // Uri.parse('https://randomnumberapi.com/api/v1.0/random'),
      Uri.parse(
          'https://www.random.org/integers/?num=1&min=1&max=6&col=1&base=10&format=plain&rnd=new'),
    );

    await Future.delayed(const Duration(seconds: 3));

    // final body = json.decode(result.body);
    // int randomNumber = (body as List).first;
    // int randomNumber = int.parse(body['buildVersion']);
    int randomNumber = int.parse(result.body);

    return randomNumber;
  }

////////////////////////////////////////////////////////////////////////////////////////////////////
//    Test Case 6 - return null
////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<int?> getDataNull() async {
    await Future.delayed(const Duration(seconds: 4));

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("fifth screen"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () => setState(() {
          dataFuture = getDataAPI();
          dataFutureNullable = getDataNull();
        }),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('Static Value: ${getData()}'),
          ),
          const SizedBox(
            height: 24,
          ),
          Center(
            child: FutureBuilder<int?>(
              future:
                  getDataLater(), //DON'T DO THIS - every `setState()` call triggers this in the build method (i.e. an API call to the server)
              builder: (context, snapshot) {
                //Check to see if the future errored
                if (snapshot.hasError) {
                  final error = snapshot.error;
                  return Text('Future Error: $error');
                }
                //Check to see if the future returned
                else if (snapshot.hasData) {
                  // Get the int from the future function call (i.e. getDataLater() )
                  int data = snapshot.data!;

                  return Text('Future Value: $data');
                } else {
                  // return const Text('Future Value: Waiting');
                  return const CircularProgressIndicator.adaptive();
                }
              },
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Center(
            child: FutureBuilder<int?>(
              future:
                  getDataError(), //DON'T DO THIS - every `setState()` call triggers this in the build method (i.e. an API call to the server)
              builder: (context, snapshot) {
                //Check to see if the future errored
                if (snapshot.hasError) {
                  final error = snapshot.error;
                  return Text('Future Error: $error');
                }
                //Check to see if the future returned
                else if (snapshot.hasData) {
                  // Get the int from the future function call (i.e. getDataLater() )
                  int data = snapshot.data!;

                  return Text('Future Value: $data');
                } else {
                  // return const Text('Future Value: Waiting');
                  return const CircularProgressIndicator.adaptive();
                }
              },
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Center(
            child: FutureBuilder<int?>(
              future:
                  getDataAPI(), //DON'T DO THIS - every `setState()` call triggers this in the build method (i.e. an API call to the server)
              builder: (context, snapshot) {
                //Check to see if the future errored
                if (snapshot.hasError) {
                  final error = snapshot.error;
                  return Text('WRONG API Error: $error');
                }
                //Check to see if the future returned
                else if (snapshot.hasData) {
                  // Get the int from the future function call (i.e. getDataLater() )
                  int data = snapshot.data!;

                  return Text('WRONG API Value: $data');
                } else {
                  return Wrap(
                    children: const [
                      Text('WRONG API Value Waiting : '),
                      CircularProgressIndicator.adaptive(),
                    ],
                  );
                }
              },
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Center(
            child: FutureBuilder<int?>(
              future:
                  dataFuture, //DO THIS - static instance of the data, until it's forced to refresh
              builder: (context, snapshot) {
                //Check to see if the future errored
                if (snapshot.hasError) {
                  final error = snapshot.error;
                  return Text('BETTER API Error: $error');
                }
                //Check to see if the future returned
                else if (snapshot.hasData) {
                  // Get the int from the future function call (i.e. getDataLater() )
                  int data = snapshot.data!;

                  return Text('BETTER API Value: $data');
                } else {
                  return Wrap(
                    children: const [
                      Text('BETTER API Value Waiting : '),
                      CircularProgressIndicator.adaptive(),
                    ],
                  );
                }
              },
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Center(
            child: FutureBuilder<int?>(
              future:
                  dataFutureNullable, //DO THIS - static instance of the data, until it's forced to refresh
              builder: (context, snapshot) {
                //Check to see if the future errored
                if (snapshot.hasError) {
                  final error = snapshot.error;
                  return Text('Better API Nullable: $error');
                }
                //Check to see if the future returned
                else if (snapshot.hasData) {
                  // Get the int from the future function call (i.e. getDataLater() )
                  int data = snapshot.data!;

                  return Text('BETTER API Nullable: $data');
                } else {
                  return Wrap(
                    children: const [
                      Text('BETTER API Nullable Waiting : '),
                      CircularProgressIndicator.adaptive(),
                    ],
                  );
                }
              },
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Center(
            child: FutureBuilder<int?>(
              future:
                  dataFuture, //DO THIS - static instance of the data, until it's forced to refresh
              builder: (context, snapshot) {
                //handle no data vs. in process separately
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Wrap(
                      children: const [
                        Text('Robust API Value Waiting : '),
                        CircularProgressIndicator.adaptive(),
                      ],
                    );
                  case ConnectionState.done:
                  default:
                    if (snapshot.hasError) {
                      final error = snapshot.error;
                      return Text('Robust API Nullable: $error');
                    } else if (snapshot.hasData) {
                      int data = snapshot.data!;
                      return Text('Robust API Nullable: $data');
                    } else {
                      return const Text('Robust API Value No Data');
                    }
                }
              },
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
            label: const Text('SetState'),
          )
        ],
      ),
    );
  }
}
