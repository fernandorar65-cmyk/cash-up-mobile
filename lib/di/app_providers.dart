import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';

import '../router/app_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return ref.watch(goRouterProvider);
});

