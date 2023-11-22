import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mhike_app/database/database_helper.dart';
import 'package:mhike_app/models/observation_model.dart';
import 'package:mhike_app/screens/home/hike_detail_screen.dart';

class EditObservationScreen extends StatefulWidget {
  final Observation observation;

  const EditObservationScreen({required this.observation});

  @override
  State<EditObservationScreen> createState() => _EditObservationScreenState();
}

class _EditObservationScreenState extends State<EditObservationScreen> {
  late TextEditingController observationDetailController;
  late TextEditingController timeController;
  late TextEditingController weatherController;
  late TextEditingController additionalCommentsController;
  late TextEditingController locationDetailController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo các trình điều khiển với giá trị hiện tại của quan sát
    observationDetailController =
        TextEditingController(text: widget.observation.observationDetail);
    weatherController = TextEditingController(text: widget.observation.weather);
    additionalCommentsController =
        TextEditingController(text: widget.observation.additionalComments);
    locationDetailController =
        TextEditingController(text: widget.observation.locationDetail);
  }

  void _editObservation() async {
    // Lấy thông tin mới từ các trình điều khiển
    final String newObservationDetail = observationDetailController.text;
    final String newWeather = weatherController.text;
    final String newAdditionalComments = additionalCommentsController.text;
    final String newLocationDetail = locationDetailController.text;

    // Tạo đối tượng Observation với thông tin mới
    Observation newObservation = Observation(
      hikeName: widget.observation.hikeName,
      observationDetail: newObservationDetail,
      time: widget.observation.time,
      weather: newWeather,
      additionalComments: newAdditionalComments,
      locationDetail: newLocationDetail,
      image: widget.observation.image,
    );

    // Gọi hàm editObservation trong DatabaseHelper để cập nhật thông tin trong cơ sở dữ liệu
    await DatabaseHelper().editObservation(newObservation);

    // Gọi setState để cập nhật UI
    setState(() {});
    Get.to(() => HikeDetailScreen(name: widget.observation.hikeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Observation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: observationDetailController,
              decoration: InputDecoration(labelText: 'Observation Detail'),
            ),
            TextFormField(
              controller: weatherController,
              decoration: InputDecoration(labelText: 'Weather'),
            ),
            TextFormField(
              controller: additionalCommentsController,
              decoration: InputDecoration(labelText: 'Additional Comments'),
            ),
            TextFormField(
              controller: locationDetailController,
              decoration: InputDecoration(labelText: 'Location Detail'),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _editObservation,
                child: Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
