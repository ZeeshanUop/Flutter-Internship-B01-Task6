import 'package:flutter/material.dart';
import 'package:neuroapp_task6/Provider/ImageUploadProvider.dart';
import 'package:provider/provider.dart';

class ImageUploadView extends StatelessWidget {
  const ImageUploadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Upload")),
      body: Consumer<ImageUploadProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: provider.pickImage,
                  child: const Text("Pick Image"),
                ),
                const SizedBox(height: 20),
                if (provider.selectedImage != null)
                  Image.file(provider.selectedImage!, height: 150),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: provider.isUploading ? null : provider.uploadImage,
                  child: const Text("Upload Image"),
                ),

                const SizedBox(height: 20),
                if (provider.isUploading)
                  Column(
                    children: [
                      LinearProgressIndicator(value: provider.uploadProgress),
                      const SizedBox(height: 8),
                      Text(
                        "${(provider.uploadProgress * 100).toStringAsFixed(0)}%",
                      ),
                    ],
                  ),

                const SizedBox(height: 20),
                if (provider.uploadedImageUrl != null)
                  Image.network(provider.uploadedImageUrl!, height: 150),

                if (provider.errorMessage != null)
                  Text(
                    provider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
