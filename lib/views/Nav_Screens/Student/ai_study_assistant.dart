import 'package:examai/constants/app_color.dart';
import 'package:examai/utils/ai_service.dart';
import 'package:examai/widgets/buttons/gradient_button_lg.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AiStudyAssistant extends StatefulWidget {
  const AiStudyAssistant({super.key});

  @override
  State<AiStudyAssistant> createState() => _AiStudyAssistantState();
}

class _AiStudyAssistantState extends State<AiStudyAssistant> {
  final AIService _aiService = AIService();
  final TextEditingController _contentController = TextEditingController();
  String? _summary;
  List<Map<String, dynamic>>? _quiz;
  bool _isLoading = false;
  String _activeTool = 'summary'; // 'summary' or 'quiz'

  Future<void> _handleGenerate() async {
    if (_contentController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _summary = null;
      _quiz = null;
    });

    try {
      if (_activeTool == 'summary') {
        final result = await _aiService.summarize(_contentController.text);
        setState(() => _summary = result);
      } else {
        final result = await _aiService.generateQuiz(_contentController.text);
        setState(() => _quiz = result);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "AI Study Assistant",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
            ),
            Text(
              "Harness AI to boost your learning efficiency",
              style: TextStyle(fontSize: 14, color: AppColor.greyText),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                _toolTab('summary', "Summarizer", FontAwesomeIcons.fileLines),
                const SizedBox(width: 15),
                _toolTab('quiz', "Quiz Generator", FontAwesomeIcons.lightbulb),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _activeTool == 'summary'
                        ? "Paste your lecture notes here"
                        : "Paste topic content for the quiz",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _contentController,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: "Enter content...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: GradientButtonLg(
                      horizontalPadding: 0,
                      verticalPadding: 16,
                      onPressed: _isLoading ? null : _handleGenerate,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              _activeTool == 'summary'
                                  ? "Generate Summary"
                                  : "Generate Quiz",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.05, end: 0),
            const SizedBox(height: 30),
            if (_summary != null) _buildSummaryResult(),
            if (_quiz != null) _buildQuizResult(),
          ],
        ),
      ),
    );
  }

  Widget _toolTab(String id, String label, IconData icon) {
    final active = _activeTool == id;
    return InkWell(
      onTap: () => setState(() => _activeTool = id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: active ? AppColor.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: active ? AppColor.primaryBlue : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: active ? Colors.white : AppColor.greyText,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: active ? Colors.white : AppColor.greyText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryResult() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(FontAwesomeIcons.robot, color: AppColor.primaryBlue, size: 20),
              const SizedBox(width: 10),
              const Text(
                "AI Summary",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            _summary!,
            style: const TextStyle(fontSize: 16, height: 1.6),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _actionBtn(FontAwesomeIcons.copy, "Copy"),
              const SizedBox(width: 15),
              _actionBtn(FontAwesomeIcons.filePdf, "Save PDF"),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildQuizResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Generated Quiz",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        ..._quiz!.asMap().entries.map((entry) {
          final i = entry.key;
          final q = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Question ${i + 1}",
                  style: TextStyle(
                    color: AppColor.primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  q['question'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 15),
                ...List.generate(q['options'].length, (optIdx) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          String.fromCharCode(65 + optIdx),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 15),
                        Text(q['options'][optIdx]),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ).animate().fadeIn(delay: (i * 100).ms).slideX(begin: 0.1, end: 0);
        }).toList(),
      ],
    );
  }

  Widget _actionBtn(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColor.primaryBlue),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColor.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
