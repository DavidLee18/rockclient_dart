import 'package:angular_router/angular_router.dart';

import 'register_retreat/register_retreat_component.template.dart' as register_template;
import 'retreat_info/retreat_info_component.template.dart' as info_template;
import 'retreat_messages/retreat_messages_component.template.dart' as messages_template;

import 'route_paths.dart';

class Routes {
  static final register = RouteDefinition(
    routePath: RoutePaths.registerRetreat,
    component: register_template.RegisterRetreatComponentNgFactory
  );
  static final home = RouteDefinition(
    routePath: RoutePaths.home,
    useAsDefault: true,
    component: info_template.RetreatInfoComponentNgFactory
  );
  static final messages = RouteDefinition(
    routePath: RoutePaths.messages,
    component: messages_template.RetreatMessagesComponentNgFactory
  );

  static final List<RouteDefinition> all = [register, home, messages];
}