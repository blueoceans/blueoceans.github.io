"use strict"

config_path = "../config.yaml"
config = undefined


angular.module("app", [
  "app.controllers"
  "app.directives"
])

.config([
  "$interpolateProvider"

($interpolateProvider) ->

  $interpolateProvider.startSymbol "[["
  $interpolateProvider.endSymbol "]]"

  return
])


### Controllers ###

angular.module("app.controllers", [])

.controller("jmpress", [
  "$scope"
  "$log"
  "$http"
  "$timeout"

($scope, $log, $http, $timeout) ->
  $http.get(config_path)
  .success (data, _status, headers, _config) ->
    $scope.c = config = jsyaml.load(data)
    $scope.rotate = config.camera.rotate
    unless $scope.$$phase?
      $scope.$apply()
    return
])

### Directives ###

# register the module with Angular
angular.module("app.directives", [
  # require the "app.service" module
])

.directive("jmpress",
->
  ($scope, elm, attrs) ->
    jmpress_init()
    return
)

### Init ###

angular.element(document).ready ->
  angular.bootstrap(document, ["app"])
