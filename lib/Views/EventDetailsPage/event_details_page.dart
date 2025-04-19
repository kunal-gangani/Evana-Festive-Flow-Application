import 'package:flutter/material.dart';

class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color gold = Color(0xFFD4AF37);
    const Color black = Color(0xFF121212);
    const Color darkGray = Color(0xFF1E1E1E);

    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        title: const Text(
          'Event Details',
          style: TextStyle(
            color: gold,
          ),
        ),
        backgroundColor: darkGray,
        iconTheme: const IconThemeData(
          color: gold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://picsum.photos/800/400?event',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Premium Tech Conference 2023',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: gold),
                const SizedBox(width: 8),
                Text(
                  'October 25, 2023 • 9:00 AM - 6:00 PM',
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: gold),
                const SizedBox(width: 8),
                Text(
                  'Grand Convention Center, San Francisco',
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'About this event',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Join us for the biggest tech conference of the year featuring keynote speakers from top tech companies, hands-on workshops, and networking opportunities with industry leaders.',
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: darkGray,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: gold.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Standard Ticket',
                          style: TextStyle(color: Colors.white)),
                      Text('\$99',
                          style: TextStyle(
                              color: gold, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Number of Tickets',
                          style: TextStyle(color: Colors.white)),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: gold),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove,
                                  color: gold, size: 20),
                              onPressed: () {},
                            ),
                            const Text('2',
                                style: TextStyle(color: Colors.white)),
                            IconButton(
                              icon:
                                  const Icon(Icons.add, color: gold, size: 20),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Bargain Amount',
                          style: TextStyle(color: Colors.white)),
                      Text('\$10',
                          style: TextStyle(
                              color: gold, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      Text('\$188',
                          style: TextStyle(
                              color: gold,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Proceed to Payment',
                        style: TextStyle(
                            color: black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Payment Options',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
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
