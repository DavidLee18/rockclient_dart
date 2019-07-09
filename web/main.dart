import 'package:angular/angular.dart';
import 'package:rockclient_dart/app_component.template.dart' as ng;
import 'package:angular_router/angular_router.dart';
import "package:http/http.dart";
import 'package:http/browser_client.dart';
import 'package:angular_router/src/router/router_impl.dart';

import 'main.template.dart' as self;

const useHashLS = false;
const providers = //routerProvidersHash ++ [ClassProvider(Client, useClass: BrowserClient)];
[
  ClassProvider(LocationStrategy, useClass: HashLocationStrategy),
  ClassProvider(PlatformLocation, useClass: BrowserPlatformLocation),
  ClassProvider(Location),
  ClassProvider(Router, useClass: RouterImpl),
  ClassProvider(Client, useClass: BrowserClient),
];
@GenerateInjector(providers)
final InjectorFactory injector = self.injector$Injector;

void main() {
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}
