/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import RpcTool from '../tool/RpcTool';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { SerialPortStatusManager } from '../tool/SerialPortStatusManager';
import { TemperatureStatusManager } from '../tool/TemperatureStatusManager';
import { promptAction } from '@kit.ArkUI';

@Component
export struct TempShowComponent {
  aboutToAppear() {
    hilog.info(0, 'testTag ui', `aboutToAppear TempShowComponent subscribe`);
    SerialPortStatusManager.subscribe(this.onSerialPortStatusChange);
  }

  @Link temperatureData: string;
  @State readButtonStatus: boolean = false; //读取温度的状态
  private intervalId: number | null = null; //存储定时器ID
  @State serialPortStatus: boolean = false; //监听串口设置的串口状态
  @State timeoutData: string = ''; //用户输入的超时时间（毫秒）
  @Link code: number; //设置超时时间 返回的code
  private onSerialPortStatusChange = (status: boolean) => {
    hilog.info(0, 'testTag ui', `onSerialPortStatusChange  status:${status}`);
    this.serialPortStatus = status;
    hilog.info(0, 'testTag ui', `onSerialPortStatusChange  serialPortStatus status:${this.serialPortStatus}`);
  };

  build() {
    Column({ space: 60 }) {
      //超时时间模块
      Row({ space: 8 }) {
        Text($r('app.string.timeout'))
          .padding({ left: 10 })
        TextInput({ text: this.timeoutData })
          .width(`160`)
          .type(InputType.Number)
          .onChange((value: string) => {
            this.timeoutData = value;
            hilog.info(0, 'testTag ui', `timeoutData value:${this.timeoutData}`);
          })
        Text($r('app.string.millisecond'))
        Button($r('app.string.setting'))
          .width(`100`)
          .onClick(async () => {
            let setTimeout: number = parseFloat(this.timeoutData);
            await RpcTool.getInstance().setTimeOut(setTimeout);
            hilog.info(0, 'testTag ui', `setTimeout code:${this.code}`);
            if (this.code == 31600000) {
              promptAction.showToast({ message: '设置超时时间成功.', duration: 2000 });
            } else {
              promptAction.showToast({ message: '设置超时时间失败.', duration: 2000 });
            }
          })
      }.width('100%')
      .margin({ top: 60 })

      //温度读取模块
      Row({ space: 24 }) {
        Text($r('app.string.temperature'))
          .padding({ left: 10 })

        Column({ space: 5 }) {
          Text(this.temperatureData)
            .width('30%')
            .margin({ left: 20 })
            .textAlign(TextAlign.Center)
          //下划线
          Text()
            .width('30%')
            .margin({ left: 20 })
            .textAlign(TextAlign.Center)
            .borderStyle(BorderStyle.Solid)
            .borderWidth({ bottom: 1 })
            .borderColor(Color.Black)
        }

        Text('℃')
        Button(this.readButtonStatus ? $r('app.string.close_read') : $r('app.string.read_temperature'))
          .backgroundColor(this.readButtonStatus ? 'red' : '')
          .onClick(() => {
            SerialPortStatusManager.subscribe(this.onSerialPortStatusChange);
            if (this.serialPortStatus == true) {
              this.readButtonStatus = !this.readButtonStatus;
              TemperatureStatusManager.notify(this.readButtonStatus);
              this.toggleReadButton();
            } else {
              promptAction.showToast({ message: '串口未打开.', duration: 2000 });
            }
          })
      }.width('100%')
    }
    .width('100%')
    .height('60%')
  }

  //切换按钮状态，并启动或停止循环调用showTemperature
  private toggleReadButton() {
    if (this.serialPortStatus == true) {
      hilog.info(0, 'testTag ui', `readButtonStatus:${this.readButtonStatus}`);
      if (this.readButtonStatus) {
        this.startPolling();
      } else {
        this.stopPolling();
      }
    } else {
      hilog.info(0, 'testTag ui', `Serial port is not opened.`);
      promptAction.showToast({ message: '未打开串口.', duration: 2000 });
    }
  }

  //读取温度，启动循环调用showTemperature接口
  private startPolling() {
    hilog.info(0, 'testTag ui', `enter startPolling`);
    if (this.intervalId == null) {
      this.intervalId = setInterval(() => {
        hilog.info(0, 'testTag ui', `enter setInterval`);
        RpcTool.getInstance().showTemperature();
      }, 500) //2s调用一次
    }
  }

  //读取温度，停止循环调用showTemperature接口
  private stopPolling() {
    hilog.info(0, 'testTag ui', `enter stopPolling`);
    if (this.intervalId != null) {
      clearInterval(this.intervalId);
      this.intervalId = null;
    }
  }
}