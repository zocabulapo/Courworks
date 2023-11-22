import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mhike_app/models/hike_model.dart';

class EditHikeScreen extends StatefulWidget {
  final Hike initialHike;

  EditHikeScreen({required this.initialHike});

  @override
  State<EditHikeScreen> createState() => _EditHikeScreenState();
}

class _EditHikeScreenState extends State<EditHikeScreen> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _dateController;
  late TextEditingController _partnerController;
  late TextEditingController _lengthController;
  File? _image;

  bool parkingAvailable = true;
  String difficulty = 'Medium';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialHike.name);
    _locationController = TextEditingController(text: widget.initialHike.location);
    _dateController = TextEditingController(text: widget.initialHike.date.toIso8601String());
    _partnerController = TextEditingController(text: widget.initialHike.partner);
    _lengthController = TextEditingController(text: widget.initialHike.length.toString());
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      print("Image picked: ${imageFile.path}");
      setState(() {
        _image = imageFile;
      });
    } else {
      print("No image picked");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Hike'),
        actions: [
          IconButton(
            onPressed: () {
              // Save changes and pop the screen
              Hike editedHike = Hike(
                id: widget.initialHike.id,
                name: _nameController.text,
                location: _locationController.text,
                date: DateTime.parse(_dateController.text),
                partner: _partnerController.text,
                parkingAvailable: parkingAvailable,
                length: double.parse(_lengthController.text),
                difficulty: difficulty,
                description: widget.initialHike.description,
                image: _image?.path ?? widget.initialHike.image,
              );
              Navigator.of(context).pop(editedHike);
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            _image != null
                ? Image.file(
                    _image!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )
                : widget.initialHike.image.isNotEmpty
                    ? Image.file(
                        File(widget.initialHike.image),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    : Container(),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            // ...

TextFormField(
  controller: _dateController,
  decoration: InputDecoration(
    labelText: 'Date and Time',
    suffixIcon: GestureDetector(
      onTap: () async {
        DateTime currentDate = DateTime.parse(_dateController.text);
        
        // Show date picker
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: currentDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (pickedDate != null) {
          // Show time picker
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentDate),
          );

          if (pickedTime != null) {
            DateTime selectedDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );

            setState(() {
              _dateController.text = selectedDateTime.toIso8601String();
            });
          }
        }
      },
      child: Icon(Icons.calendar_today),
    ),
  ),
),

// ...

            TextField(
              controller: _partnerController,
              decoration: InputDecoration(labelText: 'Partner'),
            ),
            TextField(
              controller: _lengthController,
              decoration: InputDecoration(labelText: 'Length (km)'),
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
            CheckboxListTile(
              title: Text('Parking Available'),
              value: parkingAvailable,
              onChanged: (value) {
                setState(() {
                  parkingAvailable = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
