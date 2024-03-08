import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logisticapp/providers/supabase_manager.dart';
// import 'package:logisticapp/screens/account-page/edit_profile.dart';
import 'package:logisticapp/screens/profile-edit-page/edit_profile.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  bool isLoaded = false;
  final userdata = SupabaseUserManager();
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
    return (isLoaded == true)
        ? Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  maxRadius: 80,
                  child: Icon(
                    Icons.person,
                    size: 75,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "+${user[0]['phone']}",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                  ),
                ),
                (user[0]['first_name'] != null)
                    ? Text(
                        "${user[0]['first_name']}",
                        style: GoogleFonts.poppins(fontSize: 18),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            " First Name",
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.grey),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return EditProfile();
                                },
                              ));
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.grey,
                            ),
                            tooltip: "Enter first name",
                          ),
                        ],
                      ),
                (user[0]['last_name'] != null)
                    ? Text(
                        "${user[0]['last_name']}",
                        style: GoogleFonts.poppins(fontSize: 18),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            " Last Name",
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.grey),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return EditProfile();
                                },
                              ));
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.grey,
                            ),
                            tooltip: "Enter Last name",
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 20,
                ),
                (user[0]['first_name'] != null || user[0]['last_name'] != null)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Update Your Profile",
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.grey),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return EditProfile();
                                },
                              ));
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.grey,
                            ),
                            tooltip: "Enter Last name",
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
