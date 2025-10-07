import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class VideoStatistiquePage extends StatefulWidget {
  final String videoId;
  final String videoTitle;

  const VideoStatistiquePage({
    Key? key,
    required this.videoId,
    required this.videoTitle,
  }) : super(key: key);

  @override
  State<VideoStatistiquePage> createState() => _VideoStatistiquePageState();
}

class _VideoStatistiquePageState extends State<VideoStatistiquePage> {
  double preTestMoyenne = 0;
  double postTestMoyenne = 0;
  int likes = 0;
  int vues = 0;
  int commentaires = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllStats();
  }

  /// 🔹 Récupère les moyennes de quiz, likes, vues et commentaires
  Future<void> _fetchAllStats() async {
    try {
      final videoId = widget.videoId;

      // Récupération des quiz
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

      // Récupération des likes
      final likesSnapshot = await FirebaseFirestore.instance
          .collection('likes')
          .where('videoid', isEqualTo: videoId)
          .get();

      // Récupération des vues
      final vuesSnapshot = await FirebaseFirestore.instance
          .collection('views')
          .where('videoid', isEqualTo: videoId)
          .get();

      // Récupération des commentaires
      final commentsSnapshot = await FirebaseFirestore.instance
          .collection('commentaires')
          .where('videoid', isEqualTo: videoId)
          .get();

      setState(() {
        preTestMoyenne = countPre > 0 ? totalPre / countPre : 0;
        postTestMoyenne = countPost > 0 ? totalPost / countPost : 0;
        likes = likesSnapshot.size;
        vues = vuesSnapshot.size;
        commentaires = commentsSnapshot.size;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Erreur : $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF065464),
        title: Text(
          "Statistiques - ${widget.videoTitle}",
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4F9CB2), Color(0xFF065464)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : SingleChildScrollView(
                padding: EdgeInsets.all(screenSize.width * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Comparatif Pré-test / Post-test",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenSize.width * 0.055,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.04),

                    /// 🔹 GRAPHE 1 : Moyenne des quiz
                    SizedBox(
                      height: screenSize.height * 0.35,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 100,
                          minY: 0,
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  switch (value.toInt()) {
                                    case 0:
                                      return const Text("Pré-test",
                                          style:
                                              TextStyle(color: Colors.white));
                                    case 1:
                                      return const Text("Post-test",
                                          style:
                                              TextStyle(color: Colors.white));
                                    default:
                                      return const SizedBox.shrink();
                                  }
                                },
                              ),
                            ),
                          ),
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: preTestMoyenne,
                                  color: Colors.orangeAccent,
                                  width: 35,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  toY: postTestMoyenne,
                                  color: Colors.greenAccent,
                                  width: 35,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: screenSize.height * 0.06),

                    Text(
                      "Interactions (Likes, Vues, Commentaires)",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenSize.width * 0.055,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.04),

                    /// 🔹 GRAPHE 2 : Interactions
                    SizedBox(
                      height: screenSize.height * 0.35,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: [
                                likes.toDouble(),
                                vues.toDouble(),
                                commentaires.toDouble(),
                              ].reduce((a, b) => a > b ? a : b) +
                              5,
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  switch (value.toInt()) {
                                    case 0:
                                      return const Text("Likes",
                                          style:
                                              TextStyle(color: Colors.white));
                                    case 1:
                                      return const Text("Vues",
                                          style:
                                              TextStyle(color: Colors.white));
                                    case 2:
                                      return const Text("Comts",
                                          style:
                                              TextStyle(color: Colors.white));
                                    default:
                                      return const SizedBox.shrink();
                                  }
                                },
                              ),
                            ),
                          ),
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: likes.toDouble(),
                                  color: Colors.pinkAccent,
                                  width: 30,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  toY: vues.toDouble(),
                                  color: Colors.blueAccent,
                                  width: 30,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 2,
                              barRods: [
                                BarChartRodData(
                                  toY: commentaires.toDouble(),
                                  color: Colors.yellowAccent,
                                  width: 30,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
