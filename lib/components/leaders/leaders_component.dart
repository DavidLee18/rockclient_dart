import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:rockclient_dart/route_paths.dart';
import 'package:skawa_material_components/snackbar/snackbar.dart';
import 'package:skawa_material_components/card/card.dart';

import '../../rock_service.dart';

@Component(
  selector: 'leaders-search-component',
  templateUrl: 'leaders_component.html',
  styleUrls: [
    'package:angular_components/css/mdc_web/card/mdc-card.scss.css',
    'leaders_component.css',
  ],
  providers: [SnackbarService],
  directives: [
    NgFor,
    NgIf,
    MaterialChipsComponent,
    MaterialChipComponent,
    MaterialButtonComponent,
    MaterialDialogComponent,
    MaterialDropdownSelectComponent,
    MaterialFabComponent,
    MaterialIconComponent,
    MaterialPopupComponent,
    MaterialProgressComponent,
    ModalComponent,
    skawaCardDirectives,
    SkawaSnackbarComponent,
  ],
)
class LeadersComponent implements OnActivate, CanDeactivate {
  final RockService _rockService;
  final Router _router;
  final SnackbarService _snackbar;
  Map leaders;
  Map currentLeader;
  var isAdding = false;
  var campusToAdd = "캠퍼스";
  final campuses = [
    "강변", "강북", "강원",
    "남서울", "대학로", "서바다",
    "신촌", "인성경", "인천",
    "천안", "필레오", "해외캠퍼스",
    "예배당", "새내기", "중등부",
  ];
  var error = false;
  var errorMessage = '';
  var isSetting = false;
  var name = '';

  void setLeader(int id) async {
    final res = await _rockService.setLeader(id);
    if(res.item1 != 200) {
        errorMessage = '${res.item1} 에러: ${res.item2}'; error = true;
      }
      else {  }
  }

  void unsetLeader(int id) async {
    try {
      final res = await _rockService.unsetLeader(id);
      if(res.item1 != 200) {
        errorMessage = '${res.item1} 에러: ${res.item2}'; error = true;
      }
    } catch (e) {
      errorMessage = e.toString(); error = true;
    }
  }

  void delCampus(int id, List<dynamic> origins, String campus) async {
    final newCampus = origins.sublist(0)..remove(campus);
    print(newCampus.toString());
    try {
      final res = await _rockService.editCampuses(id, {'names': newCampus});
      if (res.item1 != 200) {
        errorMessage = '${res.item1} 에러: ${res.item2}'; error = true;
      }
    } catch (e) {
      errorMessage = e.toString(); error = true;
    }
  }

  void startToAdd(Map curr) {
    currentLeader = curr;
    isAdding = true;
  }

  void addCampus(int id, List<dynamic> origins, String campus) async {
    if (!isAdding || campus == "캠퍼스") return;
    final news = origins.sublist(0)..add(campus);
    try {
      final res = await _rockService.editCampuses(id, {'name': news});
      if (res.item1 != 200) {
        errorMessage = '${res.item1} 에러: ${res.item2}'; error = true;
      }
    } catch (e) {
      errorMessage = e.toString(); error = true;
    }
    campus = "캠퍼스";
    isAdding = false;
  }

  LeadersComponent(this._rockService, this._router, this._snackbar);

  @override
  void onActivate(RouterState previous, RouterState current) async {
    final res = await _rockService.Leaders;
    if (res.item1 == 200) {
      leaders = res.item2;
    } else {
      errorMessage = '${res.item1} 에러: ${res.item2['data']}'; error = true;
    }
  }

  @override
  Future<bool> canDeactivate(RouterState current, RouterState next) async => next.routePath == RoutePaths.leaders || next.routePath == RoutePaths.retreat ? false : true;
}
