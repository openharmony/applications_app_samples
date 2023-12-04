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


import { ColumnOperation } from '../components/ColumnOperation';
import { showAlertDialog } from '../util/AlertDialogUtil';
import { PowerManagerUtil } from '../util/PowerManagerUtil';
import { SelectDialog } from '../components/SelectDialog';
import { getString, getStringArray } from '@ohos/common/src/main/ets/util/ResourceUtil';
import power from '@ohos.power';

@Preview
@Component
export struct PowerManager {
  @State result: string = '';
  @State powerModeNames: Array<string> = [];
  dialogController: CustomDialogController = new CustomDialogController({
    builder: SelectDialog({
      menus: this.powerModeNames,
      doOperation: (index) => {
        this.setPowerMode(PowerManagerUtil.powerModes[index])
      }
    }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  });

  build() {
    Scroll() {
      Column() {
        Row() {
          Text(this.result)
            .fontWeight(FontWeight.Medium)
            .fontSize(20)
        }
        .alignItems(VerticalAlign.Top)
        .width('100%')
        .backgroundColor($r("app.color.white"))
        .height(160)
        .padding(16)
        .borderRadius(20)
        .margin({ top: 16 })

        ColumnOperation({ operationRes: $r('app.strarray.power_operations'), doOperation: this.doOperation })
      }
      .width('100%')
      .padding(4)
    }
    .scrollBar(BarState.Off)
  }

  async setPowerMode(mode: power.DevicePowerMode) {
    try {
      await PowerManagerUtil.setPowerMode(mode);
      this.result = `${getString($r('app.string.power_mode'))}${await PowerManagerUtil.getPowerModeName()}`;
    } catch (err) {
      this.result = `${getString($r('app.string.power_mode'))}${JSON.stringify(err)}`;
    }
  }

  doOperation = async (index: number) => {
    switch (index) {
      case 0:
        PowerManagerUtil.suspend();
        this.result = `${getString($r('app.string.suspend_status'))}true`;
        break
      case 1:
        showAlertDialog($r('app.string.turnOff'), $r('app.string.questionTurnOff'), () => {
          this.result = getString($r('app.string.turnOff'));
          PowerManagerUtil.shutdown('shutdown_test');
        })
        break
      case 2:
        showAlertDialog($r('app.string.restart'), $r('app.string.questionRestart'), () => {
          this.result = getString($r('app.string.restart'));
          PowerManagerUtil.reboot('reboot_test');
        })
        break
      case 3:
        this.powerModeNames = await getStringArray($r('app.strarray.power_mode'));
        this.dialogController.open();
        break
      default:
        break
    }
  }
}