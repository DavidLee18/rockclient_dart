import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:rockclient_dart/rock_service.dart';
import 'package:skawa_material_components/snackbar/snackbar.dart';
import 'package:firebase/firebase.dart' as firebase;

@Component(
  selector: 'login-component',
  templateUrl: 'login_component.html',
  providers: [SnackbarService],
  directives: [
    materialInputDirectives,
    MaterialButtonComponent,
    NgModel,
    SkawaSnackbarComponent,
  ]
)
class LoginComponent implements OnActivate {
  final RockService _rockService;
  final Router _router;
  final SnackbarService _snackbarService;
  var email = '';
  var password = '';

  gotoSignup() async => await _router.navigate('/sign_up');

  logIn() async {
    try {
      await _rockService.signIn(email, password);
      await _router.navigate('/register_retreat');
    } catch (e) {
      _snackbarService.showMessage('login failed: ${e.toString()}');
    }
  }

  LoginComponent(this._rockService, this._router, this._snackbarService);

  @override
  void onActivate(RouterState previous, RouterState current) {}
}
