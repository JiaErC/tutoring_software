import 'package:flutter_modular/flutter_modular.dart';
import 'package:tutoring_software/pages/test_scoring/test_scoring_page.dart';

// 测试评分模块
class TestScoringModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const TestScoringPage());
  }
}