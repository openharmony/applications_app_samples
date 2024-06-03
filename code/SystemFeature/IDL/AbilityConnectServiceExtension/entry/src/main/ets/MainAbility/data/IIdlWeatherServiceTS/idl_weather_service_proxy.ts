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

import rpc from '@ohos.rpc'
import { updateWeatherCallback } from './i_idl_weather_service'
import IIdlWeatherService from './i_idl_weather_service'
import Logger from '../../../util/Logger'

export default class IdlWeatherServiceProxy implements IIdlWeatherService {
  constructor(proxy) {
    this.proxy = proxy
  }

  updateWeather(data: number, callback: updateWeatherCallback): void {
    let _option = new rpc.MessageOption(0)
    let _data = new rpc.MessageParcel()
    let _reply = new rpc.MessageParcel()
    _data.writeInt(data)
    this.proxy.sendRequest(IdlWeatherServiceProxy.COMMAND_UPDATE_WEATHER, _data, _reply, _option).then(function (result) {
      if (result.errCode === 0) {
        let _errCode = result.reply.readInt()
        if (_errCode != 0) {
          let _returnValue = undefined
          callback(_errCode, _returnValue)
          return
        }
        let _returnValue = result.reply.readInt()
        callback(_errCode, _returnValue)
      } else {
        Logger.error("sendRequest failed, errCode: " + result.errCode)
      }
    })
  }

  static readonly COMMAND_UPDATE_WEATHER = 1
  private proxy
}

