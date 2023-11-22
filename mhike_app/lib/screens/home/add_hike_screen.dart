import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mhike_app/database/database_helper.dart';
import 'package:mhike_app/models/hike_model.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:mhike_app/screens/navbar_bottom.dart';

class AddHikeScreen extends StatefulWidget {
  @override
  _AddHikeScreenState createState() => _AddHikeScreenState();
}

class _AddHikeScreenState extends State<AddHikeScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController partnerController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  late File _image = File('');

  double? length;
  DateTime selectedDate = DateTime.now();
  bool parkingAvailable = true;
  String difficulty = 'Medium';

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _addHike() async {
    // ignore: unnecessary_null_comparison
    if (_image == null || _image.path.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an image'),
        ),
      );
      return;
    }

    // Lấy thông tin từ các trường nhập liệu
    String name = nameController.text;
    String location = locationController.text;
    String partner = partnerController.text;
    String description = descriptionController.text;

    // Tạo đối tượng Hike với thông tin từ người dùng và URL ảnh đã chọn
    Hike newHike = Hike(
      name: name,
      location: location,
      date: selectedDate,
      partner: partner,
      parkingAvailable: parkingAvailable,
      length: length,
      difficulty: difficulty,
      description: description,
      image: _image.path,
    );
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter hike name'),
        ),
      );
      return;
    } else if (location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter hike location'),
        ),
      );
      return;
    } else if (partner.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter hiking partner'),
        ),
      );
      return;
    } else if (length == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter hike length'),
        ),
      );
      return;
    } else {
      await dbHelper.addHike(newHike);
      setState(() {});
      Get.offAll(() => NavBarBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Hike'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Hike Name'),
              ),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Hike Location'),
              ),
              TextFormField(
                controller: partnerController,
                decoration: InputDecoration(labelText: 'Hiking Partner'),
              ),
              DropdownButtonFormField<String>(
                value: difficulty,
                onChanged: (value) {
                  setState(() {
                    difficulty = value!;
                  });
                },
                items: ['Hard', 'Medium', 'Easy'].map((String level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Difficulty'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    length = double.tryParse(value);
                  });
                },
                decoration: InputDecoration(labelText: 'Length (km)'),
              ),
              SizedBox(height: 16),
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
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              CheckboxListTile(
                title: Text('Parking Available'),
                value: parkingAvailable,
                onChanged: (value) {
                  setState(() {
                    parkingAvailable = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addHike,
                child: Text('Save Hike'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
