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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      floatingActionButton: IconButton(
        padding: EdgeInsets.all(10),
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.blue),
        ),
        onPressed: () {
          final indicator = context.read<IndicatorProvider>();
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.black,
            builder: (sheetContext) {
              return Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    children: [
                      _buildTopContainer(),
                      const Text(
                        "Enter Value",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),

                      CustomInput(
                        controller: _quantityController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        prefixIcon: const Icon(Icons.water_drop_rounded, color: Colors.white),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          double value =
                              double.tryParse(_quantityController.text) ?? 0;
                          indicator.setCurrent(indicator.current + value);
                          dio.post("${PathBackend().baseUrl}/compte/score",data: {
                            "score": value,
                            "id_user":1
                          });
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(
                          minimumSize: WidgetStatePropertyAll(
                            Size(double.infinity, 50),
                          ),
                          backgroundColor: WidgetStatePropertyAll(Colors.blue),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add, color: Colors.white),
                            SizedBox(width: 10),
                            Text("Add", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          );
        },

        icon: const Icon(Icons.add, color: Colors.white),
      ),

      body: Consumer<IndicatorProvider>(
        builder: (context, indicator, _) {
          double percent = (indicator.current / indicator.max).clamp(0.0, 1.0);

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/images/avatar.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5,
                            children: [
                              Text(
                                Provider.of<NameProvider>(context).name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                Provider.of<NameProvider>(context).email,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                Provider.of<NameProvider>(context).accountState,
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    CircularPercentIndicator(
                      radius: 80.0,
                      lineWidth: 13.0,
                      animation: true,
                      percent: percent,
                      startAngle: 0,
                      backgroundColor: Colors.white10,
                      progressBorderColor: Colors.blueAccent,
                      center: Text(
                        "${(percent * 100).toStringAsFixed(2)}%",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      footer: Text(
                        "${indicator.current} / ${indicator.max} ml",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          color: Colors.white,
                        ),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.blue,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Last Activity",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        StatisticsChart()
                      ],
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
