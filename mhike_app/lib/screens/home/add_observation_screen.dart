import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mhike_app/database/database_helper.dart';
import 'package:mhike_app/models/observation_model.dart';
import 'package:mhike_app/screens/home/hike_detail_screen.dart';

class AddObservationScreen extends StatefulWidget {
  final String name;

  const AddObservationScreen({required this.name});

  @override
  State<AddObservationScreen> createState() => _AddObservationScreenState();
}

class _AddObservationScreenState extends State<AddObservationScreen> {
  final TextEditingController observationController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController additionalCommentsController =
      TextEditingController();
  DateTime selectedDate = DateTime.now();
  final TextEditingController weatherController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  late File _image = File('');

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        _image = File('');
      }
    });
  }

  void _saveObservation() async {
    Observation observation = Observation(
      observationDetail: observationController.text,
      time: selectedDate,
      weather: weatherController.text,
      additionalComments: additionalCommentsController.text,
      locationDetail: locationController.text,
      image: _image.path,
      hikeName: widget.name,
    );
    if (observationController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your observation');
      return;
    } else if (weatherController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your weather');
      return;
    } else if (locationController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your location');
      return;
    } else if (additionalCommentsController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your additional comments');
      return;
    } else if (_image.path.isEmpty) {
      Get.snackbar('Error', 'Please upload your image');
      return;
    } else {
      await DatabaseHelper().addObservation(observation);
      print('Observation added successfully');
      Get.to(() => HikeDetailScreen(name: widget.name));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Observation'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: observationController,
                decoration: InputDecoration(labelText: 'Observation *'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Observation is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: weatherController,
                decoration: InputDecoration(labelText: 'Weather'),
              ),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              DateTimePicker(
                type: DateTimePickerType.dateTime,
                dateMask: 'd MMMM, yyyy - HH:mm a',
                initialValue: DateTime.now().toString(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
                icon: const Icon(Icons.event),
                dateLabelText: 'Date of the hike',
                onChanged: (val) {
                  setState(() {
                    selectedDate = DateTime.parse(val);
                  });
                },
              ),
              TextFormField(
                controller: additionalCommentsController,
                decoration: InputDecoration(labelText: 'Additional Comments'),
              ),
              // Add other fields as needed

              SizedBox(height: 16.0),
              GestureDetector(
                onTap: _getImage,
                // ignore: unnecessary_null_comparison
                child: _image == null || _image.path.isEmpty
                    ? Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey,
                        child: Icon(Icons.camera_alt,
                            size: 50, color: Colors.white),
                      )
                    : Image.file(_image,
                        width: 200, height: 200, fit: BoxFit.cover),
              ),
              ElevatedButton(
                onPressed: () {
                  _saveObservation();
                },
                child: Text('Save Observation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
