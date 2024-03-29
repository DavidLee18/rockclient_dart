import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:rockclient_dart/rock_service.dart';
import 'package:rockclient_dart/route_paths.dart';
import 'package:tuple/tuple.dart';
import 'package:skawa_components/infobar/infobar.dart';

import '../route_paths.dart' as local;

@Component(
  selector: 'register-retreat-component',
  templateUrl: 'register_retreat_component.html',
  directives: [
    materialInputDirectives,
    AutoFocusDirective,
    MaterialDropdownSelectComponent,
    MaterialButtonComponent,
    MaterialDialogComponent,
    ModalComponent,
    NgModel,
    NgIf,
    SkawaInfobarComponent,
  ]
)
class RegisterRetreatComponent implements OnActivate/*, CanDeactivate*/ {
  final RockService _rockService;
  final Router _router;
  var lecture = null;
  final lectures = [
    "성락교회 캠퍼스 베뢰아의 사명",
    "성장 그리고 사명",
    "베뢰아 운동의 동역자",
    "베뢰아인의 삶과 세상에서의 우리",
  ];
  var retreat_gbs = "수련회 단계";
  final retreat_gbses = [
    "A", "새내기", "C", "D",
    "E", "F", "J",
    "OJ", "EN", "자모GBS",
    "STAFF",
  ];
  var position = "조원구분";
  final positions = ["조원", "부조장", "조장", "봉사자"];
  var gbs = "기존 GBS 단계";
  final gbses = [
    "칼리지베이직", "마태칼리지", "마가칼리지",
    "누가칼리지", "요한칼리지", "바울칼리지",
    "칼리지플러스", "새친구", "예비교사",
    "없음",
  ];
  var registered = false;
  var already = false;
  Tuple2<int, Map> _info;

  var error = false;
  var errorText = '';

  RegisterRetreatComponent(this._rockService, this._router);

  go() async {
    try {
      final res = already ? await _rockService.editRetreat(retreat_gbs, position) : await _rockService.registerRetreat(lecture, gbs, retreat_gbs, position);
      registered = res.item1 == 200;
      if(!registered) { errorText = '${res.item1}: ${res.item2}'; error = true; }
    } catch (e) { errorText = e.toString(); error = true; }
  }

  get Valid => retreat_gbs != "수련회 단계"
  && position != "조원구분"
  && gbs != "기존 GBS 단계";

  @override
  void onActivate(RouterState previous, RouterState current) async {
    try {
      _info = await _rockService.MyInfo;
      this.already = await _rockService.RetreatRegistered;
      if(already) {
        position = _info.item2['position'];
        retreat_gbs = _info.item2['retreatGbs'];
        gbs = _info.item2['originalGbs'];
      }
    } on ArgumentError catch (e) {
      if(e.name == 'uid') await _router.navigate('/login');
    }
    catch (e) { errorText = e.toString(); error = true; }
  }

  //@override
  Future<bool> canDeactivate(RouterState current, RouterState next) async {
    if(next.routePath == RoutePaths.leaders || next.routePath == local.RoutePaths.registerRetreat || next.routePath == RoutePaths.retreat) return true;
    else return false;
  }
}
