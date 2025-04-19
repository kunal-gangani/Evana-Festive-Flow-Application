import 'package:evana_event_management_app/Routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color gold = Color(0xFFD4AF37);
    const Color black = Color(0xFF121212);
    const Color darkGray = Color(0xFF1E1E1E);

    final List<Map<String, dynamic>> events = [
      {
        'id': '1',
        'title': 'Tech Conference 2023',
        'date': 'Oct 25, 2023 • 10:00 AM',
        'location': 'San Francisco Convention Center',
        'image': 'https://picsum.photos/500/300?tech',
        'isOrganizer': false,
        'price': '\$99'
      },
      {
        'id': '2',
        'title': 'Music Festival Weekend',
        'date': 'Nov 12-14, 2023',
        'location': 'Central Park, New York',
        'image': 'https://picsum.photos/500/300?music',
        'isOrganizer': true,
        'price': '\$149'
      },
    ];

    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        title: const Text(
          'Discover Events',
          style: TextStyle(
            color: gold,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: darkGray,
        iconTheme: const IconThemeData(
          color: gold,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: gold,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.qr_code_scanner_outlined,
              color: gold,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search events...',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                  ),
                  prefixIcon: const Icon(Icons.search, color: gold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: darkGray,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            ...events
                .map((event) => _buildEventCard(event, gold, black, darkGray)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: darkGray,
          border:
              Border(top: BorderSide(color: gold.withOpacity(0.2), width: 1)),
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          indicatorColor: gold.withOpacity(0.2),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: 0,
          onDestinationSelected: (index) {},
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: Colors.white,
              ),
              selectedIcon: Icon(
                Icons.home,
                color: gold,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              selectedIcon: Icon(
                Icons.search,
                color: gold,
              ),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.favorite_outline,
                color: Colors.white,
              ),
              selectedIcon: Icon(
                Icons.favorite,
                color: gold,
              ),
              label: 'Saved',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.person_outline,
                color: Colors.white,
              ),
              selectedIcon: Icon(
                Icons.person,
                color: gold,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(
    Map<String, dynamic> event,
    Color gold,
    Color black,
    Color darkGray,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: darkGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: gold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Stack(
                children: [
                  Image.network(
                    event['image'],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.3),
                    colorBlendMode: BlendMode.darken,
                  ),
                  if (event['isOrganizer'] == true)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: gold,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Your Event',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: gold),
                      const SizedBox(width: 8),
                      Text(
                        event['date'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: gold,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        event['location'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event['price'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: gold,
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Get.toNamed(Routes.detailPage);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: gold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Book Now',
                          style: TextStyle(
                            color: gold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
