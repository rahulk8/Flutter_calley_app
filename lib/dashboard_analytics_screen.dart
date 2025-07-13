import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'left_drawer_screen.dart'; 

class DashboardAnalyticsScreen extends StatefulWidget {
  final String userId;
  final String email;

  const DashboardAnalyticsScreen({
    super.key,
    required this.userId,
    required this.email,
    required String listId,
  });

  @override
  State<DashboardAnalyticsScreen> createState() =>
      _DashboardAnalyticsScreenState();
}

class _DashboardAnalyticsScreenState extends State<DashboardAnalyticsScreen> {
  int totalCalls = 0;
  int pending = 0;
  int done = 0;
  int schedule = 0;
  bool isLoading = true;
  String listName = "";
  String listInitial = "";

  @override
  void initState() {
    super.initState();
    fetchListAndDetails();
  }

  Future<void> fetchListAndDetails() async {
    try {
      final listUrl = Uri.parse(
        "https://mock-api.calleyacd.com/api/list?userId=${widget.userId}",
      );
      final listResponse = await http.get(listUrl);

      if (listResponse.statusCode == 200) {
        final listData = jsonDecode(listResponse.body);
        final list = listData['data'][0];
        final listId = list['_id'];
        listName = list['name'] ?? "List";
        listInitial = listName[0].toUpperCase();

        final detailUrl = Uri.parse(
          "https://mock-api.calleyacd.com/api/list/$listId",
        );
        final detailResponse = await http.post(
          detailUrl,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": widget.email}),
        );

        if (detailResponse.statusCode == 200) {
          final detailData = json.decode(detailResponse.body)['data'];

          setState(() {
            totalCalls = detailData['totalCalls'] ?? 0;
            pending = detailData['pending'] ?? 0;
            done = detailData['done'] ?? 0;
            schedule = detailData['schedule'] ?? 0;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: MyDrawer(userName: '', userEmail: '',),
      body: SafeArea(
        child: Builder(
          builder: (context) => isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                          const Text(
                            "Dashboard",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: const [
                              Icon(Icons.headset_mic_outlined),
                              SizedBox(width: 8),

                              Icon(Icons.notifications_active_outlined),
                              SizedBox(width: 8),
                              
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F6FA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(listName),
                                Text(
                                  "$totalCalls CALLS",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                listInitial,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            height: 180,
                            width: 180,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: totalCalls == 0 ? 0 : done / totalCalls,
                                  strokeWidth: 10,
                                  color: Colors.blue,
                                  backgroundColor: Colors.orange,
                                ),
                                CircularProgressIndicator(
                                  value: totalCalls == 0
                                      ? 0
                                      : schedule / totalCalls,
                                  strokeWidth: 10,
                                  color: Colors.purple,
                                  backgroundColor: Colors.transparent,
                                ),
                                const CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          statusCard("Pending", pending, Colors.orange),
                          statusCard("Done", done, Colors.green),
                          statusCard("Schedule", schedule, Colors.purple),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text("Start Calling Now"),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget statusCard(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            "$count",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text("$title Calls", style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}
