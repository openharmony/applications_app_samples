/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
export const mockEN: string = `{
  "scenes": [
      {
        "scenarioCard": {
          "scenarioCardId": "01",
          "title": "Intelligent tunnel environment control",
          "version": "0.0.1",
          "enabled": true,
          "foreground": "foreground.png",
          "logo": "logo.png",
          "author": "OpenHarmony",
          "order": 0,
          "settings": {},
          "tag": "communication",
          "type": "release",
          "description": "With the development of informatization technologies, highway tunnel construction will be oriented to comprehensive tunnel management and control and smooth road maintenance, and provide comprehensive capabilities such as environment monitoring, incident prevention, incident handling, guidance and command, and electromechanical O&M. Implement automatic tunnel monitoring from the perspective of prevention, intelligent event handling from the perspective of handling, and digital tunnel asset management from the perspective of O&M."
        },
        "flow": [
          {
            "createTime": "2024-05-16 210:24:30",
            "hasCustomAction": false,
            "id": "413ef2ab-d410-4df9-8560-2c972a909b15",
            "repeatInterval": 0,
            "repeatTimes": 1,
            "title": "When the dioxide detector detects that the dioxide exceeds the standard, the fan is turned on",
            "type": "manual",
            "version": "0.0.1",
            "actions": [
              {
                "actionId": "44a29306-33c9-47f3-a7b5-6b32147aa006",
                "actionType": "custom.action.controlDevice",
                "actions": [
                  {
                    "actionId": "3c41679e-55bb-447e-9818-5bd59cae5a99",
                    "actionType": "actions.huawei.subsystem.controlsubsystem",
                    "type": "DEVICE_COMMAND",
                    "deviceInfo": {
                      "devId": "",
                      "devName": "Fan",
                      "devType": "02D",
                      "path": "filterElement1/alarm"
                    },
                    "servies": {
                      "sid": "",
                      "data": {
                          "characteristicName1": "",
                          "characteristicName2": ""
                      }
                    },
                    "command": "$devId$,$sid$,$characteristicName1$"
                  }
                ],
                "conditions": [],
                "enabled": true,
                "source": 0,
                "title": "Control the fan to start",
                "valid": true
              }
            ],
            "trigger": {
              "events": [
                {
                  "type": "DEVICE_DATA",
                  "deviceInfo": {
                    "devId": "",
                    "devName": "Dioxide detector",
                    "devType": "02D",
                    "path": "filterElement1/alarm"
                  },
                  "operator": ">=",
                  "value": "50",
                  "strategy": {
                    "trigger": "pulse"
                  },
                  "pushMsg": "$devName$Carbon dioxide exceeding the standard"
                },
                {
                  "type": "DEVICE_DATA",
                  "deviceInfo": {
                    "devId": "",
                    "devName": "One oxide detector",
                    "devType": "02D",
                    "path": "filterElement1/alarm"
                  },
                  "operator": ">=",
                  "value": "50",
                  "strategy": {
                    "trigger": "pulse"
                  },
                  "pushMsg": "$devName$Carbon monoxide exceeding the standard"
                }
              ]
            }
          }
        ]
    },
    {
        "scenarioCard": {
          "scenarioCardId": "02",
          "title": "Execution of medical orders",
          "version": "0.0.1",
          "enabled": true,
          "foreground": "foreground.png",
          "logo": "logo.png",
          "author": "OpenHarmony",
          "order": 0,
          "settings": {},
          "tag": "traffic",
          "type": "release",
          "description": "The perception device is attached to the tunnel controller, and when the perception threshold is triggered, it will trigger the execution device linkage in the Hong controller."
        },
        "flow": [
          {
            "createTime": "2024-05-16 210:24:30",
            "hasCustomAction": false,
            "id": "413ef2ab-d410-4df9-8560-2c972a909b15",
            "repeatInterval": 0,
            "repeatTimes": 1,
            "title": "When the dioxide detector detects that the dioxide exceeds the standard, the fan is turned on",
            "type": "manual",
            "version": "0.0.1",
            "actions": [
              {
                "actionId": "44a29306-33c9-47f3-a7b5-6b32147aa006",
                "actionType": "custom.action.controlDevice",
                "actions": [
                  {
                    "actionId": "3c41679e-55bb-447e-9818-5bd59cae5a99",
                    "actionType": "actions.huawei.subsystem.controlsubsystem",
                    "type": "DEVICE_COMMAND",
                    "deviceInfo": {
                      "devId": "",
                      "devName": "Fan",
                      "devType": "02D",
                      "path": "filterElement1/alarm"
                    },
                    "servies": {
                      "sid": "",
                      "data": {
                          "characteristicName1": "",
                          "characteristicName2": ""
                      }
                    },
                    "command": "$devId$,$sid$,$characteristicName1$"
                  }
                ],
                "conditions": [],
                "enabled": true,
                "source": 0,
                "title": "Control the fan to start",
                "valid": true
              }
            ],
            "trigger": {
              "events": [
                {
                  "type": "DEVICE_DATA",
                  "deviceInfo": {
                    "devId": "",
                    "devName": "Dioxide detector",
                    "devType": "02D",
                    "path": "filterElement1/alarm"
                  },
                  "operator": ">=",
                  "value": "50",
                  "strategy": {
                    "trigger": "pulse"
                  },
                  "pushMsg": "$devName$Carbon dioxide exceeding the standard"
                },
                {
                  "type": "DEVICE_DATA",
                  "deviceInfo": {
                    "devId": "",
                    "devName": "One oxide detector",
                    "devType": "02D",
                    "path": "filterElement1/alarm"
                  },
                  "operator": ">=",
                  "value": "50",
                  "strategy": {
                    "trigger": "pulse"
                  },
                  "pushMsg": "$devName$Carbon monoxide exceeding the standard"
                }
              ]
            }
          }
        ]
    }
  ],
  "triggersDevice": [
    {
       "deviceId": 1,
       "deviceType": 1,
       "deviceName": "camera",
       "actions": [
          {
            "eventId": 1,
            "eventName": "When recognizing a face"
          }
       ]
     },
     {
       "deviceId": 2,
       "deviceType": 2,
       "deviceName": "printer",
       "actions": [
          {
            "eventId": 1,
            "eventName": "open"
          },
          {
            "eventId": 2,
            "eventName": "close"
          }
       ]
     }
  ],
  "executeDevice": [
    {
       "deviceId": 3,
       "deviceType": 1,
       "deviceName": "Turnstile",
       "actions": [
          {
            "eventId": 1,
            "eventName": "open"
          },
          {
            "eventId": 2,
            "eventName": "close"
          }
       ]
     }
  ],
 "equipment": [
    {
      "devId": "001",
      "devName": "空调新风",
      "devType": "010",
      "path": "filterElement1/alarm"
    },
    {
      "devId": "002",
      "devName": "二氧化碳传感器",
      "devType": "011",
      "path": "filterElement1/alarm"
    },
    {
      "devId": "003",
      "devName": "温度传感器",
      "devType": "012",
      "path": "filterElement1/alarm"
    },
    {
      "devId": "004",
      "devName": "灯",
      "devType": "020",
      "path": "filterElement1/alarm"
    },
    {
      "devId": "005",
      "devName": "光照传感器",
      "devType": "021",
      "path": "filterElement1/alarm"
    },
    {
      "devId": "006",
      "devName": "雨水传感器",
      "devType": "030",
      "path": "filterElement1/alarm"
    },
    {
      "devId": "007",
      "devName": "智能窗帘",
      "devType": "040",
      "path": "filterElement1/alarm"
    },
    {
      "devId": "008",
      "devName": "红外传感器",
      "devType": "041",
      "path": "filterElement1/alarm"
    }
  ],
  "device": [
    {
      "deviceId": 1,
      "deviceName": "camera1",
      "deviceType": 4,
      "actions": [
        {
          "actionID": 1,
          "actionName": "When recognizing a face"
        }
      ]
    },
    {
      "deviceId": 2,
      "deviceName": "camera2",
      "deviceType": 4,
      "actions": [
        {
          "actionID": 1,
          "actionName": "When recognizing a face"
        }
      ]
    },
    {
      "deviceId": 3,
      "deviceName": "Turnstile1",
      "deviceType": 5,
      "actions": [
        {
          "actionID": 1,
          "actionName": "lift"
        },
        {
          "actionID": 2,
          "actionName": "put down"
        }
      ]
    },
    {
      "deviceId": 4,
      "deviceName": "Turnstile2",
      "deviceType": 5,
      "actions": [
        {
          "actionID": 1,
          "actionName": "lift"
        },
        {
          "actionID": 2,
          "actionName": "put down"
        }
      ]
    },
    {
      "deviceId": 5,
      "deviceName": "printer1",
      "deviceType": 6,
      "actions": [
        {
          "actionID": 1,
          "actionName": "opne"
        },
        {
          "actionID": 2,
          "actionName": "close"
        }
      ]
    }
  ]
}`;