'user strict'
angular.module('app.pages.controllers', ['app.common'])
.controller("PageShowCtrl", ['$scope', 'page', '$stateParams', '$state', '$http',
  ($scope, page, $stateParams, $state, $http) ->

    $scope.MODE_SEC_EDIT = "editSection"
    $scope.MODE_SEC_NEW = "newSection"
    $scope.MODE_PAGE_EDIT = "pageEdit"
    $scope.MODE_PAGE_NEW = "pageNew"
    $scope.MODE_PAGE_SHOW = null

    $scope.page = page
    $scope.newSection = {weight: page.sections.length + 1}

    $scope.saveSection = (section) ->
      $http.post("/api/page/#{$scope.page.id}/update_section", section).then (response) ->
        $state.go('page.show', {pageId: $scope.page.id, sectionId: null, mode: null})

    $scope.doNewSection = () ->
      $http.post("/api/page/#{$scope.page.id}/create_section", $scope.newSection).then (response) ->
        $state.go('page.show', {pageId: $scope.page.id, sectionId: null, mode: null})
    $scope.setMode = (params) ->
      $scope.$MODE = params.mode
      switch $scope.$MODE
        when $scope.MODE_SEC_EDIT
          $scope.editSectionId = params.sectionId
      console.log($scope.$MODE)
      
    $scope.setMode($stateParams)
          
  ])
