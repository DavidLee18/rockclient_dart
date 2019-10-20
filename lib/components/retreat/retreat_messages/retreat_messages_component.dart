import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:rockclient_dart/rock_service.dart';
import 'package:rockclient_dart/route_paths.dart';

@Component(
  selector: 'retreat-messages-component',
  templateUrl: 'retreat_messages_component.html',
  styleUrls: ['retreat_messages_component.css'],
  pipes: [commonPipes],
  directives: [
    coreDirectives,
    MaterialButtonComponent,
    MaterialChipsComponent,
    MaterialChipComponent,
    MaterialIconComponent,
    MaterialDialogComponent,
    MaterialProgressComponent,
    ModalComponent,
  ]
)
class RetreatMessagesComponent implements OnActivate {
  final RockService _rockService;
  final Router _router;
  Map<String, dynamic> raw;
  Iterable messages;
  var error = false;
  var errorMessage = '';

  RetreatMessagesComponent(this._rockService, this._router);

  @override
  void onActivate(RouterState previous, RouterState current) async {
    _rockService.reactToAuth((user) async {if (user == null) {
      await _router.navigate(RoutePaths.login.toUrl());
    }});
    _rockService.reactToMessages((qe) {
      raw = qe.snapshot.toJson();
      messages = raw.values.toList().reversed;
    }, onError: (e) { errorMessage = e.toString(); error = true; });
  }
}
