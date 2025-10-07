import 'package:dentaire/view/screens/admin_screens/AboutScreen.dart';
import 'package:dentaire/view/screens/admin_screens/ContactScreen.dart';
import 'package:dentaire/view/screens/common_screens/connexion.dart';
import 'package:dentaire/view/screens/common_screens/welcom.dart';
import 'package:dentaire/view/screens/teacher_screens/favoris.dart';
import 'package:dentaire/view/screens/teacher_screens/gestionvideo.dart';
import 'package:flutter/material.dart';
import 'package:dentaire/view/screens/admin_screens/add_teacher_screen.dart';
import 'package:dentaire/view/screens/common_screens/langue.dart';
import 'package:dentaire/view/screens/common_screens/password_screen.dart';
import 'package:dentaire/view/screens/student_screens/favorite_screen_student.dart';
import 'package:dentaire/view/screens/student_screens/module_screens_student.dart';
import 'package:dentaire/view/screens/student_screens/settings_screen_student.dart';
import 'package:dentaire/view/screens/student_screens/video_details_screen.dart';
import 'package:dentaire/view/screens/student_screens/video_lecture_screen.dart';
import 'package:dentaire/view/screens/student_screens/trimestres.dart';
import 'package:dentaire/view/screens/teacher_screens/add_student_screen.dart';
import 'package:dentaire/view/screens/teacher_screens/home_screen_teacher.dart';
import 'package:dentaire/view/screens/teacher_screens/lists_etudiants_screen.dart';
import 'package:dentaire/view/screens/teacher_screens/settings_screen_teacher.dart';
import 'package:dentaire/view/screens/student_screens/home_screen_student.dart';
import 'package:dentaire/view/screens/common_screens/profile_screen.dart';
import 'package:dentaire/view/screens/student_screens/videos_list_screen.dart';
import 'package:dentaire/view/screens/student_screens/quiz_screen.dart';

class AppRoutes {
  // Routes simples (sans arguments)
  static Map<String, WidgetBuilder> routes = {
    //login
    '/launcher_screen': (context) => const WelcomeScreen(),
    '/loginScreen': (context) => const LoginScreen(),
    '/welcomeScreen': (context) => const WelcomeScreen(),
    '/profileScreen': (context) => const ProfileScreen(),

    // Admin
    '/add-teacher': (context) => const AddTeacherPage(),

    // Étudiant
    "/profile": (context) => const ProfileScreen(),
    "/home": (context) => const HomeScreenStudent(),
    "/favorits": (context) => const FavoritesContent(),
    "/modules": (context) => const ModulesContent(),
    "/settings": (context) => const SettingsScreen(),

    // Enseignant
    "/Profile_edit_teacher": (context) => const ProfileScreen(),
    "/password-change": (context) => const PasswordChangeScreen(),
    "/language": (context) => const LanguageScreen(),
    "/teacherhome": (context) => const HomeScreenTeacher(),
    "/studentList": (context) => ListEtudiantsPage(),
    "/addstudent": (context) => AddStudentPage(),
    "/teacherSettings": (context) => const SettingsScreenTeacher(),
    "/teacherProfile": (context) => const ProfileScreen(),
    '/settings-teacher': (context) => const SettingsScreenTeacher(),
    '/contact': (context) => const ContactScreen(),
    '/about': (context) => const AboutScreen(),
    '/favorites': (context) => const VideoFav(),
    '/video-list-teacher': (context) => const GestionVideosPage(),
  };

  // Routes avec arguments
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "Trimesters":
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => TrimestersModulesPage(year: args['year']),
        );

      case "videoslist":
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => VideoListScreen(moduleName: args['moduleName']),
        );

      case "videodetail":
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => VideoDetailScreen(
            moduleName: args['moduleName'],
            videoId: args['video'],
          ),
        );

      case "videoPlayer":
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
            videoTitle: args['videoTitle'],
            moduleName: args['moduleName'],
            video: args['video'],
          ),
        );

      case "quiz":
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => QuizScreen(
            videoTitle: args['videoTitle'],
            moduleName: args['moduleName'],
            video: args['video'],

            //videoId: args['videoid'],
          ),
        );

      default:
        return null;
    }
  }
}
