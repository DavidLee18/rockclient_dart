import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
//import 'package:intl/date_symbol_data_http_request.dart';
import 'package:intl/intl.dart';
import 'package:skawa_material_components/snackbar/snackbar.dart';
import 'package:firebase/firebase.dart' as firebase;
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
  var born = '';
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
  var isbaptized = false;
  var email = '';
  var password = '';
  var school = '';
  var major = '';
  var address = '';
  var guide = '';
  var passAgain = '';

  var errorMobile = '';
  var errorPass = '';
  var errorValid = '';
  var errorBorn = '';

  SignUpComponent(this._rockService, this._router, this._snackbarService);

  goback() async => await _router.navigate("/");
  goRegisterRetreat() async {
    if(firebase.apps.length == 0) {
      firebase.initializeApp(
        apiKey: "AIzaSyBkhrchnoMwgz67nJGi3qETa6EgG1xXjM0",
        authDomain: "cba-retreat.firebaseapp.com",
        databaseURL: "https://cba-retreat.firebaseio.com",
        projectId: "cba-retreat",
        storageBucket: "cba-retreat.appspot.com",
        messagingSenderId: "1069252633339"
      );
    }
    firebase.auth().signInWithEmailAndPassword(email, password);
    _rockService.uid = firebase.auth().currentUser.uid;
    await _router.navigate('/register_retreat');
  }

  void signUp(
    String email,
    String password,
    String name,
    String mobile,
    String date,
    String sex,
    String campus) async {
      final year = date.substring(0, 3);
      final month = date.substring(3, 5);
      final day = date.substring(5, 7);
      try {
        final res = await _rockService.signUp(email, password, name, mobile, '$year-$month-$day', sex, campus, address, school, major, grade, guide);
        _snackbarService.showMessage(res);
        signUpSuccess = true;
      } catch (e) {
      }
  }

  onMobile(String val) {
    errorMobile = !val.contains(RegExp(r"^\d{9,11}$")) ? "전화번호를 숫자만 입력하세요" : null;
  }

  onPass(String val) {
    errorPass = val.length < 6 ? "비밀번호는 6자 이상이어야 합니다" : null;
  }

  onValidate(String val) {
    errorValid = val != password ? "비밀번호가 일치하지 않습니다" : null;
  }

  onDate(dynamic val) {
    errorBorn = val.length != 8 ? "생년월일을 입력하새요 cf) 19960101" : null;
  }

  bool get isValid => name.length > 0
  && mobile.length > 0
  && school.length > 0
  && major.length > 0
  && email.length > 0
  && password.length > 5
  && address.length > 0
  && born.length > 0
  && campus != "캠퍼스"
  && grade != "학년";

  @override
  void onActivate(RouterState previous, RouterState current) {
    form = Control('', (c) => {});
  }
}
