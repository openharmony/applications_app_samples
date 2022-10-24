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

export class GobangConst {
  static readonly STORE_ID: string = 'game'
  static readonly DEVICE_A: string = 'deviceA'
  static readonly DEVICE_B: string = 'deviceB'
  static readonly EXIT: string = 'exit'
  static readonly CHESS_COLOR: Array<string> = ['black', 'white']
  static readonly WIDTH: number = 720
  static readonly HEIGHT: number = 1280
  static readonly SIZE: number = 16
  static readonly AUTH_TYPE_NUMBER:number = 1
  static readonly DEVICE_TYPE_NUMBER:number = 0
  static readonly RANGE_NUMBER:number = 1000
  static readonly CHECK_MODE: [number, number][] = [[1, 0], [0, 1], [1, 1], [1, -1]]
  static readonly NUMBER: number = 65536
}
