import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'rock_service.dart';
import 'routes.dart';
import 'route_paths.dart';
import './components/retreat/route_paths.dart' as retreat;

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
  var title = '';
  void logout() async => await _rockService.signOut();

  AppComponent(this._rockService, this._router) {
    _router.onNavigationStart.listen((path) async {
      title = path == RoutePaths.login.toUrl() ? '로그인' :
      path == RoutePaths.signUp.toUrl() ? '회원가입' :
      path == RoutePaths.registerMongsanpo.toUrl() ? '몽산포 수련회 등록' :
      path == RoutePaths.resetPassword.toUrl() ? '비밀번호 재설정' :
      path == RoutePaths.leaders.toUrl() ? '리더 관리' :
      path == retreat.RoutePaths.home.toUrl() ? '내 정보' :
      path == retreat.RoutePaths.registerRetreat.toUrl() ? '수련회 등록/수정' :
      'CBA';
    }, onError: (e) { title = 'CBA'; });
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
