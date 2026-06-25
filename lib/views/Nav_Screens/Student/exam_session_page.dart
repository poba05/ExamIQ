import 'dart:async';
import 'package:camera/camera.dart';
import 'package:examai/constants/app_color.dart';
import 'package:examai/utils/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';

class ExamSessionPage extends StatefulWidget {
  final Map<String, dynamic> exam;

  const ExamSessionPage({super.key, required this.exam});

  @override
  State<ExamSessionPage> createState() => _ExamSessionPageState();
}

class _ExamSessionPageState extends State<ExamSessionPage> with WidgetsBindingObserver {
  final SupabaseService _supabaseService = SupabaseService();
  CameraController? _cameraController;
  final AudioRecorder _audioRecorder = AudioRecorder();
  Timer? _monitoringTimer;
  bool _isTerminated = false;
  String _terminationReason = '';

  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  Map<int, dynamic> _answers = {};
  bool _isLoading = true;

  // Timer state
  late int _remainingSeconds;
  Timer? _examTimer;
  String _timerText = "00:00";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _remainingSeconds = (widget.exam['duration_minutes'] ?? 60) * 60;
    _startExamTimer();
    _initializeProctoring();
    _loadQuestions();
  }

  void _startExamTimer() {
    _examTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          _timerText = _formatDuration(Duration(seconds: _remainingSeconds));
        });
      } else {
        _examTimer?.cancel();
        _submitExam(); // Auto-submit when time is up
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> _loadQuestions() async {
    // Security check: Verify if student already submitted or was terminated
    final submission = await _supabaseService.checkSubmission(widget.exam['id']);
    if (submission != null && (submission['status'] == 'submitted' || submission['status'] == 'terminated')) {
      if (mounted) {
        _showAlreadySubmittedDialog(submission['status']);
      }
      return;
    }

    final questions = await _supabaseService.getExamQuestions(widget.exam['id']);
    setState(() {
      _questions = questions;
      _isLoading = false;
    });
  }

  void _showAlreadySubmittedDialog(String status) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Access Denied"),
        content: Text("You have already ${status == 'terminated' ? 'been terminated from' : 'submitted'} this exam. You cannot re-enter the session."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text("Exit"),
          ),
        ],
      ),
    );
  }

  Future<void> _initializeProctoring() async {
    try {
      // Mark as in_progress in DB
      await _supabaseService.markExamInProgress(widget.exam['id']);

      // Request permissions
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.microphone,
      ].request();

      if (statuses[Permission.camera]!.isGranted) {
        // Initialize Camera
        final cameras = await availableCameras();
        if (cameras.isNotEmpty) {
          _cameraController = CameraController(
            cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front, orElse: () => cameras.first),
            ResolutionPreset.medium,
            enableAudio: false,
            imageFormatGroup: ImageFormatGroup.jpeg,
          );
          
          try {
            await _cameraController!.initialize();
          } catch (cameraError) {
            print("Camera initialization error: $cameraError");
          }
          if (mounted) setState(() {});
        } else {
          print("No cameras found on this device");
        }
      } else {
        print("Camera permission denied");
      }

      // Initialize Audio Monitoring
      if (statuses[Permission.microphone]!.isGranted) {
        _startAudioMonitoring();
      }

      // Initialize Audio Monitoring
      if (await _audioRecorder.hasPermission()) {
        // We don't need to record to a file, just monitor amplitude if possible
        // But for this demo, we'll just start a "monitoring" process
        _startAudioMonitoring();
      }

      // Start a monitoring timer to simulate AI detection and upload snapshots
      _monitoringTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
        _performAILogic();
        _uploadSnapshot();
      });

    } catch (e) {

      print("Proctoring initialization error: $e");
    }
  }

  void _startAudioMonitoring() async {
    // In a real app, we would start a stream and check amplitude
    // For this demo, we'll simulate voice detection
    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_isTerminated) {
        timer.cancel();
        return;
      }
      // Simulate a random noise detection for demo (uncomment to test)
      // if (DateTime.now().second % 47 == 0) _terminateExam("External voice detected");
    });
  }


  void _performAILogic() {
    // This is where face detection / staring away logic would go.
    // For demo purposes, we can add a small chance of "detecting" something if we want to show it works,
    // but better to keep it stable unless triggered by user actions.
  }

  Future<void> _uploadSnapshot() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized || _isTerminated) return;

    try {
      final image = await _cameraController!.takePicture();
      final bytes = await image.readAsBytes();
      await _supabaseService.uploadExamSnapshot(widget.exam['id'], bytes);
    } catch (e) {
      print("Snapshot upload error: $e");
    }
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _terminateExam("App minimization/exit detected");
    }
  }

  Future<void> _terminateExam(String reason) async {
    if (_isTerminated) return;

    setState(() {
      _isTerminated = true;
      _terminationReason = reason;
    });

    await _supabaseService.markExamTerminated(widget.exam['id'], reason);

    if (mounted) {
      _showTerminationDialog(reason);
    }
  }

  void _showTerminationDialog(String reason) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Exam Terminated", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: Text("Your exam has been terminated for the following reason:\n\n$reason\n\nYou cannot retake this exam."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Pop dialog
              Navigator.of(context).pop(); // Exit exam session
            },
            child: const Text("Exit"),
          ),
        ],
      ),
    );
  }

  Future<void> _submitExam() async {
    // Collect answers and submit
    await _supabaseService.submitExam(
      examId: widget.exam['id'],
      submissionData: _answers.map((key, value) => MapEntry(key.toString(), value)),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Exam submitted successfully")),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _examTimer?.cancel();
    _cameraController?.dispose();
    _audioRecorder.dispose();
    _monitoringTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Rule 1: On exit the view, exam ends.
    // We use PopScope to detect this.
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        if (!_isTerminated) {
          final exit = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Warning"),
              content: const Text("Exiting the exam will terminate it. Are you sure?"),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Exit & Terminate", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );

          if (exit == true) {
            await _terminateExam("Manual exit detected");
          }
        } else {
           Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: Text(widget.exam['title'] ?? 'Exam Session'),
          backgroundColor: AppColor.white,
          foregroundColor: AppColor.black,
          elevation: 0,
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: const Center(
                child: Row(
                  children: [
                    Icon(Icons.fiber_manual_record, color: Colors.red, size: 12),
                    SizedBox(width: 6),
                    Text(
                      "LIVE MONITORING",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Row(
                children: [
                  // Main Content
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProgressHeader(),
                          const SizedBox(height: 40),
                          Expanded(
                            child: _questions.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text("No questions found for this exam."),
                                        const SizedBox(height: 10),
                                        Text("Exam ID: ${widget.exam['id']}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                      ],
                                    ),
                                  )
                                : _buildQuestionContent(),
                          ),
                          _buildNavigationButtons(),
                        ],
                      ),
                    ),
                  ),

                  // Sidebar Monitor
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      border: Border(left: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "Proctoring Feed",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        // Camera Feed
                        Container(
                          height: 200,
                          width: 260,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade800),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _cameraController != null && _cameraController!.value.isInitialized
                              ? CameraPreview(_cameraController!)
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(FontAwesomeIcons.videoSlash, color: Colors.white54, size: 30),
                                      const SizedBox(height: 10),
                                      Text(
                                        _cameraController == null ? "Initializing Camera..." : "Camera Error",
                                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        const SizedBox(height: 20),
                        _buildMonitorStatus(
                          icon: FontAwesomeIcons.solidUser,
                          label: "Face Detection",
                          status: "Active",
                          color: Colors.green,
                        ),
                        _buildMonitorStatus(
                          icon: FontAwesomeIcons.microphone,
                          label: "Audio Monitor",
                          status: "Active",
                          color: Colors.green,
                        ),
                        _buildMonitorStatus(
                          icon: FontAwesomeIcons.windowMaximize,
                          label: "Window Status",
                          status: "Focused",
                          color: Colors.green,
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: _isTerminated ? null : _submitExam,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primaryBlue,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text("Submit Examination", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  Widget _buildProgressHeader() {
    double progress = _questions.isEmpty ? 0 : (_currentQuestionIndex + 1) / _questions.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Question ${_currentQuestionIndex + 1} of ${_questions.length}",
              style: TextStyle(color: AppColor.greyText, fontWeight: FontWeight.w600),
            ),
            Text(
              "Time Remaining: $_timerText",
              style: TextStyle(
                color: _remainingSeconds < 300 ? Colors.red : AppColor.primaryBlue, 
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryBlue),
          borderRadius: BorderRadius.circular(10),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildQuestionContent() {
    final question = _questions[_currentQuestionIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['question_text'] ?? '',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.5),
        ).animate().fadeIn().slideX(begin: 0.05),
        const SizedBox(height: 30),
        if (question['question_type'] == 'Essay' || question['question_type'] == 'Structured')
          _buildTextAnswerField(isLarge: question['question_type'] == 'Essay')
        else if (question['question_type'] == 'MCQ' || question['question_type'] == 'multiple_choice')
          ..._buildMultipleChoiceOptions(question)
        else
          _buildTextAnswerField(),
      ],
    );
  }

  List<Widget> _buildMultipleChoiceOptions(Map<String, dynamic> question) {
    // Assuming options are stored or we can mock them
    final options = ['Option A', 'Option B', 'Option C', 'Option D']; // Mock
    return options.map((opt) {
      bool selected = _answers[_currentQuestionIndex] == opt;
      return GestureDetector(
        onTap: () => setState(() => _answers[_currentQuestionIndex] = opt),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: selected ? AppColor.primaryBlue.withOpacity(0.05) : AppColor.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColor.primaryBlue : Colors.grey.shade200,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? AppColor.primaryBlue : Colors.grey.shade400,
                    width: 2,
                  ),
                  color: selected ? AppColor.primaryBlue : Colors.transparent,
                ),
                child: selected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
              ),
              const SizedBox(width: 16),
              Text(opt, style: TextStyle(fontSize: 16, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildTextAnswerField({bool isLarge = false}) {
    return TextFormField(
      key: ValueKey('answer_field_$_currentQuestionIndex'),
      initialValue: _answers[_currentQuestionIndex] ?? "",
      maxLines: isLarge ? 15 : 5,
      onChanged: (val) => _answers[_currentQuestionIndex] = val,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: isLarge ? "Provide a detailed explanation here..." : "Type your answer here...",
        filled: true,
        fillColor: AppColor.white,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        contentPadding: const EdgeInsets.all(20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.primaryBlue, width: 2),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_currentQuestionIndex > 0)
          OutlinedButton(
            onPressed: () => setState(() => _currentQuestionIndex--),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Previous"),
          )
        else
          const SizedBox.shrink(),
        if (_currentQuestionIndex < _questions.length - 1)
          ElevatedButton(
            onPressed: () => setState(() => _currentQuestionIndex++),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.black,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Next Question", style: TextStyle(color: Colors.white)),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildMonitorStatus({required IconData icon, required String label, required String status, required Color color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColor.greyText),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
