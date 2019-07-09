import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_router/angular_router.dart';
import 'package:skawa_material_components/snackbar/snackbar.dart';

import '../../rock_service.dart';

@Component(
  selector: 'leaders-search-component',
  templateUrl: 'leaders_search_component.html',
  styleUrls: [
    'package:angular_components/css/mdc_web/card/mdc-card.scss.css',
    'leaders_search_component.css',
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
    ModalComponent,
    SkawaSnackbarComponent,
    ],
)
class LeadersSearchComponent implements OnActivate {
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


  void delete(int id) async {
    try {
      await _rockService.delete(id);
    } catch (e) {
      _snackbar.showMessage(e.toString());
    }
  }
  void delCampus(int id, List<dynamic> origins,  String campus) async {
    var newCampus = origins.sublist(0)..remove(campus);
    print(newCampus.toString());
    try {
      await _rockService.edit(id, {'names': newCampus});
    } catch (e) {
      _snackbar.showMessage(e.toString());
    }
  }

  void startToAdd(Map curr) {
    currentLeader = curr;
    isAdding = true;
  }

  void add(int id, List<dynamic> origins, String campus) async {
    if(isAdding) {
      if(campus != "캠퍼스") {
        var news = origins.sublist(0)..add(campus);
        try {
          await _rockService.edit(id, {'name': news});
        } catch (e) {
          _snackbar.showMessage(e.toString());
        }
        campus = "캠퍼스"; isAdding = false;
      }
    }
  }

  void goMembers() async => _router.navigate('/members');

  LeadersSearchComponent(this._rockService, this._router, this._snackbar);

  @override
  void onActivate(RouterState previous, RouterState current) async {
    this.leaders = await _rockService.Leaders;
    /*jsonDecode('''
    {"data":[{"id": 1, "name":"상건","mobile":"01012341234","memberId":3,"campuses":["필레오"]},
         {"id": 2, "name":"진환","mobile":"01012341234","memberId":4,"campuses":["성용"]},
         {"id": 3, "name":"목사님","mobile":"01012341234","memberId":5,"campuses":["성용","천안"]}]}
         ''') as Map;*/
  }
}
