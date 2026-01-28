import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hydratation/utils/path.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final dio = Dio();
  List<dynamic> ranking = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRanking();
  }

  Future<void> fetchRanking() async {
    try {
      final response = await dio.get("${PathBackend().baseUrl}/users/ranking");
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        int currentRank = 1;
        for (int i = 0; i < data.length; i++) {
          if (i > 0 && data[i]['score'] < data[i - 1]['score']) {
            currentRank = i + 1;
          }
          data[i]['display_rank'] = currentRank;
        }
        if (!mounted) return;
        setState(() {
          ranking = data;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching ranking: $e");
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchRanking,
        backgroundColor: Colors.blue,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Leaderboard",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Today's top hydrators",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ranking.isEmpty
                        ? const Center(
                            child: Text(
                              "No users found in the community",
                              style: TextStyle(color: Colors.white54),
                            ),
                          )
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(), // Important for RefreshIndicator
                            itemCount: ranking.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final user = ranking[index];
                              final rank = user['display_rank'] ?? (index + 1);
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(15),
                                  border: rank == 1
                                      ? Border.all(color: Colors.amber, width: 1)
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "#$rank",
                                      style: TextStyle(
                                        color: rank == 1 ? Colors.amber : Colors.white54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: user['profile_picture'].isNotEmpty
                                            ? DecorationImage(
                                                image: MemoryImage(base64Decode(user['profile_picture'])),
                                                fit: BoxFit.cover,
                                              )
                                            : const DecorationImage(
                                                image: AssetImage('assets/images/avatar.jpg'),
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Text(
                                        user['name'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${user['score'].toInt()} ml",
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
