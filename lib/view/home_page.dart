import 'package:crud_api_app/model/person_model.dart';
import 'package:crud_api_app/view/person_widget.dart';
import 'package:flutter/material.dart';

import '../service/person_service.dart';
import 'add_edit_person.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<PersonDetails> filteredList = <PersonDetails>[];

  List<PersonDetails> originalList = <PersonDetails>[];

  var searchItem = '';

  Future<PersonDetails?> showPersonAddEditDialog(PersonDetails? person) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: AddEditPerson(person: person),
        );
      },
    );
  }

  Future<bool?> showDeleteOption() async {
    return await showDialog<bool?>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirm:'),
            content: const Text("Are you sure you want to delete the person "),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Yes'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("No"),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  Future getDataFromApi() async {
    originalList = await getPersonDetails();
  }

  Future<List<PersonDetails>> filterResults() async {
    await getDataFromApi();

    filteredList = originalList
        .where((element) =>
            element.name!.contains(searchItem) ||
            element.age!.toString().contains(searchItem))
        .toList();

    return filteredList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crud App')),
      body: getBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          //add
          var person = await showPersonAddEditDialog(null);
          if (person != null) {
            await addPerson(person);
            setState(() {});
          }
        },
      ),
    );
  }

  Widget getBody() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          return getPersonWidget(data!);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: filterResults(),
    );
  }

  Widget getPersonWidget(List<PersonDetails> data) {
    // if (data.isEmpty) {
    //   return const Center(child: Text('there is no data'));
    // }
    return Column(
      children: [
        searchBar(),
        Expanded(child: ListView(children: getPersonWidgets(data))),
      ],
    );
  }

  List<Widget> getPersonWidgets(List<PersonDetails> persons) {
    var widgets = <Widget>[];
    for (var person in persons) {
      var widget = GestureDetector(
        onLongPress: () async {
          var canDelete = await showDeleteOption();
          if (canDelete!) {
            await deletePerson(person);
            await filterResults();
            setState(() {});
          }
        },
        onTap: () async {
          var newPerson = await showPersonAddEditDialog(person);
          if (newPerson != null) {
            await editPerson(newPerson);
            await filterResults();
            setState(() {});
          }
        },
        child: PersonWidget(person: person),
      );

      widgets.add(widget);
    }

    return widgets;
  }

  Widget searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        keyboardType: TextInputType.name,
        decoration: const InputDecoration(
          constraints: BoxConstraints(minWidth: 20, minHeight: 20),
          hintText: 'search',
          labelText: 'search the crud in List',
          icon: Icon(Icons.search),
        ),
        onChanged: (value) async {
          searchItem = value;
          await filterResults();
          setState(() {});
        },
      ),
    );
  }

  // void applyFilter() {
  //   setState(() {
  //   //   filteredList = data
  //   //       .where((element) =>
  //   //           element.name!.contains(searchItem) &&
  //   //           element.age!.toString().contains(searchItem))
  //   //       .toList();
  //   // });
  // }
}
