import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mach_mit/constants.dart';
import 'package:mach_mit/widgets/textfield.dart';
import 'package:mach_mit/screens/home_screen.dart';
import 'package:mach_mit/screens/make_events2.dart';

class MakeEvents extends StatefulWidget {
  const MakeEvents({super.key});

  @override
  State<MakeEvents> createState() => _MakeEvents();
}

class _MakeEvents extends State<MakeEvents> {
  int selectedCategory = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController =
      TextEditingController();
  String? _errorMessage;

  final List<Map<String, dynamic>> categories = [
    {'id': 1, 'emoji': '🌿', 'name': 'Outdoors', 'color': selected_color},
    {'id': 2, 'emoji': '🍷', 'name': 'Food & Drink', 'color': Colors.cyan},
    {'id': 3, 'emoji': '🎨', 'name': 'Arts', 'color': Color(0xFFFBE4C8)},
    {'id': 4, 'emoji': '⚽', 'name': 'Sports', 'color': Color(0xFFFFD8BE)},
    {'id': 5, 'emoji': '🎵', 'name': 'Music', 'color': Color(0xFFC8E6C9)},
    {'id': 6, 'emoji': '✨', 'name': 'Social', 'color': Color(0xFFB3E5FC)},
    {'id': 7, 'emoji': '💡', 'name': 'Learning', 'color': Color(0xFFE1BEE7)},
    {'id': 8, 'emoji': '🎮', 'name': 'Gaming', 'color': Colors.grey},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String get _selectedCategoryName {
    final match = categories.firstWhere(
      (c) => c['id'] == selectedCategory,
      orElse: () => {'name': ''},
    );
    return match['name'] as String;
  }

  void _goNext() {
    if (_titleController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please describe what you want to do');
      return;
    }
    if (selectedCategory == 0) {
      setState(() => _errorMessage = 'Please pick a category');
      return;
    }

    setState(() => _errorMessage = null);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MakeEvents2(
          eventName: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          categorie: _selectedCategoryName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: MediaQuery.of(
          context,
        ).padding.copyWith(left: 20.0, right: 20.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          color: text_color1,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MyHomePage(title: ''),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 5),
                        Text(
                          'New event',
                          style: GoogleFonts.fraunces(
                            fontSize: 25,
                            color: text_color1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

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
                            color: Colors.black,
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
                      'WHAT DO YOU WANT TO DO?',
                      style: GoogleFonts.roboto(
                        color: text_color2,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    MyTextField(
                      controller: _titleController,
                      lines: 1,
                      hinttext: "e.g. Morning surf session...",
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'TELL PEOPLE MORE',
                      style: GoogleFonts.roboto(
                        color: text_color2,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    MyTextField(
                      controller: _descriptionController,
                      lines: 4,
                      hinttext: "What should people expect? Anything to bring?",
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'CATEGORY',
                      style: GoogleFonts.roboto(
                        color: text_color2,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: categories.map((category) {
                        return _buildCategoryButton(
                          id: category['id'],
                          emoji: category['emoji'],
                          label: category['name'],
                          color: category['color'],
                        );
                      }).toList(),
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
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
            Row(
              mainAxisAlignment: .center,
              children: [
                GestureDetector(
                  onTap: _goNext,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 54,
                    width: (MediaQuery.of(context).size.width - 40),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: selected_color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: .center,
                      children: [
                        Text(
                          'Next',
                          style: GoogleFonts.roboto(
                            color: text_color1,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward_rounded, color: text_color2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton({
    required int id,
    required String emoji,
    required String label,
    required Color color,
  }) {
    final bool isSelected = selectedCategory == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 54,
        width: (MediaQuery.of(context).size.width - 52) / 2,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? color : card_backgroud_color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.black : text_color1,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
