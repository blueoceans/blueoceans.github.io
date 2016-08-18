init = ->
  camera = new THREE.PerspectiveCamera(40, window.innerWidth / window.innerHeight, 1, 10000)
  camera.position.z = 3000
  scene = new THREE.Scene()
  
  # table
  i = 0

  while i < table.length
    element = document.createElement("div")
    element.className = "element"
    element.style.backgroundColor = "rgba(0,127,127," + (Math.random() * 0.5 + 0.25) + ")"
    number = document.createElement("div")
    number.className = "number"
    number.textContent = i + 1
    element.appendChild number
    symbol = document.createElement("div")
    symbol.className = "symbol"
    symbol.textContent = table[i]
    element.appendChild symbol
    details = document.createElement("div")
    details.className = "details"
    details.innerHTML = table[i + 1] + "<br>" + table[i + 2]
    element.appendChild details
    object = new THREE.CSS3DObject(element)
    object.position.x = Math.random() * 4000 - 2000
    object.position.y = Math.random() * 4000 - 2000
    object.position.z = Math.random() * 4000 - 2000
    scene.add object
    objects.push object
    
    #
    object = new THREE.Object3D()
    object.position.x = (table[i + 3] * 140) - 1330
    object.position.y = -(table[i + 4] * 180) + 990
    targets.table.push object
    i += 5
  
  # sphere
  vector = new THREE.Vector3()
  i = 0
  l = objects.length

  while i < l
    phi = Math.acos(-1 + (2 * i) / l)
    theta = Math.sqrt(l * Math.PI) * phi
    object = new THREE.Object3D()
    object.position.x = 800 * Math.cos(theta) * Math.sin(phi)
    object.position.y = 800 * Math.sin(theta) * Math.sin(phi)
    object.position.z = 800 * Math.cos(phi)
    vector.copy(object.position).multiplyScalar 2
    object.lookAt vector
    targets.sphere.push object
    i++
  
  # helix
  vector = new THREE.Vector3()
  i = 0
  l = objects.length

  while i < l
    phi = i * 0.175 + Math.PI
    object = new THREE.Object3D()
    object.position.x = 900 * Math.sin(phi)
    object.position.y = -(i * 8) + 450
    object.position.z = 900 * Math.cos(phi)
    vector.x = object.position.x * 2
    vector.y = object.position.y
    vector.z = object.position.z * 2
    object.lookAt vector
    targets.helix.push object
    i++
  
  # grid
  i = 0

  while i < objects.length
    object = new THREE.Object3D()
    object.position.x = ((i % 5) * 400) - 800
    object.position.y = (-(Math.floor(i / 5) % 5) * 400) + 800
    object.position.z = (Math.floor(i / 25)) * 1000 - 2000
    targets.grid.push object
    i++
  
  #
  renderer = new THREE.CSS3DRenderer()
  renderer.setSize window.innerWidth, window.innerHeight
  renderer.domElement.style.position = "absolute"
  document.getElementById("container").appendChild renderer.domElement
  
  #
  controls = new THREE.TrackballControls(camera, renderer.domElement)
  controls.rotateSpeed = 0.5
  controls.minDistance = 500
  controls.maxDistance = 6000
  controls.addEventListener "change", render
  button = document.getElementById("table")
  button.addEventListener "click", ((event) ->
    transform targets.table, 2000
  ), false
  button = document.getElementById("sphere")
  button.addEventListener "click", ((event) ->
    transform targets.sphere, 2000
  ), false
  button = document.getElementById("helix")
  button.addEventListener "click", ((event) ->
    transform targets.helix, 2000
  ), false
  button = document.getElementById("grid")
  button.addEventListener "click", ((event) ->
    transform targets.grid, 2000
  ), false
  transform targets.helix, 5000
  
  #
  window.addEventListener "resize", onWindowResize, false
transform = (targets, duration) ->
  TWEEN.removeAll()
  i = 0

  while i < objects.length
    object = objects[i]
    target = targets[i]
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
    i++
  new TWEEN.Tween(this).to({}, duration * 2).onUpdate(render).start()
onWindowResize = ->
  camera.aspect = window.innerWidth / window.innerHeight
  camera.updateProjectionMatrix()
  renderer.setSize window.innerWidth, window.innerHeight
  render()
animate = ->
  requestAnimationFrame animate
  TWEEN.update()
  controls.update()
render = ->
  renderer.render scene, camera
table = ["H", "Hydrogen", "1.00794", 1, 1, "He", "Helium", "4.002602", 18, 1, "Li", "Lithium", "6.941", 1, 2, "Be", "Beryllium", "9.012182", 2, 2, "B", "Boron", "10.811", 13, 2, "C", "Carbon", "12.0107", 14, 2, "N", "Nitrogen", "14.0067", 15, 2, "O", "Oxygen", "15.9994", 16, 2, "F", "Fluorine", "18.9984032", 17, 2, "Ne", "Neon", "20.1797", 18, 2, "Na", "Sodium", "22.98976...", 1, 3, "Mg", "Magnesium", "24.305", 2, 3, "Al", "Aluminium", "26.9815386", 13, 3, "Si", "Silicon", "28.0855", 14, 3, "P", "Phosphorus", "30.973762", 15, 3, "S", "Sulfur", "32.065", 16, 3, "Cl", "Chlorine", "35.453", 17, 3, "Ar", "Argon", "39.948", 18, 3, "K", "Potassium", "39.948", 1, 4, "Ca", "Calcium", "40.078", 2, 4, "sc", "scandium", "44.955912", 3, 4]
camera = undefined
scene = undefined
renderer = undefined
controls = undefined
objects = []
targets =
  table: []
  sphere: []
  helix: []
  grid: []

init()
animate()
