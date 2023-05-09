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
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import power from '@ohos.power';
import { ColumnOperation } from '../components/ColumnOperation';
import { getString } from '@ohos/common';
import { showAlertDialog } from '../util/AlertDialogUtil';

@Preview
@Component
export struct PowerManager {
  @State result: string = '';

  build() {
    Scroll() {
      Column() {
        Text(this.result)
          .width('100%')
          .height(100)
          .backgroundColor('#DFDFDF')
          .fontSize(20)
          .margin({ top: 20 })
          .textAlign(TextAlign.Start)
          .padding(10)
        ColumnOperation({ operationRes: $r('app.strarray.power_operations'), doOperation: this.doOperation })
      }
      .width('100%')
      .padding(16)
    }
    .scrollBar(BarState.Off)
    .align(Alignment.Start)
  }

  doOperation = (index: number) => {
    switch (index) {
      case 0:
        showAlertDialog($r('app.string.turnOff'), $r('app.string.questionTurnOff'), ()=>{
          this.result = getString($r('app.string.turnOff'));
          power.shutdown('shutdown_test');
        })
        break;
      case 1:
        showAlertDialog($r('app.string.restart'), $r('app.string.questionRestart'), ()=>{
          this.result = getString($r('app.string.restart'));
          power.reboot('reboot_test')
        })
        break;
      case 2:
        let isActive = power.isActive();
        this.result = `${getString($r('app.string.screen_state'))}${isActive}`
        break;
      default:
        break;
    }
  }
}