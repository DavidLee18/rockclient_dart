import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:rockclient_dart/rock_service.dart';

@Component(
  selector: 'register-mongsanpo-component',
  templateUrl: 'register_mongsanpo_component.html',
  directives: [
    materialInputDirectives,
    AutoFocusDirective,
    MaterialButtonComponent,
    MaterialDialogComponent,
    ModalComponent,
    NgIf,
    NgModel,
  ]
)
class RegisterMongsanpoComponent {
  final RockService _rockService;
  var name = '';
  var mobile = '';
  var belongTo = '';
  var carType = '';
  var carNumber = '';

  var errorMobile = '';

  var registered = false;
  var errorText = '';
  var error = false;

  RegisterMongsanpoComponent(this._rockService);

  bool get Valid => name.length > 0
  && mobile.contains(RegExp(r"^\d{9,11}$"))
  && belongTo.length > 0
  && carType.length > 0
  &&carNumber.length > 0;

  void onMobile(String val) {
    errorMobile = !val.contains(RegExp(r"^\d{9,11}$")) ? "전화번호를 숫자만 입력하세요" : null;
  }

  void register(String name, String mobile, String belongTo, String carType, String carNumber) async {
    try {
      final res = await _rockService.registerMongsanpo(name, mobile, belongTo, '$carType $carNumber');
      registered = res.item1 == 200;
      if(!registered) { errorText = '${res.item1}:${res.item2}'; error = true; }
    } catch (e) { errorText = e.toString(); error = true; }
  }
}
