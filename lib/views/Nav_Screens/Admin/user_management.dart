import 'package:examai/constants/app_color.dart';
import 'package:examai/utils/supabase_service.dart';
import 'package:examai/widgets/buttons/gradient_button_lg.dart';
import 'package:examai/widgets/textfields/Custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SupabaseService _supabaseService = SupabaseService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "User Management",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: AppColor.primaryBlue,
                  unselectedLabelColor: AppColor.greyText,
                  indicatorColor: AppColor.primaryBlue,
                  tabs: const [
                    Tab(text: "Register New"),
                    Tab(text: "Manage Existing"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _RegisterUserView(supabaseService: _supabaseService),
                _ManageUsersView(supabaseService: _supabaseService),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterUserView extends StatefulWidget {
  final SupabaseService supabaseService;
  const _RegisterUserView({required this.supabaseService});

  @override
  State<_RegisterUserView> createState() => _RegisterUserViewState();
}

class _RegisterUserViewState extends State<_RegisterUserView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  String _selectedRole = 'student';
  bool _isLoading = false;

  Future<void> _register() async {
    if (_emailController.text.isEmpty || _fullNameController.text.isEmpty)
      return;
    setState(() => _isLoading = true);
    try {
      await widget.supabaseService.registerUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim().isEmpty
            ? 'password123'
            : _passwordController.text.trim(),
        fullName: _fullNameController.text.trim(),
        role: _selectedRole,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User registered successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Role",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _roleOption("student", FontAwesomeIcons.userGraduate),
                const SizedBox(width: 20),
                _roleOption("lecturer", FontAwesomeIcons.chalkboardUser),
              ],
            ),
            const SizedBox(height: 30),
            CustomTextfield(
              label: "Full Name",
              icon: Icons.person,
              obscure: false,
              controller: _fullNameController,
            ),
            const SizedBox(height: 20),
            CustomTextfield(
              label: "Email Address",
              icon: Icons.email,
              obscure: false,
              controller: _emailController,
            ),
            const SizedBox(height: 20),
            CustomTextfield(
              label: "Initial Password",
              icon: Icons.lock,
              obscure: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: GradientButtonLg(
                horizontalPadding: 0,
                verticalPadding: 16,
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Register User",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleOption(String role, IconData icon) {
    final selected = _selectedRole == role;
    return InkWell(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        decoration: BoxDecoration(
          color: selected ? AppColor.primaryBlue : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColor.primaryBlue : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? Colors.white : AppColor.greyText,
            ),
            const SizedBox(width: 10),
            Text(
              role.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : AppColor.greyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManageUsersView extends StatefulWidget {
  final SupabaseService supabaseService;
  const _ManageUsersView({required this.supabaseService});

  @override
  State<_ManageUsersView> createState() => _ManageUsersViewState();
}

class _ManageUsersViewState extends State<_ManageUsersView> {
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = widget.supabaseService.getAllProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _usersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final users = snapshot.data ?? [];
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: user['role'] == 'lecturer'
                      ? Colors.purple.shade100
                      : Colors.blue.shade100,
                  child: Icon(
                    user['role'] == 'lecturer'
                        ? FontAwesomeIcons.chalkboardUser
                        : FontAwesomeIcons.userGraduate,
                    size: 16,
                    color: user['role'] == 'lecturer'
                        ? Colors.purple
                        : Colors.blue,
                  ),
                ),
                title: Text(user['full_name'] ?? "Unknown"),
                subtitle: Text(user['email'] ?? ""),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user['role'] ?? "student",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
