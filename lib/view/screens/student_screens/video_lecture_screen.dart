import 'package:dentaire/view/screens/student_screens/add_comment_screen.dart';
import 'package:dentaire/view/screens/student_screens/post_test.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:dentaire/view/components/custom_navigation_bar_curved.dart';
import 'package:dentaire/view/components/navigation_item.dart';
import 'home_screen_student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoTitle;
  final String moduleName;
  final dynamic video;

  const VideoPlayerScreen({
    Key? key,
    required this.videoTitle,
    required this.moduleName,
    required this.video,
  }) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  int _currentIndex = 0;
  bool _showCommentField = false;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;
  bool _isFavorite = false;
  bool _hasRecordedView = false; // Pour enregistrer la vue une seule fois

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    final videoUrl = widget.video['videoUrl'];
    if (videoUrl != null && videoUrl.isNotEmpty) {
      _controller = VideoPlayerController.network(videoUrl);
      _initializeVideoPlayerFuture = _controller.initialize().then((_) {
        setState(() {});
      });
      _controller.setLooping(false);
    } else {
      _initializeVideoPlayerFuture = Future.error("Aucune URL vidéo trouvée");
    }

    _checkIfFavorite();
  }

  /// Vérifie si la vidéo est déjà en favoris
  Future<void> _checkIfFavorite() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('favorites')
        .where('userId', isEqualTo: user.uid)
        .where('videoId', isEqualTo: widget.video['videoId'])
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        _isFavorite = true;
      });
    }
  }

  /// Ajouter / supprimer des favoris
  Future<void> _toggleFavorite() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      if (_isFavorite) {
        final snapshot = await _firestore
            .collection('favorites')
            .where('userId', isEqualTo: user.uid)
            .where('videoid', isEqualTo: widget.video['videoid'])
            .get();

        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }

        setState(() {
          _isFavorite = false;
        });
      } else {
        await _firestore.collection('favorites').add({
          'userId': user.uid,
          'videoid': widget.video['videoid'],
          'videoTitle': widget.videoTitle,
          'moduleName': widget.moduleName,
          'videoUrl': widget.video['videoUrl'],
          'timestamp': FieldValue.serverTimestamp(),
        });

        setState(() {
          _isFavorite = true;
        });
      }
    } catch (e) {
      print("Erreur favoris : $e");
    }
  }

  /// Ajouter / supprimer like
  Future<void> _toggleLike() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final likeRef = _firestore.collection('likes');

    final snapshot = await likeRef
        .where('userId', isEqualTo: user.uid)
        .where('videoid', isEqualTo: widget.video['videoid'])
        .get();

    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } else {
      await likeRef.add({
        'userId': user.uid,
        'videoid': widget.video['videoid'],
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Vérifie si l'utilisateur a déjà liké la vidéo
  Stream<bool> _isLikedStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(false);

    return _firestore
        .collection('likes')
        .where('userId', isEqualTo: user.uid)
        .where('videoid', isEqualTo: widget.video['videoid'])
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  /// Enregistre une vue une seule fois
  Future<void> _recordView() async {
    if (_hasRecordedView) return;
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('views')
        .where('userId', isEqualTo: user.uid)
        .where('videoid', isEqualTo: widget.video['videoid'])
        .get();

    if (snapshot.docs.isEmpty) {
      await _firestore.collection('views').add({
        'userId': user.uid,
        'videoid': widget.video['videoid'],
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    _hasRecordedView = true;
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
        _recordView(); // Enregistre la vue dès que la vidéo est lancée
      }
    });
  }

  void _handleSendComment(String comment) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    await _firestore.collection('commentaire').add({
      'videoid': widget.video['videoid'],
      'userId': currentUser.uid,
      'userEmail': currentUser.email,
      'comment': comment,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      _showCommentField = false;
    });
  }

  void _onNavBarTap(int index) {
    if (index == _currentIndex) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreenStudent(selectedIndex: index),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4F9CB2), Color(0xff065464)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.grey, size: 16),
                    ),
                    Expanded(
                      child: Text(
                        widget.videoTitle,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const Icon(Icons.notifications_none, color: Colors.white),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),

                // Player vidéo
                Expanded(
                  flex: 6,
                  child: FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                            IconButton(
                              iconSize: 64,
                              icon: Icon(
                                _isPlaying
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_fill,
                                color: Colors.white70,
                              ),
                              onPressed: _togglePlayPause,
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            "Aucune vidéo disponible",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                    },
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // Contrôles favoris + like
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: Colors.black,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                    StreamBuilder<bool>(
                      stream: _isLikedStream(),
                      builder: (context, snapshotLiked) {
                        final isLiked = snapshotLiked.data ?? false;
                        return IconButton(
                          icon: Icon(
                            isLiked
                                ? Icons.thumb_up
                                : Icons.thumb_up_alt_outlined,
                            color: isLiked ? Colors.black : Colors.white,
                          ),
                          onPressed: _toggleLike,
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.pause_circle_filled,
                          color: Colors.white),
                      onPressed: _controller.pause,
                    ),
                    IconButton(
                      icon: const Icon(Icons.play_circle_fill,
                          color: Colors.white),
                      onPressed: _togglePlayPause,
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.02),

                // Boutons test / commentaire
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostQuizScreen(
                                videoTitle: widget.videoTitle,
                                moduleName: widget.moduleName,
                                video: widget.video,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text('Passer le test',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showCommentField = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text('Laisser un commentaire',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                ),

                if (_showCommentField) AddComment(onSend: _handleSendComment),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBarTheme.getNavigationBar(
        index: _currentIndex,
        onTap: _onNavBarTap,
        itemsList: const [
          NavItem(icon: Icons.home, label: "Accueil"),
          NavItem(icon: Icons.list, label: "Modules"),
          NavItem(icon: Icons.favorite, label: "Favoris"),
          NavItem(icon: Icons.settings, label: "Paramètres"),
          NavItem(icon: Icons.person, label: "Profil"),
        ],
      ),
    );
  }
}
