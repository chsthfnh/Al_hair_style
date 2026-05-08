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

    // 2. Logic phân tích sâu
    if (ratio > 1.6) return 'Mặt Dài (Long)';
    if (ratio < 1.1) return 'Tròn (Round)';
    if (ratio > 1.35) return 'Trái Xoan (Oval)';

    return 'Vuông (Square)';
  }

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
