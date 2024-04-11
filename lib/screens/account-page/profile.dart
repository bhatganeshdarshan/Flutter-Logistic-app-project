import 'package:flutter/material.dart';


class ProfileScreenDisplay extends StatelessWidget {
  const ProfileScreenDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            title: Text('John Doe'),
            subtitle: Text('john.doe@example.com'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Add functionality for editing profile
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('Email'),
            subtitle: Text('john.doe@example.com'),
            onTap: () {
              // Add functionality for changing email
            },
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Phone'),
            subtitle: Text('+1234567890'),
            onTap: () {
              // Add functionality for changing phone number
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Contact Support'),
            onTap: () {
              // Add functionality for contacting support
            },
          ),
          ListTile(
            leading: Icon(Icons.library_books),
            title: Text('Terms and Conditions'),
            onTap: () {
              // Add functionality for viewing terms and conditions
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Add functionality for navigating to settings
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Add functionality for logging out
            },
          ),
        ],
      ),
    );
  }
}