import 'package:angular_router/angular_router.dart';

class RoutePaths {
  static final leaders = RoutePath(path: 'leaders');
  static final signUp = RoutePath(path: 'sign_up');
  static final login = RoutePath(path: 'login');
  static final retreat = RoutePath(path: 'retreat');
  static final registerRetreat = RoutePath(path: 'register', parent: retreat);
  static final registerMongsanpo = RoutePath(path: 'register_mongsanpo');
  static final resetPassword = RoutePath(path: 'reset_password');
}