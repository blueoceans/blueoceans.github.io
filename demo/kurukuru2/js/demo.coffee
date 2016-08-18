"use strict"

config_path = "./config.yaml"
config = undefined

camera = undefined
scene = undefined
renderer = undefined
controls = undefined
objects = undefined
projector = undefined
targets =
  table: []
  sphere: []
  helix: []
  grid: []

init = (config) ->
  space = config.object.space or 20
  config.object.distance = config.item.length * (config.object.width + space) / (2 * Math.PI)
  config.camera._distance = config.object.distance + config.camera.distance
  camera = new THREE.PerspectiveCamera(40, window.innerWidth / window.innerHeight, 1, 10000)
  camera.position.set(
    0
    config.camera.height
    config.camera._distance
  )
  scene = new THREE.Scene()

  range = config.object.distance
  variability_x = config.object.variability.x
  variability_y = config.object.variability.y
  variability_z = config.object.variability.z
  for object in objects
    vector = 2 * Math.PI * Math.random()
    object.position.x = Math.sin(vector) * range * variability_x
    object.position.y = Math.sin(2 * Math.PI * Math.random()) * range * variability_y
    object.position.z = Math.cos(vector) * range * variability_z
    scene.add object

    #
    object = new THREE.Object3D()
    targets.table.push object

  # helix
  unless targets.helix.length > 0
    for _ in [0..objects.length]
      object = new THREE.Object3D()
      targets.helix.push object
  phi0 = 2 * Math.PI / config.item.length
  vector = new THREE.Vector3()
  for object, index in targets.helix
    phi = index * phi0
    object.position.x = config.object.distance * Math.sin(phi)
    object.position.y = 0
    object.position.z = config.object.distance * Math.cos(phi)
    vector.x = object.position.x * 2
    vector.y = object.position.y
    vector.z = object.position.z * 2
    object.lookAt vector

  #
  renderer = new THREE.CSS3DRenderer()
  renderer.setSize window.innerWidth, window.innerHeight
  renderer.domElement.style.position = "absolute"
  document.getElementById("container").appendChild renderer.domElement

  #
  controls = new THREE.TrackballControls(camera, renderer.domElement)
  controls.rotateSpeed = config.controls.rotateSpeed or 0.05
  controls.minDistance = config.object.distance
  controls.maxDistance = config.object.distance * 12
  controls.addEventListener "change", render
  transform targets.helix, 5000

  #
  window.addEventListener "resize", onWindowResize, false

  return

transform = (targets, duration) ->
  TWEEN.removeAll()
  vector = new THREE.Vector3()
  for object, index in objects
    target = targets[index]
    vector.x = 0
    vector.y = 0
    vector.z = 10000
    object.lookAt vector
    new TWEEN.Tween(object.position).to(
      x: target.position.x
      y: target.position.y
      z: target.position.z
    , Math.random() * duration + duration).easing(TWEEN.Easing.Exponential.InOut).start()
    new TWEEN.Tween(object.rotation).to(
      x: target.rotation.x
      y: target.rotation.y
      z: target.rotation.z
    , Math.random() * duration + duration).easing(TWEEN.Easing.Exponential.InOut).start()
  new TWEEN.Tween(this).to({}, duration * 2).onUpdate(render)
  .onComplete ->
    return
  .start()
  return

onWindowResize = ->
  camera.aspect = window.innerWidth / window.innerHeight
  camera.updateProjectionMatrix()
  renderer.setSize window.innerWidth, window.innerHeight
  render()
  return

animate = ->
  requestAnimationFrame animate
  TWEEN.update()
  controls.update()
  return

render = ->
  renderer.render scene, camera
  return


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

.controller("Ctrl", [
  "$scope"
  "$location"
  "$log"
  "$http"
  "$timeout"
  "$window"

($scope, $location, $log, $http, $timeout, $window) ->
  img_loaded = 0
  $http.get(config_path)
  .success (data, _status, headers, _config) ->
    $scope.c = config = jsyaml.load(data)
    $scope.rotate = config.camera.rotate
    unless $scope.$$phase?
      $scope.$apply()
    mask_img = angular.element("#mask-img")[0]
    mask_img.onload = ->
      fade_reflect()
      width = $scope.c.object.width
      height = $scope.c.object.reflect or $scope.c.object.height
      angular.forEach angular.element(".element-canvas"), (canvas) ->
        canvas.width = width
        canvas.height = height
        canvas.style.width = "#{width}px"
        canvas.style.height = "#{height}px"
        img = canvas.parentNode.previousElementSibling
        img.onload = ->
          context = canvas.getContext("2d")
          context.clearRect(0, 0, img.width, img.height)
          context.drawImage(img, 0, 0, img.width, img.height)
          context.globalCompositeOperation = "xor"
          context.drawImage(mask_img, 0, 0, img.width, img.height)
          img_loaded += 1
          if img_loaded >= $scope.c.item.length
            addReflections()
          return
        return
      hide_reflect()
      return
    $timeout () ->
      objects = for element in angular.element(".element")
        new THREE.CSS3DObject(element)
      $scope.reset()
      animate()
      rotation()
      return
    , 200
    return

  hide_reflect = ->
    reflect = angular.element(".element-canvas canvas:not(.reflected)")
    if reflect.length > 0
      $(reflect).addClass("ng-hide")
    else
      $timeout fade_reflect, 200
    return

  fade_reflect = ->
    reflect = angular.element(".element-canvas canvas:not(.reflected)")
    if reflect.length > 0
      for canvas in reflect
        canvas.style.opacity = 0
        new TWEEN.Tween(canvas.style).to(
          opacity: 1
        , 2000)
        .delay(3000)
        .easing(TWEEN.Easing.Quadratic.In)
        .start()
      $(reflect).removeClass("ng-hide")
    else
      $timeout fade_reflect, 200
    return

  omega = 0
  $scope.reset = () ->
    omega = 0
    $scope.rotate = config.camera.rotate
    hide_reflect()
    init($scope.c)
    fade_reflect()
    renderer.domElement.addEventListener "click", ((evt) ->
      element = evt.toElement
      unless element.className in ["element-img", "element-canvas"]
        return
      next = Number(element.getAttribute("data-nth"))
      url = $scope.c.item[next]?[1]
      length = $scope.c.item.length
      current = Math.floor(length * omega / ( 2 * Math.PI ))
      if Math.abs(next - current) > length / 2
        next += length * if (next - current) < 0 then 1 else -1
      rotate_to next
      if url
        $timeout ->
          $window.open url
          return
        , $scope.c.efect.time + 100
      return
    ), false
    return

  $scope.zoom = (magnification) ->
    new TWEEN.Tween($scope.c.camera).to(
      _distance: $scope.c.camera._distance * magnification
    , $scope.c.efect.time)
    .easing(TWEEN.Easing.Linear.None)
    .onUpdate () ->
      camera.position.x = Math.sin( omega ) * $scope.c.camera._distance
      camera.position.z = Math.cos( omega ) * $scope.c.camera._distance
      return
    .onComplete ->
      unless $scope.mouseup
        $scope.zoom magnification
      return
    .start()
    return

  rotation = () ->
    #if $scope.rotate
    #  omega = Date.now() * 0.001 * $scope.c.camera.frequency
    #camera.position.x = Math.sin( omega ) * $scope.c.camera._distance
    #camera.position.z = Math.cos( omega ) * $scope.c.camera._distance
    camera.lookAt( scene.position )
    $timeout rotation, 40 #1000/25
    return

  $scope.rotate_next = (direction) ->
    left = if $scope.rotate then 0 else -1
    length = $scope.c.item.length
    current = length * omega / ( 2 * Math.PI )
    next = Math.round(current) + if direction is "left" then left else 1
    rotate_to next, direction
    return

  rotate_to = (next, direction) ->
    height = $scope.c.object.height or 200
    unless camera.position.y % (height / 2) is 0
      controls.reset()
    if $scope.rotate
      $scope.rotate = false

    length = $scope.c.item.length
    current = Math.floor(length * omega / ( 2 * Math.PI ))
    if Math.abs(next - current) > length / 2
      next += length * if (next - current) < 0 then 1 else -1
    new TWEEN.Tween({omega: omega}).to(
      omega: 2 * Math.PI / length * next
    , $scope.c.efect.time)
    .easing(TWEEN.Easing.Linear.None)
    .onUpdate () ->
      omega = @omega
      camera.position.x = Math.sin( omega ) * $scope.c.camera._distance
      camera.position.z = Math.cos( omega ) * $scope.c.camera._distance
      return
    .onComplete ->
      unless $scope.mouseup
        $timeout ->
          $scope.rotate_next direction
          return
        , 40
      return
    .start()
    return

  $scope.up = (range) ->
    unless range
      range = ($scope.c.object.height or 200) / 2
    new TWEEN.Tween(camera.position).to(
      y: camera.position.y + range
    , $scope.c.efect.time)
    .easing(TWEEN.Easing.Linear.None)
    .onComplete ->
      unless $scope.mouseup
        $scope.up range
      return
    .start()
    return

  $scope.down = () ->
    $scope.up(($scope.c.object.height or 200) / -2)
    return

  return
])

.controller("jmpress", [
  "$scope"
  "$location"
  "$log"
  "$http"
  "$timeout"
  "$window"

($scope, $location, $log, $http, $timeout, $window) ->
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
