/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF InputStyle KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import deviceInfo from '@ohos.deviceInfo';
import Log from '../model/Log';
import { InputHandler } from '../model/KeyboardController';
import {
  MenuType,
  keySourceListData,
  numberSourceListData,
  symbolSourceListData,
  keySourceListType,
  sourceListType
} from '../model/KeyboardKeyData';
import { KeyMenu } from '../components/KeyMenu';
import { NumberMenu } from '../components/NumberMenu';
import { StyleConfiguration, KeyStyle } from '../common/StyleConfiguration';
import { SymbolMenu } from '../components/SymbolMenu';
import { TopMenu } from '../components/TopMenu';

const DEVICE_TYPE: string = deviceInfo.deviceType;
const TAG: string = 'index->';

@Entry
@Component
struct Index {
  private keyList: keySourceListType[] = keySourceListData;
  private numberList: sourceListType[] = numberSourceListData;
  private symbolList: sourceListType[] = symbolSourceListData;
  @Provide menuType: number = MenuType.NORMAL;
  @StorageLink('inputPattern') @Watch('inputPatternChange') inputPattern: InputType = InputType.Normal
  @StorageLink('isLandscape') @Watch('change') isLandscape: boolean = false;
  @StorageLink('isRkDevice') isRkDevice: boolean = true;
  @StorageLink('inputStyle') inputStyle: KeyStyle = StyleConfiguration.getInputStyle(this.isLandscape, this.isRkDevice, DEVICE_TYPE);

  onBackPress(): boolean {
    Log.showInfo(TAG, 'kikaInput onBackPress');
    InputHandler.getInstance().hideKeyboardSelf();
    return true;
  }

  inputPatternChange(): void {
    if (this.inputPattern === InputType.Number || this.inputPattern === InputType.PhoneNumber) {
      this.menuType = MenuType.NUMBER;
    } else {
      this.menuType = MenuType.NORMAL;
    }
  }

  change(): void {
    AppStorage.set('inputStyle', StyleConfiguration.getInputStyle(this.isLandscape, this.isRkDevice, DEVICE_TYPE));
  }

  build() {
    Stack() {
      Column() {
        TopMenu()
        Column() {
          if (this.menuType === MenuType.NORMAL) {
            KeyMenu({ keyList: this.keyList })
          } else if (this.menuType === MenuType.NUMBER) {
            NumberMenu({ numberList: this.numberList, })
          } else {
            SymbolMenu({ symbolList: this.symbolList, })
          }
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#D5D8DD')
      }
      .height('100%')
    }
    .height('100%')
    .backgroundColor(Color.White)
  }
}