import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../blocs/sales/sales_bloc.dart';
import '../api/api_service.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? token = ModalRoute.of(context)!.settings.arguments as String?;

    if (token == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ventas')),
        body: const Center(child: Text('Error: No se proporcionó el token')),
      );
    }

    return BlocProvider(
      create: (context) => SalesBloc(ApiService())..add(LoadSales(token)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Ventas')),
        body: BlocBuilder<SalesBloc, SalesState>(
          builder: (context, state) {
            if (state is SalesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SalesLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text('Ventas Diarias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 300,
                      child: BarChart(
                        BarChartData(
                          barGroups: _getBarGroups(state.dailySales),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(state.dailySales[value.toInt()]['fecha'].substring(0, 10));
                                },
                                reservedSize: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text('Ventas Mensuales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 300,
                      child: BarChart(
                        BarChartData(
                          barGroups: _getBarGroups(state.monthlySales),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(state.monthlySales[value.toInt()]['fecha'].substring(0, 7));
                                },
                                reservedSize: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is SalesError) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return const Center(child: Text('No hay datos disponibles'));
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups(List<Map<String, dynamic>> sales) {
    return sales.asMap().entries.map((entry) {
      int index = entry.key;
      double total = double.parse(entry.value['total']);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: total,
            color: Colors.blue,
            width: 16,
            borderSide: const BorderSide(color: Colors.black),
          ),
        ],
      );
    }).toList();
  }
}
