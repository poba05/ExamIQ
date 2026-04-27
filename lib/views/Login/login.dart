import 'package:examai/constants/app_color.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:examai/models/user_role.dart';
import 'package:examai/views/Nav_Screens/Lecturer/lecturer_dashboard.dart';
import 'package:examai/views/Nav_Screens/Student/student_dashboard.dart';
import 'package:examai/views/Landing/landing_page.dart';
import 'package:examai/widgets/buttons/gradient_button_lg.dart';
import 'package:examai/widgets/containers/gradient_container.dart';
import 'package:examai/widgets/textfields/Custom_textfield.dart';
import 'package:examai/views/Admin/admin_registration.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  final UserRole? selectedRole;
  const Login({super.key, this.selectedRole});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UserRole? currentRole;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    currentRole = widget.selectedRole;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (response.user != null) {
        // Fetch profile to check role
        final profile = await supabase
            .from('profiles')
            .select('role')
            .eq('id', response.user!.id)
            .single();

        final String role = profile['role'];

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  role == 'student' ? StudentDashboard() : LecturerDashboard(),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Failed: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientContainer(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 30,
                      ),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColor.primaryBlue,
                                  AppColor.primaryPurple,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Icon(
                                FontAwesomeIcons.graduationCap,
                                color: AppColor.white,
                                size: 25,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColor.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Sign in to continue with ExamIQ",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColor.greyText,
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  currentRole = UserRole.student;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: currentRole == UserRole.student
                                    ? AppColor.primaryBlue
                                    : Colors.grey.shade300,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.userGraduate,
                                    color: currentRole == UserRole.student
                                        ? AppColor.white
                                        : AppColor.black,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "student",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: currentRole == UserRole.student
                                          ? AppColor.white
                                          : AppColor.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  currentRole = UserRole.lecturer;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor:
                                    currentRole == UserRole.lecturer
                                    ? AppColor.primaryPurple
                                    : Colors.grey.shade300,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.chalkboardUser,
                                    color: currentRole == UserRole.lecturer
                                        ? AppColor.white
                                        : AppColor.black,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "lecturer",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: currentRole == UserRole.lecturer
                                          ? AppColor.white
                                          : AppColor.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor.greyText,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          CustomTextfield(
                            label: "Email",
                            icon: Icons.email,
                            obscure: false,
                            controller: _emailController,
                          ),
                          SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor.greyText,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          CustomTextfield(
                            label: "Password",
                            icon: Icons.lock,
                            obscure: true,
                            controller: _passwordController,
                          ),
                          SizedBox(height: 20),
                          _isLoading
                              ? CircularProgressIndicator()
                              : GradientButtonLg(
                                  horizontalPadding: 40,
                                  verticalPadding: 15,
                                  onPressed: _signIn,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Sign in",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        FontAwesomeIcons.arrowRight,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LandingPage(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.arrowLeft,
                                  color: AppColor.primaryBlue,
                                  size: 16,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Back to home",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColor.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Divider(color: Colors.grey.shade200, thickness: 1),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AdminRegistration(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.userShield,
                                  color: AppColor.primaryPurple,
                                  size: 16,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Admin Portal",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColor.primaryPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
