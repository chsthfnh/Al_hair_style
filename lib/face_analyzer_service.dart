import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'; // Để dùng debugPrint
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

class FaceAnalyzerService {
  Interpreter? _interpreter;
  List<String>? _labels;

  Future<void> initModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/face_shape_model.tflite',
      );
      final labelsData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelsData.split('\n').where((s) => s.isNotEmpty).toList();
      debugPrint("✅ Model Ready!");
    } catch (e) {
      debugPrint("❌ Init Error: $e");
    }
  }

  Future<String> analyzeFaceShape(File imageFile) async {
    if (_interpreter == null) return "Model loading...";

    // ===== BƯỚC 1: KIỂM TRA KHUÔN MẶT =====
    final inputImage = InputImage.fromFile(imageFile);

    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
        enableContours: true,
        enableLandmarks: true,
      ),
    );

    final faces = await faceDetector.processImage(inputImage);

    // Không có mặt
    if (faces.isEmpty) {
      print('🛑 LỖI BƯỚC 1: ML Kit không tìm thấy khuôn mặt nào trong ảnh!');
      return "Không thể xác minh được";
    }

    // NẾU CÓ NHIỀU MẶT -> TÌM MẶT TO NHẤT (SỬA Ở ĐÂY 👇)
    if (faces.length > 1) {
      print(
        '⚠️ CẢNH BÁO BƯỚC 1: Tìm thấy ${faces.length} khuôn mặt! Đang lọc lấy khuôn mặt to nhất...',
      );
      // Sắp xếp danh sách khuôn mặt theo diện tích (Rộng x Cao) giảm dần
      faces.sort((a, b) {
        double areaA = a.boundingBox.width * a.boundingBox.height;
        double areaB = b.boundingBox.width * b.boundingBox.height;
        return areaB.compareTo(areaA);
      });
    }

    // Sau khi sắp xếp, mặt to nhất chắc chắn sẽ nằm ở vị trí đầu tiên (.first)
    final face = faces.first;

    // ===== BƯỚC 2: KIỂM TRA ĐỘ RÕ =====
    print(
      '📐 Thông số mặt: Rộng=${face.boundingBox.width}, Cao=${face.boundingBox.height}',
    );
    print(
      '📐 Góc nghiêng: Y=${face.headEulerAngleY}, Z=${face.headEulerAngleZ}',
    );

    // mặt quá nhỏ
    if (face.boundingBox.width < 120 || face.boundingBox.height < 120) {
      print(
        '🛑 LỖI BƯỚC 2: Khuôn mặt quá nhỏ (< 120px). Kích thước thật: ${face.boundingBox.width} x ${face.boundingBox.height}',
      );
      return "Không thể xác minh được";
    }

    // xoay quá nhiều
    if ((face.headEulerAngleY ?? 0).abs() > 35 ||
        (face.headEulerAngleZ ?? 0).abs() > 35) {
      print('🛑 LỖI BƯỚC 2: Mặt bị nghiêng quá 35 độ!');
      return "Không thể xác minh được";
    }
    // ===== BƯỚC 3: CẮT KHUÔN MẶT & CHẠY MODEL =====
    final rawImage = img.decodeImage(await imageFile.readAsBytes());
    if (rawImage == null) return "Không thể xác minh được";

    // 1. Lấy tọa độ khuôn mặt gốc từ ML Kit
    final boundingBox = face.boundingBox;

    // 💡 THÊM PADDING: Mở rộng khung cắt ra 25% để lấy cả Tóc, Tai và Cổ
    int paddingX = (boundingBox.width * 0.25).toInt();
    int paddingY = (boundingBox.height * 0.25).toInt();

    int x = boundingBox.left.toInt() - paddingX;
    int y = boundingBox.top.toInt() - paddingY;
    int w = boundingBox.width.toInt() + (paddingX * 2);
    int h = boundingBox.height.toInt() + (paddingY * 2);

    // 2. Đảm bảo khung cắt không bị tràn ra ngoài viền ảnh gốc (Tránh lỗi Crash)
    x = x.clamp(0, rawImage.width);
    y = y.clamp(0, rawImage.height);
    w = w.clamp(0, rawImage.width - x);
    h = h.clamp(0, rawImage.height - y);

    // 3. CẮT LẤY KHUÔN MẶT ĐÃ MỞ RỘNG
    img.Image croppedFace = img.copyCrop(
      rawImage,
      x: x,
      y: y,
      width: w,
      height: h,
    );

    // 4. Bóp ảnh CẮT về chuẩn 224x224 cho AI
    img.Image resized = img.copyResize(croppedFace, width: 224, height: 224);

    // Tiếp tục đưa vào Model như cũ
    var input = _imageToByteListFloat32(resized).reshape([1, 224, 224, 3]);
    var output = [List<double>.filled(5, 0.0)];
    _interpreter!.run(input, output);
    List<double> probs = output[0];

    // ===== BƯỚC 4: CONFIDENCE =====

    double maxVal = probs.reduce((a, b) => a > b ? a : b);
    print('maxVal ket qua la: $maxVal');

    // Nếu AI không tự tin
    if (maxVal < 0.25) {
      return "Không thể xác minh được";
    }
    int maxIdx = probs.indexOf(maxVal);
    print(maxIdx);
    print(_labels![maxIdx].trim());
    return _labels![maxIdx].trim();
  }

  Float32List _imageToByteListFloat32(img.Image image) {
    var buffer = Float32List(1 * 224 * 224 * 3);
    int idx = 0;
    for (var y = 0; y < 224; y++) {
      for (var x = 0; x < 224; x++) {
        var pixel = image.getPixel(x, y);

        // SỬA TẠI ĐÂY: Truyền thẳng giá trị pixel 0-255 vào, để AI (TFLite) tự chuẩn hóa
        buffer[idx++] = pixel.r.toDouble();
        buffer[idx++] = pixel.g.toDouble();
        buffer[idx++] = pixel.b.toDouble();
      }
    }
    return buffer;
  }

  Future<String> analyzeSkinTone(File imageFile) async => "Neutral";
}
