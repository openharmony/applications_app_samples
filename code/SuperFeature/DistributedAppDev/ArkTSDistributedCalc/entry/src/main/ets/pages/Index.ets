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
import mediaQuery from '@ohos.mediaquery'
import Logger from '../model/Logger'
import { ButtonComponent } from '../common/ButtonComponent'
import { ButtonComponentHorizontal } from '../common/ButtonComponentHorizontal'
import { InputComponent } from '../common/InputComponent'
import { KvStoreModel } from '../model/KvStoreModel'
import { RemoteDeviceModel } from '../model/RemoteDeviceModel'
import { TitleBarComponent } from '../common/TitleBarComponent'
import { isOperator, calc } from '../model/Calculator'

const TAG: string = 'Index'
const EXIT: string = 'exit'
const DATA_CHANGE: string = 'dataChange'

@Entry
@Component
struct Index {
  @State isLand: boolean = false
  @State result: string = ''
  @State @Watch('dataChange') expression: string = ''
  @State isDistributed: boolean = false
  @State isShow: boolean = false
  private listener = mediaQuery.matchMediaSync('screen and (min-aspect-ratio: 1.5) or (orientation: landscape)')
  private kvStoreModel: KvStoreModel = new KvStoreModel()
  private remoteDeviceModel: RemoteDeviceModel = new RemoteDeviceModel()

  onLand = (mediaQueryResult) => {
    Logger.debug(TAG, `onLand: mediaQueryResult.matches= ${mediaQueryResult.matches}`)
    if (mediaQueryResult.matches) {
      this.isLand = true
    } else {
      this.isLand = false
    }
  }

  dataChange() {
    Logger.info(TAG, `dataChange, expression = ${this.expression}`)
    this.kvStoreModel.put(DATA_CHANGE, this.expression)
  }

  isOperator(operator) {
    return (
      operator === '+' || operator === '-' || operator === '*' || operator === '/'
    )
  }

  onInputValue = (value) => {
    Logger.info(TAG, `this.isLand=${this.isLand}`)
    if (value === 'C') { // 当用户点击C按钮，表达式和运算结果归0
      this.expression = ''
      this.result = ''
      return
    } else if (value === '') {
      this.expression = this.expression.substring(0, this.expression.length - 1)
      this.result = this.result = calc(this.expression)
      if (!this.expression.length) {
        this.result = ''
        Logger.info(TAG, `handleBackspace`)
      }
    } else if (isOperator(value)) {
      Logger.info(TAG, `value=${value}`)
      let size = this.expression.length;
      if (size) {
        const last = this.expression.charAt(size - 1);
        if (isOperator(last)) {
          this.expression = this.expression.substring(0, this.expression.length - 1);
        }
      }
      if (!this.expression && (value === '*' || value === '/')) {
        return
      }
      this.expression += value
    } else if (value === '=') {
      this.result = calc(this.expression)
      if (this.result !== '' && this.result !== undefined) {
        this.expression = this.result
        this.result = ''
      }
    } else {
      this.expression += value
      this.result = calc(this.expression)
    }
  }

  async aboutToAppear() {
    this.listener.on('change', this.onLand)
    let context = getContext(this) as any
    await context.requestPermissionsFromUser(['ohos.permission.DISTRIBUTED_DATASYNC'])
    Logger.info(TAG, `grantPermission,requestPermissionsFromUser`)
    if (AppStorage.Get('isRemote') === 'isRemote') {
      this.isDistributed = true
      this.isShow = true
    }
    this.kvStoreModel.setOnMessageReceivedListener(context, DATA_CHANGE, (value) => {
      Logger.debug(TAG, `DATA_CHANGE: ${value},this.isDistributed = ${this.isDistributed}`)
      if (this.isDistributed) {
        if (value.search(EXIT) !== -1) {
          Logger.info(TAG, `EXIT ${EXIT}`)
          context.terminateSelf((error) => {
            Logger.error(TAG, `terminateSelf finished, error= ${error}`)
          })
        } else {
          if (value === 'null') {
            this.expression = ''
          } else {
            this.expression = value
          }
          if (this.isOperator(this.expression.substr(this.expression.length - 1, this.expression.length))) {
            this.result = calc(this.expression.substring(0, this.expression.length - 1))
          } else {
            this.result = calc(this.expression)
          }
        }
      }
    })
  }

  startAbilityCallBack = (key: string) => {
    Logger.info(TAG, `startAbilityCallBack ${key}`)
    if (DATA_CHANGE === key) {
      this.kvStoreModel.put(DATA_CHANGE, this.expression)
    }
    if (EXIT === key) {
      this.kvStoreModel.put(DATA_CHANGE, EXIT)
    }
  }

  build() {
    Column() {
      TitleBarComponent({
        isLand: this.isLand,
        startAbilityCallBack: this.startAbilityCallBack,
        remoteDeviceModel: this.remoteDeviceModel,
        isDistributed: $isDistributed,
        isShow: this.isShow
      })
      if (this.isLand) {
        Row() {
          InputComponent({ isLand: this.isLand, result: $result, expression: $expression })
          ButtonComponentHorizontal({ onInputValue: this.onInputValue })
        }
        .width('100%')
        .layoutWeight(1)
      } else {
        Column() {
          InputComponent({ isLand: this.isLand, result: $result, expression: $expression })
          ButtonComponent({ onInputValue: this.onInputValue })
        }
        .width('100%')
      }
    }
    .width('100%')
    .height('100%')
  }
}