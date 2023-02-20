import 'package:crud_api_app/model/person_model.dart';
import 'package:crud_api_app/view/personWidget.dart';
import 'package:flutter/material.dart';

import '../service/person_service.dart';
import 'add_edit_person.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Crud App')),
        body: getBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            //add
            var person = await showPersonAddEditDialog(null);
            if (person != null) {
              await addPerson(person);
              setState(() {});
            }
          },
        ));
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
      future: getPersonDetails(),
    );
  }

  Widget getPersonWidget(List<PersonDetails> data) {
    if (data.isEmpty) {
      return const Center(child: Text('there is no data'));
    }
    return ListView(children: getPersonWidgets(data));
  }

  List<Widget> getPersonWidgets(List<PersonDetails> persons) {
    var widgets = <Widget>[];
    for (var person in persons) {
      var widget = GestureDetector(
        onTap: () async {
          var newPerson = await showPersonAddEditDialog(person);
          if (newPerson != null) {
            await editPerson(newPerson);
            setState(() {});
          }
        },
        child: PersonWidget(person: person),
      );

      widgets.add(widget);
    }

    return widgets;
  }
}
