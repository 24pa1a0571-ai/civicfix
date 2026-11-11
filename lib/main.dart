import 'package:flutter/material.dart';

void main() {
  runApp(const CivicFixApp());
}

class CivicFixApp extends StatelessWidget {
  const CivicFixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CivicFix',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF176B87),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class CivicIssue {
  String title;
  String description;
  String category;
  String location;
  String status;
  DateTime date;

  CivicIssue({
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    this.status = 'Pending',
    required this.date,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<CivicIssue> issues = [
    CivicIssue(
      title: 'Road damage',
      description: 'Road needs repair.',
      category: 'Road',
      location: 'Main Street',
      date: DateTime.now(),
    ),
    CivicIssue(
      title: 'Garbage collection',
      description: 'Garbage not collected.',
      category: 'Sanitation',
      location: 'Market Area',
      status: 'In Progress',
      date: DateTime.now(),
    ),
  ];

  int get pending => issues.where((e) => e.status == 'Pending').length;

  int get progress => issues.where((e) => e.status == 'In Progress').length;

  int get resolved => issues.where((e) => e.status == 'Resolved').length;

  @override
  Widget build(BuildContext context) {
    final pages = [
      dashboard(),
      reportPage(),
      myReportsPage(),
      adminPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.location_city),
            SizedBox(width: 8),
            Text(
              'CivicFix',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF176B87),
        foregroundColor: Colors.white,
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            label: 'Report',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'My Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            label: 'Admin',
          ),
        ],
      ),
    );
  }

  Widget dashboard() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'Welcome to CivicFix!',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Report civic problems and help improve your community.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            statCard('Total Reports', issues.length, Colors.blue),
            statCard('Pending', pending, Colors.orange),
            statCard('In Progress', progress, Colors.purple),
            statCard('Resolved', resolved, Colors.green),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Recent Reports',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        if (issues.isEmpty)
          const Text('No reports available.')
        else
          ...issues.take(3).map(issueCard),
        const SizedBox(height: 15),
        FilledButton.icon(
          onPressed: () => setState(() => selectedIndex = 1),
          icon: const Icon(Icons.add),
          label: const Text('Report a Problem'),
        ),
      ],
    );
  }

  Widget statCard(String title, int count, Color color) {
    return SizedBox(
      width: 155,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.assessment, color: color, size: 28),
              const SizedBox(height: 10),
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  Widget reportPage() {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();

    String category = 'Road';

    return StatefulBuilder(
      builder: (context, updateForm) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Report a Civic Issue',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Issue Title',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Enter issue title'
                      : null,
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    'Road',
                    'Water',
                    'Electricity',
                    'Sanitation',
                    'Street Lights',
                    'Other',
                  ].map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      updateForm(() => category = value);
                    }
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Enter location' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Enter description'
                      : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          issues.insert(
                            0,
                            CivicIssue(
                              title: titleController.text.trim(),
                              description: descriptionController.text.trim(),
                              category: category,
                              location: locationController.text.trim(),
                              date: DateTime.now(),
                            ),
                          );
                          selectedIndex = 2;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Report submitted successfully!'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.send),
                    label: const Text('Submit Report'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget myReportsPage() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'My Reports',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        if (issues.isEmpty)
          const Center(child: Text('No reports submitted yet.'))
        else
          ...issues.map(issueCard),
      ],
    );
  }

  Widget adminPage() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text('Manage submitted civic complaints.'),
        const SizedBox(height: 15),
        if (issues.isEmpty)
          const Text('No complaints to manage.')
        else
          ...issues.map((issue) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      issue.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Text(issue.location),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: issue.status,
                      decoration: const InputDecoration(
                        labelText: 'Update Status',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        'Pending',
                        'In Progress',
                        'Resolved',
                      ].map((s) {
                        return DropdownMenuItem(
                          value: s,
                          child: Text(s),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => issue.status = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget issueCard(CivicIssue issue) {
    Color statusColor = issue.status == 'Resolved'
        ? Colors.green
        : issue.status == 'In Progress'
            ? Colors.purple
            : Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.report_problem),
        ),
        title: Text(
          issue.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${issue.category} • ${issue.location}\n'
          '${issue.description}',
        ),
        isThreeLine: true,
        trailing: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            issue.status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}
