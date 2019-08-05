import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:rockclient_dart/rock_service.dart';
import 'package:skawa_material_components/snackbar/snackbar.dart';

@Component(
  selector: 'reset-password-component',
  templateUrl: 'reset_password_component.html',
  providers: [SnackbarService],
  directives: [
    materialInputDirectives,
    MaterialButtonComponent,
    NgIf,
    SkawaSnackbarComponent,
  ]
)
class ResetPasswordComponent {
  final RockService _rockService;
  final SnackbarService _snackbarService;
  var succeeded = false;
  var email = '';
  bool get Valid => email != '';

  onClick() async {
    try {
      final res = await _rockService.resetPass(email.trim());
      succeeded = true;
    } catch (e) {
      _snackbarService.showMessage(e.toString());
    }
  }

  ResetPasswordComponent(this._rockService, this._snackbarService);
}
