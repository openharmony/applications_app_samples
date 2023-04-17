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

export default class IdlWeatherServiceStub extends rpc.RemoteObject implements IIdlWeatherService {
  constructor(des: string) {
    super(des)
  }

  onRemoteRequest(code: number, data, reply, option): boolean {
    Logger.info("onRemoteRequest called, code = " + code)
    switch (code) {
      case IdlWeatherServiceStub.COMMAND_UPDATE_WEATHER: {
        let _data = data.readInt()
        this.updateWeather(_data, (errCode, returnValue) => {
          reply.writeInt(errCode)
          if (errCode == 0) {
            reply.writeInt(returnValue)
          }
        })
        return true
      }
      default: {
        Logger.error("invalid request code" + code)
        break
      }
    }
    return false
  }

  updateWeather(data: number, callback: updateWeatherCallback): void {
  }

  static readonly COMMAND_UPDATE_WEATHER = 1
}

