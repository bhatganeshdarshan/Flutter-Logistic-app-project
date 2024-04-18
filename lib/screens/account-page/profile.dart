import 'package:flutter/material.dart';
import 'package:logisticapp/providers/supabase_manager.dart';
import 'package:logisticapp/screens/profile-edit-page/edit_profile.dart';
import 'package:logisticapp/user_auth/login_page.dart';

class ProfileScreenDisplay extends StatefulWidget {
  const ProfileScreenDisplay({super.key});

  @override
  _ProfileScreenDisplayState createState() => _ProfileScreenDisplayState();
}

class _ProfileScreenDisplayState extends State<ProfileScreenDisplay> {
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
        ? Scaffold(
            body: ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                  ),
                  title: Text(
                      "${user[0]['first_name'].toUpperCase()} ${user[0]['last_name'].toUpperCase()}"),
                  subtitle: Text("+${user[0]['phone']}"),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfile(),
                          ));
                    },
                  ),
                ),
                const Divider(),
                // ListTile(
                //   leading: Icon(Icons.email),
                //   title: Text('Email'),
                //   subtitle: Text('john.doe@example.com'),
                //   onTap: () {
                //     // Add functionality for changing email
                //   },
                // ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('Phone'),
                  subtitle: Text("+${user[0]['phone']}"),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Contact Support'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.library_books),
                  title: const Text('Terms and Conditions'),
                  onTap: () {
                    // Add functionality for viewing terms and conditions
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    // Add functionality for navigating to settings
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                ),
              ],
            ),
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
