import 'package:flutter_modular/flutter_modular.dart';
import 'package:tutoring_software/pages/learning_analysis/learning_analysis_page.dart';
import 'package:tutoring_software/pages/learning_analysis/test_paper_preview_page.dart';

// 学习分析模块
class LearningAnalysisModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const LearningAnalysisPage());
    r.child("/preview", child: (_) => const TestPaperPreviewPage());
  }
}