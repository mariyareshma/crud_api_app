import 'dart:convert';

import 'package:dio/dio.dart';

import '../model/person_model.dart';

var dio = Dio();

const String apibase = 'f31e2d83044e41ceb084aa425987c508';

Future<List<PersonDetails>> getPersonDetails() async {
  var response = await dio.get('https://crudcrud.com/api/$apibase/users');

  if (response.statusCode == 200) {
    var personJsons = response.data;
    var persons = <PersonDetails>[];
    for (var personJson in personJsons) {
      var personObj = PersonDetails.fromJson(personJson);
      persons.add(personObj);
    }
    return persons;
  }

  return <PersonDetails>[];
}

Future<bool> deletePerson(PersonDetails personObj) async {
  var url = 'https://crudcrud.com/api/$apibase/users/${personObj.id}';
  var response = await dio.delete(url);
  if (response.statusCode == 200) {
    return true;
  }
  return false;
}

Future<bool> editPerson(PersonDetails personObj) async {
  dio.options.contentType = 'application/json';
  var url = 'https://crudcrud.com/api/$apibase/users/${personObj.id}';
  var response = await dio.put(url, data: jsonEncode(personObj.toJson()));
  if (response.statusCode == 200) {
    return true;
  }
  return false;
}

Future<bool> addPerson(PersonDetails personObj) async {
  dio.options.contentType = 'application/json';
  var url = 'https://crudcrud.com/api/$apibase/users';
  var response = await dio.post(url, data: jsonEncode(personObj.toJson()));
  if (response.statusCode == 201) {
    return true;
  }
  return false;
}
