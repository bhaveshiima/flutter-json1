import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart'as http;
import 'dart:convert';

void main() => runApp(new MyApp());


class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'Flutter JSON Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo using JSON'),
      );
  }
}


class MyHomePage extends StatefulWidget{
  final String title;
  MyHomePage({Key key, this.title}) : super (key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<User>> _getUsers() async{
    //http://bhaveshpatel.in/testapi/memberinfo1/2.html
    var JsonURL = 'http://www.json-generator.com/api/json/get/cfwZmvEBbC?indent=2';
    var data = await http.get(JsonURL);
    var jsonData = json.decode(data.body);

    List<User> users = [];
    for(var u in jsonData){
        User user  = User(u["index"], u["about"], u["name"], u["email"], u["picture"]);
        users.add(user);
    }
    return users;
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            print(snapshot.data);

            if(snapshot.data == null){
              return Container(
                child: Center(
                  child: Text("Loading....!"),
                ),
              );
            }else{
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){

                  // Store all values in Variable
                  var ImgURL = snapshot.data[index].picture;
                  var UserName = snapshot.data[index].name;
                  var UserEmail = snapshot.data[index].email;

                  // Return the List View
                  return ListTile(
                    // Display the Image [ START ]
                    leading: CircleAvatar(
                     backgroundImage: NetworkImage(
                         ImgURL
                     ),
                    ),
                    // Display the Image [ END ]

                    title: Text(UserName),
                    subtitle: Text(UserEmail),
                    // On tap or click [ redirect to detail page ] [ START ]
                    onTap: (){
                      Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))
                      );
                    },
                    // On tap or click [ redirect to detail page ] [ END ]

                  );
                }
              );

            } //end of else
          },
        ),
      ),
    );
  }
}


// Detail Page [ START ]
class DetailPage extends StatelessWidget {
  final User user;

  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(user.name),
        ),
    );
  }
}
// Detail Page [ END ]

class User{
  final int index;
  final String about;
  final String name;
  final String email;
  final String picture;

   User(this.index, this.about, this.name, this.email, this.picture);
}