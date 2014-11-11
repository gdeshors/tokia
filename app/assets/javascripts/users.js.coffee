# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if ($("#elograph").length>0)
    $.ajax "/elodata",
      type:'GET'
      dataType:'json'
      success: (data, status, j) ->

        Morris.Line({
          element: 'elograph',
          data: data.matches,
          ymin: 'auto',
          hideHover : true,
          xkey: 'date',
          ykeys: ykeys,
          labels: labels,
          events: data.events
        })
