import 'package:flutter/material.dart';
import 'package:mis_lab_4/screens/calendar_screen.dart';
import 'package:mis_lab_4/screens/exams_screen.dart';
import 'package:provider/provider.dart';

import '../providers/authentication_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(CalendarScreen.routeName);
            },
            leading: const Icon(Icons.calendar_month_sharp),
            title: const Text('My Calendar'),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ExamsScreen.routeName);
            },
            leading: const Icon(Icons.library_books),
            title: const Text('All Exams'),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
