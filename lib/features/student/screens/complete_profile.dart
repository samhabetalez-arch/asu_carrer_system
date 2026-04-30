import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'package:file_picker/file_picker.dart'; // سميناها picker

class CompleteProfileScreen extends StatefulWidget {
  final String userName;
  const CompleteProfileScreen({super.key, this.userName = "Student"});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  bool isArabic = true;
  final int currentYear = 2026;
  final Color primaryBlue = const Color(0xFF229BD8);
  final Color grayTextColor = const Color(0xFF7E848E);

  String? selectedFaculty;
  String? selectedMajor;
  String? selectedYear;
  String? studyStatus; // 'student' أو 'graduate'
  String? cvFileName;
  String? profileImageName;
  bool isLoading = false;

  List<String> skills = [];
  final TextEditingController _skillController = TextEditingController();

  bool get hasUnsavedChanges =>
      studyStatus != null ||
      selectedFaculty != null ||
      selectedMajor != null || // هذا سيبقى كما هو ليتحقق إذا تم اختيار تخصص
      selectedYear != null ||
      skills.isNotEmpty ||
      cvFileName != null ||
      profileImageName != null ||
      _skillController.text.isNotEmpty;

  Map<String, dynamic> get content => {
    'title': isArabic ? "استكمال الملف الشخصي" : "Complete Your Profile",
    'statusLabel': isArabic ? "الحالة الدراسية" : "Study Status",
    'statusStudent': isArabic ? "طالب" : "Student",
    'statusGrad': isArabic ? "خريج" : "Graduate",
    'facLabel': isArabic ? "الكلية" : "Faculty",
    'majorLabel': isArabic ? "التخصص" : "Major",
    'yearLabel': isArabic ? "السنة الدراسية" : "Study Year",
    'gradYearLabel': isArabic ? "سنة التخرج" : "Graduation Year",
    'skillsLabel': isArabic ? "المهارات" : "Skills",
    'cvLabel': isArabic ? "رفع السيرة الذاتية" : "Upload CV",
    'imgLabel': isArabic ? "صورة الملف" : "Profile Image",
    'saveBtn': isArabic ? "حفظ واستمرار" : "Save & Continue",
    'studentYears': isArabic
        ? [
            "السنة الأولى",
            "السنة الثانية",
            "السنة الثالثة",
            "السنة الرابعة",
            "السنة الخامسة",
          ]
        : ["1st Year", "2nd Year", "3rd Year", "4th Year", "5th Year"],
    'gradYears': List.generate(
      currentYear - 1950 + 1,
      (index) => (currentYear - index).toString(),
    ),
  };

  // 1. دالة اختيار الملف (الـ CV) بعد التصليح
  Future<void> _pickCV() async {
    // استخدام FilePicker.platform الآن مفروض يشتغل بدون أخطاء
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        cvFileName = result.files.single.name;
      });
    }
  }

  Future<void> _pickProfileImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        profileImageName = result.files.single.name;
      });
    }
  }

  // 2. دالة إظهار رسالة التنبيه عند الخروج

  void _handleLogout() {
    if (hasUnsavedChanges) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            isArabic ? "تأكيد تسجيل الخروج" : "Confirm Logout",
            style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
          ),
          content: Text(
            isArabic
                ? "هل أنت متأكد من تسجيل الخروج؟ سيتم فقدان البيانات التي أدخلتها ولم يتم حفظها بعد."
                : "Are you sure you want to logout? Unsaved data will be lost.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                isArabic ? "استمرار" : "Stay",
                style: TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // إغلاق الديالوج
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Text(
                isArabic ? "خروج" : "Logout",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFEBEEF4),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.orange),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            TextButton.icon(
              onPressed: _handleLogout,
              icon: Icon(Icons.logout, color: grayTextColor, size: 18),
              label: Text(
                isArabic ? "خروج" : "Logout",
                style: TextStyle(
                  color: grayTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => isArabic = !isArabic),
              child: Text(
                isArabic ? "English" : "العربية",
                style: TextStyle(
                  color: primaryBlue,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  _buildLogo(),
                  const SizedBox(height: 5),

                  _buildLabel(content['statusLabel'] ?? ''),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSelectionCard(
                          title: content['statusStudent'],
                          isSelected: studyStatus == 'student',
                          onTap: () => setState(() {
                            studyStatus = 'student';
                            selectedYear = null;
                          }),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildSelectionCard(
                          title: content['statusGrad'],
                          isSelected: studyStatus == 'graduate',
                          onTap: () => setState(() {
                            studyStatus = 'graduate';
                            selectedYear = null;
                          }),
                        ),
                      ),
                    ],
                  ),
                  _buildLabel(content['facLabel'] ?? ""), // تأمين ضد الـ null
                  _buildDropdown(
                    // التأمين السحري: لو القيمة المختارة مش موجودة في القائمة الحالية (بسبب تغيير اللغة مثلاً) يخليها null
                    (isArabic
                        ? ([
                                "التربية النوعية",
                                "الطب البيطري",
                                "الآثار",
                                "الزراعة",
                                "التربية",
                                "كلية البنات",
                                "التجارة",
                                "التمريض",
                                "الصيدلة",
                                "الهندسة",
                                "طب الأسنان",
                                "الطب",
                                "الإعلام",
                                "الآداب",
                                "الحقوق",
                                "الحاسبات",
                                "الألسن",
                                "العلوم",
                              ].contains(selectedFaculty)
                              ? selectedFaculty
                              : null)
                        : ([
                                "Specific Education",
                                "Veterinary Medicine",
                                "Archaeology",
                                "Agriculture",
                                "Education",
                                "Faculty of Women",
                                "Commerce",
                                "Nursing",
                                "Pharmacy",
                                "Engineering",
                                "Dentistry",
                                "Medicine",
                                "Mass Communication",
                                "Arts",
                                "Law",
                                "Computer and Information Sciences",
                                "Al-Alsun",
                                "Science",
                              ].contains(selectedFaculty)
                              ? selectedFaculty
                              : null)),
                    (isArabic ? "اختر الكلية" : "Select Faculty"),
                    isArabic
                        ? [
                            "التربية النوعية",
                            "الطب البيطري",
                            "الآثار",
                            "الزراعة",
                            "التربية",
                            "كلية البنات",
                            "التجارة",
                            "التمريض",
                            "الصيدلة",
                            "الهندسة",
                            "طب الأسنان",
                            "الطب",
                            "الإعلام",
                            "الآداب",
                            "الحقوق",
                            "الحاسبات",
                            "الألسن",
                            "العلوم",
                          ]
                        : [
                            "Specific Education",
                            "Veterinary Medicine",
                            "Archaeology",
                            "Agriculture",
                            "Education",
                            "Faculty of Women",
                            "Commerce",
                            "Nursing",
                            "Pharmacy",
                            "Engineering",
                            "Dentistry",
                            "Medicine",
                            "Mass Communication",
                            "Arts",
                            "Law",
                            "Computer and Information Sciences",
                            "Al-Alsun",
                            "Science",
                          ],
                    (val) => setState(() => selectedFaculty = val),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(content['majorLabel'] ?? ""),
                            Container(
                              height: 48,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: TextFormField(
                                onChanged: (val) =>
                                    setState(() => selectedMajor = val),
                                style: const TextStyle(fontSize: 13),
                                decoration: InputDecoration(
                                  hintText: isArabic
                                      ? "الفيزياء / علوم الحاسب"
                                      : "Physics / CS",
                                  hintStyle: TextStyle(
                                    // ignore: deprecated_member_use
                                    color: Colors.grey.withOpacity(0.5),
                                    fontSize: 12,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(
                              studyStatus == 'student'
                                  ? content['yearLabel']
                                  : content['gradYearLabel'],
                            ),
                            _buildDropdown(
                              selectedYear,
                              studyStatus == 'student'
                                  ? (isArabic ? "السنة" : "Year")
                                  : (isArabic ? "سنة التخرج" : "Grad Year"),
                              studyStatus == 'student'
                                  ? content['studentYears']
                                  : content['gradYears'],
                              (val) => setState(() => selectedYear = val),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  _buildSkillsInput(),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(content['cvLabel']),
                            _buildUploadArea(
                              title:
                                  cvFileName ??
                                  (isArabic ? "سيرة ذاتية" : "CV (PDF)"),
                              icon: Icons.picture_as_pdf_outlined,
                              onTap: _pickCV,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(content['imgLabel']),
                            _buildUploadArea(
                              title:
                                  profileImageName ??
                                  (isArabic ? "صورة" : "Image"),
                              icon: Icons.image_outlined,
                              onTap: _pickProfileImage,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  _buildSaveButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 0, bottom: 0),
        height: 85,
        width: 85,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Image.asset(
          'assets/image/logo image.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 40, color: Colors.grey);
          },
        ),
      ),
    );
  }

  Widget _buildSelectionCard({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? primaryBlue : Colors.black12),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : grayTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 2, right: 5, left: 5),
    child: Text(
      text,
      style: TextStyle(
        color: grayTextColor,
        fontWeight: FontWeight.w500,
        fontSize: 13,
      ),
    ),
  );

  Widget _buildDropdown(
    String? value,
    String hint,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          menuMaxHeight: 250,
          // التعديل السحري هنا: التأكد أن القيمة موجودة داخل القائمة فعلاً
          value: (value != null && items.contains(value)) ? value : null,
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(fontSize: 12, color: Colors.black26),
            overflow: TextOverflow.ellipsis,
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: primaryBlue),
          items: items
              .map(
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text(
                    i,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSkillsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(content['skillsLabel']),
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              if (skills.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: skills
                            .map(
                              (s) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2.0,
                                ),
                                child: Chip(
                                  label: Text(
                                    s,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  onDeleted: () =>
                                      setState(() => skills.remove(s)),
                                  visualDensity: VisualDensity.compact,
                                  deleteIcon: const Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Colors.red,
                                  ),
                                  backgroundColor: const Color(0xFFF0F7FF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      // ignore: deprecated_member_use
                                      color: primaryBlue.withOpacity(0.1),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: TextFormField(
                  controller: _skillController,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: skills.isEmpty
                        ? (isArabic ? "أضف مهارة..." : "Add skill...")
                        : "",
                    hintStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.black26,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (val) {
                    if (val.endsWith(',') || val.endsWith('،')) {
                      final newSkill = val.substring(0, val.length - 1).trim();
                      if (newSkill.isNotEmpty) {
                        setState(() {
                          skills.add(newSkill);
                          _skillController.clear();
                        });
                      } else {
                        _skillController.clear();
                      }
                    }
                  },
                  onFieldSubmitted: (v) {
                    if (v.trim().isNotEmpty) {
                      setState(() {
                        skills.add(v.trim());
                        _skillController.clear();
                      });
                    }
                  },
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.add_circle, color: primaryBlue, size: 22),
                onPressed: () {
                  final val = _skillController.text.trim();
                  if (val.isNotEmpty) {
                    setState(() {
                      skills.add(val);
                      _skillController.clear();
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUploadArea({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: primaryBlue, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildSaveButton() => Container(
    width: double.infinity,
    height: 50,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          // ignore: deprecated_member_use
          color: primaryBlue.withOpacity(0.3),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: ElevatedButton(
      onPressed: isLoading
          ? null
          : () async {
              if (selectedFaculty != null &&
                  selectedYear != null) {
                setState(() {
                  isLoading = true;
                });

                // محاكاة رفع البيانات (Spinner delay)
                await Future.delayed(const Duration(seconds: 2));

                if (mounted) {
                  setState(() {
                    isLoading = false;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isArabic
                            ? "تم حفظ بياناتك بنجاح"
                            : "Data saved successfully",
                      ),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen(userName: widget.userName),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isArabic ? "يرجى إكمال البيانات" : "Please complete data",
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              content['saveBtn'],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
    ),
  );
}
