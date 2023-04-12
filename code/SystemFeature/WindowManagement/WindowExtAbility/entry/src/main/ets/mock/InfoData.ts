/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

export const INFODATA: Array<{
  name: Resource,
  info: string,
  image: Resource,
  value: Resource,
  flag: boolean,
  index: number,
  uri: string
}> =
  [
    {
      name: $r('app.string.wlan'),
      info: 'WlanExtAbility',
      image: $r('app.media.wlan'),
      value: $r('app.string.ux'),
      flag: true,
      index: 0,
      uri: 'pages/Wlan'
    },
    {
      name: $r('app.string.bluetooth'),
      info: 'BluetoothExtAbility',
      image: $r('app.media.bluetooth'),
      value: $r('app.string.start'),
      flag: true,
      index: 1,
      uri: 'pages/Bluetooth'
    },
    {
      name: $r('app.string.mobile_network'),
      info: 'MobileDataExtAbility',
      image: $r('app.media.mobiledata'),
      value: undefined,
      flag: false,
      index: 2,
      uri: 'pages/MobileData'
    }
  ]

export const WLANDATA: Array<{
  text: Resource,
  info: Resource,
  img: Resource
}> =
  [
    { text: $r('app.string.ux'), info: $r('app.string.save'), img: $r('app.media.wlanLock') },
    { text: $r('app.string.aaa'), info: $r('app.string.encryption'), img: $r('app.media.wlanLock') },
    { text: $r('app.string.bbb'), info: $r('app.string.encryption_not'), img: $r('app.media.noneWlan') },
    { text: $r('app.string.ux_5g'), info: $r('app.string.open'), img: $r('app.media.openWlan') },
  ]

export const RESOURCES: Resource[] = [$r('app.string.mobile_network'), $r('app.string.sim_manager'), $r('app.string.personal_hotspot')]