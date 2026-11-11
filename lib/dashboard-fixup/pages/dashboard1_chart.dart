import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';
import 'package:stsj/dashboard-fixup/models/dashboard1_model.dart';
import 'package:stsj/dashboard-fixup/models/detail_dashboard1_model.dart';
import 'package:stsj/dashboard-fixup/utilities/utils.dart';
import 'package:stsj/dashboard-fixup/widgets/legend_widget.dart';
import 'package:stsj/dashboard-fixup/widgets/top_widget.dart';
import 'package:stsj/dashboard-fixup/widgets/vs_horizontal.dart';
import 'package:stsj/dashboard-fixup/widgets/vs_vertical.dart';

class Dashboard1Chart extends StatefulWidget {
  const Dashboard1Chart(this.listDashboard1, this.sortDetailOmset, this.bln,
      {super.key});
  final List<Dashboard1> listDashboard1;
  final List<DetailDashboard1> sortDetailOmset;
  final String bln;

  @override
  State<Dashboard1Chart> createState() => _Dashboard1ChartState();
}

class _Dashboard1ChartState extends State<Dashboard1Chart> {
  int touchedIndex = -1;

  double _calculateNiceOmsetInterval(double maxOmset) {
    if (maxOmset <= 0) return 50000000;
    final rawStep = maxOmset / 4.0;
    const steps = <double>[
      10000000,
      20000000,
      25000000,
      50000000,
      100000000,
      150000000,
      200000000,
      250000000,
      500000000,
      1000000000,
      2000000000,
    ];
    for (final s in steps) {
      if (s >= rawStep) return s;
    }
    return (rawStep / 1000000000).ceil() * 1000000000.0;
  }

  Widget _buildCardTitle(String title, {double fontSize = 18}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTotalUnitEntryCard(Dashboard1 data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildCardTitle('TOTAL UNIT ENTRY', fontSize: 19),
          const SizedBox(height: 6),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: VSVertical(
                    data.unitEntryTm,
                    data.unitEntryLm,
                    'LM',
                  ),
                ),
                const VerticalDivider(
                  thickness: 2,
                  width: 16,
                  color: Colors.grey,
                  indent: 6,
                  endIndent: 6,
                ),
                Expanded(
                  flex: 1,
                  child: VSVertical(
                    data.unitEntryTm,
                    data.unitEntryLy,
                    'LY',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalOmsetCard(Dashboard1 data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildCardTitle('TOTAL OMSET', fontSize: 19),
          const SizedBox(height: 4),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: VSHorizontal(
                    data.omsetTm,
                    data.omsetLm,
                    'LM',
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 2,
                  height: 8,
                  indent: 10,
                  endIndent: 10,
                ),
                Expanded(
                  flex: 1,
                  child: VSHorizontal(
                    data.omsetTm,
                    data.omsetLy,
                    'LY',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatioOmsetCard(Dashboard1 data) {
    final omsetTm = data.omsetTm;
    final pctS = omsetTm == 0 ? 0.0 : (data.tmS * 100 / omsetTm);
    final pctPS = omsetTm == 0 ? 0.0 : (data.tmPS * 100 / omsetTm);
    final pctP = omsetTm == 0 ? 0.0 : (data.tmP * 100 / omsetTm);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildCardTitle('RATIO OMSET', fontSize: 18),
          const SizedBox(height: 4),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxDiameter = math.min(
                  constraints.maxWidth * 0.45,
                  constraints.maxHeight,
                );
                final totalRadius = (maxDiameter / 2).clamp(22.0, 62.0);
                final centerRadius = totalRadius * 0.52;
                final sectionRadius = totalRadius * 0.48;
                final titleFontSize = (totalRadius * 0.19).clamp(9.0, 12.0);

                return Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(enabled: false),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 0,
                          centerSpaceRadius: centerRadius,
                          sections: [
                            PieChartSectionData(
                              color: Colors.indigo[500],
                              value: pctS,
                              title: pctS >= 5 ? '${pctS.toStringAsFixed(1)}%' : '',
                              radius: sectionRadius,
                              titleStyle: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[500],
                                shadows: const [
                                  Shadow(color: Colors.black87, blurRadius: 1)
                                ],
                              ),
                            ),
                            PieChartSectionData(
                              color: Colors.indigo[300],
                              value: pctPS,
                              title: pctPS >= 5 ? '${pctPS.toStringAsFixed(1)}%' : '',
                              radius: sectionRadius,
                              titleStyle: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[300],
                                shadows: const [
                                  Shadow(color: Colors.black87, blurRadius: 1)
                                ],
                              ),
                            ),
                            PieChartSectionData(
                              color: Colors.indigo[100],
                              value: pctP,
                              title: pctP >= 5 ? '${pctP.toStringAsFixed(1)}%' : '',
                              radius: sectionRadius,
                              titleStyle: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[200],
                                shadows: const [
                                  Shadow(color: Colors.black87, blurRadius: 1)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 6,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LegendWidget(
                              Colors.indigo[500]!,
                              'Services:\n${Format.rupiahFormat(data.tmS.toString())}',
                            ),
                            const SizedBox(height: 4),
                            LegendWidget(
                              Colors.indigo[300]!,
                              'Parts & Services:\n${Format.rupiahFormat(data.tmPS.toString())}',
                            ),
                            const SizedBox(height: 4),
                            LegendWidget(
                              Colors.indigo[100]!,
                              'Parts:\n${Format.rupiahFormat(data.tmP.toString())}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatioMemberCard(Dashboard1 data) {
    final pctMember = data.unitEntryTm == 0
        ? 0.0
        : (data.memberTm * 100 / data.unitEntryTm);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildCardTitle('RATIO MEMBER', fontSize: 18),
          const SizedBox(height: 4),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxDiameter = math.min(
                  constraints.maxWidth * 0.45,
                  constraints.maxHeight,
                );
                final totalRadius = (maxDiameter / 2).clamp(22.0, 62.0);
                final centerRadius = totalRadius * 0.52;
                final sectionRadius = totalRadius * 0.48;
                final titleFontSize = (totalRadius * 0.19).clamp(9.0, 12.0);

                return Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(enabled: false),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 0,
                          centerSpaceRadius: centerRadius,
                          sections: [
                            PieChartSectionData(
                              color: Colors.indigo,
                              value: pctMember,
                              title: data.unitEntryTm == 0
                                  ? '-'
                                  : '${pctMember.toStringAsFixed(1)}%',
                              radius: sectionRadius,
                              titleStyle: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                shadows: const [
                                  Shadow(color: Colors.black87, blurRadius: 1)
                                ],
                              ),
                            ),
                            PieChartSectionData(
                              color: Colors.grey[300],
                              value: (100 - pctMember).clamp(0.0, 100.0),
                              showTitle: false,
                              radius: sectionRadius,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 6,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LegendWidget(
                              Colors.indigo,
                              'Member: ${Format.thousandFormat(data.memberTm.toString())}',
                            ),
                            const SizedBox(height: 4),
                            LegendWidget(
                              Colors.grey[400]!,
                              'Unit Entry: ${Format.thousandFormat(data.unitEntryTm.toString())}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTop5OmsetCard() {
    final topCount = math.min(5, widget.sortDetailOmset.length);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildCardTitle(
            'TOP 5 OMSET ${listBulan[int.parse(widget.bln) - 1]}',
            fontSize: 19,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(topCount, (i) {
                return Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TopWidget(
                      i + 1,
                      widget.sortDetailOmset[i].bsName,
                      widget.sortDetailOmset[i].omsetTmBS,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitEntryChartCard(Dashboard1 data) {
    final details = data.detail;
    final detailCount = details.isEmpty ? 1 : details.length;
    double maxUE = 1500.0;
    for (final d in details) {
      if (d.unitEntryTmBS > maxUE) {
        maxUE = (d.unitEntryTmBS * 1.15).ceilToDouble();
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildCardTitle('UNIT ENTRY (PER CABANG)', fontSize: 19),
          const SizedBox(height: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barWidth =
                    ((constraints.maxWidth - 24) / (detailCount * 1.9))
                        .clamp(6.0, 20.0);
                final labelFontSize =
                    detailCount > 12 ? 10.0 : (detailCount > 8 ? 11.5 : 13.5);

                return BarChart(
                  BarChartData(
                    barTouchData: BarTouchData(
                      touchCallback: (FlTouchEvent event, barTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              barTouchResponse == null ||
                              barTouchResponse.spot == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex =
                              barTouchResponse.spot!.touchedBarGroupIndex;
                        });
                      },
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.white,
                        tooltipHorizontalAlignment:
                            FLHorizontalAlignment.center,
                        maxContentWidth: 200,
                        tooltipMargin: 10,
                        tooltipBorder: const BorderSide(color: Colors.grey),
                        tooltipRoundedRadius: 10,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${details[groupIndex].bsName}\n',
                            const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                            children: <TextSpan>[
                              TextSpan(
                                text: Format.thousandFormat(
                                  details[groupIndex].unitEntryTmBS.toString(),
                                ),
                                style: TextStyle(
                                  color: Colors.orange[700],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx < 0 || idx >= details.length) {
                              return const SizedBox.shrink();
                            }
                            return SideTitleWidget(
                              axisSide: AxisSide.top,
                              space: 4,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${details[idx].branch}${details[idx].shop}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: labelFontSize,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      drawVerticalLine: false,
                      horizontalInterval: 100,
                    ),
                    barGroups: List.generate(details.length, (idx) {
                      return BarChartGroupData(
                        x: idx,
                        barRods: [
                          BarChartRodData(
                            toY: details[idx].unitEntryTmBS.toDouble(),
                            gradient: touchedIndex == idx
                                ? LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.orange[100]!,
                                      Colors.orange[500]!,
                                    ],
                                  )
                                : LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.indigo[100]!,
                                      Colors.indigo[500]!,
                                    ],
                                  ),
                            width: barWidth,
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: maxUE,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOmsetChartCard(Dashboard1 data) {
    final details = data.detail;
    final detailCount = details.isEmpty ? 1 : details.length;

    double maxBranchOmset = 0;
    for (final d in details) {
      final total = (d.tmPBS + d.tmPSBS + d.tmSBS).toDouble();
      if (total > maxBranchOmset) maxBranchOmset = total;
    }
    final omsetInterval = _calculateNiceOmsetInterval(maxBranchOmset);
    final chartMaxY = maxBranchOmset <= 0
        ? 100000000.0
        : ((maxBranchOmset / omsetInterval).ceil() * omsetInterval);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildCardTitle('OMSET (PER CABANG)', fontSize: 19),
          const SizedBox(height: 6),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 4,
            children: [
              LegendWidget(Colors.indigo[100]!, 'Parts'),
              LegendWidget(Colors.indigo[300]!, 'Parts & Services'),
              LegendWidget(Colors.indigo[500]!, 'Services'),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barWidth =
                    ((constraints.maxHeight - 36) / (detailCount * 1.75))
                        .clamp(6.0, 18.0);
                final branchFontSize =
                    detailCount > 12 ? 10.0 : (detailCount > 8 ? 11.5 : 13.0);

                return RotatedBox(
                  quarterTurns: 1,
                  child: BarChart(
                    BarChartData(
                      maxY: chartMaxY,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.white,
                          tooltipHorizontalAlignment:
                              FLHorizontalAlignment.center,
                          maxContentWidth: 200,
                          tooltipMargin: -150,
                          tooltipHorizontalOffset: -40,
                          tooltipBorder: const BorderSide(color: Colors.grey),
                          tooltipRoundedRadius: 10,
                          rotateAngle: -90,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final item = details[groupIndex];
                            final val = rodIndex == 0
                                ? item.tmPBS
                                : rodIndex == 1
                                    ? item.tmPSBS
                                    : item.tmSBS;
                            return BarTooltipItem(
                              '${item.bsName}\n',
                              const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                              children: <TextSpan>[
                                TextSpan(
                                  text: Format.rupiahFormat(val.toString()),
                                  style: TextStyle(
                                    color: Colors.orange[700],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            interval: omsetInterval,
                            getTitlesWidget: (value, meta) {
                              if (value == meta.max &&
                                  (value % omsetInterval).abs() > 1) {
                                return const SizedBox.shrink();
                              }
                              final inMillions = value / 1000000;
                              final label = (value % 1000000) == 0
                                  ? '${inMillions.toInt()}M'
                                  : '${inMillions.toStringAsFixed(1)}M';
                              return SideTitleWidget(
                                axisSide: AxisSide.right,
                                space: 4,
                                child: RotatedBox(
                                  quarterTurns: -1,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      label,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 11.5,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 48,
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (idx < 0 || idx >= details.length) {
                                return const SizedBox.shrink();
                              }
                              return SideTitleWidget(
                                axisSide: AxisSide.top,
                                space: 4,
                                child: RotatedBox(
                                  quarterTurns: -1,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '${details[idx].branch}${details[idx].shop}',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: branchFontSize,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        drawVerticalLine: false,
                        horizontalInterval: omsetInterval,
                      ),
                      barGroups: List.generate(details.length, (idx) {
                        final item = details[idx];
                        final p = item.tmPBS.toDouble();
                        final ps = item.tmPSBS.toDouble();
                        final s = item.tmSBS.toDouble();
                        return BarChartGroupData(
                          x: idx,
                          groupVertically: true,
                          barRods: [
                            BarChartRodData(
                              fromY: 0,
                              toY: p,
                              color: Colors.indigo[100],
                              width: barWidth,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            BarChartRodData(
                              fromY: p,
                              toY: p + ps,
                              color: Colors.indigo[300],
                              width: barWidth,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            BarChartRodData(
                              fromY: p + ps,
                              toY: p + ps + s,
                              color: Colors.indigo[500],
                              width: barWidth,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listDashboard1.isEmpty) {
      return const SizedBox.shrink();
    }
    final data = widget.listDashboard1[0];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        // 1. Mobile / Narrow Screen (< 700px): Single-column scrollable layout
        if (width < 700) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 36),
            children: [
              SizedBox(height: 170, child: _buildTotalUnitEntryCard(data)),
              const SizedBox(height: 12),
              SizedBox(height: 190, child: _buildTotalOmsetCard(data)),
              const SizedBox(height: 12),
              SizedBox(height: 200, child: _buildRatioOmsetCard(data)),
              const SizedBox(height: 12),
              SizedBox(height: 200, child: _buildRatioMemberCard(data)),
              const SizedBox(height: 12),
              SizedBox(height: 280, child: _buildTop5OmsetCard()),
              const SizedBox(height: 12),
              SizedBox(height: 300, child: _buildUnitEntryChartCard(data)),
              const SizedBox(height: 12),
              SizedBox(height: 340, child: _buildOmsetChartCard(data)),
            ],
          );
        }

        // 2. Tablet / Medium Screen (700px - 1100px): 2-column scrollable grid
        if (width < 1100) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
            children: [
              SizedBox(
                height: 190,
                child: Row(
                  children: [
                    Expanded(child: _buildTotalUnitEntryCard(data)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTotalOmsetCard(data)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 210,
                child: Row(
                  children: [
                    Expanded(child: _buildRatioOmsetCard(data)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildRatioMemberCard(data)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(height: 280, child: _buildTop5OmsetCard()),
              const SizedBox(height: 16),
              SizedBox(height: 300, child: _buildUnitEntryChartCard(data)),
              const SizedBox(height: 16),
              SizedBox(height: 340, child: _buildOmsetChartCard(data)),
            ],
          );
        }

        // 3. Desktop (>= 1100px): 3-column layout, scrollable vertically if viewport height < 620px
        final desktopContent = Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              //*BARIS 1
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(flex: 1, child: _buildTotalUnitEntryCard(data)),
                    const SizedBox(height: 16),
                    Expanded(flex: 1, child: _buildTotalOmsetCard(data)),
                    const SizedBox(height: 16),
                    Expanded(flex: 1, child: _buildRatioOmsetCard(data)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              //*BARIS 2
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(flex: 1, child: _buildRatioMemberCard(data)),
                    const SizedBox(height: 16),
                    Expanded(flex: 2, child: _buildTop5OmsetCard()),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              //*BARIS 3
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(flex: 1, child: _buildUnitEntryChartCard(data)),
                    const SizedBox(height: 16),
                    Expanded(flex: 1, child: _buildOmsetChartCard(data)),
                  ],
                ),
              ),
            ],
          ),
        );

        if (height < 620) {
          return SingleChildScrollView(
            child: SizedBox(
              height: 620,
              child: desktopContent,
            ),
          );
        }

        return desktopContent;
      },
    );
  }
}
