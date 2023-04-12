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

import ServiceExtension from '@ohos.app.ability.ServiceExtensionAbility'
import IdlWeatherServiceStub from '../MainAbility/data/IIdlWeatherServiceTS/idl_weather_service_stub'
import { updateWeatherCallback } from "../MainAbility/data/IIdlWeatherServiceTS/i_idl_weather_service"
import { getUpdateTemperature } from '../mock/RequestData'
import Logger from '../util/Logger'

class WeatherServiceStub extends IdlWeatherServiceStub {
  constructor(des) {
    super(des)
  }

  updateWeather(data: number, callback: updateWeatherCallback): void {
    let temperature = getUpdateTemperature()
    callback(0, temperature)
    Logger.info(`testIntTransaction: temperature: ${temperature}`)
  }
}

export default class ServiceExtAbility extends ServiceExtension {
  onCreate(want) {
    Logger.info(`onCreate, want: ${want.abilityName}`)
  }

  onRequest(want, startId) {
    Logger.info(`onRequest, want: ${want.abilityName}`)
  }

  onConnect(want) {
    Logger.info(`onConnect , want: ${want.abilityName}`)
    return new WeatherServiceStub("weather service stub")
  }

  onDisconnect(want) {
    Logger.info(`onDisconnect, want: ${want.abilityName}`)
  }

  onDestroy() {
    Logger.info(`onDestroy`)
  }
}