import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:rockclient_dart/rock_service.dart';

@Component(
  selector: 'register-retreat-component',
  templateUrl: 'register_retreat_component.html',
  directives: [
    materialInputDirectives,
    MaterialDropdownSelectComponent,
    MaterialButtonComponent,
    NgModel,
    NgIf,
  ]
)
class RegisterRetreatComponent implements OnActivate {
  final RockService _rockService;
  var lecture = null;
  final lectures = [
    "성락교회 캠퍼스 베뢰아의 사명",
    "성장 그리고 사명",
    "베뢰아 운동의 동역자",
    "베뢰아인의 삶과 세상에서의 우리",
  ];
  var retreat_gbs = "수련회 단계";
  final retreat_gbses = [
    "A", "새내기", "C",
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
    "칼리지플러스", "없음",
  ];
  var registered = false;
  var already = false;
  Map _info;

  RegisterRetreatComponent(this._rockService);

  register(lecture, weeklyGbs, retreatGbs, position) async {
    await _rockService.registerRetreat(lecture, weeklyGbs, retreatGbs, position);
    registered = true;
    await _rockService.signOut();
  }

  @override
  void onActivate(RouterState previous, RouterState current) async {
    _info = await _rockService.MyInfo;
    this.already = _info['retreat_id'] != null
    && _info['gbsLevel'] != null
    && _info['position'] != null;
    if(already) {
      position = _info['position'];
    }
  }
}
