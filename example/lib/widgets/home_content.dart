import 'package:example/provider/auth_provider.dart';
import 'package:example/widgets/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int _selectedCategoryIndex = 0;
  bool _isDarkMode = false;

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _goToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfilePage()),
    );
  }

  String _getGreeting() {
    Provider.of<AuthProvider>(context, listen: false).login();
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  final List<String> _categories = [
    'All',
    'Electronics',
    'Fashion',
    'Home',
    'Beauty',
    'Toys'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = _isDarkMode ? ThemeData.dark() : Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: _toggleDarkMode,
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${_getGreeting()} 👋",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "What would you like to shop today?",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _goToProfile(context),
                  child: const CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?img=4",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Flash Sales Banner
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.redAccent.shade100,
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage(
                      "https://images.unsplash.com/photo-1685640206182-c51b8aa9b686?q=80&w=1469&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                  fit: BoxFit.cover,
                  opacity: 0.3,
                ),
              ),
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              child: Text(
                "⚡ Flash Sale:\nUp to 50% OFF!",
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Category Filters
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return ChoiceChip(
                    label: Text(_categories[index]),
                    selected: _selectedCategoryIndex == index,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                    selectedColor: theme.primaryColor,
                    backgroundColor: Colors.grey.shade200,
                    labelStyle: TextStyle(
                      color: _selectedCategoryIndex == index
                          ? Colors.white
                          : Colors.black,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "🔥 Trending Products",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("View all"),
                ),
              ],
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: theme.cardColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Image.network(
                            "https://images.unsplash.com/photo-1659512042872-7ad995b65aac?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Product ${index + 1}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "\$29.99",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.shop),
              label: const Text("Start Shopping"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
