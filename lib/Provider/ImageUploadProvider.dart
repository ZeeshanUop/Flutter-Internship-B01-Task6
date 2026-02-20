import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageUploadProvider extends ChangeNotifier {
  File? selectedImage;
  String? uploadedImageUrl;
  double uploadProgress = 0.0;
  bool isUploading = false;
  String? errorMessage;

  final ImagePicker _picker = ImagePicker();
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        selectedImage = File(image.path);
        notifyListeners();
      }
    } catch (e) {
      errorMessage = "Failed to pick image";
      notifyListeners();
    }
  }

  Future<Uint8List?> _compressImage(File file) async {
    try {
      return await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        quality: 70,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> uploadImage() async {
    if (selectedImage == null) return;

    try {
      isUploading = true;
      uploadProgress = 0;
      errorMessage = null;
      notifyListeners();
      Uint8List? imageBytes = await _compressImage(selectedImage!);
      imageBytes ??= await selectedImage!.readAsBytes();
      var uri = Uri.parse("https://your-api.com/upload");

      var request = http.MultipartRequest("POST", uri);
      var multipartFile = http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: "upload.jpg",
      );
      request.files.add(multipartFile);
      var streamedResponse = await request.send();
      streamedResponse.stream.listen((value) {
        uploadProgress += value.length / streamedResponse.contentLength!;
        notifyListeners();
      });

      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        uploadedImageUrl = data['imageUrl'];
      } else {
        errorMessage = "Upload failed";
      }
    } catch (e) {
      errorMessage = "Error: $e";
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }
}
