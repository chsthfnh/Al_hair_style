import 'dart:io';
import 'dart:math';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

class AnalysisResult {
  final String shape;
  final List<Point<int>> points;
  AnalysisResult(this.shape, this.points);
}

class FaceAnalyzerService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(enableContours: true),
  );

  Future<AnalysisResult> analyzeFaceShape(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) return AnalysisResult('Không tìm thấy mặt', []);

      final face = faces.first;
      final points = face.contours[FaceContourType.face]?.points ?? [];

      if (points.length < 10) return AnalysisResult('Dữ liệu không đủ', []);

      final shape = _calculateComplexShape(points);
      return AnalysisResult(shape, points);
    } catch (e) {
      return AnalysisResult('Lỗi hệ thống', []);
    }
  }

  String _calculateComplexShape(List<Point<int>> points) {
    // 1. Tính toán kích thước tổng quát
    int minX = points.map((p) => p.x).reduce(min);
    int maxX = points.map((p) => p.x).reduce(max);
    int minY = points.map((p) => p.y).reduce(min);
    int maxY = points.map((p) => p.y).reduce(max);

    double width = (maxX - minX).toDouble();
    double height = (maxY - minY).toDouble();
    double ratio = height / width;
    print(ratio.toStringAsFixed(3));
    // 2. Logic phân tích sâu
    if (ratio <= 1.15) {
      return 'Không thể xác minh được';
    } else if (ratio < 1.168) {
      return 'Tròn (Round)';
    } else if (ratio <= 1.17) {
      return 'Kim Cương (Diamond)';
    } else if (ratio <= 1.18) {
      return 'Mặt Dài (Long)';
    } else if (ratio < 1.23) {
      return 'Vuông (Square)';
    } else if (ratio < 1.3) {
      return 'Trái Xoan (Oval)';
    } else {
      return 'Không thể xác minh được';
    }
  }

  //Tron 1.166
  //kc 1.169
  //dai 1.174
  //Vuong 1.224
  //Oval 1.231;1.276
  //KHL: 1.096;1.144;1.376;1.449

  Future<String> analyzeSkinTone(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return 'Trung tính';
      final p = image.getPixel(image.width ~/ 2, image.height ~/ 2);
      return (p.r > p.g && p.r > p.b)
          ? 'Warm Tone (Da ấm)'
          : 'Cool Tone (Da lạnh)';
    } catch (e) {
      return 'Trung tính';
    }
  }

  void dispose() => _faceDetector.close();
}
