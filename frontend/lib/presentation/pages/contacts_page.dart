import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final List<Map<String, dynamic>> _contacts = AppConstants.sampleContacts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh bạ'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // TODO: Open drawer or menu
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Mở menu'),
                backgroundColor: Color(0xFF7B91FF),
              ),
            );
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF7B91FF)),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      contact['avatar'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    contact['name'],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(contact['phone']),
                  trailing: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: contact['status'] == 'online'
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
                  onTap: () {
                    // TODO: Navigate to chat with this contact
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Mở chat với ${contact['name']}'),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
