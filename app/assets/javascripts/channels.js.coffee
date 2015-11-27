window.App = {};

# This is a hack because the asset pipeline doesn't respect the ENV['HOST'] when doing a precompile for production
host = window.location.hostname;
if window.location.port isnt ""
  host += ":#{window.location.port}"

App.cable = Cable.createConsumer('ws://' + host + '/websocket');

window.connectToTeachersSocket = ->
  App.teacherChannel = App.cable.subscriptions.create("TeacherChannel",
    onDuty: ->
      @perform 'on_duty'

    offDuty: ->
      @perform 'off_duty'

    received: (data) ->
      handler = new TeacherChannelHandler data
      handler.processResponse()
  )

$ ->
  App.userChannel = App.cable.subscriptions.create("UserChannel", 
    requestAssistance: (reason) ->
      @perform 'request_assistance', reason: reason

    cancelAssistanceRequest: ->
      @perform 'cancel_assistance'
    
    received: (data) ->
      handler = new UserChannelHandler data
      handler.processResponse()
  )