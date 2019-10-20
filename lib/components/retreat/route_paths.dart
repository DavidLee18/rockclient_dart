import 'package:angular_router/angular_router.dart';
import '../../route_paths.dart' as root;

class RoutePaths {
  static final registerRetreat = RoutePath(path: 'register', parent: root.RoutePaths.retreat);
  static final messages = RoutePath(path: 'messages', parent: root.RoutePaths.retreat);
  static final home = RoutePath(path: '', useAsDefault: true, parent: root.RoutePaths.retreat);
}