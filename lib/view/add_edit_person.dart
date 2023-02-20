import 'package:flutter/material.dart';

import '../model/person_model.dart';

class AddEditPerson extends StatefulWidget {
  const AddEditPerson({Key? key, this.person}) : super(key: key);
  final PersonDetails? person;

  @override
  AddEditPersonState createState() => AddEditPersonState();
}

class AddEditPersonState extends State<AddEditPerson> {
  final formkey = GlobalKey<FormState>();
  TextEditingController nameControler = TextEditingController();
  TextEditingController ageControler = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.person != null) {
      nameControler.text = widget.person!.name!;
      ageControler.text = widget.person!.age.toString();
    }
  }

  String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter number ';
    }

    var valueOfAge = int.parse(value);
    if (valueOfAge < 0 || valueOfAge > 100) {
      return 'Please enter valid number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            getTitle(),
            getName(),
            getAge(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        var nametxt = nameControler.text;
                        var ageNum = int.parse(ageControler.text);

                        var personObj = PersonDetails(
                          name: nametxt,
                          age: ageNum,
                        );
                        if (widget.person != null) {
                          personObj.id = widget.person!.id;
                        }

                        Navigator.pop(context, personObj);
                      },
                      child: const Text('Ok')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'))
                ],
              ),
            )
          ]),
    );
  }

  TextFormField getAge() {
    return TextFormField(
      keyboardType: TextInputType.number,
      validator: validateNumber,
      decoration: const InputDecoration(
          icon: Icon(Icons.person),
          labelText: 'Enter Person Age',
          hintText: 'Person Age'),
      controller: ageControler,
    );
  }

  TextFormField getName() {
    return TextFormField(
      keyboardType: TextInputType.name,
      validator: validateNumber,
      decoration: const InputDecoration(
          icon: Icon(Icons.subject_outlined),
          labelText: 'Enter name',
          hintText: 'Name'),
      controller: nameControler,
    );
  }

  getTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Container(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                    child: Text(
                  widget.person == null ? 'Add' : 'Edit',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20),
                )),
              )),
        ),
      ],
    );
  }
}
