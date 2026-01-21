import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart'; // Cloudinary handles naming or we can specify

class StorageService {
  // Replace with your actual Cloudinary credentials
  final _cloudinary = CloudinaryPublic(
    'dsx11',
    'unsigned_upload',
    cache: false,
  );

  Future<String> uploadImage(XFile file, String folder) async {
    try {
      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          resourceType: CloudinaryResourceType.Image,
          folder: folder,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Cloudinary upload failed: $e');
    }
  }
}
