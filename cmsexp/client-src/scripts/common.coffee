'use strict'
angular.module('app.common', [])
.factory('httpInterceptor', [() ->
  # make posting work nicer by allowing the client to post a js
  # object, and transform it to a form post before sending
  interceptor =
    request: (config) ->
      if config.method == "POST"
        config.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        if config.data
          config.data = $.param(config.data)
      config
  ])
.config(['$httpProvider', ($httpProvider) ->
  $httpProvider.interceptors.push 'httpInterceptor'
  ])
