'use strict'

angular.module('app.session', ['ui.router', 'app.views', 'app.common', 'app.session.controllers'])
.config(['$stateProvider',
  ($stateProvider) ->
    $stateProvider
    .state('login',
      url: '/login'
      templateUrl: 'user/login_form.html'
      controller: 'LoginCtrl'
    )
    .state('logout'
    url: '/logout'
    template:'logging out...'
    controller: 'LogoutCtrl'
    )
    .state('register',
      url: '/register'
      templateUrl:'user/register.html'
      controller: 'RegisterCtrl'
    )
    .state('activate',
      url: '/activate/:cmdId'
      templateUrl: 'user/activate.html'
      controller: 'ActivateCtrl'
    )
    .state('forgot',
      url: '/forgot'
      templateUrl: 'user/forgot.html'
      controller: 'ForgotCtrl'
    )
    .state('reset',
      url: '/reset/:cmdId'
      templateUrl: 'user/reset.html'
      controller: 'ResetCtrl'
    )    
])
