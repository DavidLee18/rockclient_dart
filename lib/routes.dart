import 'package:angular_router/angular_router.dart';

import 'components/leaders/leaders_component.template.dart' as leaders_template;
import 'components/sign_up/sign_up_component.template.dart' as sign_up_template;
import 'components/login/login_component.template.dart' as login_template;
import 'components/retreat/retreat_component.template.dart' as retreat_template;
import 'components/register_retreat/register_retreat_component.template.dart' as register_retreat_template;
import 'components/register_monsanpo/register_mongsanpo_component.template.dart' as register_mongsanpo_template;
import 'components/not_found/not_found_component.template.dart' as not_found_template;
import 'components/reset_password/reset_password_component.template.dart' as reset_pass_template;

import 'route_paths.dart';


class Routes {
  static final leaders = RouteDefinition(
    routePath: RoutePaths.leaders,
    component: leaders_template.LeadersComponentNgFactory
  );
  static final signup = RouteDefinition(
    routePath: RoutePaths.signUp,
    component: sign_up_template.SignUpComponentNgFactory
  );
  static final login = RouteDefinition(
    routePath: RoutePaths.login,
    component: login_template.LoginComponentNgFactory
  );
  static final retreat = RouteDefinition(
    routePath: RoutePaths.retreat,
    component: retreat_template.RetreatComponentNgFactory
  );
  static final registerRetreat = RouteDefinition(
    routePath: RoutePaths.registerRetreat,
    component: register_retreat_template.RegisterRetreatComponentNgFactory
  );
  static final registerMongsanpo = RouteDefinition(
    routePath: RoutePaths.registerMongsanpo,
    component: register_mongsanpo_template.RegisterMongsanpoComponentNgFactory
  );
  static final resetPassword = RouteDefinition(
    routePath: RoutePaths.resetPassword,
    component: reset_pass_template.ResetPasswordComponentNgFactory
  );

  static final List<RouteDefinition> all = [leaders, signup, login, retreat, registerRetreat, registerMongsanpo, resetPassword,
    RouteDefinition.redirect(path: '', redirectTo: RoutePaths.login.toUrl()),
    RouteDefinition(path: '.+', component: not_found_template.NotFoundComponentNgFactory)
    ];
}