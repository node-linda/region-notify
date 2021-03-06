path = require 'path'

config = require path.resolve 'config'
console.log config

LindaClient = require('linda').Client
socket = require('socket.io-client').connect(config.url)
linda = new LindaClient().connect(socket)

notify = (msg) ->
  ts = linda.tuplespace(config.tuplespace)
  ts.write {type: "skype", cmd: "post", value: msg}
  ts.write {type: "slack", cmd: "post", value: msg}
  for name, yomi of config.regions
    ts = linda.tuplespace(name)
    ts.write {type: "say", value: msg}

linda.io.on 'connect', ->
  console.log "socket.io connect!!"

  linda.tuplespace(config.tuplespace).watch {type: "region"}, (err, tuple) ->
    return if err
    return unless tuple.data.where?
    return unless tuple.data.who?
    return unless tuple.data.action?
    console.log tuple
    where = tuple.data.where
    who = tuple.data.who
    msg = switch tuple.data.action
      when "enter"
        "#{config.regions[where] or where}に#{who}があらわれました"
      when "leave"
        "#{config.regions[where] or where}から#{who}が離れました"
    console.log msg
    notify msg
