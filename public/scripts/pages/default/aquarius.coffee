$ = require 'jquery'
Flow = require 'flow'
require '../../components/csrf'

{upyun} = adou

$ ->
  flow = new Flow
    target: upyun.api + '/starry-images'
    singleFile: true
    testChunks: false

  flow.assignBrowse $('#replaceImage')[0]
  flow.on 'filesSubmitted', ->
    $.ajax
      url: '/api/upyun_token'
      type: 'POST'
      data:
        bucket: 'starry-images'
        expiration: parseInt (new Date().getTime() + 600000)/1000, 10
        'save-key': '/{year}{mon}/{day}/{filemd5}-{random}{.suffix}'
      dataType: 'json'
    .done (res) ->
      flow.opts.query = res
      flow.upload()
    .fail (res) ->
      error = res.responseJSON.error
      window.alert error

  flow.on 'fileSuccess', (file, message) ->
    message = JSON.parse message
    console.log message
    $('body').append "<img src='#{upyun.buckets['starry-images']}#{message.url}'>"