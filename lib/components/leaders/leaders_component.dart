import 'dart:convert';

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
    MaterialExpansionPanel,
    MaterialExpansionPanelSet,
    MaterialFabComponent,
    MaterialIconComponent,
    MaterialInputComponent,
    MaterialPopupComponent,
    MaterialProgressComponent,
    ModalComponent,
    skawaCardDirectives,
    SkawaSnackbarComponent,
  ],
)
class LeadersComponent implements OnActivate {
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
  List members = List();
  var searching = false;

  void loadLeaders() async {
    leaders = null; name = ''; isAdding = false; currentLeader = null;
    final res = await _rockService.Leaders;
    if (res.item1 == 200) {
      leaders = res.item2;
    } else {
      errorMessage = '${res.item1} 에러: ${res.item2['data']}'; error = true;
    }
  }

  void searchMember(String name) async {
    searching = true;
    final res = await _rockService.members(name);
    if (res.item1 != 200) {
      errorMessage = '${res.item1} 에러: ${res.item2['data']}'; error = true;
    } else {
      members = res.item2;
    } searching = false;
  }

  void setLeader(int id) async {
    final res = await _rockService.setLeader(id);
    if(res.item1 != 200) {
        errorMessage = '${res.item1} 에러: ${res.item2}'; error = true;
      }
      else { isSetting = false; _snackbar.showMessage('리더 등록 성공'); loadLeaders(); }
  }

  void unsetLeader(int id) async {
    try {
      final res = await _rockService.unsetLeader(id);
      if(res.item1 != 200) {
        errorMessage = '${res.item1} 에러: ${res.item2}'; error = true;
      } else { _snackbar.showMessage('리더가 삭제되었습니다.'); loadLeaders(); }
    } catch (e) {
      errorMessage = e.toString(); error = true;
    }
  }

  void delCampus(int id, List<dynamic> origins, String campus) async {
    final newCampus = origins.sublist(0)..remove(campus);
    try {
      final res = await _rockService.editCampuses(id, {'names': newCampus});
      if (res.item1 != 200) {
        errorMessage = '${res.item1} 에러: ${res.item2}'; error = true;
      } else { _snackbar.showMessage('캠퍼스 $campus를 지웠습니다.'); loadLeaders(); }
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
      final res = await _rockService.editCampuses(id, {'names': news});
      if (res.item1 != 200) {
        errorMessage = '${res.item1} 에러: ${res.item2}'; error = true;
      } else { _snackbar.showMessage('캠퍼스 $campus를 추가했습니다.'); loadLeaders(); }
    } catch (e) {
      errorMessage = e.toString(); error = true;
    } finally {
      campus = "캠퍼스";
      isAdding = false;
    }
  }

  LeadersComponent(this._rockService, this._router, this._snackbar);

  @override
  void onActivate(RouterState previous, RouterState current) async {
    /*try {
      final load = await _rockService.isLeader();
      print(load);
      if (!load) {
        await _router.navigate(RoutePaths.login.path);
      }
    } on ArgumentError catch (e) {
      if (e.name == 'uid') {
        await _router.navigate(RoutePaths.login.path);
      }
    }*/
    loadLeaders();
  }
}
