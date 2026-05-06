import 'dart:math';

class AIService {
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

  // Simulates AI Grading
  Future<Map<String, dynamic>> gradePaper(String imageUrl) async {
    await Future.delayed(const Duration(seconds: 3));
    final random = Random();
    final score = 70 + random.nextInt(25); // Score between 70 and 95
    return {
      "score": score,
      "feedback": "Great work! You demonstrated a solid understanding of the concepts. Your explanation of the architecture was clear, although you could provide more detail on the security implementation.",
      "identified_text": "The handwritten text was identified as a discussion on distributed systems and the CAP theorem..."
    };
  }
}
