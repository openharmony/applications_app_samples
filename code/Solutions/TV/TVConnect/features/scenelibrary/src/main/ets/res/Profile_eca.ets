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
export const profileEca: string = `
{
    "prodId": "0123A",
    "deviceTypeId": "123",
    "deviceName": "",
    "eventUIInfo": [
        {
            "path": "switch/on",
            "uiInfo": [
                {
                    "descCh": "关",
                    "descEn": "off",
                    "enumVal": "0"
                },
                {
                    "descCh": "开",
                    "descEn": "on",
                    "enumVal": "1"
                }
            ],
            "name": "开关",
            "id": "1",
            "nameEn": "onOff",
            "conflictType": "DEVICE_EVENT",
            "type": "enum",
            "strategy": {
                "trigger": "pulse"
            },
            "operator": "="
        },
        {
            "path": "introduction/bootTime",
            "name": "启动时间大于",
            "id": "2",
            "nameEn": "bootTime big than",
            "conflictType": "DEVICE_STATUS",
            "type": "int",
            "strategy": {
                "trigger": "reverse"
            },
            "operator": ">",
            "min": "10",
            "max": "80",
            "unit": "秒",
            "unitEn": "s"
        },
        {
            "path": "introduction/bootTime",
            "name": "启动时间小于",
            "id": "3",
            "nameEn": "bootTime less than",
            "conflictType": "DEVICE_STATUS",
            "type": "int",
            "strategy": {
                "trigger": "reverse"
            },
            "operator": "<",
            "min": "0",
            "max": "100",
            "unit": "秒",
            "unitEn": "s"
        },
        {
            "path": "introduction/bootTime",
            "name": "启动时间等于",
            "id": "4",
            "nameEn": "bootTime equal than",
            "conflictType": "DEVICE_STATUS",
            "type": "int",
            "strategy": {
                "trigger": "reverse"
            },
            "operator": "=",
            "min": "0",
            "max": "100",
            "unit": "秒",
            "unitEn": "s"
        }
    ],
    "actionUIInfo": [
        {
            "type": "enum",
            "name": "编程",
            "id": "1",
            "nameEn": "on",
            "conflictType": "DEVICE_EVENT",
            "deviceCmd": [
                {
                    "sid": "washer",
                    "propertyInfo": [
                        {
                            "type": "ACTION_VALUE",
                            "characteristics": "program"
                        }
                    ]
                }
            ],
            "uiInfo": [
                {
                    "descCh": "ECO经济洗/节能",
                    "descEn": "EC0",
                    "enumVal": "1"
                },
                {
                    "descCh": "快洗",
                    "descEn": "fast",
                    "enumVal": "2"
                },
                {
                    "descCh": "混合洗",
                    "descEn": "mix",
                    "enumVal": "3"
                },
                {
                    "descCh": "超净洗",
                    "descEn": "超净洗",
                    "enumVal": "4"
                },
                {
                    "descCh": "筒自洁",
                    "descEn": "筒自洁",
                    "enumVal": "5"
                },
                {
                    "descCh": "单脱水",
                    "descEn": "单脱水",
                    "enumVal": "6"
                }
            ]
        }
    ]
}
`;