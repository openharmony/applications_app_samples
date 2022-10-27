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

import Logger from '../util/Logger'
import IdlWeatherServiceProxy from '../MainAbility/data/IIdlWeatherServiceTS/idl_weather_service_proxy'

const BUNDLE_NAME = "com.example.abilityconnectserviceextension"
const SERVICE_EXTENSION_ABILITY_NAME = "ServiceExtAbility"
const ERROR_CODE = -1 // 失败
const SUCCESS_CODE = 0 // 成功

export default class HomeFeature {
  connection = -1 // 初始值
  remoteCallback = null
  context = null
  options = null

  constructor(context) {
    this.context = context
    this.options = {
      outObj: this,
      // 连接成功时回调
      onConnect: function (elementName, proxy) {
        Logger.info(`onConnect success`)
        // 接收来自服务返回的实例
        let weatherProxy = new IdlWeatherServiceProxy(proxy)
        weatherProxy.updateWeather(123, this.outObj.remoteCallback)
      },
      onDisconnect: function () {
        Logger.info(`onDisconnect`)
      },
      onFailed: function () {
        Logger.info(`onFailed`)
      }
    }
  }

  connectServiceExtAbility(callback) {
    Logger.info(`connectServiceExtAbility`)
    this.remoteCallback = callback
    let want = {
      bundleName: BUNDLE_NAME,
      abilityName: SERVICE_EXTENSION_ABILITY_NAME
    }
    this.connection = this.context.connectAbility(want, this.options)
    Logger.info(`connectServiceExtAbility result:${this.connection}`)
  }

  disconnectServiceExtAbility(callback) {
    Logger.info(`disconnectServiceExtAbility`)
    this.context.disconnectAbility(this.connection).then((data) => {
      Logger.info(`disconnectAbility success:${JSON.stringify(data)}`)
      callback(SUCCESS_CODE)
    }).catch((error) => {
      Logger.error(`disconnectAbility failed:${JSON.stringify(error)}`)
      callback(ERROR_CODE)
    })
  }
}