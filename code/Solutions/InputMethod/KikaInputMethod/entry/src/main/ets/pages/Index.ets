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
import { EditView } from '../components/EditView';
import { InputHandler } from '../model/KeyboardController';
import {
  MenuType,
  SubMenuType,
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
import { Submenu } from '../components/Submenu';
import { TopMenu } from '../components/TopMenu';

const DEVICE_TYPE: string = deviceInfo.deviceType;
const TAG: string = 'index->';

@Entry
@Component
struct Index {
  @Provide menuType: number = MenuType.NORMAL;
  @StorageLink('inputPattern') @Watch('inputPatternChange') inputPattern: InputType = InputType.Normal
  @StorageLink('submenuType') submenuType: number = SubMenuType.NORMAL;
  @StorageLink('isLandscape') @Watch('change') isLandscape: boolean = false;
  @StorageLink('isRkDevice') isRkDevice: boolean = true;
  @StorageLink('inputStyle') inputStyle: KeyStyle = StyleConfiguration.getInputStyle(this.isLandscape, this.isRkDevice, DEVICE_TYPE);

  onBackPress(): boolean {
    Log.showInfo(TAG, 'kikaInput onBackPress');
    this.submenuType = SubMenuType.NORMAL;
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
          if (this.submenuType > SubMenuType.NORMAL) {
            if (this.submenuType === SubMenuType.MENU) {
              Submenu()
            } else {
              EditView();
            }
          } else {
            if (this.menuType === MenuType.NORMAL) {
              KeyMenu()
            } else if (this.menuType === MenuType.NUMBER) {
              NumberMenu()
            } else {
              SymbolMenu()
            }
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