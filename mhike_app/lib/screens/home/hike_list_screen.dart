import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mhike_app/database/database_helper.dart';
import 'package:mhike_app/models/hike_model.dart';
import 'package:mhike_app/screens/home/add_hike_screen.dart';
import 'package:intl/intl.dart';
import 'package:mhike_app/screens/home/hike_detail_screen.dart';
import 'package:mhike_app/screens/home/EditHikeScreen.dart';  // Import EditHikeScreen
import 'package:mhike_app/screens/home/search_hike_screen.dart';

class HikeListScreen extends StatefulWidget {
  @override
  State<HikeListScreen> createState() => _HikeListScreenState();
}

class _HikeListScreenState extends State<HikeListScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  void _searchHikes() async {
    String searchName = _searchController.text;
    List<Hike> searchResults = await DatabaseHelper().searchHikes(searchName);

    if (searchResults.isEmpty) {
      Get.snackbar('No Results', 'No hikes match the search criteria');
    } else {
      Get.to(() => SearchResultScreen(searchResults: searchResults));
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search Hike'),
          content: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Enter hike name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _searchHikes();
                Navigator.of(context).pop();
              },
              child: Text('Search'),
            ),
          ],
        );
      },
    );
  }

void _editHike(Hike hike) async {
  Hike? editedHike = await Get.to(() => EditHikeScreen(initialHike: hike));
  if (editedHike != null) {
    await DatabaseHelper().updateHike(editedHike);
    setState(() {
    });
  } else {
    print('Edit canceled');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hike List'),
        actions: [
          IconButton(
            onPressed: _showSearchDialog,
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => AddHikeScreen());
            },
            icon: Icon(Icons.assignment_add),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Hike>>(
          future: DatabaseHelper().getHikes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hikes available.'));
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Hike hike = snapshot.data![index];
                  final dateFormat = DateFormat("HH:mm - dd/MM/yy");
                  final formattedDate = dateFormat.format(hike.date);

                  return GestureDetector(
                    onTap: () {
                      Get.to(() => HikeDetailScreen(name: hike.name));
                    },
                    child: Container(
                      color: Colors.grey[300],
                      margin: EdgeInsets.only(bottom: 8, top: 8),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name hikes: ${hike.name}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 25,
                              ),
                              SizedBox(width: 10),
                              Text(
                                hike.location,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Start time:  $formattedDate",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Accompany:  ${hike.partner}",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Parking:  ${hike.parkingAvailable ? 'Available' : 'Not available'}",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Length:  ${hike.length.toString()} km",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Level of difficulty:  ${hike.difficulty}",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 5),
                          Image.file(
                            File(hike.image),
                            height: 280,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.to(() => HikeDetailScreen(name: hike.name));
                                },
                                icon: Icon(
                                  Icons.info,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  DatabaseHelper().deleteHike(hike.name);
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _editHike(hike);
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
