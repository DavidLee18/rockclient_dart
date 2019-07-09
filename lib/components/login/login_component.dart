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
      await firebase.auth().signInWithEmailAndPassword(email, password);
      _rockService.uid = firebase.auth().currentUser.uid;
      await _router.navigate('/retreat_info');
    } catch (e) {
      _snackbarService.showMessage('login failed...');
    }
  }

  LoginComponent(this._rockService, this._router, this._snackbarService);

  @override
  void onActivate(RouterState previous, RouterState current) {
    if(firebase.apps.length == 0)
    firebase.initializeApp(
      apiKey: "AIzaSyBkhrchnoMwgz67nJGi3qETa6EgG1xXjM0",
      authDomain: "cba-retreat.firebaseapp.com",
      databaseURL: "https://cba-retreat.firebaseio.com",
      projectId: "cba-retreat",
      storageBucket: "cba-retreat.appspot.com",
      messagingSenderId: "1069252633339"
    );
    firebase.auth().onAuthStateChanged.listen((user) async {
      if(user?.uid != null) _snackbarService.showMessage('login succeeded: ${user.uid}');
      });
  }
}
