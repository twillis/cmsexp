'use strict'
angular.module('app.filters', [])
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
