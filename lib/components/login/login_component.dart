import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:rockclient_dart/rock_service.dart';
import 'package:rockclient_dart/route_paths.dart';
import 'package:skawa_material_components/snackbar/snackbar.dart';
import '../retreat/route_paths.dart' as retreat;

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
  gotoResetPass() async => await _router.navigate(RoutePaths.resetPassword.toUrl());

  logIn() async {
    try {
      final result = await _rockService.signIn(email.trim(), password);
      if(result == true) {
        final leader = await _rockService.IsLeader;
        if(leader) { await _router.navigate(RoutePaths.leaders.toUrl()); }
        else { await _router.navigate(RoutePaths.retreat.toUrl()); }
      } else {
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
