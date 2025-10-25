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
import Logger from '../model/Logger';
import { ButtonComponent } from '../common/ButtonComponent';
import { ButtonComponentHorizontal } from '../common/ButtonComponentHorizontal';
import { InputComponent } from '../common/InputComponent';

import { RemoteDeviceModel } from '../model/RemoteDeviceModel';
import { TitleBarComponent } from '../common/TitleBarComponent';
import { isOperator, calc } from '../model/Calculator';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import mediaquery from '@ohos.mediaquery';
import { KvStoreModel } from '../model/KvStoreModel';
import { emitter } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

const TAG: string = 'Index';
const EXIT: string = 'exit';
const DATA_CHANGE: string = 'dataChange';

@Entry
@Component
struct Index {
  @State isCallback: boolean = false;
  @State isLand: boolean = false;
  @State result: string = '';
  @State @Watch('dataChange') expression: string = '';
  @State isDistributed: boolean = false;
  @State isShow: boolean = false;
  private kvStoreModel: KvStoreModel | undefined = AppStorage.get('KvStoreModel');
  private listener = this.getUIContext()
    .getMediaQuery()
    .matchMediaSync('screen and (min-aspect-ratio: 1.5) or (orientation: landscape)');
  private remoteDeviceModel: RemoteDeviceModel = new RemoteDeviceModel();
  onLand = (mediaQueryResult: mediaquery.MediaQueryResult) => {
    Logger.info(TAG, `onLand: mediaQueryResult.matches= ${mediaQueryResult.matches}`);
    if (mediaQueryResult.matches) {
      this.isLand = true
    } else {
      this.isLand = false
    }
  };

  dataChange() {
    Logger.info(TAG, `dataChange, expression = ${this.expression}`);
    Logger.info(TAG, `dataChange, isCallback = ${this.isCallback}`);
    if (this.isCallback) {
      this.isCallback = false;
    } else {
      // 如果是第一次同步数据，会通过startAbilityCallBack调用，所以此处不需要调用put
      if (!this.kvStoreModel?.isFirstSync) {
        Logger.info(TAG, `dataChange, put start`)
        this.kvStoreModel?.put(DATA_CHANGE, this.expression, false);
      }
    }
  }

  onInputValue = (value: string) => {
    Logger.info(TAG, `this.isLand=${this.isLand}`);
    Logger.info(TAG, `onInputValue=${value}`);
    if (value === 'C') { // 当用户点击C按钮，表达式和运算结果归0
      this.expression = '';
      this.result = '';
      return;
    } else if (value === 'D') {
      this.expression = this.expression.substring(0, this.expression.length - 1);
      this.result = this.result = calc(this.expression);
      if (!this.expression.length) {
        this.result = '';
        Logger.info(TAG, `handleBackspace`);
      }
    } else if (isOperator(value)) {
      Logger.info(TAG, `value=${value}`);
      let size = this.expression.length;
      if (size) {
        const last = this.expression.charAt(size - 1);
        if (isOperator(last)) {
          this.expression = this.expression.substring(0, this.expression.length - 1);
        }
      }
      if (!this.expression && (value === '*' || value === '/')) {
        return;
      }
      this.expression += value;
    } else if (value === '=') {
      this.result = calc(this.expression);
      if (this.result !== '' && this.result !== undefined) {
        this.expression = this.result;
        this.result = '';
      }
    } else {
      const hasSymbol: boolean = this.expression.indexOf('+') !== -1 || this.expression.indexOf('-') !== -1 ||
        this.expression.indexOf('*') !== -1 || this.expression.indexOf('/') !== -1;
      if (this.expression && !this.result && !hasSymbol) {
        this.expression = '';
      }
      this.expression += value;
      this.result = calc(this.expression);
    }
  }

  aboutToDisappear() {
    Logger.info(TAG, `index disappear`);
    emitter.off('dataChange');
  }

  async aboutToAppear() {
    this.listener.on('change', this.onLand)
    let context: common.UIAbilityContext = AppStorage.get('UIAbilityContext') as common.UIAbilityContext;
    let atManager = abilityAccessCtrl.createAtManager();
    try {
      atManager.requestPermissionsFromUser(context, ['ohos.permission.DISTRIBUTED_DATASYNC']).then((data) => {
        Logger.info(TAG, `grantPermission,requestPermissionsFromUser`);
        Logger.info(TAG, `data: ${JSON.stringify(data)}`);
      }).catch((err: object) => {
        Logger.info(TAG, `err: ${JSON.stringify(err)}`);
      })
    } catch (err) {
      Logger.info(TAG, `catch err->${JSON.stringify(err)}`);
    }
    let isRemote: string | undefined = AppStorage.get('isRemote');
    Logger.info(TAG, `aboutToAppear isRemote = ${isRemote}`);

    if (isRemote === 'isRemote' ? true : false) {
      this.isDistributed = true;
      this.isShow = true;
      // 如果设备是被远程拉起的设备，则不需要增加延迟时间，因为此时应用已经启动了，不涉及耗时增加
      this.kvStoreModel!.isFirstSync = false;
    }

    emitter.on('dataChange', (data: emitter.EventData) => {
      let value: string = data.data?.value;
      Logger.info(TAG, `dataChange: ${value},this.isDistributed = ${this.isDistributed}`);
      if (this.isDistributed) {
        if (value.search('exit') !== -1) {
          Logger.info(TAG, `EXIT`);
          context.terminateSelf((error) => {
            Logger.error(TAG, `terminateSelf finished, error= ${error}`);
          })
        } else {
          this.isCallback = true;
          if (value === 'null') {
            this.expression = ''
          } else {
            this.expression = value
          }
          if (isOperator(this.expression.substr(this.expression.length - 1, this.expression.length))) {
            this.result = calc(this.expression.substring(0, this.expression.length - 1))
          } else {
            this.result = calc(this.expression)
          }
        }
      }
    });
  }

  startAbilityCallBack = (key: string) => {
    Logger.info(TAG, `startAbilityCallBack ${key}`);
    this.kvStoreModel!.isFirstSync = false;
    // 拉起另一台设备、第一次同步数据时，如果数据不为空，则同步数据
    if (DATA_CHANGE === key && this.expression.length > 0) {
      this.kvStoreModel?.put(DATA_CHANGE, this.expression, true);
    }
    if (EXIT === key) {
      this.kvStoreModel?.put(DATA_CHANGE, EXIT, false);
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