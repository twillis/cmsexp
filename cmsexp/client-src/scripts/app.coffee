'use strict'

angular.module('app', ['ui.router', 'app.views', 'ngCkeditor', 'mediaPlayer'])
.config(['$stateProvider', '$urlRouterProvider',
  ($stateProvider, $urlRouterProvider) ->

    FORM_CONTENT_TYPE = {'Content-Type': 'application/x-www-form-urlencoded'}
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
    .state('login',
      url: '/login'
      templateUrl: 'user/login_form.html'
      controller: ['$scope', '$http', '$state', ($scope, $http, $state) ->
        $scope.form = {}
        $scope.errors = {}
        
        $scope.doLogin = () ->
          $http.post('/api/login', $.param($scope.form), {headers: FORM_CONTENT_TYPE}).then (response) ->
            $state.go('app', {}, {reload: true})
          , (response) ->
            if response.status == 400
              $scope.errors = response.data
            else
              $scope.errors =
                login_id: "wrong id or password"
      ]
      
    )
    .state('logout'
    url: '/logout'
    template:'logging out...'
    controller: ['$http', '$state', ($http, $state) ->
      $http.post('/api/logout', {}, {headers: FORM_CONTENT_TYPE}).finally (response) ->
        $state.go('app', {}, {reload: true})
      ]
    )
    .state('register',
      url: '/register'
      templateUrl:'user/register.html'
      controller: ['$scope', '$http', '$state', ($scope, $http, $state)->
        $scope.form = {}
        $scope.errors = {}

        $scope.doRegister = () ->
          $http.post('/api/user/register', $.param($scope.form), {headers: FORM_CONTENT_TYPE}).then (response) ->
            $state.go('app', {}, {reload: true})
          , (response) ->
            if response.status == 400
              $scope.errors = response.data
            else
              $scope.errors =
                email: "could not register with this email"
            
        ]
    )
    .state('activate',
      url: '/activate/:cmdId'
      templateUrl: 'user/activate.html'
      controller: ['$scope', '$http', '$state', ($scope, $http, $state) ->
        $scope.form = {}
        $scope.form.command_id = $state.params.cmdId

        $scope.doActivate = () ->
          $http.post('/api/user/activate', $.param($scope.form), {headers: FORM_CONTENT_TYPE}).then (result) ->
            $state.go('app', {}, {reload: true})
          , (response) ->
            if response.status == 400
              $scope.errors = response.data
            else
              $scope.errors =
                email: "could not create your account"
        
        ]
    )
    .state('forgot',
      url: '/forgot'
      templateUrl: 'user/forgot.html'
      controller: ['$scope', '$http', '$state', ($scope, $http, $state) ->
        $scope.form = {}
        $scope.errors = {}

        $scope.doForgot = () ->
          $http.post('/api/user/forgot', $.param($scope.form), {headers: FORM_CONTENT_TYPE}).then (response) ->
            $state.go('app', {}, {reload: true})
          , (response) ->
            if response.status == 400
              $scope.errors = response.data
            else
              $scope.errors =
                email: "could not reset password with this email"
            
        
        ]
    )
    .state('reset',
      url: '/reset/:cmdId'
      templateUrl: 'user/reset.html'
      controller: ['$scope', '$http', '$state', ($scope, $http, $state) ->
        $scope.form = {}
        $scope.form.command_id = $state.params.cmdId

        $scope.doReset = () ->
          $http.post('/api/user/reset', $.param($scope.form), {headers: FORM_CONTENT_TYPE}).then (result) ->
            $state.go('app', {}, {reload: true})
          , (response) ->
            if response.status == 400
              $scope.errors = response.data
            else
              $scope.errors =
                email: "could not reset your password"
        
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
          $http.post("/api/page/#{$scope.page.id}/update_section", $.param(section), {headers: FORM_CONTENT_TYPE}).then (response) ->
            $state.go('page.show', {pageId: $scope.page.id, sectionId: null, newSection: null})

        $scope.doNewSection = () ->
          $http.post("/api/page/#{$scope.page.id}/create_section", $.param($scope.newSection), {headers: FORM_CONTENT_TYPE}).then (response) ->
            $state.go('page.show', {pageId: $scope.page.id, sectionId: null, newSection: null})
          
        ]
      templateUrl: "page/show.html"
    )
  ])
.filter('asHtml', ['$sce', ($sce) ->
    (val) ->
      $sce.trustAsHtml(val)
])
.filter('formatTime' , () ->
  (seconds) ->
    minutes = Math.floor(seconds / 60)
    minutes = if (minutes >= 10) then  minutes else "0" + minutes
    seconds = Math.floor(seconds % 60)
    seconds = if (seconds >= 10) then seconds else "0" + seconds
    "#{minutes}:#{seconds}"

  )
