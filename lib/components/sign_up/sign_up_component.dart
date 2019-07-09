import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
//import 'package:intl/date_symbol_data_http_request.dart';
import 'package:intl/intl.dart';
import 'package:skawa_material_components/snackbar/snackbar.dart';
import '../../rock_service.dart';

@Component(
  selector: 'sign-up-component',
  templateUrl: 'sign_up_component.html',
  styleUrls: ['sign_up_component.css'],
  providers: [SnackbarService],
  directives: [
    materialInputDirectives,
    formDirectives,
    MaterialDropdownSelectComponent,
    MaterialRadioComponent,
    MaterialRadioGroupComponent,
    MaterialDatepickerComponent,
    MaterialCheckboxComponent,
    MaterialButtonComponent,
    SkawaSnackbarComponent,
    NgFor,
    NgIf,
    NgModel,
  ],
)
class SignUpComponent implements OnActivate {
  final RockService _rockService;
  final Router _router;
  final SnackbarService _snackbarService;
  Control form;
  var name = '';
  var mobile = '';
  var ismale = true;
  var signUpSuccess = false;
  var born = Date.today();
  final min = Date(1950);
  final dateform = DateFormat('yyyy-MM-dd');
  var campus = "캠퍼스";
  final campuses = [
    "강변", "강북", "강원",
    "남서울", "대학로", "서바다",
    "신촌", "인성경", "인천",
    "천안", "필레오", "해외캠퍼스",
    "예배당", "새내기", "중등부",
  ];
  var grade = "학년";
  final grades = [
    "1학년", "2학년", "3학년",
    "4학년", "대학원", "졸업생",
  ];
  var lecture = "단계별 강의";
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
  var retreat_gbs_type = "조원구분";
  final retreat_gbs_types = ["조원", "부조장", "조장", "봉사자"];
  var isbaptized = false;
  var email = '';
  var password = '';
  var school = '';
  var major = '';
  var address = '';
  var guide = '';

  SignUpComponent(this._rockService, this._router, this._snackbarService);

  goback() async => _router.navigate("/");

  void signUp(
    String email,
    String password,
    String name,
    String mobile,
    String date,
    String sex,
    String campus) async {
    final res = await _rockService.signUp(email, password, name, mobile, date, sex, campus, address, school, major, grade, guide);

    //_snackbarService.showMessage(res);
  }

  @override
  void onActivate(RouterState previous, RouterState current) {
    form = Control('', (c) => {});
    /*initializeDateFormatting('ko_KR', null).then(
      (_) => this.dateform = DateFormat('yyyy-MM-dd', 'ko-kr'));*/
  }
}
