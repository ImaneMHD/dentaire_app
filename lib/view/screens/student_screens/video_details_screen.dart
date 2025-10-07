import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/view/components/custom_navigation_bar_curved.dart';
import 'package:dentaire/view/components/navigation_item.dart';
import 'package:dentaire/view/screens/student_screens/pdfView.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoDetailScreen extends StatefulWidget {
  final String videoId;
  final String moduleName;

  const VideoDetailScreen({
    Key? key,
    required this.videoId,
    required this.moduleName,
  }) : super(key: key);

  @override
  _VideoDetailScreenState createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  int _currentIndex = 0;

  void _onNavBarTap(int index) {
    Navigator.pushReplacementNamed(
      context,
      'home',
      arguments: {'selectedIndex': index},
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoRef =
        FirebaseFirestore.instance.collection('videos').doc(widget.videoId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff065464),
        title: const Text("Détails vidéo"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4F9CB2),
              Color(0xff065464),
            ],
          ),
        ),
        child: FutureBuilder<DocumentSnapshot>(
          future: videoRef.get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError ||
                !snapshot.hasData ||
                !snapshot.data!.exists) {
              return const Center(
                child: Text(
                  "Vidéo non trouvée.",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final documents =
                List<Map<String, dynamic>>.from(data['documents'] ?? []);
            final title = data['title'] ?? "Titre inconnu";

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Player placeholder
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        'quiz',
                        arguments: {
                          'videoTitle': title,
                          'moduleName': widget.moduleName,
                          'video': data,
                        },
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          size: 60,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Documents associés :",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final doc = documents[index];
                        final docName = doc['name'] ?? 'Document';
                        final docUrl = doc['url'] ?? '';

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // ... inside VideoDetailScreen's build method

// ... (inside the ListView.builder)

                          child: ListTile(
                            leading: const Icon(Icons.folder,
                                color: Colors.blue), // icône folder
                            title: Text(docName,
                                style: const TextStyle(fontSize: 14)),
                            onTap: () {
                              if (docUrl.isNotEmpty) {
                                // 🚀 NEW LOGIC: Check if it's likely a PDF (or document you can handle)
                                // and navigate to the dedicated viewer screen.

                                // Since you are using advance_pdf_viewer, assume all documents are PDFs
                                // or documents that the viewer can handle via URL.

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PDFViewerPage(
                                      //PdfViewScreen(
                                      pdfUrl: docUrl,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "L'URL du document $docName est vide.")),
                                );
                              }
                            },
                          ),
// ...
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: CustomNavBarTheme.getNavigationBar(
        index: _currentIndex,
        onTap: _onNavBarTap,
        itemsList: const [
          NavItem(icon: Icons.home, label: "Accueil"),
          NavItem(icon: Icons.list, label: "Modules"),
          NavItem(icon: Icons.favorite, label: "Favoris"),
          NavItem(icon: Icons.settings, label: "Profil"),
          NavItem(icon: Icons.person, label: "Profil"),
        ],
      ),
    );
  }
}
