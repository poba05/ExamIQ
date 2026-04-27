import 'package:supabase_flutter/supabase_flutter.dart';

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
          .select('*, courses(title, course_code, profiles!lecturer_id(full_name))');
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print("Error in getAllExams: $e");
      try {
        final response = await supabase
            .from('exams')
            .select('*, courses(title, course_code, profiles(full_name))');
        return List<Map<String, dynamic>>.from(response as List);
      } catch (e2) {
        final response = await supabase.from('exams').select('*, courses(title, course_code)');
        return List<Map<String, dynamic>>.from(response as List);
      }
    }
  }

  Future<List<Map<String, dynamic>>> getLecturerExams() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final response = await supabase
        .from('exams')
        .select('*, courses!inner(title, course_code, lecturer_id)')
        .eq('courses.lecturer_id', user.id);
    return List<Map<String, dynamic>>.from(response);
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
    });
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
        .filter('exam_id', 'in', examIds);
    
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
      data: {'full_name': fullName},
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
      }
    }
  }
}
