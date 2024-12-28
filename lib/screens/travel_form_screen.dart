import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/travel_request.dart';
import '../models/traveler.dart';
import 'package:uuid/uuid.dart';
import 'home_screen.dart'; // Import home screen to set index to dashboard

class TravelFormScreen extends StatefulWidget {
  const TravelFormScreen({super.key});

  @override
  _TravelFormScreenState createState() => _TravelFormScreenState();
}

class _TravelFormScreenState extends State<TravelFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  // Form fields
  final _travelSpecController = TextEditingController();
  final _nameController = TextEditingController();
  final _sourceController = TextEditingController();
  final _destinationController = TextEditingController();
  final _airlineController = TextEditingController();
  final _flightNumberController = TextEditingController();
  final _connectingCityController = TextEditingController();

  String? _selectedFlightType;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final List<Map<String, dynamic>> _travelers = [];

  @override
  void dispose() {
    _travelSpecController.dispose();
    _nameController.dispose();
    _sourceController.dispose();
    _destinationController.dispose();
    _airlineController.dispose();
    _flightNumberController.dispose();
    _connectingCityController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final travelers = _travelers.map((t) => Traveler(
          name: t['nameController'].text,
          gender: t['gender'] ?? 'Not Specified',
          passport: t['passportController'].text,
          visa: t['visaController'].text,
        )).toList();

        final request = TravelRequest(
          id: const Uuid().v4(),
          travelSpec: _travelSpecController.text,
          name: _nameController.text,
          source: _sourceController.text,
          destination: _destinationController.text,
          airline: _airlineController.text,
          flightNumber: _flightNumberController.text,
          flightType: _selectedFlightType ?? 'Direct',
          connectingCity: _connectingCityController.text,
          date: DateFormat('yyyy-MM-dd').format(_selectedDate ?? DateTime.now()),
          time: _selectedTime?.format(context) ?? TimeOfDay.now().format(context),
          travelers: travelers,
        );

        await _apiService.createTravelRequest(request);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Request submitted successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Navigate back to dashboard screen using global key
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen(initialIndex: 0,))
            );
          }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  Widget _buildCard({required String title, required IconData icon, required Widget content}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          content,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Travel Request Form",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.withOpacity(0.1),
              Colors.white.withOpacity(0.5),
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildCard(
                title: 'Travel Details',
                icon: Icons.flight_takeoff,
                content: Column(
                  children: [
                    TextFormField(
                      controller: _travelSpecController,
                      decoration: const InputDecoration(
                        labelText: "Travel Specification",
                        hintText: 'Enter your travel goal',
                        prefixIcon: Icon(Icons.description_outlined, color: Colors.blue),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? "Required" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        hintText: "Enter your name",
                        prefixIcon: Icon(Icons.person_outline, color: Colors.blue),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? "Required" : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildCard(
                title: 'Route Information',
                icon: Icons.map_outlined,
                content: Column(
                  children: [
                    TextFormField(
                      controller: _sourceController,
                      decoration: const InputDecoration(
                        labelText: "Source",
                        hintText: "Enter your source",
                        prefixIcon: Icon(Icons.flight_takeoff, color: Colors.blue),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? "Required" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _destinationController,
                      decoration: const InputDecoration(
                        labelText: "Destination",
                        hintText: "Enter your destination",
                        prefixIcon: Icon(Icons.flight_land, color: Colors.blue),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? "Required" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _airlineController,
                      decoration: const InputDecoration(
                        labelText: "Airline",
                        hintText: "Enter preferred airline",
                        prefixIcon: Icon(Icons.airplane_ticket_outlined, color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _flightNumberController,
                      decoration: const InputDecoration(
                        labelText: "Flight Number",
                        hintText: "Enter flight number",
                        prefixIcon: Icon(Icons.confirmation_number_outlined, color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Flight Type",
                        prefixIcon: Icon(Icons.connecting_airports_outlined, color: Colors.blue),
                      ),
                      value: _selectedFlightType,
                      items: const [
                        DropdownMenuItem(value: "Direct", child: Text("Direct")),
                        DropdownMenuItem(value: "Connecting", child: Text("Connecting")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedFlightType = value;
                        });
                      },
                      validator: (value) => value == null ? "Required" : null,
                    ),
                    if (_selectedFlightType == "Connecting") ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _connectingCityController,
                        decoration: const InputDecoration(
                          labelText: "Connecting City",
                          hintText: "Enter connecting city",
                          prefixIcon: Icon(Icons.location_city_outlined, color: Colors.blue),
                        ),
                        validator: (value) => value?.isEmpty ?? true ? "Required" : null,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildCard(
                title: "Travel Date and Time",
                icon: Icons.calendar_today,
                content: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (pickedDate != null) {
                          setState(() => _selectedDate = pickedDate);
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? "Select Date"
                                  : DateFormat('MMM d, y').format(_selectedDate!),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.arrow_drop_down, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime ?? TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() => _selectedTime = pickedTime);
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Time',
                          prefixIcon: Icon(Icons.access_time, color: Colors.blue),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedTime == null
                                  ? "Select Time"
                                  : _selectedTime!.format(context),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.arrow_drop_down, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildCard(
                title: 'Travelers Information',
                icon: Icons.people_outline,
                content: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Number of Travelers",
                        hintText: 'Enter total number of travelers',
                        prefixIcon: Icon(Icons.group_add_outlined, color: Colors.blue),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value?.isEmpty ?? true ? "Required" : null,
                      onChanged: (value) {
                        setState(() {
                          _travelers.clear();
                          if (value.isNotEmpty) {
                            final count = int.tryParse(value) ?? 0;
                            for (int i = 0; i < count; i++) {
                              _travelers.add({
                                'nameController': TextEditingController(),
                                'passportController': TextEditingController(),
                                'visaController': TextEditingController(),
                                'gender': null,
                              });
                            }
                          }
                        });
                      },
                    ),
                    if (_travelers.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _travelers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final traveler = _travelers[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.person, color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Traveler ${index + 1}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: traveler['nameController'],
                                  decoration: const InputDecoration(
                                    labelText: "Traveler Name",
                                    hintText: "Enter traveler's name",
                                    prefixIcon: Icon(Icons.person_outline, color: Colors.blue),
                                  ),
                                  validator: (value) => value?.isEmpty ?? true ? "Required" : null,
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    labelText: "Gender",
                                    prefixIcon: Icon(Icons.people_outline, color: Colors.blue),
                                  ),
                                  value: traveler['gender'],
                                  items: const [
                                    DropdownMenuItem(value: "Male", child: Text("Male")),
                                    DropdownMenuItem(value: "Female", child: Text("Female")),
                                    DropdownMenuItem(value: "Other", child: Text("Other")),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      traveler['gender'] = value;
                                    });
                                  },
                                  validator: (value) => value == null ? "Required" : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: traveler['passportController'],
                                  decoration: const InputDecoration(
                                    labelText: "Passport",
                                    hintText: "Enter passport details",
                                    prefixIcon: Icon(Icons.document_scanner_outlined, color: Colors.blue),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: traveler['visaController'],
                                  decoration: const InputDecoration(
                                    labelText: "Visa",
                                    hintText: "Enter visa information",
                                    prefixIcon: Icon(Icons.card_membership_outlined, color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Submit Request',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}