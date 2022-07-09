import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:recipe_flutter/model.dart';
import 'package:recipe_flutter/recipe_view.dart';
import 'model.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Search extends StatefulWidget {
  late String query;
  Search({required this.query});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool isLoading = true;
  bool flag = false;
  TextEditingController searchController = new TextEditingController();
  List<RecipeDetails> recipedetails = [];
  getdata(String query) async {
    Response response = await get(Uri.parse(
        "https://api.edamam.com/search?q=$query&app_id=d8e284f1&app_key=88a62bc45775609065bedc933b5cf057"));
    Map data = jsonDecode(response.body);
    if (data["more"] == false) {
      flag = true;
      isLoading = false;
      RecipeDetails instance = RecipeDetails();
      recipedetails.add(instance);
    }
    setState(() {
      List hits = data["hits"];
      hits.forEach((element) {
        Map a = element["recipe"];
        RecipeDetails instance = RecipeDetails(
            calories: a["calories"].toString().substring(0, 5),
            label: a["label"],
            image: a["image"],
            url: a["url"]);
        recipedetails.add(instance);
        setState(() {
          isLoading = false;
        });
        log(recipedetails.toString());
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blue, Colors.pink])),
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0)),
              child: Row(children: [
                GestureDetector(
                  onTap: () {
                    if ((searchController.text).replaceAll(" ", "") == "") {
                      print("Empty");
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Search(query: searchController.text)));
                    }
                  },
                  child: Icon(Icons.search),
                ),
                Expanded(
                    child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search recipe',
                  ),
                ))
              ]),
            ),
            Container(
                child: isLoading
                    ? CircularProgressIndicator()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: recipedetails.length,
                        itemBuilder: (context, index) {
                          if (flag) {
                            String a = widget.query;
                            return Center(
                                child: Container(child: Text("Not Fount $a")));
                          }

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RecipeView(
                                          url: recipedetails[index].url)));
                            },
                            child: Card(
                              margin: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0.0,
                              child: Stack(children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      recipedetails[index].image,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                    )),
                                Positioned(
                                    left: 0,
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration:
                                          BoxDecoration(color: Colors.black26),
                                      child: Row(
                                        children: [
                                          Text(recipedetails[index].label)
                                        ],
                                      ),
                                    )),
                                Positioned(
                                    right: 0,
                                    height: 40,
                                    width: 80,
                                    child: Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        recipedetails[index].calories,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ))
                              ]),
                            ),
                          );
                        })),
          ]),
        ),
      )),
    );
  }
}
