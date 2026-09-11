import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mach_mit/constants.dart';
import 'package:mach_mit/widgets/textfield.dart';
import 'package:mach_mit/screens/home_screen.dart';
import 'package:mach_mit/event_service.dart';

class MakeEvents2 extends StatefulWidget {
  final String eventName;
  final String description;
  final String categorie;

  const MakeEvents2({
    super.key,
    required this.eventName,
    required this.description,
    required this.categorie,
  });

  @override
  State<MakeEvents2> createState() => _MakeEvents2();
}

class _MakeEvents2 extends State<MakeEvents2> {
  double _attendeeCount = 10.0;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  File? _selectedImage;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final EventService _eventService = EventService();
  bool _isPosting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd.MM.yyyy').format(picked);
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _postEvent() async {
    if (_selectedDate == null || _selectedTime == null) {
      setState(() => _errorMessage = 'Please pick a date and time');
      return;
    }
    if (_locationController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please add a location');
      return;
    }

    setState(() {
      _isPosting = true;
      _errorMessage = null;
    });

    try {
      final combinedDate = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      await _eventService.createEvent(
        categorie: widget.categorie,
        eventName: widget.eventName,
        description: widget.description,
        date: combinedDate,
        maxAttendees: _attendeeCount.round(),
        location: _locationController.text.trim(),
        imageFile: _selectedImage,
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage(title: '')),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not post your event. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() => _isPosting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: MediaQuery.of(
          context,
        ).padding.copyWith(left: 20.0, right: 20.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: .start,
          mainAxisAlignment: .spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      color: text_color1,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyHomePage(title: ''),
                          ),
                        );
                      },
                    ),
                    Row(
                      children: [
                        Container(
                          width: (MediaQuery.of(context).size.width - 55) / 2,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: (MediaQuery.of(context).size.width - 55) / 2,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: .start,
                      children: [
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 52) / 2,
                          child: Text(
                            'What & Category',
                            style: GoogleFonts.roboto(
                              color: Colors.deepOrange,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'When & Where',
                          style: GoogleFonts.roboto(
                            color: text_color1,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'PHOTO',
                      style: GoogleFonts.roboto(
                        color: text_color2,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: searchbar_color,
                          borderRadius: BorderRadius.circular(16),
                          image: _selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(_selectedImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _selectedImage == null
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: text_color2,
                                      size: 28,
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'Add a photo',
                                      style: TextStyle(color: text_color2),
                                    ),
                                  ],
                                ),
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: 20),

                    Text(
                      'Date',
                      style: GoogleFonts.roboto(
                        color: text_color2,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: searchbar_color,
                        filled: true,
                        hintText: 'tt.mm.jjjj',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: text_color1),
                      readOnly: true,
                      maxLines: 1,
                      minLines: 1,
                      onTap: _pickDate,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Time',
                      style: GoogleFonts.roboto(
                        color: text_color2,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _timeController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.watch_later_outlined,
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: searchbar_color,
                        filled: true,
                        hintText: 'ss:mm',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: text_color1),
                      readOnly: true,
                      maxLines: 1,
                      minLines: 1,
                      onTap: _pickTime,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Location',
                      style: GoogleFonts.roboto(
                        color: text_color2,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: 10),
                    MyTextField(
                      controller: _locationController,
                      lines: 1,
                      hinttext: "University Library TU Chemnitz",
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Attendees',
                      style: GoogleFonts.roboto(
                        color: text_color2,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: 10),
                    Slider(
                      value: _attendeeCount,
                      min: 1.0,
                      max: 50.0,
                      divisions: 50,
                      label: _attendeeCount.round().toString(),
                      activeColor: Colors.deepOrange,
                      inactiveColor: searchbar_color,
                      onChanged: (double newValue) {
                        setState(() {
                          _attendeeCount = newValue;
                        });
                      },
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      GestureDetector(
                        onTap: _isPosting ? null : _postEvent,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 54,
                          width: (MediaQuery.of(context).size.width - 40),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: selected_color,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: _isPosting
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: .center,
                                  children: [
                                    Text(
                                      'Post event',
                                      style: GoogleFonts.roboto(
                                        color: text_color1,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(Icons.check, color: text_color2),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Back',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: text_color2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
