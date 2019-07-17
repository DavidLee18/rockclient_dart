import 'package:angular_router/angular_router.dart';

import 'components/leaders_search/leaders_search_component.template.dart' as leaders_search_template;
import 'components/sign_up/sign_up_component.template.dart' as sign_up_template;
import 'components/members/members_component.template.dart' as members_template;
import 'components/login/login_component.template.dart' as login_template;
import 'components/register_retreat/register_retreat_component.template.dart' as register_retreat_template;
import 'components/retreat_info/retreat_info_component.template.dart' as retreat_info_template;
import 'components/register_monsanpo/register_mongsanpo_component.template.dart' as register_mongsanpo_template;
import 'components/not_found/not_found_component.template.dart' as not_found_template;

import 'route_paths.dart';


class Routes {
  static final search = RouteDefinition(
    routePath: RoutePaths.leadersSearch,
    component: leaders_search_template.LeadersSearchComponentNgFactory
  );
  static final signup = RouteDefinition(
    routePath: RoutePaths.signUp,
    component: sign_up_template.SignUpComponentNgFactory
  );
  static final members = RouteDefinition(
    routePath: RoutePaths.members,
    component: members_template.MembersComponentNgFactory
  );
  static final login = RouteDefinition(
    routePath: RoutePaths.login,
    component: login_template.LoginComponentNgFactory
  );
  static final registerRetreat = RouteDefinition(
    routePath: RoutePaths.registerRetreat,
    component: register_retreat_template.RegisterRetreatComponentNgFactory
  );
  static final retreatInfo = RouteDefinition(
    routePath: RoutePaths.retreatInfo,
    component: retreat_info_template.RetreatInfoComponentNgFactory
  );
  static final registerMongsanpo = RouteDefinition(
    routePath: RoutePaths.registerMongsanpo,
    component: register_mongsanpo_template.RegisterMongsanpoComponentNgFactory
  );

  static final List<RouteDefinition> all = [search, signup, members, login, registerRetreat, retreatInfo, registerMongsanpo,
    RouteDefinition.redirect(path: '', redirectTo: RoutePaths.login.toUrl()),
    RouteDefinition(path: '.+', component: not_found_template.NotFoundComponentNgFactory)
    ];
}