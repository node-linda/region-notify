Linda Region Notify
===================

- https://github.com/node-linda/region-notify

notify region tuple from [iBeacon](https://github.com/node-linda/ibeacon-android)

to

- [slack chat](https://github.com/node-linda/slack-chat)
- [skype chat](https://github.com/node-linda/skype-chat)
- [mac-say](https://github.com/node-linda/mac-say)



- watch {"type": "region"}
  - write {"type": "slack", "cmd": "post", "value": "#{where}に#{who}があらわれました"}
  - write {"type": "say", "value": "#{where}から#{who}が離れました"}



## Install Dependencies

    % npm install


## Run

    % npm start
