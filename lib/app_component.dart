import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'rock_service.dart';
import 'routes.dart';
import 'route_paths.dart';

@Component(
  selector: 'app-component',
  templateUrl: 'app_component.html',
  styleUrls: ['package:angular_components/app_layout/layout.scss.css'],
  directives: [
    coreDirectives,
    routerDirectives,
    DeferredContentDirective,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialListComponent,
    MaterialListItemComponent,
    MaterialTemporaryDrawerComponent,
    MaterialPersistentDrawerDirective,
    ],
  providers: [ClassProvider(RockService), materialProviders],
  exports: [Routes, RoutePaths]
)
class AppComponent {
  final RockService _rockService;
  final Router _router;
  var loggedOn = false;
  var isLeader = false;
  Map myInfo = null;
  void logout() async => await _rockService.signOut();

  AppComponent(this._rockService, this._router) {
    //_router.onRouteActivated.listen(onData)
    _rockService.reactToAuth((user) async {
      if (user != null) {
        loggedOn = true;
        isLeader = await _rockService.IsLeader;
        final res = await _rockService.MyInfo;
        myInfo = res.item1 == 200 ? res.item2 : null;
      } else { loggedOn = false; isLeader = false; myInfo = null; }
    }, onError: (e) { loggedOn = false; isLeader = false; myInfo = null; });
  }
}
