import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:rockclient_dart/rock_service.dart';
import 'package:skawa_components/skawa_components.dart';
import 'package:firebase/firebase.dart' as firebase;

@Component(
  selector: 'messages',
  templateUrl: 'messages_component.html',
  styleUrls: ['messages_component.css'],
  directives: [
    coreDirectives,
    materialInputDirectives,
    MaterialButtonComponent,
    MaterialChipComponent,
    MaterialChipsComponent,
    MaterialDialogComponent,
    MaterialFabComponent,
    MaterialIconComponent,
    MaterialProgressComponent,
    MaterialTooltipDirective,
    ModalComponent,
    SkawaInfobarComponent,
  ],
  pipes: [commonPipes],
)
class MessagesComponent implements OnInit, OnDestroy {
  final RockService _rockService;
  var isAdmin = true, _sending = false, notify = false, _error = false;
  bool get error => _error;
  bool get isEmpty => messages == null || messages.isEmpty;
  bool get sending => _sending;
  set sending(bool b) { _sending = b; if(b == false) { toSend = ''; _replyTo = ''; } }
  var toSend = '', _errorMessage = '', _replyTo = '';
  set replyTo(String s) { _replyTo = s; sending = true; }
  get replyTo => _replyTo;
  get errorMessage => _errorMessage;
  set errorMessage(String m) { if (m.isEmpty || m == '') { _error = false; } else { _errorMessage = m; _error = true; } }
  String get notiIcon => notify ? 'notifications_active' : 'notifications_off';
  Iterable messages = [];
  Map raw;
  StreamSubscription<firebase.QueryEvent> _subscription;

  MessagesComponent(this._rockService);

  void send() {
    _rockService.saveMessage(toSend, author: _replyTo.isEmpty ? 'CBA 본부' : '$_replyTo 답장');
    if (notify) { _rockService.notify(toSend); }
    sending = false;
  }

  @override
  void ngOnDestroy() {
    _subscription.cancel();
  }

  @override
  void ngOnInit() {
    _subscription = _rockService.reactToMessages((val) {
      try {
        raw = val.snapshot.val();
        messages = raw.values;
      } catch (e) {
        raw = null; messages = null;
        errorMessage = '';
      }
    }, onError: (e) { errorMessage = 'Message None or Failed: ${e.message}'; });
  }
}
