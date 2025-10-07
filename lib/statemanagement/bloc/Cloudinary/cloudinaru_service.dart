import 'package:cloudinary_public/cloudinary_public.dart';
import 'dart:io';
// Correction de l'import : Utilisation du chemin relatif (un dossier parent)
import '../video_config.dart' as config;

class CloudinaryService {
  final _cloudinary = CloudinaryPublic(
    // Accès aux constantes via l'alias 'config'
    config.CloudinaryConfig.cloudName,
    config.CloudinaryConfig.uploadPreset, // Preset non signé
    cache: false,
  );

  /// Charge un fichier (vidéo ou document) sur Cloudinary.
  Future<String?> uploadFile({
    required File file,
    required CloudinaryResourceType resourceType,
  }) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          resourceType: resourceType,
        ),
      );
      // L'URL sécurisée est retournée
      return response.secureUrl;
    } on CloudinaryException catch (e) {
      // Correction de l'erreur 'data':
      // Nous nous limitons aux propriétés garanties par toutes les versions
      print("Erreur Cloudinary (Code ${e.statusCode}) : ${e.message}");
      return null;
    } catch (e) {
      print("Erreur inconnue lors de l'upload : $e");
      return null;
    }
  }

  Future<String?> uploadVideo(File file) async {
    return uploadFile(
      file: file,
      resourceType: CloudinaryResourceType.Video,
    );
  }

  Future<String?> uploadDocument(File file) async {
    return uploadFile(
      file: file,
      resourceType:
          CloudinaryResourceType.Raw, // 'Raw' pour les documents/fichiers
    );
  }
}
