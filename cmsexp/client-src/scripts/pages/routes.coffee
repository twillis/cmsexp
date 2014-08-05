'use strict'

angular.module('app.pages', ['ui.router', 'app.views', 'app.common', 'app.pages.controllers'])
.config(['$stateProvider', ($stateProvider) ->
  pageResolver = ['$http', '$stateParams', ($http, $stateParams) ->
    $http.get("/api/page/#{$stateParams.pageId}").then (response) ->
      response.data
  ]
          
  
  $stateProvider
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
      url: '/:pageId?sectionId&mode'
      resolve:
        page: pageResolver
      controller: "PageShowCtrl"
      templateUrl: "page/show.html"
    )
  ])
