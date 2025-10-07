import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GlobalStatsPage extends StatefulWidget {
  final String teacherId;

  const GlobalStatsPage({Key? key, required this.teacherId}) : super(key: key);

  @override
  State<GlobalStatsPage> createState() => _GlobalStatsPageState();
}

class _GlobalStatsPageState extends State<GlobalStatsPage> {
  bool isLoading = true;
  List<String> videoTitles = [];
  List<double> vues = [];
  List<double> likes = [];
  List<double> favoris = [];
  List<double> moyennesQuizPre = [];
  List<double> moyennesQuizPost = [];

  @override
  void initState() {
    super.initState();
    _fetchGlobalStats();
  }

  Future<void> _fetchGlobalStats() async {
    try {
      final videosSnapshot = await FirebaseFirestore.instance
          .collection('videos')
          .where('teacherId', isEqualTo: widget.teacherId)
          .get();

      for (var video in videosSnapshot.docs) {
        final videoId = video.id;
        final videoTitle = video['videoTitle'] ?? 'Sans titre';

        // Récupérer les vues, likes et favoris
        final vuesCount = await FirebaseFirestore.instance
            .collection('views')
            .where('videoid', isEqualTo: videoId)
            .count()
            .get();

        final likesCount = await FirebaseFirestore.instance
            .collection('likes')
            .where('videoid', isEqualTo: videoId)
            .count()
            .get();

        final favCount = await FirebaseFirestore.instance
            .collection('favorites')
            .where('videoid', isEqualTo: videoId)
            .count()
            .get();

        // Récupérer les résultats de quiz
        final quizResults = await FirebaseFirestore.instance
            .collection('quizResultats')
            .where('videoid', isEqualTo: videoId)
            .get();

        double totalPre = 0;
        double totalPost = 0;
        int countPre = 0;
        int countPost = 0;

        for (var doc in quizResults.docs) {
          final data = doc.data();
          final type = data['quizType'];
          final score = (data['score'] ?? 0).toDouble();

          if (type == 'pre-test') {
            totalPre += score;
            countPre++;
          } else if (type == 'post-test') {
            totalPost += score;
            countPost++;
          }
        }

        setState(() {
          videoTitles.add(videoTitle);
          vues.add((vuesCount.count ?? 0).toDouble());
          likes.add((likesCount.count ?? 0).toDouble());
          favoris.add((favCount.count ?? 0).toDouble());
        });
      }

      setState(() => isLoading = false);
    } catch (e) {
      debugPrint("Erreur lors du chargement : $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF065464),
      appBar: AppBar(
        backgroundColor: const Color(0xFF065464),
        title: const Text("Statistiques globales",
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildLineChart(),
                  const SizedBox(height: 40),
                  _buildBarChart(),
                ],
              ),
            ),
    );
  }

  /// 🔹 Graphe 1 : Courbes Vues / Likes / Favoris / Quiz
  Widget _buildLineChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F9CB2), Color(0xFF065464)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text("Métriques par vidéo",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) => Text(
                        "${val.toInt() + 1}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: vues
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    color: Colors.blueAccent,
                    barWidth: 3,
                    isCurved: true,
                  ),
                  LineChartBarData(
                    spots: likes
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    color: Colors.greenAccent,
                    barWidth: 3,
                    isCurved: true,
                  ),
                  LineChartBarData(
                    spots: favoris
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    color: Colors.purpleAccent,
                    barWidth: 3,
                    isCurved: true,
                  ),
                  LineChartBarData(
                    spots: moyennesQuizPost
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    color: Colors.redAccent,
                    barWidth: 3,
                    isCurved: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Legend(color: Colors.blueAccent, label: "Vues"),
              _Legend(color: Colors.greenAccent, label: "Likes"),
              _Legend(color: Colors.purpleAccent, label: "Favoris"),
              _Legend(color: Colors.redAccent, label: "Quiz"),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔹 Graphe 2 : Barres Pré-test / Post-test
  Widget _buildBarChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F9CB2), Color(0xFF065464)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text("Résultats Quiz",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) => Text(
                        "v${val.toInt() + 1}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                barGroups: List.generate(videoTitles.length, (i) {
                  return BarChartGroupData(x: i, barRods: [
                    BarChartRodData(
                        toY: moyennesQuizPre[i],
                        color: Colors.cyanAccent,
                        width: 12),
                    BarChartRodData(
                        toY: moyennesQuizPost[i],
                        color: Colors.white,
                        width: 12),
                  ]);
                }),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Legend(color: Colors.cyanAccent, label: "Pré-test"),
              SizedBox(width: 20),
              _Legend(color: Colors.white, label: "Post-test"),
            ],
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 14, height: 14, color: color),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
