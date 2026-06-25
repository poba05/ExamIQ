import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  // Read API key dynamically from .env file at runtime
  static String get geminiApiKey =>
      dotenv.env['GEMINI_API_KEY'] ??
      const String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

  // Simulates AI summarization of text
  Future<String> summarize(String text) async {
    await Future.delayed(const Duration(seconds: 2));
    return "This is an AI-generated summary of the provided lecture notes. It highlights the key concepts, including data structures, algorithms, and system design principles mentioned in the source material. Perfect for quick revision before exams!";
  }

  // Simulates AI quiz generation
  Future<List<Map<String, dynamic>>> generateQuiz(String content) async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      {
        "question": "What is the primary goal of the system described?",
        "options": ["Efficiency", "Cost reduction", "Scalability", "User experience"],
        "answer": 0
      },
      {
        "question": "Which algorithm is most suitable for this task?",
        "options": ["Binary Search", "Quick Sort", "Dijkstra's", "A* Search"],
        "answer": 2
      },
      {
        "question": "What is the complexity of the proposed solution?",
        "options": ["O(1)", "O(n)", "O(log n)", "O(n^2)"],
        "answer": 1
      },
    ];
  }

  // Simulates AI Grading for scan documents (kept for compatibility)
  Future<Map<String, dynamic>> gradePaper(String imageUrl) async {
    await Future.delayed(const Duration(seconds: 3));
    return {
      "score": 85,
      "feedback": "Great work! You demonstrated a solid understanding of the concepts. Your explanation of the architecture was clear, although you could provide more detail on the security implementation.",
      "identified_text": "The handwritten text was identified as a discussion on distributed systems and the CAP theorem..."
    };
  }

  /// Performs semantic grading of a student's answer against the model answer.
  Future<Map<String, dynamic>> gradeAnswerSemantically({
    required String questionText,
    required String studentAnswer,
    required String correctAnswer,
    required int maxPoints,
  }) async {
    final key = geminiApiKey.trim();
    if (key.isEmpty) {
      print("[AIService] Warning: GEMINI_API_KEY is empty in .env. Using offline matcher.");
      return _fallbackGrade(questionText, studentAnswer, correctAnswer, maxPoints, apiError: "No API Key configured in .env");
    }

    try {
      final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$key');
      
      final prompt = """
You are an expert AI Examiner. Your task is to grade a student's answer to an exam question by comparing it semantically to the lecturer's correct answer.

Question:
"$questionText"

Lecturer's Correct Answer:
"$correctAnswer"

Student's Answer:
"$studentAnswer"

Maximum Points for this Question: $maxPoints

Grading Instructions:
1. Analyze the student's answer semantically. Do not just look for exact word matches. The student may explain the correct concept using different words, synonyms, or paraphrasing.
2. Award a score between 0 and $maxPoints (decimals are allowed if appropriate, but integers are preferred).
3. If the student's answer is blank or completely unrelated, award 0.
4. If the student's answer is partially correct, award a partial score.
5. Provide constructive feedback (1-2 sentences) explaining why this score was awarded, noting what was correct and what was missing compared to the lecturer's answer.

Output format:
You MUST respond with a JSON object containing exactly two keys:
- "score": a number (the score awarded, between 0 and $maxPoints)
- "feedback": a string (the explanation of the grade)

Do not include any other text, markdown formatting, or wrappers. Return ONLY the JSON object.
""";

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final textContent = decoded['candidates'][0]['content']['parts'][0]['text'] as String;
        
        // Clean markdown block fences if present in the raw text response
        String cleanJson = textContent.trim();
        if (cleanJson.startsWith('```')) {
          final lines = cleanJson.split('\n');
          if (lines.first.startsWith('```')) {
            lines.removeAt(0);
          }
          if (lines.isNotEmpty && lines.last.startsWith('```')) {
            lines.removeLast();
          }
          cleanJson = lines.join('\n').trim();
        }

        final gradeResult = jsonDecode(cleanJson);
        double score = (gradeResult['score'] as num?)?.toDouble() ?? 0.0;
        String feedback = gradeResult['feedback']?.toString() ?? 'Graded by AI.';
        
        return {
          "score": score.clamp(0.0, maxPoints.toDouble()),
          "feedback": feedback
        };
      } else {
        print("[AIService] Gemini API error (Status ${response.statusCode}): ${response.body}");
        throw Exception("Status code ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("[AIService] Exception in Gemini API grading: $e");
      return _fallbackGrade(questionText, studentAnswer, correctAnswer, maxPoints, apiError: e.toString());
    }
  }

  /// Evaluates an entire exam's answers
  Future<Map<String, dynamic>> gradeSubmission({
    required List<Map<String, dynamic>> questions,
    required Map<String, dynamic> studentAnswers,
  }) async {
    List<Map<String, dynamic>> gradedQuestions = [];
    double totalScore = 0;
    double maxPossibleScore = 0;

    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      final qId = q['id']?.toString() ?? '';
      final qText = q['question_text']?.toString() ?? '';
      final qType = q['question_type']?.toString() ?? 'Essay';
      final correctAnswer = q['correct_answer']?.toString() ?? '';
      final points = (q['points'] as num?)?.toInt() ?? 5;

      // Student answer is keyed by question index in exam_session_page
      final studentAnswer = studentAnswers[i.toString()]?.toString() ?? studentAnswers[qId]?.toString() ?? '';

      maxPossibleScore += points;

      if (qType.toUpperCase() == 'MCQ' || qType == 'multiple_choice') {
        // Multiple choice questions are graded programmatically for precision
        final cleanStudent = studentAnswer.trim().toLowerCase();
        final cleanCorrect = correctAnswer.trim().toLowerCase();
        final isCorrect = cleanStudent == cleanCorrect && cleanStudent.isNotEmpty;
        final score = isCorrect ? points.toDouble() : 0.0;
        final feedback = isCorrect 
            ? "Correct answer." 
            : "Incorrect answer. Expected '$correctAnswer', but student selected '$studentAnswer'.";

        gradedQuestions.add({
          "index": i,
          "question_id": qId,
          "question_text": qText,
          "question_type": qType,
          "student_answer": studentAnswer,
          "lecturer_answer": correctAnswer,
          "points": points,
          "score": score,
          "feedback": feedback,
        });
        totalScore += score;
      } else {
        // Essay or Structured questions undergo semantic grading
        final grade = await gradeAnswerSemantically(
          questionText: qText,
          studentAnswer: studentAnswer,
          correctAnswer: correctAnswer,
          maxPoints: points,
        );

        final score = (grade['score'] as num?)?.toDouble() ?? 0.0;
        final feedback = grade['feedback']?.toString() ?? 'AI Grading Completed.';

        gradedQuestions.add({
          "index": i,
          "question_id": qId,
          "question_text": qText,
          "question_type": qType,
          "student_answer": studentAnswer,
          "lecturer_answer": correctAnswer,
          "points": points,
          "score": score,
          "feedback": feedback,
        });
        totalScore += score;
      }
    }

    double confidence = maxPossibleScore > 0 ? (totalScore / maxPossibleScore) : 1.0;
    // Format to 2 decimal places
    confidence = double.parse(confidence.toStringAsFixed(2));
    totalScore = double.parse(totalScore.toStringAsFixed(1));

    return {
      "total_score": totalScore,
      "max_score": maxPossibleScore.toInt(),
      "confidence": confidence,
      "questions": gradedQuestions,
    };
  }

  /// Smart local fallback grading system to simulate semantic grading offline or when API key is missing.
  Map<String, dynamic> _fallbackGrade(
    String question,
    String studentAnswer,
    String correctAnswer,
    int maxPoints, {
    String? apiError,
  }) {
    final cleanStudent = studentAnswer.trim();
    if (cleanStudent.isEmpty) {
      return {
        "score": 0.0,
        "feedback": "No answer was provided by the student." + 
            (apiError != null ? " (AI connection failed: $apiError)" : " (No API Key)")
      };
    }

    final cleanLecturer = correctAnswer.trim();
    if (cleanLecturer.isEmpty) {
      return {
        "score": maxPoints.toDouble(),
        "feedback": "Graded automatically as full marks because no model answer was provided by the lecturer."
      };
    }

    // Normalize texts for simple similarity check
    final normStudent = cleanStudent.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
    final normLecturer = cleanLecturer.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');

    // Split into words, filter out short connector words to find keywords
    final studentWords = normStudent.split(RegExp(r'\s+')).where((w) => w.length > 3).toSet();
    final lecturerWords = normLecturer.split(RegExp(r'\s+')).where((w) => w.length > 3).toSet();

    if (lecturerWords.isEmpty) {
      return {
        "score": maxPoints.toDouble(),
        "feedback": "Answer matches basic criteria."
      };
    }

    // Find keyword intersection
    final matches = lecturerWords.intersection(studentWords);
    final overlapRatio = matches.length / lecturerWords.length;

    // Calculate score
    double score = overlapRatio * maxPoints;
    
    // Add extra score if lengths are similar and there are keyword overlaps (representing elaboration)
    if (overlapRatio > 0.1) {
      final lengthRatio = (normStudent.length / normLecturer.length).clamp(0.0, 1.0);
      score += (lengthRatio * 0.2 * maxPoints);
    }
    
    // Clamp score
    score = score.clamp(0.0, maxPoints.toDouble());
    score = double.parse(score.toStringAsFixed(1));
    
    // If it's an exact integer, return as integer value
    dynamic finalScore = score % 1 == 0 ? score.toInt() : score;

    String feedback = "";
    if (overlapRatio >= 0.7) {
      feedback = "Excellent! The answer matches key concepts: [${matches.take(3).join(', ')}]. The explanation is semantically complete and well structured.";
    } else if (overlapRatio >= 0.4) {
      feedback = "Good attempt. The answer mentions important keywords like [${matches.take(3).join(', ')}] but lacks some elaboration or complete detail.";
    } else if (overlapRatio >= 0.15) {
      feedback = "Partial understanding. Only a few keywords: [${matches.take(2).join(', ')}] align with the correct answer. More details are required.";
    } else {
      feedback = "The answer does not semantically address the question criteria. Expected concepts: [${lecturerWords.take(3).join(', ')}].";
    }

    final reasonSuffix = apiError != null
        ? " (Gemini Offline Fallback - Error: $apiError)"
        : " (Gemini Offline Fallback - No API Key)";

    return {
      "score": finalScore,
      "feedback": "$feedback$reasonSuffix"
    };
  }
}
