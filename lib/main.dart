import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'face_analyzer_service.dart';
import 'face_painter.dart';
import 'result_screen.dart';

void main() => runApp(const HairStyleAdvisorApp());

class HairStyleAdvisorApp extends StatelessWidget {
  const HairStyleAdvisorApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const AnalyzerScreen(),
    );
  }
}

class AnalyzerScreen extends StatefulWidget {
  const AnalyzerScreen({Key? key}) : super(key: key);
  @override
  State<AnalyzerScreen> createState() => _AnalyzerScreenState();
}

class _AnalyzerScreenState extends State<AnalyzerScreen>
    with SingleTickerProviderStateMixin {
  final FaceAnalyzerService _service = FaceAnalyzerService();
  late AnimationController _controller;
  XFile? _image;
  bool _loading = false;
  dynamic _points = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  Future<void> _pickImage(ImageSource source) async {
    final img = await ImagePicker().pickImage(source: source);
    if (img == null) return;
    setState(() {
      _image = img;
      _loading = true;
      _points = [];
    });

    final result = await _service.analyzeFaceShape(img.path);
    if (result.points.isEmpty) {
      setState(() => _loading = false);
      _showError('Không nhận diện được khuôn mặt!');
      return;
    }
    final tone = await _service.analyzeSkinTone(img.path);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ResultScreen(faceShape: result.shape, skinTone: tone),
      ),
    );
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thông báo'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Hair Advisor'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null)
              Container(
                height: 350,
                width: 280,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.tealAccent),
                ),
                child: Stack(
                  children: [
                    Image.file(
                      File(_image!.path),
                      fit: BoxFit.cover,
                      width: 280,
                      height: 350,
                    ),
                    if (_loading)
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (ctx, child) => Positioned(
                          top: _controller.value * 350,
                          child: Container(
                            width: 280,
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.tealAccent,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.tealAccent,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
            else
              const Icon(Icons.face, size: 80, color: Colors.tealAccent),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: const Text('Chụp Selfie'),
            ),
            TextButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: const Text('Thư viện'),
            ),
          ],
        ),
      ),
    );
  }
}
