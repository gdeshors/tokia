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

        # remplir les événements
        for e in data.event_comments
          do (e) =>
            str = "<p>Le " + e.date
            str += " : l'IA '" + e.ai + "' a été mise à jour en version " + e.version
            if e.commentaire != null
              str += " avec le commentaire : " + e.commentaire
            str += "</p>"
            $("#event_comments").append(str)
