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
    AutoFocusDirective,
    MaterialButtonComponent,
    MaterialDialogComponent,
    ModalComponent,
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
  var error = false;
  var errorText = ''; 

  gotoSignup() async => await _router.navigate('/sign_up');

  logIn() async {
    try {
      final result = await _rockService.signIn(email, password);
      if(result == true) await _router.navigate('/register_retreat');
      else {
        errorText = "Somehow Login failed for an unkwown reason...";
        error = true;
      }
    } catch (e) {
      errorText = e.toString();
      error = true;
    }
  }

  LoginComponent(this._rockService, this._router, this._snackbarService);

  @override
  void onActivate(RouterState previous, RouterState current) {}
}
