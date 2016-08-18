// Ionic Starter App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'
// 'starter.controllers' is found in controllers.js
angular.module('starter', ['ionic'])

.run(function($ionicPlatform) {
  $ionicPlatform.ready(function() {
    // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    // for form inputs)
    if(window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
    }
    if(window.StatusBar) {
      // org.apache.cordova.statusbar required
      StatusBar.styleDefault();
    }
    start();
  });
})

// http://www.akibahideki.com/html5/cssnite0927/bar.html
var start = function () {
  var canvas = document.getElementById('bar');
	var ctx;
	var value=[];
	var _width = 300;
	var _height = 500;
	ctx = canvas.getContext("2d");
	
		if (canvas.getContext) {
			getTableData();
			}
			
		function init () {
			ctx.clearRect(0, 0, _width, _height);
			ctx.beginPath();//パスを書き始めます
			ctx.moveTo(0,_height);
			for(var i=0 ; i<interval ; i++){
			ctx.lineTo(_width/interval*(i+1),_height-value[i]);
			}
			ctx.stroke();
		}
		
		function getTableData() {
			var values=document.getElementById("tableData").getElementsByTagName("input");
			for(var i=0 ; i<values.length ; i++){
				value[i]=(values[i].value);
			}
			interval = values.length;
			init ();
		}
}
