import 'package:examai/constants/app_color.dart';
import 'package:examai/widgets/buttons/gradient_button_lg.dart';
import 'package:examai/widgets/containers/top_container_lt.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:examai/utils/supabase_service.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CreateExamPage extends StatefulWidget {
  const CreateExamPage({super.key});

  @override
  State<CreateExamPage> createState() => _CreateExamPageState();
}

class _CreateExamPageState extends State<CreateExamPage> {
  final SupabaseService _supabaseService = SupabaseService();
  final _formKey = GlobalKey<FormState>();

  String? _selectedCourseId;
  final _titleController = TextEditingController();
  final _durationController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  List<Map<String, dynamic>> _questions = [
    {
      'question_text': '',
      'question_type': 'MCQ',
      'correct_answer': '',
      'points': 1,
    },
  ];

  List<Map<String, dynamic>> _courses = [];
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      final courses = await _supabaseService.getLecturerCourses();
      setState(() {
        _courses = courses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _addQuestion() {
    setState(() {
      _questions.add({
        'question_text': '',
        'question_type': 'MCQ',
        'correct_answer': '',
        'points': 1,
      });
    });
  }

  void _removeQuestion(int index) {
    if (_questions.length > 1) {
      setState(() {
        _questions.removeAt(index);
      });
    }
  }

  Future<void> _submitExam() async {
    if (!_formKey.currentState!.validate() || _selectedCourseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final examId = await _supabaseService.createExam(
        courseId: _selectedCourseId!,
        title: _titleController.text,
        examDate: _selectedDate.toIso8601String(),
        durationMinutes: int.parse(_durationController.text),
      );

      await _supabaseService.addQuestionsToExam(examId, _questions);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Exam created successfully!")),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error creating exam: $e")));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  TopContainerLt(
                    title: "Create New Exam",
                    subtitle:
                        "Define questions and answers for your assessment",
                    buttonLabel: "Cancel",
                    buttonIcon: FontAwesomeIcons.xmark,
                    onPressed: (context) => Navigator.pop(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            "Exam Information",
                            FontAwesomeIcons.clipboardCheck,
                          ),
                          const SizedBox(height: 25),
                          _buildExamInfoCard(),
                          const SizedBox(height: 40),
                          _buildSectionHeader(
                            "Exam Questions",
                            FontAwesomeIcons.circleQuestion,
                          ),
                          const SizedBox(height: 25),
                          ..._questions.asMap().entries.map(
                            (entry) =>
                                _buildQuestionCard(entry.key, entry.value),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: OutlinedButton.icon(
                              onPressed: _addQuestion,
                              icon: const Icon(FontAwesomeIcons.plus, size: 14),
                              label: const Text("Add Another Question"),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 60),
                          Center(
                            child: _isSubmitting
                                ? const CircularProgressIndicator()
                                : GradientButtonLg(
                                    onPressed: _submitExam,
                                    horizontalPadding: 100,
                                    verticalPadding: 10,
                                    child: const Text(
                                      "Create Exam & Save Answers",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColor.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppColor.primaryBlue),
        ),
        const SizedBox(width: 15),
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColor.black,
          ),
        ),
      ],
    ).animate().fadeIn().slideX(begin: -0.05, end: 0);
  }

  Widget _buildExamInfoCard() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _selectedCourseId,
            hint: const Text("Select Course"),
            items: _courses.map((course) {
              return DropdownMenuItem<String>(
                value: course['id'].toString(),
                child: Text("${course['course_code']} - ${course['title']}"),
              );
            }).toList(),
            onChanged: (val) => setState(() => _selectedCourseId = val),
            decoration: _inputDecoration("Course", FontAwesomeIcons.book),
            validator: (val) => val == null ? "Required" : null,
          ),
          const SizedBox(height: 25),
          TextFormField(
            controller: _titleController,
            decoration: _inputDecoration(
              "Exam Title (e.g. Mid-term Assessment)",
              FontAwesomeIcons.pen,
            ),
            validator: (val) => val!.isEmpty ? "Required" : null,
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(
                    "Duration (Minutes)",
                    FontAwesomeIcons.clock,
                  ),
                  validator: (val) => val!.isEmpty ? "Required" : null,
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) setState(() => _selectedDate = picked);
                  },
                  child: InputDecorator(
                    decoration: _inputDecoration(
                      "Exam Date",
                      FontAwesomeIcons.calendarDay,
                    ),
                    child: Text(
                      "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05, end: 0);
  }

  Widget _buildQuestionCard(int index, Map<String, dynamic> question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Question ${index + 1}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              if (_questions.length > 1)
                IconButton(
                  onPressed: () => _removeQuestion(index),
                  icon: const Icon(
                    FontAwesomeIcons.trashCan,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: question['question_text'],
            onChanged: (val) => question['question_text'] = val,
            maxLines: 2,
            decoration: _inputDecoration("Enter question text...", null),
            validator: (val) => val!.isEmpty ? "Required" : null,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: question['question_type'],
                  items: ['MCQ', 'Short Answer'].map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (val) =>
                      setState(() => question['question_type'] = val),
                  decoration: _inputDecoration("Type", null),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  initialValue: question['points'].toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (val) =>
                      question['points'] = int.tryParse(val) ?? 1,
                  decoration: _inputDecoration("Points", null),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: question['correct_answer'],
            onChanged: (val) => question['correct_answer'] = val,
            decoration: _inputDecoration(
              "Correct Answer (Essential for grading)",
              FontAwesomeIcons.check,
            ),
            validator: (val) =>
                val!.isEmpty ? "Correct answer is required" : null,
          ),
          if (question['question_type'] == 'MCQ')
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10),
              child: Text(
                "Tip: For MCQ, use comma-separated options if needed, but the field above is the correct one.",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.greyText,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    ).animate().fadeIn(delay: (200 + index * 50).ms).slideY(begin: 0.05, end: 0);
  }

  InputDecoration _inputDecoration(String label, IconData? icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null
          ? Icon(icon, size: 16, color: AppColor.primaryBlue)
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColor.primaryBlue, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }
}
