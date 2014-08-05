'use strict'

angular.module('app', ['ui.router', 'app.views', 'ngCkeditor', 'mediaPlayer', 'app.session', 'app.common', 'app.filters', 'app.pages'])
.config(['$stateProvider', '$urlRouterProvider',
  ($stateProvider, $urlRouterProvider) ->
    
    $urlRouterProvider.otherwise('/')
    
    $stateProvider
    .state('app',
      url: '/'
      resolve:
        user: ['$http', ($http) ->
          $http.post('/api/user/me').then (response) ->
            response.data
          , (response) ->
            {}
          ]
      templateUrl: 'app.html'
      controller: ['$scope', 'user', ($scope, user) ->
        $scope.APP_NAME = 'cmsexp'
        $scope.user = user
        ]
    )
    .state('cms',
      url: '/cms'
      templateUrl: 'cms.html'
      controller: ['$scope', ($scope) ->
        $scope.data = ""
        $scope.editorOptions =
          uiColor: '#000000'
          filebrowserBrowseUrl: '/#/login'
  
        ]
    )
    .state('btt',
      url: '/btt'
      templateUrl: 'btt.html'
      controller: ['$scope', ($scope) ->
        $scope.playToggle = () ->
          if $scope.audio1.playing
            $scope.audio1.pause()
          else
            $scope.audio1.play()
        ]
    )
 
  ])
