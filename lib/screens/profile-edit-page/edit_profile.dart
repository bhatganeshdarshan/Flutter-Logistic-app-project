import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logisticapp/entrypage.dart';
import 'package:logisticapp/providers/supabase_manager.dart';
import 'package:logisticapp/screens/account-page/account.dart';
import 'package:logisticapp/utils/app_colors.dart';

final TextEditingController firstNameController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isLoaded = false;
  final userdata = SupabaseUserManager();
  final supabaseUpdateProfile = SupabaseUpdateProfile();
  late dynamic user;
  @override
  void initState() {
    readData();
    super.initState();
  }

  readData() async {
    user = await userdata.readData();
    setState(() {
      isLoaded = true;
    });
    print(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: ApplicationColors.mainThemeBlue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_sharp,
                color: Colors.white,
              )),
          title: Text(
            "Profile",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          titleSpacing: 0.0,
        ),
      ),
      body: (isLoaded == true)
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Customtextfield(
                    labelText: (user[0]['first_name'] == null)
                        ? 'Enter your First name'
                        : '${user[0]['first_name']}',
                    hintText: 'eg: John',
                    isEnabled: (user[0]['first_name'] == null) ? false : true,
                    isFirstName: true,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Customtextfield(
                    labelText: (user[0]['last_name'] == null)
                        ? 'Enter your Last name'
                        : '${user[0]['last_name']}',
                    hintText: 'eg: Cena',
                    isEnabled: (user[0]['last_name'] == null) ? false : true,
                    isFirstName: false,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Customtextfield(
                    labelText: (user[0]['phone'] == null)
                        ? 'Enter your phone number'
                        : '${user[0]['phone']}',
                    hintText: 'eg: 123456789',
                    isEnabled: (user[0]['phone'] == null) ? false : true,
                    // isFirstName: false,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await supabaseUpdateProfile.updateData(
                            firstNameController.text.toString(),
                            lastNameController.text.toString());
                        // print(firstNameController.text.toString());
                        // print(lastNameController.text.toString());
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(),
                          ),
                        );
                      },
                      child: const Icon(Icons.forward)),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class Customtextfield extends StatelessWidget {
  Customtextfield({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.isEnabled,
    this.isFirstName,
  });
  final String labelText;
  final String hintText;
  final bool isEnabled;
  bool? isFirstName;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: (isFirstName == true)
          ? firstNameController
          : (isFirstName == false)
              ? lastNameController
              : null,
      enabled: !isEnabled,
      decoration: InputDecoration(
        // border: InputBorder.none,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        labelText: labelText,
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(),
        labelStyle: GoogleFonts.poppins(),
      ),
    );
  }
}
