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
import { VideoSettingBtnsType } from './Type'

export const settingButton : VideoSettingBtnsType[] =  [
  {
    id: 's_1',
    name: '分辨率',
    disable: false,
    items: [

      {
        id: 's_1_1',
        name: '4K',
        val: '3840x2160'
      },
      {
        id: 's_1_2',
        name: '2K',
        val: '2560x1440'
      },
      {
        id: 's_1_3',
        name: '1080P',
        val: '1920x1080'
      }
    ]
  },
  {
    id: 's_2',
    name: '倍速',
    disable: false,
    items: [

      {
        id: 's_2_1',
        name: '2.0 X',
        val: '2.0',
        param: 4
      },
      {
        id: 's_2_2',
        name: '1.75 X',
        val: '1.75',
        param: 3
      },
      {
        id: 's_2_3',
        name: '1.25 X',
        val: '1.25',
        param: 2
      },
      {
        id: 's_2_4',
        name: '1.0 X',
        val: '1.0',
        param: 1
      },
      {
        id: 's_2_5',
        name: '0.75 X',
        val: '0.75',
        param: 0
      }
    ]
  },
  {
    id: 's_3',
    name: '声道',
    disable: false,
    items: [
      {
        id: 's_3_1',
        name: '立体声',
        param: 0
      },
      {
        id: 's_3_6',
        name: '右声道',
        param: 5
      },
      {
        id: 's_3_7',
        name: '左声道',
        param: 6
      }
    ]
  },
  {

    id: 's_4',
    name: '音轨',
    disable: false,
    items: []
  },
  {

    id: 's_5',
    name: '画面尺寸',
    disable: false,
    items: [
      {
        id: 's_5_1',
        name: '4:3',
        param: 0
      },
      {
        id: 's_5_2',
        name: '16:9',
        param: 1
      },
      {
        id: 's_4_3',
        name: '自适应',
        param: 6
      }
    ]
  }
];