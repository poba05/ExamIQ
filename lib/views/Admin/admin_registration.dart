import 'package:examai/constants/app_color.dart';
import 'package:examai/utils/supabase_service.dart';
import 'package:examai/widgets/buttons/gradient_button_lg.dart';
import 'package:examai/widgets/containers/gradient_container.dart';
import 'package:examai/widgets/textfields/Custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─────────────────────────────────────────────────
// The secret admin PIN (change this to whatever you want)
const String _kAdminPin = '1234';
// ─────────────────────────────────────────────────

class AdminRegistration extends StatefulWidget {
  const AdminRegistration({super.key});

  @override
  State<AdminRegistration> createState() => _AdminRegistrationState();
}

class _AdminRegistrationState extends State<AdminRegistration> {
  bool _isAuthenticated = false;

  void _onAuthenticated() => setState(() => _isAuthenticated = true);

  @override
  Widget build(BuildContext context) {
    return _isAuthenticated
        ? _AdminPortalPage(key: const ValueKey('portal'))
        : _AdminPinGate(
            key: const ValueKey('gate'),
            onAuthenticated: _onAuthenticated,
          );
  }
}

// ─────────────────────────────────────────────────
// PIN GATE
// ─────────────────────────────────────────────────
class _AdminPinGate extends StatefulWidget {
  final VoidCallback onAuthenticated;
  const _AdminPinGate({super.key, required this.onAuthenticated});

  @override
  State<_AdminPinGate> createState() => _AdminPinGateState();
}

class _AdminPinGateState extends State<_AdminPinGate> {
  final TextEditingController _pinController = TextEditingController();
  bool _obscurePin = true;
  String? _error;

  void _verify() {
    if (_pinController.text == _kAdminPin) {
      widget.onAuthenticated();
    } else {
      setState(() => _error = 'Incorrect PIN. Access denied.');
      _pinController.clear();
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientContainer(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Material(
                elevation: 16,
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  padding: const EdgeInsets.all(36),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 75,
                        width: 75,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColor.primaryBlue, AppColor.primaryPurple],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.primaryPurple.withOpacity(0.3),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          FontAwesomeIcons.lock,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Admin Access',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter the admin PIN to continue',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.greyText,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: _pinController,
                        obscureText: _obscurePin,
                        keyboardType: TextInputType.number,
                        maxLength: 8,
                        decoration: InputDecoration(
                          labelText: 'Admin PIN',
                          prefixIcon: const Icon(FontAwesomeIcons.key, size: 16),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePin
                                  ? FontAwesomeIcons.eyeSlash
                                  : FontAwesomeIcons.eye,
                              size: 16,
                            ),
                            onPressed: () =>
                                setState(() => _obscurePin = !_obscurePin),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          errorText: _error,
                          counterText: '',
                        ),
                        onSubmitted: (_) => _verify(),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: GradientButtonLg(
                          horizontalPadding: 0,
                          verticalPadding: 16,
                          onPressed: _verify,
                          child: const Text(
                            'Verify PIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(FontAwesomeIcons.arrowLeft,
                                size: 13, color: AppColor.primaryBlue),
                            const SizedBox(width: 8),
                            Text(
                              'Back to Login',
                              style: TextStyle(
                                color: AppColor.primaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms).scale(
                    begin: const Offset(0.92, 0.92),
                    curve: Curves.easeOutBack,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// ADMIN PORTAL (after PIN is verified)
// ─────────────────────────────────────────────────
class _AdminPortalPage extends StatefulWidget {
  const _AdminPortalPage({super.key});

  @override
  State<_AdminPortalPage> createState() => _AdminPortalPageState();
}

class _AdminPortalPageState extends State<_AdminPortalPage>
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColor.primaryBlue, AppColor.primaryPurple],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          FontAwesomeIcons.userShield,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Admin Portal',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColor.black,
                            ),
                          ),
                          Text(
                            'Manage users & accounts',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor.greyText,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          FontAwesomeIcons.xmark,
                          color: AppColor.greyText,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColor.primaryBlue,
                    unselectedLabelColor: AppColor.greyText,
                    indicatorColor: AppColor.primaryBlue,
                    tabs: const [
                      Tab(
                        icon: Icon(FontAwesomeIcons.userPlus, size: 14),
                        text: 'Register User',
                      ),
                      Tab(
                        icon: Icon(FontAwesomeIcons.users, size: 14),
                        text: 'Manage Users',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Tab content fills remaining space ──
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _RegisterTab(supabaseService: _supabaseService),
                  _ManageUsersTab(supabaseService: _supabaseService),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  } // end build()
} // end _AdminPortalPageState

// ─────────────────────────────────────────────────
// TAB 1 – Register User
// ─────────────────────────────────────────────────
class _RegisterTab extends StatefulWidget {
  final SupabaseService supabaseService;
  const _RegisterTab({required this.supabaseService});

  @override
  State<_RegisterTab> createState() => _RegisterTabState();
}

class _RegisterTabState extends State<_RegisterTab> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  String _selectedRole = 'student';
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _fullNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await widget.supabaseService.registerUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _fullNameController.text.trim(),
        role: _selectedRole,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Successfully registered $_selectedRole: ${_fullNameController.text}'),
            backgroundColor: Colors.green,
          ),
        );
        _emailController.clear();
        _passwordController.clear();
        _fullNameController.clear();
      }
    } catch (e) {
      if (mounted) {
        final msg = e.toString();
        String userMsg;
        if (msg.contains('rate limit') || msg.contains('email_rate_limit')) {
          userMsg =
              'Email rate limit exceeded.\n\nFix: Go to Supabase → Auth → Providers → Email → turn OFF "Confirm email".';
        } else if (msg.contains('already registered') ||
            msg.contains('already been registered')) {
          userMsg = 'This email is already registered.';
        } else {
          userMsg = 'Registration failed: $msg';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(userMsg),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 6),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role selector
          Row(
            children: [
              Expanded(child: _roleBtn('student', FontAwesomeIcons.userGraduate)),
              const SizedBox(width: 14),
              Expanded(child: _roleBtn('lecturer', FontAwesomeIcons.chalkboardUser)),
            ],
          ),
          const SizedBox(height: 24),
          _label('Full Name'),
          CustomTextfield(
            label: 'John Doe',
            icon: Icons.person_outline,
            obscure: false,
            controller: _fullNameController,
          ),
          const SizedBox(height: 18),
          _label('Email Address'),
          CustomTextfield(
            label: 'example@examiq.com',
            icon: Icons.email_outlined,
            obscure: false,
            controller: _emailController,
          ),
          const SizedBox(height: 18),
          _label('Initial Password'),
          CustomTextfield(
            label: '••••••••',
            icon: Icons.lock_outline,
            obscure: true,
            controller: _passwordController,
          ),
          const SizedBox(height: 28),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : GradientButtonLg(
                  horizontalPadding: 0,
                  verticalPadding: 16,
                  onPressed: _registerUser,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(FontAwesomeIcons.userPlus,
                          color: Colors.white, size: 16),
                      SizedBox(width: 10),
                      Text(
                        'Register User',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _roleBtn(String role, IconData icon) {
    final isSelected = _selectedRole == role;
    return InkWell(
      onTap: () => setState(() => _selectedRole = role),
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? (role == 'student'
                  ? AppColor.primaryBlue
                  : AppColor.primaryPurple)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border:
              Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: isSelected ? Colors.white : AppColor.greyText, size: 20),
            const SizedBox(height: 6),
            Text(
              role.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColor.greyText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 2),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColor.black.withOpacity(0.7),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────
// TAB 2 – Manage Users (with Delete)
// ─────────────────────────────────────────────────
class _ManageUsersTab extends StatefulWidget {
  final SupabaseService supabaseService;
  const _ManageUsersTab({required this.supabaseService});

  @override
  State<_ManageUsersTab> createState() => _ManageUsersTabState();
}

class _ManageUsersTabState extends State<_ManageUsersTab> {
  late Future<List<Map<String, dynamic>>> _usersFuture;
  String _filter = 'all'; // 'all', 'student', 'lecturer'

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _usersFuture = widget.supabaseService.getAllProfiles();
    });
  }

  Future<void> _confirmDelete(Map<String, dynamic> user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(FontAwesomeIcons.triangleExclamation,
                color: Colors.red, size: 20),
            SizedBox(width: 10),
            Text('Delete Account'),
          ],
        ),
        content: Text(
          'Are you sure you want to permanently delete the account for\n\n'
          '"${user['full_name'] ?? user['email']}"?\n\n'
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await widget.supabaseService.deleteUserProfile(user['id']);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Account "${user['full_name']}" deleted.'),
              backgroundColor: Colors.red.shade700,
            ),
          );
          _refresh();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Delete failed: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter chips
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            children: [
              _filterChip('All', 'all'),
              const SizedBox(width: 8),
              _filterChip('Students', 'student'),
              const SizedBox(width: 8),
              _filterChip('Lecturers', 'lecturer'),
              const Spacer(),
              IconButton(
                onPressed: _refresh,
                icon: Icon(FontAwesomeIcons.arrowsRotate,
                    size: 14, color: AppColor.primaryBlue),
                tooltip: 'Refresh',
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _usersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red)),
                );
              }

              final all = snapshot.data ?? [];
              final users = _filter == 'all'
                  ? all
                  : all.where((u) => u['role'] == _filter).toList();

              if (users.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.usersSlash,
                          size: 40, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text('No users found',
                          style: TextStyle(color: AppColor.greyText)),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                itemCount: users.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (ctx, i) {
                  final user = users[i];
                  final role = user['role'] ?? 'student';
                  final isLecturer = role == 'lecturer';
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: isLecturer
                            ? AppColor.primaryPurple.withOpacity(0.12)
                            : AppColor.primaryBlue.withOpacity(0.12),
                        child: Icon(
                          isLecturer
                              ? FontAwesomeIcons.chalkboardUser
                              : FontAwesomeIcons.userGraduate,
                          size: 16,
                          color: isLecturer
                              ? AppColor.primaryPurple
                              : AppColor.primaryBlue,
                        ),
                      ),
                      title: Text(
                        user['full_name'] ?? 'Unknown',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        user['email'] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.greyText,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isLecturer
                                  ? AppColor.primaryPurple.withOpacity(0.1)
                                  : AppColor.primaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              role,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isLecturer
                                    ? AppColor.primaryPurple
                                    : AppColor.primaryBlue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _confirmDelete(user),
                            icon: const Icon(FontAwesomeIcons.trash,
                                size: 14, color: Colors.red),
                            tooltip: 'Delete account',
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: (i * 40).ms);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _filterChip(String label, String value) {
    final selected = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColor.primaryBlue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : AppColor.greyText,
          ),
        ),
      ),
    );
  }
}
