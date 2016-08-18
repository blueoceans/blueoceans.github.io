

			var table = [
      "http://ec2.images-amazon.com/images/I/31auv1zIKzL._SL500__SS160_.jpg",
      "http://ec2.images-amazon.com/images/I/412itLzzeVL._SL500__SS160_.jpg",
      "http://ec2.images-amazon.com/images/I/414dANGlX4L._SL500__SS160_.jpg",
      "http://ec2.images-amazon.com/images/I/418ZQdfYRZL._SL500__SS160_.jpg",
      "http://ec2.images-amazon.com/images/I/41Dgqqcwc6L._SL500__SS160_.jpg",
      "http://ec2.images-amazon.com/images/I/41fZio3CgUL._SL500__SS160_.jpg",
      "http://ec2.images-amazon.com/images/I/515-6Y889qL._SL500__SS160_.jpg",
      "http://ec2.images-amazon.com/images/I/516Bmn8bsIL._SL500__SS160_.jpg",
      "http://ec2.images-amazon.com/images/I/51EqYw2Cs-L._SL500__SS160_.jpg",
      "http://ec2.images-amazon.com/images/I/51KzPdf-0UL._SL500__SS160_.jpg",
      "http://ec2.images-amazon.com/images/I/51uT%2Bo93e5L._SL500__SS160_.jpg",
      "http://ec2.images-amazon.com/images/I/51xnsP8YiVL._SL500__SS160_.jpg",
      "http://ec2.images-amazon.com/images/I/51zDFnDxERL._SL500__SS160_.jpg",
      "http://ecx.images-amazon.com/images/I/41%2BNYktlZjL._SL500__SS160_.jpg",
      "http://ecx.images-amazon.com/images/I/410-Y2B3bVL._SL500__SS160_.jpg",
      "http://ecx.images-amazon.com/images/I/416yKBFkqKL._SL500__SS160_.jpg",
      "http://ecx.images-amazon.com/images/I/419tIk6CleL._SL500__SS160_.jpg",
      "http://ecx.images-amazon.com/images/I/41ArXU3kH%2BL._SL500__SS160_.jpg",
      "http://ecx.images-amazon.com/images/I/41CPpyjeXVL._SL500__SS160_.jpg",
      "http://ecx.images-amazon.com/images/I/41DBbFiBt0L._SL500__SS160_.jpg",
      "http://ecx.images-amazon.com/images/I/41LJsNyVhYL._SL500__SS160_.jpg",
      "http://ecx.images-amazon.com/images/I/41U1bsxl1YL._SL500__SS160_.jpg",
      "http://ecx.images-amazon.com/images/I/41iB6BUYTBL._SL500__SS160_.jpg",
      "http://ecx.images-amazon.com/images/I/41oAbEkd5fL._SL500__SS160_.jpg",
      "http://ecx.images-amazon.com/images/I/41t%2BxlLqOVL._SL500__SS160_.jpg",
      "http://ecx.images-amazon.com/images/I/51FaJuHRckL._SL500__SS160_.jpg",
      "http://ecx.images-amazon.com/images/I/51MD1m%2Bb4tL._SL500__SS160_.jpg",
      "http://ecx.images-amazon.com/images/I/51mx2xhibrL._SL500__SS160_.jpg",
      "http://ecx.images-amazon.com/images/I/41j81nVqvqL._SL500__SS160_.jpg",
      "http://ec2.images-amazon.com/images/I/41K6ayp4ULL._SL500__SS160_.jpg",
      "http://ecx.images-amazon.com/images/I/411rGgmVcZL._SL500__SS160_.jpg",
      "http://ec2.images-amazon.com/images/I/41hrWLw9oXL._SL500__SS160_.jpg",
      "http://ec2.images-amazon.com/images/I/51%2BOBrDqcOL._SL500__SS160_.jpg",
      "http://ec2.images-amazon.com/images/I/41GRCf8oADL._SL500__SS160_.jpg",
      "http://ecx.images-amazon.com/images/I/416qy08eDJL._SL500__SS160_.jpg",
      "http://ec2.images-amazon.com/images/I/41yOVsCFagL._SL500__SS160_.jpg",
			];

			var camera, scene, renderer;
			var controls;

			var objects = [];
			var targets = { table: [], sphere: [], helix: [], grid: [] };

			init();
			animate();

			function init() {

				camera = new THREE.PerspectiveCamera( 40, window.innerWidth / window.innerHeight, 1, 10000 );
				camera.position.z = 1500;

				scene = new THREE.Scene();

				// table

				for ( var i = 0; i < table.length; i += 1 ) {

					var element = document.createElement( 'div' );
					element.className = 'element';
					//element.style.backgroundColor = 'rgba(0,127,127,' + ( Math.random() * 0.5 + 0.25 ) + ')';
					element.style.backgroundImage = 'url("' + table[i] + '")';
					element.style.backgroundSize = 'contain';
					element.style.backgroundRepeat = 'no-repeat';
					element.style.backgroundPosision = 'center bottom';
					element.style.backgroundColor = 'rgba(255, 255, 255,0)';

					var object = new THREE.CSS3DObject( element );
					object.position.x = Math.random() * 4000 - 2000;
					object.position.y = Math.random() * 4000 - 2000;
					object.position.z = Math.random() * 4000 - 2000;
					scene.add( object );

					objects.push( object );

					//

					var object = new THREE.Object3D();

					targets.table.push( object );

				}

				// helix

				var vector = new THREE.Vector3();

				for ( var i = 0, l = objects.length; i < l; i ++ ) {

					var phi = i * 0.175 + Math.PI;

					var object = new THREE.Object3D();

					object.position.x = 900 * Math.sin( phi );
					object.position.y = 1;
					object.position.z = 900 * Math.cos( phi );

					vector.x = object.position.x * 2;
					vector.y = object.position.y;
					vector.z = object.position.z * 2;

					object.lookAt( vector );

					targets.helix.push( object );

				}

				//

				renderer = new THREE.CSS3DRenderer();
				renderer.setSize( window.innerWidth, window.innerHeight );
				renderer.domElement.style.position = 'absolute';
				document.getElementById( 'container' ).appendChild( renderer.domElement );

				//

				controls = new THREE.TrackballControls( camera, renderer.domElement );
				controls.rotateSpeed = 0.5;
				controls.minDistance = 500;
				controls.maxDistance = 6000;
				controls.addEventListener( 'change', render );

				var button = document.getElementById( 'table' );
				button.addEventListener( 'click', function ( event ) {

					transform( targets.table, 2000 );

				}, false );

				var button = document.getElementById( 'sphere' );
				button.addEventListener( 'click', function ( event ) {

					transform( targets.sphere, 2000 );

				}, false );

				var button = document.getElementById( 'helix' );
				button.addEventListener( 'click', function ( event ) {

					transform( targets.helix, 2000 );

				}, false );

				var button = document.getElementById( 'grid' );
				button.addEventListener( 'click', function ( event ) {

					transform( targets.grid, 2000 );

				}, false );

				transform( targets.helix, 5000 );

				//

				window.addEventListener( 'resize', onWindowResize, false );

			}

			function transform( targets, duration ) {

				TWEEN.removeAll();

				for ( var i = 0; i < objects.length; i ++ ) {

					var object = objects[ i ];
					var target = targets[ i ];

					new TWEEN.Tween( object.position )
						.to( { x: target.position.x, y: target.position.y, z: target.position.z }, Math.random() * duration + duration )
						.easing( TWEEN.Easing.Exponential.InOut )
						.start();

					new TWEEN.Tween( object.rotation )
						.to( { x: target.rotation.x, y: target.rotation.y, z: target.rotation.z }, Math.random() * duration + duration )
						.easing( TWEEN.Easing.Exponential.InOut )
						.start();

				}

				new TWEEN.Tween( this )
					.to( {}, duration * 2 )
					.onUpdate( render )
					.start();

			}

			function onWindowResize() {

				camera.aspect = window.innerWidth / window.innerHeight;
				camera.updateProjectionMatrix();

				renderer.setSize( window.innerWidth, window.innerHeight );

				render();

			}

			function animate() {

				requestAnimationFrame( animate );

				TWEEN.update();

				controls.update();

			}

			function render() {

				renderer.render( scene, camera );

			}

