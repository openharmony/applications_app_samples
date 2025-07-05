/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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
import { TitleBar } from '../common/TitleBar';
import { FaultDialog } from '../common/FaultDialog';
import PreferencesManager from '../common/PreferencesManager';

const TAG: string = 'Index';

@Entry
@Component
struct Index {
  @State message: string = 'FaultLog';
  private operates: Resource[] = [$r('app.string.create_fault'), $r('app.string.catch_js_fault'),
  $r('app.string.catch_cpp_fault'), $r('app.string.catch_app_freeze_fault'), $r('app.string.catch_all_fault')];
  private faultDialogController: CustomDialogController | null = null;
  private preferencesManager = new PreferencesManager();

  handleOperate(index: number) {
    switch (index) {
      case 0:
        if (this.faultDialogController === null) {
          this.faultDialogController = new CustomDialogController({
            builder: FaultDialog(),
            autoCancel: true
          });
        }
        this.faultDialogController.open();
        break;
      case 1:
        Logger.info(TAG, 'catch JS_CRASH');
        this.message = this.preferencesManager.getFaultMessage('crashMsg');
        break
      case 2:
        Logger.info(TAG, 'catch CPP_CRASH');
        this.message = this.preferencesManager.getFaultMessage('crashMsg');
        break
      case 3:
        Logger.info(TAG, 'catch APP_FREEZE');
        this.message = this.preferencesManager.getFaultMessage('freezeMsg');
        break
      case 4:
        Logger.info(TAG, 'catch NO_SPECIFIC')
        this.message = this.preferencesManager.getAllFaultMessage();
        break
      default:
        break
    }
  }

  build() {
    Column() {
      TitleBar()

      Scroll() {
        Text(this.message)
          .id('message')
          .textAlign(TextAlign.Start)
          .width('100%')
          .fontSize(22)
      }
      .size({ width: '95%', height: '35%' })
      .border({ width: 1, radius: 20, color: Color.Black })
      .padding(10)
      .margin({ top: 16 })

      Scroll() {
        Column() {
          ForEach(this.operates, (item: Resource, index) => {
            Button(item)
              .id(item.id.toString())
              .type(ButtonType.Capsule)
              .size({ width: '90%', height: 60 })
              .margin({ top: 10 })
              .onClick(() => {
                this.handleOperate(index)
              })
          }, (item: Resource) => JSON.stringify(item))
        }
        .width('100%')
        .padding({ bottom: '8%' })
      }
      .size({ width: '95%', height: '50%' })
    }
    .width('100%')
    .height('100%')
  }
}