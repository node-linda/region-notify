path = require 'path'

config = require path.resolve 'config'
console.log config

LindaClient = require('linda-socket.io').Client
socket = require('socket.io-client').connect(config.url)
linda = new LindaClient().connect(socket)

notify = (msg) ->
  for name, yomi of config.regions
    ts = linda.tuplespace(name)
    ts.write {type: "say", value: msg}
    ts.write {type: "skype", cmd: "post", value: msg}
    ts.write {type: "slack", cmd: "post", value: msg}

linda.io.on 'connect', ->
  console.log "socket.io connect!!"

  linda.tuplespace(config.watch).watch {type: "region"}, (err, tuple) ->
    return if err
    return unless tuple.data.where?
    return unless tuple.data.who?
    return unless tuple.data.action?
    console.log tuple
    msg = switch tuple.data.action
      when "enter"
        "#{config.regions[tuple.data.where]}に#{tuple.data.who}があらわれました"
      when "leave"
        "#{config.regions[tuple.data.where]}から#{tuple.data.who}が離れました"
    console.log msg
    notify msg
