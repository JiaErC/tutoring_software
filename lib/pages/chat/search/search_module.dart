import 'package:flutter_modular/flutter_modular.dart';

import 'package:tutoring_software/pages/chat/search/search_page.dart';

class SearchModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const SearchPage());
  }
}