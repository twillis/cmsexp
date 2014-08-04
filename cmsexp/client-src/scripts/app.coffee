'use strict'

angular.module('app', ['ui.router', 'app.views', 'ngCkeditor', 'mediaPlayer', 'app.session', 'app.common', 'app.filters'])
.config(['$stateProvider', '$urlRouterProvider',
  ($stateProvider, $urlRouterProvider) ->
    
    $urlRouterProvider.otherwise('/')
    
    pageResolver = ['$http', '$stateParams', ($http, $stateParams) ->
          $http.get("/api/page/#{$stateParams.pageId}").then (response) ->
            response.data
          ]
          
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
    .state('page',
      url: '/pages'
      resolve:
        pages: [ '$http', ($http) ->
          $http.get('/api/page').then (response) ->
            response.data
        ]
      controller: ['$scope', 'pages', ($scope, pages) ->
        $scope.pages = pages
        ]
      templateUrl: "page/index.html"
    )
    .state('page.show',
      url: '/:pageId?sectionId&newSection'
      resolve:
        page: pageResolver
      controller: ['$scope', 'page', '$stateParams', '$state', '$http', ($scope, page, $stateParams, $state, $http) ->
        $scope.page = page
        $scope.newSection = {weight: page.sections.length + 1}
        $scope.isNewSection = $stateParams.newSection or false
        
        if not $scope.isNewSection
          $scope.editSectionId = $stateParams.sectionId

        $scope.saveSection = (section) ->
          $http.post("/api/page/#{$scope.page.id}/update_section", section).then (response) ->
            $state.go('page.show', {pageId: $scope.page.id, sectionId: null, newSection: null})

        $scope.doNewSection = () ->
          $http.post("/api/page/#{$scope.page.id}/create_section", $scope.newSection).then (response) ->
            $state.go('page.show', {pageId: $scope.page.id, sectionId: null, newSection: null})
          
        ]
      templateUrl: "page/show.html"
    )
  ])
