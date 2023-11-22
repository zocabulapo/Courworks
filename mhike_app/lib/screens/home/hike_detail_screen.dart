import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mhike_app/database/database_helper.dart';
import 'package:mhike_app/models/hike_model.dart';
import 'package:mhike_app/models/observation_model.dart';
import 'dart:io';
import 'package:mhike_app/screens/home/add_observation_screen.dart';
import 'package:mhike_app/screens/home/edit_observation_screen.dart';

class HikeDetailScreen extends StatefulWidget {
  final String name;
  HikeDetailScreen({required this.name});

  @override
  State<HikeDetailScreen> createState() => _HikeDetailScreenState();
}

class _HikeDetailScreenState extends State<HikeDetailScreen> {
  Hike? hike; // Make hike nullable

  @override
  void initState() {
    super.initState();
    // Fetch hike data based on the name
    DatabaseHelper().getHikes().then((List<Hike> hikes) {
      Hike? foundHike;
      try {
        foundHike = hikes.firstWhere((hike) => hike.name == widget.name);
      } catch (e) {
        foundHike = null;
      }
      setState(() {
        hike = foundHike;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hike Detail'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => AddObservationScreen(name: hike!.name));
            },
            icon: Icon(
              Icons.add_comment,
              size: 32,
            ),
          ),
          SizedBox(
            width: 8,
          )
        ],
      ),
      body: hike != null
          ? SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Hike name: ${hike!.name}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.location_on),
                          Text('Location: ${hike!.location}'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Description: ${hike!.description}'),
                    ),
                    // ... Add other details
                    Image.file(
                      File(hike!.image),
                      height: 280,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Text('Observations:'),
                      ),
                    ),
                    buildObservationList(),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget buildObservationList() {
    return FutureBuilder<List<Observation>>(
      future: DatabaseHelper().getObservationsForHike(hike!.name),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading observations');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No observations available');
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Observation observation = snapshot.data![index];
              final dateFormat = DateFormat("HH:mm - dd/MM/yy");
              final formattedDate = dateFormat.format(observation.time);
              return Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey[100],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Text(
                        'Comment: ${observation.observationDetail}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Row(
                        children: [
                          Icon(Icons.access_time_filled),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '$formattedDate',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Row(
                        children: [
                          Icon(Icons.cloud_circle_rounded),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            ' Weather:  ${observation.weather}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Location: ${observation.locationDetail}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Image.file(
                        File(observation.image),
                        height: 280,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Text(
                        'Additional Comments: ${observation.additionalComments}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: IconButton(
                            icon: Icon(
                              Icons.edit_document,
                              size: 30,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () {
                              Get.to(() => EditObservationScreen(
                                    observation: observation,
                                  ));
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              size: 30,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              DatabaseHelper().deleteObservation(
                                  observation.hikeName, observation.time);
                              setState(() {});
                            },
                          ),
                        ),
                        
                      ],
                    ),
                    // ... Add other details
                  ],
                  // Add other details you want to display
                ),
              );
            },
          );
        }
      },
    );
  }
}
