import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydratation/providers/indicator_provider.dart';
import 'package:hydratation/providers/name_provider.dart';
import 'package:hydratation/sections/daily.dart';
import 'package:hydratation/utils/path.dart';
import 'package:hydratation/widgets/custom_input.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class IndicatorScreen extends StatefulWidget {
  const IndicatorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IndicatorScreenState createState() => _IndicatorScreenState();
}

class _IndicatorScreenState extends State<IndicatorScreen>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _quantityController;
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<NameProvider>();
      if (user.id != 0) {
        context.read<IndicatorProvider>().fetchData(user.id);
      }
    });
  }

  Widget _buildTopContainer() {
    return Center(
      child: Container(
        width: 50,
        height: 5,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Future<void> _quickLog(double amount) async {
    final indicator = context.read<IndicatorProvider>();
    final userId = context.read<NameProvider>().id;
    try {
      final response = await dio.post("${PathBackend().baseUrl}/compte/score", data: {
        "score": amount,
        "id_user": userId
      });
      
      if (response.statusCode == 200) {
        indicator.setCurrent((response.data['total_today'] as num).toDouble());
        indicator.fetchData(userId);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Added ${amount.toInt()}ml 💧", style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error quick logging: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<IndicatorProvider>(
        builder: (context, indicator, _) {
          double percent = (indicator.current / indicator.max).clamp(0.0, 1.0);
          final userProv = Provider.of<NameProvider>(context);

          return RefreshIndicator(
            onRefresh: () => indicator.fetchData(userProv.id),
            backgroundColor: Colors.blue,
            color: Colors.white,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    // Glassmorphism Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 54,
                            width: 54,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blue.withOpacity(0.5), width: 2),
                              image: userProv.profilePicture.isNotEmpty
                                  ? DecorationImage(
                                      image: MemoryImage(base64Decode(userProv.profilePicture)),
                                      fit: BoxFit.cover,
                                    )
                                  : const DecorationImage(
                                      image: AssetImage('assets/images/avatar.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello, ${userProv.name}!",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Keep up the good work! 💧",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Main Progress Section
                    Center(
                      child: CircularPercentIndicator(
                        radius: 100.0,
                        lineWidth: 16.0,
                        animation: true,
                        percent: percent,
                        startAngle: 0,
                        backgroundColor: Colors.white10,
                        progressBorderColor: Colors.blue.withOpacity(0.3),
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${(percent * 100).toInt()}%",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32.0,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "of daily goal",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        footer: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            "${indicator.current.toInt()} / ${indicator.max.toInt()} ml",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Quick Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickAction(250, Icons.local_cafe_outlined),
                        _buildQuickAction(500, Icons.local_drink_outlined),
                        _buildCustomAction(),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Trends Section
                    const Text(
                      "Hydration Trends",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const StatisticsChart(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickAction(double amount, IconData icon) {
    return InkWell(
      onTap: () => _quickLog(amount),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue, size: 28),
            const SizedBox(height: 8),
            Text(
              "${amount.toInt()}ml",
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAction() {
    return InkWell(
      onTap: () {
        final indicator = context.read<IndicatorProvider>();
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.black,
          isScrollControlled: true,
          builder: (sheetContext) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E293B),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: _buildTopContainer()),
                    const SizedBox(height: 16),
                    const Text(
                      "Custom Amount",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    CustomInput(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      prefixIcon: const Icon(Icons.water_drop_rounded, color: Colors.blue),
                      hintText: "Enter amount in ml",
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        double value = double.tryParse(_quantityController.text) ?? 0;
                        if (value > 0) {
                          await _quickLog(value);
                          _quantityController.clear();
                        }
                        if (!mounted) return;
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text("Add Intake", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
        ),
        child: Column(
          children: const [
            Icon(Icons.add, color: Colors.blue, size: 28),
            SizedBox(height: 8),
            Text(
              "Custom",
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
