//= require angular
//= require angular-ui-bootstrap
//= require angular-ui-router
//= require ./sharedServices
//= require_tree ./shared
//= require_tree ./homepage

app = angular.module("HomePage", ["ui.bootstrap", "ui.router", "Router", "Profile", "Sidebar"])
