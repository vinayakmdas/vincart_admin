import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName = 'logocloudname';
  final String uploadPreset = 'brand_logo';

  uploadImage(Uint8List unit8List) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );

      var reqest = await http.MultipartRequest('post', url);

      reqest.fields['upload_preset'] = uploadPreset;

      reqest.files.add(
        http.MultipartFile.fromBytes(
          'file',
          unit8List,
          filename: 'brand_logo.png',
        ),
      );

      var response = await reqest.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        final imageUrl = data['secure_url'];
        print('✅ Uploaded to Cloudinary: $imageUrl');
        return imageUrl;
      } else {
        print('❌ Upload failed: ${response.statusCode}');
        print(responseBody);
        return null;
      }
    } catch (e) {
      print('⚠️ Error uploading image: $e');
      return null;
    }
  }
}
