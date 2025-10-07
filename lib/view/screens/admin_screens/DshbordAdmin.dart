import 'package:flutter/material.dart';
import 'package:dentaire/statemanagement/bloc/dashbord/dashbord_service.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final DashboardService _service = DashboardService();

  Map<String, dynamic>? stats;
  List<Map<String, dynamic>> recentVideos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final fetchedStats = await _service.fetchStats();
      final fetchedRecent = await _service.fetchRecentVideos();

      setState(() {
        stats = fetchedStats;
        recentVideos = fetchedRecent;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Erreur lors du chargement des données: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📊 Tableau de bord Admin"),
        backgroundColor: const Color(0xFF1A6175),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : stats == null
              ? const Center(child: Text("Impossible de charger les données"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      // ---- Statistiques générales ----
                      Text(
                        "Statistiques",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatCard("👨‍🏫 Enseignants",
                              "${stats!['enseignants'] ?? 0}", Colors.blue),
                          _buildStatCard("👩‍🎓 Étudiants",
                              "${stats!['etudiants'] ?? 0}", Colors.green),
                          _buildStatCard("🎥 Vidéos",
                              "${stats!['videos'] ?? 0}", Colors.orange),
                          _buildStatCard("📝 Quiz", "${stats!['quiz'] ?? 0}",
                              Colors.purple),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // ---- Vidéos récentes ----
                      Text(
                        "Vidéos récentes",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),

                      if (recentVideos.isEmpty)
                        const Text("Aucune vidéo récente"),
                      ...recentVideos.map((video) => Card(
                            child: ListTile(
                              leading: const Icon(Icons.play_circle,
                                  color: Colors.orange),
                              title: Text(video['title'] ?? "Sans titre"),
                              subtitle: Text(
                                  "Ajouté le ${video['createdAt'] ?? '--'}"),
                            ),
                          )),
                    ],
                  ),
                ),
    );
  }

  // ---- Carte statistique réutilisable ----
  Widget _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color.withOpacity(0.1),
          ),
          child: Column(
            children: [
              Text(
                count,
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(height: 5),
              Text(title, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
