import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:rockclient_dart/components/retreat/retreat_messages/messages_component.dart';
import 'package:rockclient_dart/components/retreat/retreat_messages/noties_component.dart';
import 'package:rockclient_dart/rock_service.dart';

import '../../../route_paths.dart';

@Component(
  selector: 'retreat-messages-component',
  templateUrl: 'retreat_messages_component.html',
  styleUrls: ['retreat_messages_component.css'],
  directives: [
    coreDirectives,
    materialInputDirectives,
    FixedMaterialTabStripComponent,
    MessagesComponent,
    NotiesComponent,
  ]
)
class RetreatMessagesComponent implements OnActivate {
  final RockService _rockService;
  final Router _router;
  final labels = const <String>[ 'Q&A', '공지' ];
  int tabIndex = 0;

  RetreatMessagesComponent(this._rockService, this._router);

  @override
  void onActivate(RouterState previous, RouterState current) async {
    _rockService.reactToAuth((user) async {if (user == null) {
      await _router.navigate(RoutePaths.login.toUrl());
    }});
  }
}
