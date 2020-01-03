import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:rockclient_dart/rock_service.dart';
import 'package:rockclient_dart/route_paths.dart';
import 'dart:collection';

@Component(
  selector: 'retreat-messages-component',
  templateUrl: 'retreat_messages_component.html',
  styleUrls: ['retreat_messages_component.css'],
  pipes: [commonPipes],
  directives: [
    coreDirectives,
    MaterialButtonComponent,
    MaterialCheckboxComponent,
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
  Iterable _messages;
  Iterable get messages => showMessages ? _messages : null;
  Iterable _noties;
  Iterable get noties => showNoties ? _noties : null;
  var error = false;
  var errorMessage = '';
  var showMessages = true;
  var showNoties = true;
  Iterable get sums => messages?.followedBy(noties) ?? noties?.followedBy(messages);

  RetreatMessagesComponent(this._rockService, this._router);

  @override
  void onActivate(RouterState previous, RouterState current) async {
    _rockService.reactToAuth((user) async {if (user == null) {
      await _router.navigate(RoutePaths.login.toUrl());
    }});
    _rockService.reactToMessages((qe) {
      if (showMessages) {
        raw = qe.snapshot.toJson();
        _messages = raw.values.toList().reversed;
      } else { _messages = null; }
    }, onError: (e) { errorMessage = e.toString(); error = true; });
    _rockService.reactToNoties((qe) {
      if (showNoties) {
        raw = qe.snapshot.toJson();
        _noties = raw.values.toList().reversed;
      } else { _noties = null; }
    }, onError: (e) { errorMessage = e.toString(); error = true; });
  }
}
