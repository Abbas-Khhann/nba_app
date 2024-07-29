import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nba_app_api/model/team.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  List<Team> teams = [];

Future getTeams()async{
  const String apiUrl = 'https://api.balldontlie.io/v1/teams';
  const String apiKey = '012d02c3-3566-4811-8b71-44b1dac99e6b';
  var response = await http.get(Uri.parse(apiUrl),
  headers: {
    'Authorization' : apiKey
  }
  );

  if (response.statusCode == 200){
    var jsonData = jsonDecode(response.body);
    for(var eachTeam in jsonData['data']){
     final team = Team(
         abbreviation: eachTeam['abbreviation'],
         city: eachTeam['city'],
         name: eachTeam['name']);
     teams.add(team);
    }
    print(teams.length);

  }else{
    print('Error: ${response.statusCode}, ${response.reasonPhrase}');
  }
}

  @override
  Widget build(BuildContext context) {
    getTeams();
    return Scaffold(
      appBar: AppBar(
        title: Text("NBA Teams"),
      ),body: FutureBuilder(
      future: getTeams(),
      builder: (context, snapshot){
        // Is is done loading, then show team data
        if(snapshot.connectionState == ConnectionState.done){
          return ListView.builder(
            itemCount: teams.length,
              itemBuilder: (context, index)
          {
                 return Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Container(
                     decoration: BoxDecoration(
                       color: Colors.grey[200],
                       borderRadius: BorderRadius.circular(15)
                     ),
                     child: ListTile(
                                     title: Text(teams[index].abbreviation),
                       subtitle: Text(teams[index].name),
                       trailing: Text(teams[index].city),
                     ),
                   ),
                 );
          }
          );
        } // if it's still loading
        else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    ),
    );
  }
}
