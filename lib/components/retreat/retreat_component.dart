import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:rockclient_dart/rock_service.dart';
import 'route_paths.dart';
import 'routes.dart';

@Component(
  selector: 'retreat-component',
  templateUrl: 'retreat_component.html',
  directives: [MaterialButtonComponent, coreDirectives, RouterOutlet],
  exports: [Routes, RoutePaths],
)
class RetreatComponent extends OnActivate {
  final Router _router;
  final RockService _rockService;
  String messages;

  RetreatComponent(this._router, this._rockService);

  void gotoRegister() async => await _router.navigate(RoutePaths.registerRetreat.toUrl());

  @override
  void onActivate(RouterState previous, RouterState current) async {
    _rockService.Messages.listen((e) { messages = e; });
  }
}
