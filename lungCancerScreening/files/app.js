'use strict';

/**
 * @ngdoc overview
 * @name angularApp
 * @description
 * # angularApp
 *
 * Main module of the application.
 */
var app = angular.module("myapp", ['ngStorage','ngRoute']);

app.config(function ($routeProvider) {

    $routeProvider
      .when('/', {
        templateUrl: 'form.html',
        controller: 'FormCtrl'
      })   
      .when('/results', {
        templateUrl: 'results.html',
        controller: 'ResultCtrl'
      })  
      .when('/pdf', {
        templateUrl: 'pdf.html',
        controller: 'ResultCtrl'
      })     
      .when('/about', {
        templateUrl: 'about.html'
      })                        
      .otherwise({
        redirectTo: '/'
      });
  });