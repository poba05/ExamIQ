import 'package:examai/constants/app_color.dart';
import 'package:examai/utils/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:examai/utils/ai_service.dart';
import 'package:examai/widgets/containers/top_container_lt.dart';

class LecturerReviewPage extends StatefulWidget {
  final Map<String, dynamic>? initialExam;
  final Map<String, dynamic>? initialSubmission;
  const LecturerReviewPage({super.key, this.initialExam, this.initialSubmission});

  @override
  State<LecturerReviewPage> createState() => _LecturerReviewPageState();
}

class _LecturerReviewPageState extends State<LecturerReviewPage> {
  final SupabaseService _supabaseService = SupabaseService();
  
  int _currentView = 0; // 0: Exams list, 1: Submissions list, 2: Grading Details
  Map<String, dynamic>? _selectedExam;
  Map<String, dynamic>? _selectedSubmission;

  List<Map<String, dynamic>> _exams = [];
  List<Map<String, dynamic>> _pendingSubmissions = [];
  List<Map<String, dynamic>> _submissionsForExam = [];
  int _approvedCount = 0;
  bool _isLoadingData = true;
  bool _isGradingAI = false;

  // Detail grading states
  Map<int, double> _lecturerScores = {};
  String _overallFeedback = "";
  final TextEditingController _feedbackController = TextEditingController();

  Future<void> _fetchInitialDataSilent() async {
    try {
      final exams = await _supabaseService.getLecturerExams();
      final pending = await _supabaseService.getPendingSubmissions();
      final approved = await _supabaseService.getApprovedSubmissionsCount();
      if (!mounted) return;
      setState(() {
        _exams = exams;
        _pendingSubmissions = pending;
        _approvedCount = approved;
        _isLoadingData = false;
      });
    } catch (e) {
      print("Error loading initial data silently: $e");
      if (!mounted) return;
      setState(() {
        _isLoadingData = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialSubmission != null) {
      _selectedExam = widget.initialExam;
      _selectedSubmission = widget.initialSubmission;
      _currentView = 2;
      _fetchInitialDataSilent();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final submissionData = _selectedSubmission!['submission_data'] as Map? ?? {};
        final aiEvaluation = submissionData['ai_evaluation'];
        if (aiEvaluation == null) {
          _runAutoAIGrading(_selectedSubmission!['id']);
        } else {
          _loadExistingGrading(aiEvaluation);
        }
      });
    } else if (widget.initialExam != null) {
      _selectedExam = widget.initialExam;
      _currentView = 1;
      _fetchInitialDataSilent();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _selectExam(widget.initialExam!);
      });
    } else {
      _fetchInitialData();
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    setState(() {
      _isLoadingData = true;
    });
    try {
      // 1. Fetch lecturer's exams
      final exams = await _supabaseService.getLecturerExams();
      
      // 2. Fetch pending submissions (where score is null)
      final pending = await _supabaseService.getPendingSubmissions();
      
      // 3. Fetch approved submissions count
      final approved = await _supabaseService.getApprovedSubmissionsCount();

      if (!mounted) return;
      setState(() {
        _exams = exams;
        _pendingSubmissions = pending;
        _approvedCount = approved;
        _isLoadingData = false;
      });
    } catch (e) {
      print("Error loading initial data: $e");
      if (!mounted) return;
      setState(() {
        _isLoadingData = false;
      });
    }
  }

  Future<void> _selectExam(Map<String, dynamic> exam) async {
    setState(() {
      _selectedExam = exam;
      _isLoadingData = true;
      _currentView = 1;
    });

    try {
      final subs = await _supabaseService.getExamSubmissions(exam['id']);
      if (!mounted) return;
      setState(() {
        _submissionsForExam = subs;
        _isLoadingData = false;
      });
    } catch (e) {
      print("Error loading submissions for exam: $e");
      if (!mounted) return;
      setState(() {
        _isLoadingData = false;
      });
    }
  }

  Future<void> _selectSubmission(Map<String, dynamic> submission) async {
    setState(() {
      _selectedSubmission = submission;
      _lecturerScores.clear();
      _currentView = 2;
    });

    final submissionData = submission['submission_data'] as Map? ?? {};
    final aiEvaluation = submissionData['ai_evaluation'];

    if (aiEvaluation == null) {
      // Trigger AI semantic grading automatically!
      _runAutoAIGrading(submission['id']);
    } else {
      // AI grading has already been run. Load it.
      _loadExistingGrading(aiEvaluation);
    }
  }

  void _loadExistingGrading(dynamic aiEvaluation) {
    try {
      final questions = (aiEvaluation['questions'] as List? ?? []);
      for (var q in questions) {
        final index = (q['index'] as num?)?.toInt() ?? 0;
        final score = (q['score'] as num?)?.toDouble() ?? 0.0;
        _lecturerScores[index] = score;
      }
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      print("Error loading existing grading: $e");
    }
  }

  Future<void> _runAutoAIGrading(String submissionId) async {
    setState(() {
      _isGradingAI = true;
    });

    try {
      final gradingDetails = await _supabaseService.runAIGrading(submissionId);
      
      if (!mounted) return;
      // Update selected submission local state safely
      setState(() {
        final rawData = _selectedSubmission!['submission_data'];
        final Map<String, dynamic> submissionData = rawData is Map
            ? Map<String, dynamic>.from(rawData)
            : <String, dynamic>{};
            
        submissionData['ai_evaluation'] = gradingDetails;
        _selectedSubmission!['submission_data'] = submissionData;
        _isGradingAI = false;
      });
      
      _loadExistingGrading(gradingDetails);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("AI Semantic Grading completed successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Error running AI grading: $e");
      if (!mounted) return;
      setState(() {
        _isGradingAI = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("AI Grading failed: $e. Using local grader..."),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _submitApprovedGrade() async {
    if (_selectedSubmission == null) return;

    final submissionData = _selectedSubmission!['submission_data'] as Map? ?? {};
    final aiEvaluation = Map<String, dynamic>.from(submissionData['ai_evaluation'] as Map? ?? {});
    
    // Calculate final score based on lecturer values
    double finalScore = _lecturerScores.values.fold(0.0, (sum, score) => sum + score);
    
    // Update the local question score records inside AI evaluation
    final questions = List<Map<String, dynamic>>.from(
      (aiEvaluation['questions'] as List? ?? []).map((e) => Map<String, dynamic>.from(e as Map))
    );
    
    for (int i = 0; i < questions.length; i++) {
      final idx = questions[i]['index'] as int;
      if (_lecturerScores.containsKey(idx)) {
        questions[i]['score'] = _lecturerScores[idx];
      }
    }
    aiEvaluation['questions'] = questions;
    aiEvaluation['lecturer_feedback'] = _feedbackController.text;

    setState(() {
      _isLoadingData = true;
    });

    try {
      await _supabaseService.approveSubmission(
        submissionId: _selectedSubmission!['id'],
        finalScore: finalScore,
        aiEvaluation: aiEvaluation,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Grades approved and saved successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Reset text field
      _feedbackController.clear();

      // Go back to the student submissions list for this exam
      if (_selectedExam != null) {
        await _selectExam(_selectedExam!);
      } else {
        if (!mounted) return;
        setState(() {
          _currentView = 0;
        });
      }
    } catch (e) {
      print("Error submitting grade: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit grade: $e")),
      );
      setState(() {
        _isLoadingData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData && _currentView != 2) {
      return const SizedBox(
        height: 400,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final totalPending = _pendingSubmissions.length;
    final isGeminiKeySet = AIService.geminiApiKey.isNotEmpty;

    final stats = [
      {
        "maintext": "$totalPending",
        "Subtext": "Awaiting Review",
        "icon": FontAwesomeIcons.solidHourglassHalf,
        "iconColor": Colors.orange,
        "iconbg": Colors.orange.shade50,
      },
      {
        "maintext": "$_approvedCount",
        "Subtext": "Approved Grades",
        "icon": FontAwesomeIcons.solidCircleCheck,
        "iconColor": Colors.green,
        "iconbg": Colors.green.shade50,
      },
      {
        "maintext": isGeminiKeySet ? "Active" : "Local Engine",
        "Subtext": isGeminiKeySet ? "Gemini 2.5 Flash API" : "Semantic Offline Matcher",
        "icon": FontAwesomeIcons.robot,
        "iconColor": isGeminiKeySet ? Colors.blue : Colors.purple,
        "iconbg": isGeminiKeySet ? Colors.blue.shade50 : Colors.purple.shade50,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TopContainerLt(
          title: _currentView == 0
              ? "Review Grades"
              : _currentView == 1
                  ? "Examinee Submissions"
                  : "Detail Grading Review",
          subtitle: _currentView == 0
              ? "Grade and approve student exam papers"
              : _currentView == 1
                  ? "Exam: ${_selectedExam?['title'] ?? 'N/A'}"
                  : "Reviewing paper for ${_selectedSubmission?['profiles']?['full_name'] ?? 'Student'}",
          onPressed: (context) {},
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistics Headers (Always shown to give context)
              if (_currentView == 0) ...[
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: stats.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 2.2,
                  ),
                  itemBuilder: (context, index) {
                    final item = stats[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Container(
                              height: 52,
                              width: 52,
                              decoration: BoxDecoration(
                                color: item["iconbg"] as Color,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Icon(
                                  item["icon"] as IconData,
                                  color: item["iconColor"] as Color,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["maintext"] as String,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item["Subtext"] as String,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1, end: 0);
                  },
                ),
                const SizedBox(height: 32),
              ],

              // Main dynamic views
              if (_currentView == 0)
                _buildExamsListView()
              else if (_currentView == 1)
                _buildSubmissionsListView()
              else if (_currentView == 2)
                _buildGradingDetailView(),
            ],
          ),
        ),
      ],
    );
  }

  // --- View 0: List of Exams ---
  Widget _buildExamsListView() {
    if (_exams.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40.0),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Column(
            children: [
              Icon(FontAwesomeIcons.fileInvoice, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                "No exams found",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text("Create courses and exams first to review grades."),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Exam to Review",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _exams.length,
          itemBuilder: (context, index) {
            final exam = _exams[index];
            final course = exam['courses'] as Map? ?? {};
            final examId = exam['id'] as String;

            // Calculate pending submissions specifically for this exam
            final examPendingCount = _pendingSubmissions
                .where((sub) => sub['exam_id'] == examId)
                .length;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                leading: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.fileSignature,
                      color: AppColor.primaryBlue,
                      size: 20,
                    ),
                  ),
                ),
                title: Text(
                  exam['title'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    "Course: ${course['course_code'] ?? 'N/A'} - ${course['title'] ?? 'N/A'}",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (examPendingCount > 0)
                      Container(
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Text(
                          "$examPendingCount Awaiting Review",
                          style: TextStyle(
                            color: Colors.orange.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      )
                    else
                      Container(
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Text(
                          "Completed",
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
                onTap: () => _selectExam(exam),
              ),
            ).animate().fadeIn(delay: (index * 80).ms).slideX(begin: 0.05, end: 0);
          },
        ),
      ],
    );
  }

  // --- View 1: Submissions for Selected Exam ---
  Widget _buildSubmissionsListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header and back button
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _currentView = 0;
                  _selectedExam = null;
                });
                _fetchInitialData();
              },
            ),
            const SizedBox(width: 8),
            const Text(
              "Back to Exam List",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        Text(
          "Student Submissions (${_submissionsForExam.length})",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),

        if (_submissionsForExam.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(40.0),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                "No submissions yet for this exam.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _submissionsForExam.length,
            itemBuilder: (context, index) {
              final sub = _submissionsForExam[index];
              final student = sub['profiles'] as Map? ?? {};
              final score = sub['score'];
              final status = sub['status']?.toString().toLowerCase();

              Widget statusPill;
              if (status == 'terminated') {
                statusPill = Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    "Terminated",
                    style: TextStyle(color: Colors.red.shade800, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                );
              } else if (score != null) {
                statusPill = Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Text(
                    "Approved: $score",
                    style: TextStyle(color: Colors.green.shade800, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                );
              } else {
                final hasAiGrade = sub['submission_data']?['ai_evaluation'] != null;
                statusPill = Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: hasAiGrade ? Colors.blue.shade50 : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: hasAiGrade ? Colors.blue.shade200 : Colors.orange.shade200),
                  ),
                  child: Text(
                    hasAiGrade ? "AI Graded" : "Awaiting AI",
                    style: TextStyle(
                      color: hasAiGrade ? Colors.blue.shade800 : Colors.orange.shade800,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.01),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                  child: Row(
                    children: [
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(FontAwesomeIcons.userGraduate, size: 16, color: Colors.blueGrey),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student['full_name'] ?? 'Unknown Student',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              student['email'] ?? '',
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      statusPill,
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: status == 'terminated' ? null : () => _selectSubmission(sub),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        ),
                        child: const Row(
                          children: [
                            Icon(FontAwesomeIcons.solidEye, size: 12),
                            SizedBox(width: 6),
                            Text("Review", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.05, end: 0);
            },
          ),
      ],
    );
  }

  // --- View 2: Detailed Submission Grading View ---
  Widget _buildGradingDetailView() {
    if (_selectedSubmission == null) return const SizedBox();

    if (_isGradingAI) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(48.0),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(strokeWidth: 5),
              ).animate().scale(duration: 500.ms, curve: Curves.bounceOut),
              const SizedBox(height: 32),
              const Text(
                "Semantic Grading in Progress...",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              Text(
                "Google Gemini is analyzing the student's answer semantically against the lecturer's answer key.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
              ),
              const SizedBox(height: 24),
              Card(
                color: Colors.blue.shade50,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FontAwesomeIcons.circleInfo, color: Colors.blue),
                      SizedBox(width: 8),
                      Text("We evaluate conceptual alignment, not just exact word matching.", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final submissionData = _selectedSubmission!['submission_data'] as Map? ?? {};
    final aiEvaluation = submissionData['ai_evaluation'] as Map? ?? {};
    final questions = (aiEvaluation['questions'] as List? ?? []);

    if (questions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40.0),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text("No grading evaluation found. Check questions and responses."),
        ),
      );
    }

    // Calculate totals
    double totalAiScore = (aiEvaluation['total_score'] as num?)?.toDouble() ?? 0.0;
    int maxScore = (aiEvaluation['max_score'] as num?)?.toInt() ?? 100;
    double currentLecturerTotal = _lecturerScores.values.fold(0.0, (sum, score) => sum + score);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back Button
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (_selectedExam != null) {
                  _selectExam(_selectedExam!);
                } else {
                  setState(() {
                    _currentView = 0;
                  });
                }
              },
            ),
            const SizedBox(width: 8),
            const Text(
              "Back to Submissions",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Info Panel
        Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.navyblue, const Color(0xFF1E293B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedSubmission!['profiles']?['full_name'] ?? 'Student',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _selectedSubmission!['profiles']?['email'] ?? '',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(FontAwesomeIcons.robot, color: Colors.blue, size: 12),
                              const SizedBox(width: 6),
                              Text(
                                "AI Confidence: ${(aiEvaluation['confidence'] ?? 0.8) * 100}%",
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Big Score Widget
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Lecturer Total Grade",
                      style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "$currentLecturerTotal / $maxScore",
                      style: const TextStyle(color: Colors.greenAccent, fontSize: 26, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "AI Suggested: $totalAiScore",
                      style: TextStyle(color: Colors.blue.shade200, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Questions List
        const Text(
          "Grading Breakdown",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        ...questions.map((q) {
          final index = (q['index'] as num?)?.toInt() ?? 0;
          final questionText = q['question_text']?.toString() ?? '';
          final questionType = q['question_type']?.toString() ?? 'Essay';
          final studentAns = q['student_answer']?.toString() ?? '';
          final lecturerAns = q['lecturer_answer']?.toString() ?? '';
          final points = (q['points'] as num?)?.toInt() ?? 5;
          final aiScore = (q['score'] as num?)?.toDouble() ?? 0.0;
          final aiFeedback = q['feedback']?.toString() ?? 'No feedback provided.';

          // Lecturer override value
          final double lecturerVal = _lecturerScores[index] ?? aiScore;

          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Question Number, Type, Points)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Q${index + 1} ($questionType)",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Max Points: $points",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Question text
                Text(
                  questionText,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.4),
                ),
                const SizedBox(height: 16),
                
                // Student's answer
                const Text("Student's Answer:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 13)),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Text(
                    studentAns.isEmpty ? "[No answer provided]" : studentAns,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                ),
                const SizedBox(height: 16),

                // Lecturer's answer
                const Text("Model Answer (Lecturer):", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 13)),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade100),
                  ),
                  child: Text(
                    lecturerAns.isEmpty ? "[No model answer key provided]" : lecturerAns,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                ),
                const SizedBox(height: 20),

                // AI evaluation box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF5FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.robot, color: AppColor.primaryPurple, size: 14),
                          const SizedBox(width: 8),
                          Text(
                            "AI Evaluation",
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.primaryPurple, fontSize: 14),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Suggested Score: $aiScore / $points",
                              style: TextStyle(color: AppColor.primaryPurple, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        aiFeedback,
                        style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Adjust score controls
                Row(
                  children: [
                    const Text(
                      "Lecturer Score Override:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(width: 16),
                    // Decrement button
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                      onPressed: lecturerVal <= 0
                          ? null
                          : () {
                              setState(() {
                                final newVal = (lecturerVal - 0.5).clamp(0.0, points.toDouble());
                                _lecturerScores[index] = double.parse(newVal.toStringAsFixed(1));
                              });
                            },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "$lecturerVal / $points",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Increment button
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                      onPressed: lecturerVal >= points
                          ? null
                          : () {
                              setState(() {
                                final newVal = (lecturerVal + 0.5).clamp(0.0, points.toDouble());
                                _lecturerScores[index] = double.parse(newVal.toStringAsFixed(1));
                              });
                            },
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),

        // Overall Feedback Text Field
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Feedback to Student (Optional)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _feedbackController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter summary feedback for this student's exam sheet...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColor.primaryBlue),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Action Submit Row
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                if (_selectedExam != null) {
                  _selectExam(_selectedExam!);
                } else {
                  setState(() {
                    _currentView = 0;
                  });
                }
              },
              child: const Text("Cancel"),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 2,
              ),
              onPressed: _submitApprovedGrade,
              child: const Row(
                children: [
                  Icon(FontAwesomeIcons.solidCircleCheck, size: 16),
                  SizedBox(width: 8),
                  Text("Approve & Submit Grade", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),
      ],
    );
  }
}
