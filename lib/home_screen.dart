// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'conversation_provider.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> subjects = [
    {'name': 'Math', 'icon': Icons.calculate, 'color': Colors.blue},
    {'name': 'Physics+Chemistry', 'icon': Icons.science, 'color': Colors.green},
    {'name': 'Biology', 'icon': Icons.biotech, 'color': Colors.deepPurpleAccent},
    {'name': 'General Chat', 'icon': Icons.chat, 'color': Colors.brown},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('What can I teach you today'),
        backgroundColor: Colors.blue[300],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConversationScreen(
                      subject: subject['name'],
                      color: subject['color'],
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                color: subject['color'].withOpacity(0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      subject['icon'],
                      size: 48,
                      color: subject['color'],
                    ),
                    SizedBox(height: 8),
                    Text(
                      subject['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: subject['color'],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to parent dashboard
          _showParentDashboard(context);
        },
        child: Icon(Icons.supervisor_account),
        backgroundColor: Colors.purple[300],
      ),
    );
  }

  void _showParentDashboard(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Parent Dashboard'),
        content: Text('Coming in next version!\nVastadhi vastadhi wait cheyyi.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
