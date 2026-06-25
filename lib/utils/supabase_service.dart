import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:examai/utils/ai_service.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  // --- Profile ---
  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();
    return response;
  }

  // --- Courses ---
  Future<List<Map<String, dynamic>>> getCourses() async {
    try {
      final response = await supabase
          .from('courses')
          .select('*, profiles!lecturer_id(full_name)');
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print("Error in getCourses: $e");
      try {
        // Second attempt with a simpler join
        final response = await supabase.from('courses').select('*, profiles(full_name)');
        return List<Map<String, dynamic>>.from(response as List);
      } catch (e2) {
        print("Error in getCourses (retry): $e2");
        final response = await supabase.from('courses').select('*');
        return List<Map<String, dynamic>>.from(response as List);
      }
    }
  }

  Future<List<Map<String, dynamic>>> getLecturerCourses() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return [];
      
      final response = await supabase
          .from('courses')
          .select('*, profiles!lecturer_id(full_name)')
          .eq('lecturer_id', user.id);
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print("Error in getLecturerCourses: $e");
      try {
        final user = supabase.auth.currentUser;
        if (user == null) return [];
        final response = await supabase.from('courses').select('*, profiles(full_name)').eq('lecturer_id', user.id);
        return List<Map<String, dynamic>>.from(response as List);
      } catch (e2) {
        final user = supabase.auth.currentUser;
        if (user == null) return [];
        final response = await supabase.from('courses').select('*').eq('lecturer_id', user.id);
        return List<Map<String, dynamic>>.from(response as List);
      }
    }
  }

  // --- Exams ---
  Future<List<Map<String, dynamic>>> getAllExams() async {
    try {
      final response = await supabase
          .from('exams')
          .select('*, courses(title, course_code, profiles!lecturer_id(full_name)), questions(id)');
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print("Error in getAllExams: $e");
      try {
        final response = await supabase
            .from('exams')
            .select('*, courses(title, course_code, profiles(full_name)), questions(id)');
        return List<Map<String, dynamic>>.from(response as List);
      } catch (e2) {
        final response = await supabase.from('exams').select('*, courses(title, course_code), questions(id)');
        return List<Map<String, dynamic>>.from(response as List);
      }
    }
  }

  Future<List<Map<String, dynamic>>> getLecturerExams() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    try {
      final response = await supabase
          .from('exams')
          .select('*, courses!inner(title, course_code, lecturer_id, enrollments(id)), questions(id), submissions(score, status)')
          .eq('courses.lecturer_id', user.id);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error in getLecturerExams: $e");
      try {
        final response = await supabase
            .from('exams')
            .select('*, courses!inner(title, course_code, lecturer_id), questions(id), submissions(score, status)')
            .eq('courses.lecturer_id', user.id);
        return List<Map<String, dynamic>>.from(response);
      } catch (e2) {
        print("Error in getLecturerExams (retry 1): $e2");
        try {
          final response = await supabase
              .from('exams')
              .select('*, courses!inner(title, course_code, lecturer_id)')
              .eq('courses.lecturer_id', user.id);
          return List<Map<String, dynamic>>.from(response);
        } catch (e3) {
          print("Error in getLecturerExams (retry 2): $e3");
          return [];
        }
      }
    }
  }

  Future<List<Map<String, dynamic>>> getExamsForCourse(String courseId) async {
    final response = await supabase
        .from('exams')
        .select()
        .eq('course_id', courseId);
    return List<Map<String, dynamic>>.from(response);
  }

  // --- Submissions ---
  Future<void> submitExam({
    required String examId,
    String? fileUrl,
    Map<String, dynamic>? submissionData,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    await supabase.from('submissions').insert({
      'exam_id': examId,
      'student_id': user.id,
      'file_url': fileUrl,
      'submission_data': submissionData,
      'status': 'submitted',
    });
  }

  Future<void> markExamTerminated(String examId, String reason) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.from('submissions').upsert({
      'exam_id': examId,
      'student_id': user.id,
      'status': 'terminated',
      'submission_data': {'termination_reason': reason},
    });

  }

  Future<void> markExamInProgress(String examId) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.from('submissions').upsert({
      'exam_id': examId,
      'student_id': user.id,
      'status': 'in_progress',
    });
  }

  Future<Map<String, dynamic>?> checkSubmission(String examId) async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final response = await supabase
        .from('submissions')
        .select()
        .eq('exam_id', examId)
        .eq('student_id', user.id)
        .limit(1)
        .maybeSingle();
    return response;
  }

  Future<List<Map<String, dynamic>>> getExamQuestions(String examId) async {
    final response = await supabase
        .from('questions')
        .select()
        .eq('exam_id', examId);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getActiveExaminees(String examId) async {
    final response = await supabase
        .from('submissions')
        .select('*, profiles!student_id(full_name, email)')
        .eq('exam_id', examId)
        .eq('status', 'in_progress');
    return List<Map<String, dynamic>>.from(response);
  }



  Future<List<Map<String, dynamic>>> getStudentSubmissions() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final response = await supabase
        .from('submissions')
        .select('*, exams(title, exam_date, courses(course_code))')
        .eq('student_id', user.id);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getPendingSubmissions() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    // Fetches submissions for exams that belong to courses taught by the current lecturer
    final response = await supabase
        .from('submissions')
        .select('*, exams!inner(title, course_id, courses!inner(lecturer_id)), profiles!inner(full_name)')
        .eq('exams.courses.lecturer_id', user.id)
        .filter('score', 'is', null); // score null means pending review
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> getLecturerStats() async {
    final user = supabase.auth.currentUser;
    if (user == null) return {};

    final courses = await getLecturerCourses();
    final exams = await getLecturerExams();
    
    // Get unique students enrolled in this lecturer's courses
    int studentCount = 0;
    if (courses.isNotEmpty) {
      final courseIds = courses.map((c) => c['id']).toList();
      final enrollmentResponse = await supabase
          .from('enrollments')
          .select('student_id')
          .inFilter('course_id', courseIds);
      
      final List enrollmentList = (enrollmentResponse as List?) ?? [];
      // Use a Set to get unique student IDs across all lecturer's courses
      final uniqueStudents = enrollmentList.map((e) => e['student_id']).toSet();
      studentCount = uniqueStudents.length;
    }

    // Get all submissions for this lecturer's exams
    final examIds = exams.map((e) => e['id']).toList();
    if (examIds.isEmpty) {
      return {
        'courseCount': courses.length,
        'examCount': exams.length,
        'studentCount': studentCount,
        'avgScore': 0.0,
      };
    }

    final submissions = await supabase
        .from('submissions')
        .select('score')
        .inFilter('exam_id', examIds);
    
    final List<Map<String, dynamic>> subList = List<Map<String, dynamic>>.from(submissions);
    final double avgScore = subList.isEmpty 
      ? 0.0 
      : subList.fold(0.0, (sum, s) => sum + (s['score'] as num? ?? 0.0)) / subList.length;

    return {
      'courseCount': courses.length,
      'examCount': exams.length,
      'studentCount': studentCount,
      'avgScore': avgScore,
    };
  }

  Future<List<Map<String, dynamic>>> getAllStudents() async {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('role', 'student');
    return List<Map<String, dynamic>>.from(response);
  }

  /// Returns all users (students + lecturers) for the admin panel.
  Future<List<Map<String, dynamic>>> getAllProfiles() async {
    final response = await supabase
        .from('profiles')
        .select('id, full_name, email, role')
        .order('full_name', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  /// Deletes a user's profile row from the `profiles` table.
  /// Note: Removing the auth user requires a Supabase Edge Function with
  /// the service-role key. This removes the profile so they can no longer log in
  /// to their dashboard, and all their data is disassociated.
  Future<void> deleteUserProfile(String userId) async {
    // Remove enrollments first (cascade may not be set)
    await supabase.from('enrollments').delete().eq('student_id', userId);
    // Remove the profile row
    await supabase.from('profiles').delete().eq('id', userId);
  }

  Future<List<Map<String, dynamic>>> getEnrolledStudentsForLecturer() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final courses = await getLecturerCourses();
    if (courses.isEmpty) return [];

    final courseIds = courses.map((c) => c['id']).toList();
    
    // Join enrollments with profiles
    final response = await supabase
        .from('enrollments')
        .select('profiles!student_id(*)')
        .inFilter('course_id', courseIds);
    
    final List list = (response as List?) ?? [];
    // Extract unique profiles
    final Map<String, Map<String, dynamic>> students = {};
    for (var item in list) {
      final profile = item['profiles'];
      if (profile != null) {
        final profileMap = Map<String, dynamic>.from(profile);
        students[profileMap['id']] = profileMap;
      }
    }
    
    return students.values.toList();
  }

  Future<int> getEnrollmentCountForCourse(String courseId) async {
    try {
      final response = await supabase
          .from('enrollments')
          .select('id')
          .eq('course_id', courseId);
      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getExamCountForCourse(String courseId) async {
    try {
      final response = await supabase
          .from('exams')
          .select('id')
          .eq('course_id', courseId);
      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  // Get enrolled students specifically for a course
  Future<List<Map<String, dynamic>>> getStudentsForCourse(String courseId) async {
    try {
      final response = await supabase
          .from('enrollments')
          .select('profiles!student_id(*)')
          .eq('course_id', courseId);
      
      final List list = (response as List?) ?? [];
      return list
          .where((e) => e['profiles'] != null)
          .map((e) => Map<String, dynamic>.from(e['profiles']))
          .toList();
    } catch (e) {
      print("Error in getStudentsForCourse: $e");
      return [];
    }
  }

  // --- Course Creation & PDF Upload ---
  Future<void> createCourse({
    required String title,
    required String courseCode,
    required String description,
    required String semester,
    required int units,
    String? pdfUrl,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    await supabase.from('courses').insert({
      'title': title,
      'course_code': courseCode,
      'description': description,
      'semester': semester,
      'units': units,
      'lecturer_id': user.id,
      'pdf_url': pdfUrl,
    });
  }

  Future<String?> uploadCoursePdf(List<int> fileBytes, String fileName) async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final path = 'course_pdfs/${user.id}/${DateTime.now().millisecondsSinceEpoch}_$fileName';
    
    // Ensure the bucket 'course_materials' exists in your Supabase dashboard
    await supabase.storage.from('course_materials').uploadBinary(
      path,
      fileBytes as dynamic,
      fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
    );
    
    return supabase.storage.from('course_materials').getPublicUrl(path);
  }

  Future<String?> uploadExamSnapshot(String examId, List<int> fileBytes) async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final path = 'exam_feeds/$examId/${user.id}.jpg';
    
    // We use upsert: true to overwrite the previous snapshot
    await supabase.storage.from('proctoring').uploadBinary(
      path,
      fileBytes as dynamic,
      fileOptions: const FileOptions(cacheControl: '0', upsert: true),
    );
    
    return supabase.storage.from('proctoring').getPublicUrl(path);
  }

  String getExamSnapshotUrl(String examId, String studentId) {
    final path = 'exam_feeds/$examId/$studentId.jpg';
    // Append timestamp to bust cache
    return "${supabase.storage.from('proctoring').getPublicUrl(path)}?t=${DateTime.now().millisecondsSinceEpoch}";
  }


  Future<void> updateCoursePdf(String courseId, String pdfUrl) async {
    await supabase
        .from('courses')
        .update({'pdf_url': pdfUrl})
        .eq('id', courseId);
  }

  // --- Enrollments ---
  Future<void> enrollInCourse(String courseId) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    await supabase.from('enrollments').insert({
      'student_id': user.id,
      'course_id': courseId,
    });
  }

  Future<List<Map<String, dynamic>>> getEnrolledCourses() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return [];

      final response = await supabase
          .from('enrollments')
          .select('*, courses(*, profiles!lecturer_id(full_name))')
          .eq('student_id', user.id);
      
      final List list = (response as List?) ?? [];
      return list
          .where((e) => e['courses'] != null)
          .map((e) {
            final coursesData = e['courses'];
            if (coursesData is Map) {
              return Map<String, dynamic>.from(coursesData);
            } else if (coursesData is List && coursesData.isNotEmpty) {
              return Map<String, dynamic>.from(coursesData[0]);
            }
            return <String, dynamic>{};
          })
          .where((e) => e.isNotEmpty)
          .toList();
    } catch (e) {
      print("Error in getEnrolledCourses: $e");
      try {
        final user = supabase.auth.currentUser;
        if (user == null) return [];
        final response = await supabase
            .from('enrollments')
            .select('*, courses(*, profiles(full_name))')
            .eq('student_id', user.id);
        final List list = (response as List?) ?? [];
        return list
            .where((e) => e['courses'] != null)
            .map((e) {
              final coursesData = e['courses'];
              if (coursesData is Map) {
                return Map<String, dynamic>.from(coursesData);
              } else if (coursesData is List && coursesData.isNotEmpty) {
                return Map<String, dynamic>.from(coursesData[0]);
              }
              return <String, dynamic>{};
            })
            .where((e) => e.isNotEmpty)
            .toList();
      } catch (e2) {
        return [];
      }
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableCourses() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    // Get IDs of courses student is already enrolled in
    List<dynamic> enrolledIds = [];
    try {
      final enrolledResponse = await supabase
          .from('enrollments')
          .select('course_id')
          .eq('student_id', user.id);
      
      final List enrolledList = (enrolledResponse as List?) ?? [];
      enrolledIds = enrolledList.map((e) => e['course_id']).toList();
    } catch (e) {
      print("Error fetching enrollment IDs: $e");
    }

    try {
      // Get courses not in that list
      var query = supabase
          .from('courses')
          .select('*, profiles!lecturer_id(full_name)');
      
      if (enrolledIds.isNotEmpty) {
        query = query.not('id', 'in', enrolledIds);
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print("Error in getAvailableCourses: $e");
      try {
        // Fallback with simpler join
        var query = supabase
            .from('courses')
            .select('*, profiles(full_name)');
        
        if (enrolledIds.isNotEmpty) {
          query = query.not('id', 'in', enrolledIds);
        }

        final response = await query;
        return List<Map<String, dynamic>>.from(response as List);
      } catch (e2) {
        // Ultimate fallback
        var query = supabase.from('courses').select('*');
        
        if (enrolledIds.isNotEmpty) {
          query = query.not('id', 'in', enrolledIds);
        }

        final response = await query;
        return List<Map<String, dynamic>>.from(response as List);
      }
    }
  }

  // --- Admin Methods ---
  Future<void> registerUser({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    // 1. Sign up the user
    final AuthResponse res = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'role': role,
      },
    );

    if (res.user != null) {
      // 2. Create profile (Trigger might handle this, but being explicit is safer if trigger is missing)
      try {
        await supabase.from('profiles').upsert({
          'id': res.user!.id,
          'full_name': fullName,
          'role': role,
        });
      } catch (e) {
        print("Profile creation error (might be handled by trigger): $e");
        rethrow;
      }
    }
  }
  // --- Exam Creation ---
  Future<String> createExam({
    required String courseId,
    required String title,
    required String examDate,
    required int durationMinutes,
  }) async {
    final response = await supabase.from('exams').insert({
      'course_id': courseId,
      'title': title,
      'exam_date': examDate,
      'duration_minutes': durationMinutes,
      'status': 'Upcoming', 
    }).select().single();


    return response['id'];
  }

  Future<void> addQuestionsToExam(String examId, List<Map<String, dynamic>> questions) async {
    final formattedQuestions = questions.map((q) {
      String fullText = q['question_text'];
      if (q['label'] != null && q['label'].toString().isNotEmpty) {
        fullText = "${q['label']}) $fullText";
      }
      return {
        'exam_id': examId,
        'question_text': fullText,
        'question_type': q['question_type'],
        'correct_answer': q['correct_answer'],
        'points': q['points'] ?? 5,
      };
    }).toList();

    await supabase.from('questions').insert(formattedQuestions);
  }

  /// Fetches all submissions (completed, graded, terminated, etc.) for a specific exam
  Future<List<Map<String, dynamic>>> getExamSubmissions(String examId) async {
    try {
      final response = await supabase
          .from('submissions')
          .select('*, profiles!student_id(full_name, email)')
          .eq('exam_id', examId);
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print("Error in getExamSubmissions: $e");
      return [];
    }
  }

  /// Runs AI grading for a specific submission and stores the results in the database
  Future<Map<String, dynamic>> runAIGrading(String submissionId) async {
    try {
      // 1. Fetch submission details without unnecessary join to avoid postgrest errors
      final submission = await supabase
          .from('submissions')
          .select('*')
          .eq('id', submissionId)
          .single();

      final examId = submission['exam_id'] as String;
      
      // Safely parse submission_data map
      Map<String, dynamic> submissionData = {};
      final rawData = submission['submission_data'];
      if (rawData is Map) {
        submissionData = Map<String, dynamic>.from(rawData);
      } else if (rawData is String) {
        try {
          submissionData = Map<String, dynamic>.from(jsonDecode(rawData));
        } catch (_) {}
      }

      // 2. Fetch exam questions
      final questions = await getExamQuestions(examId);

      // 3. Call AI Service to grade
      final aiService = AIService();
      final gradingDetails = await aiService.gradeSubmission(
        questions: questions,
        studentAnswers: submissionData,
      );

      // 4. Update the submission's submission_data with ai_evaluation and save confidence
      final updatedSubmissionData = Map<String, dynamic>.from(submissionData);
      updatedSubmissionData['ai_evaluation'] = gradingDetails;

      await supabase.from('submissions').update({
        'submission_data': updatedSubmissionData,
        'ai_confidence': gradingDetails['confidence'],
      }).eq('id', submissionId);

      return gradingDetails;
    } catch (e) {
      print("Error running AI grading in SupabaseService: $e");
      rethrow;
    }
  }

  /// Saves the final score approved by the lecturer and marks the status as approved
  Future<void> approveSubmission({
    required String submissionId,
    required double finalScore,
    required Map<String, dynamic> aiEvaluation,
  }) async {
    // 1. Fetch the current submission to preserve student answers
    final submission = await supabase
        .from('submissions')
        .select('submission_data')
        .eq('id', submissionId)
        .single();
        
    final submissionData = Map<String, dynamic>.from(submission['submission_data'] as Map? ?? {});
    
    // 2. Update status and approved score inside ai_evaluation
    final aiEval = Map<String, dynamic>.from(aiEvaluation);
    aiEval['status'] = 'approved';
    aiEval['approved_score'] = finalScore;
    aiEval['approved_at'] = DateTime.now().toIso8601String();
    
    submissionData['ai_evaluation'] = aiEval;
    
    // 3. Save to database and set main score
    await supabase.from('submissions').update({
      'score': finalScore,
      'status': 'approved',
      'submission_data': submissionData,
    }).eq('id', submissionId);
  }

  /// Fetches the count of submissions that have been reviewed and approved
  Future<int> getApprovedSubmissionsCount() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return 0;

      final response = await supabase
          .from('submissions')
          .select('id, exams!inner(course_id, courses!inner(lecturer_id))')
          .eq('exams.courses.lecturer_id', user.id)
          .not('score', 'is', null);
          
      return (response as List).length;
    } catch (e) {
      print("Error fetching approved submissions count: $e");
      return 0;
    }
  }
}
