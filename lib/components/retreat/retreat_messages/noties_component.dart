import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:rockclient_dart/rock_service.dart';
import 'package:skawa_components/skawa_components.dart';

@Component(
  selector: 'noties',
  templateUrl: 'noties_component.html',
  styleUrls: ['noties_component.css'],
  pipes: [commonPipes],
  directives: [
    coreDirectives,
    materialInputDirectives,
    MaterialButtonComponent,
    MaterialDialogComponent,
    MaterialFabComponent,
    MaterialIconComponent,
    MaterialProgressComponent,
    ModalComponent,
    SkawaInfobarComponent,
  ],
)
class NotiesComponent implements OnInit, OnDestroy {
  final RockService _rockService;
  var notify = false, isAdmin = true, sending = false, error = false;
  String get notiIcon => notify ? 'notifications_active' : 'notifications_off';
  var toSend = '', errorMessage = ''; Iterable noties = null;
  StreamSubscription _subscription;

  NotiesComponent(this._rockService);

  void send() {
    _rockService.saveMessage(toSend, isNoti: true);
    if(notify) { _rockService.notify(toSend, isNoti: true); }
    sending = false; toSend = '';
  }

  @override
  void ngOnDestroy() {
    _subscription.cancel();
  }

  @override
  void ngOnInit() {
    _subscription = _rockService.reactToNoties((val) {
      noties = (val.snapshot.toJson() as Map)?.values;
    }, onError: (e) { errorMessage = 'Noties None or Failed: ${e.message}'; error = true; });
  }
}
