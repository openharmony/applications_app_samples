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
export const mock: string = `{
  "scenes": [
      {
        "scenarioCard": {
          "scenarioCardId": "01",
          "title": "智慧隧道",
          "version": "0.0.1",
          "enabled": true,
          "foreground": "foreground.png",
          "logo": "logo.png",
          "author": "OpenHarmony",
          "order": 0,
          "settings": {},
          "tag": "交通",
          "type": "release",
          "description": "隧道控制器下挂感知设备，当触发了感知阈值时，会触发在鸿控制器的执行设备联动。"
        },
        "flow": [
          {
            "createTime": "2024-05-16 210:24:30",
            "hasCustomAction": false,
            "id": "413ef2ab-d410-4df9-8560-2c972a909b15",
            "repeatInterval": 0,
            "repeatTimes": 1,
            "title": "当二氧化检测仪检测到二氧化超标时，风机打开",
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
                      "devName": "风机",
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
                  },
                  {
                    "actionId": "3c41679e-55bb-447e-9818-5bd59cae5a99",
                    "actionType": "actions.huawei.subsystem.controlsubsystem",
                    "type": "DEVICE_COMMAND",
                    "deviceInfo": {
                      "devId": "",
                      "devName": "风机",
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
                "title": "控制风机开启",
                "valid": true
              }
            ],
            "trigger": {
              "events": [
                {
                  "type": "DEVICE_DATA",
                  "deviceInfo": {
                    "devId": "",
                    "devName": "二氧化检测仪",
                    "devType": "02D",
                    "path": "filterElement1/alarm"
                  },
                  "operator": ">=",
                  "value": "50",
                  "strategy": {
                    "trigger": "pulse"
                  },
                  "pushMsg": "$devName$二氧化碳超标"
                },
                {
                  "type": "DEVICE_DATA",
                  "deviceInfo": {
                    "devId": "",
                    "devName": "一氧化检测仪",
                    "devType": "02D",
                    "path": "filterElement1/alarm"
                  },
                  "operator": ">=",
                  "value": "50",
                  "strategy": {
                    "trigger": "pulse"
                  },
                  "pushMsg": "$devName$一氧化碳超标"
                }
              ]
            }
          }
        ]
    },
    {
        "scenarioCard": {
          "scenarioCardId": "02",
          "title": "医嘱执行",
          "version": "0.0.1",
          "enabled": true,
          "foreground": "foreground.png",
          "logo": "logo.png",
          "author": "OpenHarmony",
          "order": 0,
          "settings": {},
          "tag": "交通",
          "type": "release",
          "description": "隧道控制器下挂感知设备，当触发了感知阈值时，会触发在鸿控制器的执行设备联动。"
        },
        "flow": [
          {
            "createTime": "2024-05-16 210:24:30",
            "hasCustomAction": false,
            "id": "413ef2ab-d410-4df9-8560-2c972a909b15",
            "repeatInterval": 0,
            "repeatTimes": 1,
            "title": "当二氧化检测仪检测到二氧化超标时，风机打开",
            "type": "manual",
            "version": "0.0.1",
            "actions": [
              {
                "actionId": "44a29306-33c9-47f3-a7b5-6b32147aa006",
                "actionType": "custom.action.controlDevice",
                "actions": [],
                "conditions": [],
                "enabled": true,
                "source": 0,
                "title": "控制风机开启",
                "valid": true
              }
            ],
            "trigger": {
              "events": []
            }
          }
        ]
    }
  ],
  "triggersDevice": [
    {
       "deviceId": 1,
       "deviceType": 1,
       "deviceName": "摄像头",
       "actions": [
          {
            "eventId": 1,
            "eventName": "识别到人脸时"
          }
       ]
     },
     {
       "deviceId": 2,
       "deviceType": 2,
       "deviceName": "打印机",
       "actions": [
          {
            "eventId": 1,
            "eventName": "打开"
          },
          {
            "eventId": 2,
            "eventName": "关闭"
          }
       ]
     }
  ],
  "executeDevice": [
    {
       "deviceId": 3,
       "deviceType": 1,
       "deviceName": "闸机",
       "actions": [
          {
            "eventId": 1,
            "eventName": "打开"
          },
          {
            "eventId": 2,
            "eventName": "关闭"
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
      "deviceName": "摄像头1",
      "deviceType": 4,
      "actions": [
        {
          "actionID": 1,
          "actionName": "识别人脸时"
        }
      ]
    },
    {
      "deviceId": 2,
      "deviceName": "摄像头2",
      "deviceType": 4,
      "actions": [
        {
          "actionID": 1,
          "actionName": "识别人脸时"
        }
      ]
    },
    {
      "deviceId": 3,
      "deviceName": "闸机1",
      "deviceType": 5,
      "actions": [
        {
          "actionID": 1,
          "actionName": "抬起"
        },
        {
          "actionID": 2,
          "actionName": "放下"
        }
      ]
    },
    {
      "deviceId": 4,
      "deviceName": "闸机2",
      "deviceType": 5,
      "actions": [
        {
          "actionID": 1,
          "actionName": "抬起"
        },
        {
          "actionID": 2,
          "actionName": "放下"
        }
      ]
    },
    {
      "deviceId": 5,
      "deviceName": "打印机1",
      "deviceType": 6,
      "actions": [
        {
          "actionID": 1,
          "actionName": "开启"
        },
        {
          "actionID": 2,
          "actionName": "关闭"
        }
      ]
    }
  ]
}`;