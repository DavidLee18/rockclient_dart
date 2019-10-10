import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'rock_service.dart';
import 'routes.dart';
import 'route_paths.dart';

@Component(
  selector: 'app-component',
  templateUrl: 'app_component.html',
  styleUrls: ['package:angular_components/app_layout/layout.scss.css'],
  directives: [
    routerDirectives,
    DeferredContentDirective,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialListComponent,
    MaterialListItemComponent,
    MaterialTemporaryDrawerComponent,
    MaterialPersistentDrawerDirective,
    ],
  providers: [ClassProvider(RockService), materialProviders],
  exports: [Routes, RoutePaths]
)
class AppComponent {}
