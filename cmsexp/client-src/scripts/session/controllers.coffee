'use strict'

angular.module('app.session.controllers', ['app.common'])
.controller('LoginCtrl', ['$scope', '$http', '$state', ($scope, $http, $state) ->
  $scope.form = {}
  $scope.errors = {}
        
  $scope.doLogin = () ->
    $http.post('/api/login', $scope.form).then (response) ->
      $state.go('app', {}, {reload: true})
    , (response) ->
      if response.status == 400
        $scope.errors = response.data
      else
        $scope.errors =
          login_id: "wrong id or password"
])
.controller('LogoutCtrl', ['$http', '$state', ($http, $state) ->
  $http.post('/api/logout', {}).finally (response) ->
    $state.go('app', {}, {reload: true})
])
.controller('RegisterCtrl', ['$scope', '$http', '$state', ($scope, $http, $state)->
  $scope.form = {}
  $scope.errors = {}

  $scope.doRegister = () ->
    $http.post('/api/user/register', $scope.form).then (response) ->
      $state.go('app', {}, {reload: true})
    , (response) ->
      if response.status == 400
        $scope.errors = response.data
      else
        $scope.errors =
          email: "could not register with this email"          
])
.controller('ActivateCtrl', ['$scope', '$http', '$state', ($scope, $http, $state) ->
  $scope.form = {}
  $scope.form.command_id = $state.params.cmdId

  $scope.doActivate = () ->
    $http.post('/api/user/activate', $scope.form).then (result) ->
      $state.go('app', {}, {reload: true})
    , (response) ->
      if response.status == 400
        $scope.errors = response.data
      else
        $scope.errors =
          email: "could not create your account"      
])
.controller('ForgotCtrl', ['$scope', '$http', '$state', ($scope, $http, $state) ->
  $scope.form = {}
  $scope.errors = {}

  $scope.doForgot = () ->
    $http.post('/api/user/forgot', $scope.form).then (response) ->
      $state.go('app', {}, {reload: true})
    , (response) ->
      if response.status == 400
        $scope.errors = response.data
      else
        $scope.errors =
          email: "could not reset password with this email"
])
.controller('ResetCtrl', ['$scope', '$http', '$state', ($scope, $http, $state) ->
  $scope.form = {}
  $scope.form.command_id = $state.params.cmdId

  $scope.doReset = () ->
    $http.post('/api/user/reset', $scope.form).then (result) ->
      $state.go('app', {}, {reload: true})
    , (response) ->
      if response.status == 400
        $scope.errors = response.data
      else
        $scope.errors =
          email: "could not reset your password"
])
