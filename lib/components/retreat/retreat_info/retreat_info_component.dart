import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:rockclient_dart/rock_service.dart';
import 'package:rockclient_dart/route_paths.dart';
import '../route_paths.dart' as retreat;

@Component(
  selector: 'retreat-info-component',
  templateUrl: 'retreat_info_component.html',
  directives: [
    coreDirectives,
    MaterialButtonComponent,
    MaterialProgressComponent,
    ],
)
class RetreatInfoComponent implements OnActivate {
  final RockService _rockService;
  final Router _router;
  Map info;
  get already => _rockService.isRegistered(info);

  RetreatInfoComponent(this._rockService, this._router);

  void registerOrEdit() async => await _router.navigateByUrl(retreat.RoutePaths.registerRetreat.toUrl());

  @override
  void onActivate(RouterState previous, RouterState current) async {
    try {
      final res = await _rockService.MyInfo;
      if (res.item1 == 200) {
        this.info = res.item2;
      }
    } on ArgumentError catch (e) {
      if (e.name == 'uid') {
        await _router.navigate(RoutePaths.login.toUrl());
      }
    }
  }
}
