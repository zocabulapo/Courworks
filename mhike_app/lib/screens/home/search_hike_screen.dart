import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mhike_app/models/hike_model.dart';
import 'package:mhike_app/screens/home/hike_detail_screen.dart';

class SearchResultScreen extends StatefulWidget {
  final List<Hike> searchResults;

  const SearchResultScreen({required this.searchResults});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: widget.searchResults.length,
        itemBuilder: (context, index) {
          Hike hike = widget.searchResults[index];
          return Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blueGrey[100],
            ),
            child: ListTile(
              title: Text(
                "Name hike: ${hike.name}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 10),
                  Text(
                    hike.location,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              onTap: () {
                Get.to(() => HikeDetailScreen(name: hike.name));
              },
            ),
          );
        },
      ),
    );
  }
}
