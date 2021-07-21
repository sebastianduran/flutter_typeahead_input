import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_typeahead_input/data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late DocumentReference linkRef;
  List<String> cityID = [];
  bool showItem = false;

  @override
  void initState() {
    linkRef = FirebaseFirestore.instance
        .collection('cities')
        .doc('2FsFlRxhFaLtTdtoY2XvYT');
    super.initState();
    getData();
  }

  getData() async {
    await linkRef
        .get()
        .then((value) => value.data()?.forEach((key, value) {
              if (!cityID.contains(value)) {
                cityID.add(value);
              }
            }))
        .whenComplete(() => setState(() {
              cityID.shuffle();
              showItem = true;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("App de busqueda"),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                },
                icon: Icon(Icons.search))
          ],
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<Cities> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      onPressed: () {},
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Center(child: Text(query));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final suggestionList = query.isEmpty
        ? citiesDetails
        : citiesDetails
            .where((element) => element.name.startsWith(query))
            .toList();
    return suggestionList.isEmpty
        ? Center(
            child: Text("No se encontraron datos"),
          )
        : ListView.builder(
            itemCount: suggestionList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    left: 15.00, right: 15.00, top: 15.00),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        showResults(context);
                      },
                      leading: Icon(Icons.location_city, size: 40),
                      title: Text(suggestionList[index].name),
                      subtitle:
                          Text("id${(suggestionList[index].id.toString())}"),
                    ),
                  ],
                ),
              );
            });
  }
}
