/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import XComponentContext from '../interface/XComponentContext';
import Logger from '../utils/Logger';

const TAG = '[XComponentDisplaySoloist]';
const START = 'Start';
const STOP = 'Stop';

@Entry
@Component
struct Index {
  @State status1: string = START;
  @State isOn1: boolean = false;
  @State status2: string = START;
  @State isOn2: boolean = false;
  @State status3: string = START;
  @State isOn3: boolean = false;
  private xComponentContext1: XComponentContext | undefined = undefined;
  private xComponentContext2: XComponentContext | undefined = undefined;
  private xComponentContext3: XComponentContext | undefined = undefined;

  aboutToDisappear(): void {
    Logger.info(TAG, 'aboutToDisappear');
    if (this.xComponentContext1) {
      this.xComponentContext1.unregister();
      this.xComponentContext1.destroy();
    }
    if (this.xComponentContext2) {
      this.xComponentContext2.unregister();
      this.xComponentContext2.destroy();
    }
    if (this.xComponentContext3) {
      this.xComponentContext3.unregister();
      this.xComponentContext3.destroy();
    }
  }

  Execute(component: XComponentContext, flg: boolean): string {
    if (flg) {
      component.register();
      return STOP;
    } else {
      component.unregister();
      return START;
    }
  }

  build() {
    Column() {
      Row() {
        Text('30hz')
          .fontWeight(FontWeight.Bold)
          .fontSize(12)
          .fontColor(Color.Red)
          .textAlign(TextAlign.End)
          .width(40)
          .height(30)

        Button(this.status1)
          .id('Start30')
          .controlSize(ControlSize.SMALL)
          .onClick((): void => {
            if (this.xComponentContext1) {
              this.isOn1 = !(this.isOn1);
              this.status1 = this.Execute(this.xComponentContext1, this.isOn1);
            }
          }).margin(4)

        XComponent({ id: 'xcomponentId30', type: XComponentType.SURFACE, libraryname: 'entry' })
          .onLoad((xComponentContext) => {
            this.xComponentContext1 = xComponentContext as XComponentContext;
          }).width('640px')
          .backgroundColor(Color.White);
      }.height('30%')

      Row() {
        Text('60hz')
          .fontWeight(FontWeight.Bold)
          .fontSize(12)
          .fontColor(Color.Red)
          .textAlign(TextAlign.End)
          .width(40)
          .height(30)

        Button(this.status2)
          .id('Start60')
          .controlSize(ControlSize.SMALL)
          .onClick((): void => {
            if (this.xComponentContext2) {
              this.isOn2 = !(this.isOn2);
              this.status2 = this.Execute(this.xComponentContext2, this.isOn2);
            }
          }).margin(4)

        XComponent({ id: 'xcomponentId60', type: XComponentType.SURFACE, libraryname: 'entry' })
          .onLoad((xComponentContext) => {
            this.xComponentContext2 = xComponentContext as XComponentContext;
          }).width('640px')
          .backgroundColor(Color.White);
      }.height('30%')

      Row() {
        Text('120hz')
          .fontWeight(FontWeight.Bold)
          .fontSize(12)
          .fontColor(Color.Red)
          .textAlign(TextAlign.End)
          .width(40)
          .height(30)

        Button(this.status3)
          .id('Start120')
          .controlSize(ControlSize.SMALL)
          .onClick((): void => {
            if (this.xComponentContext3) {
              this.isOn3 = !(this.isOn3);
              this.status3 = this.Execute(this.xComponentContext3, this.isOn3);
            }
          }).margin(4)

        XComponent({ id: 'xcomponentId120', type: XComponentType.SURFACE, libraryname: 'entry' })
          .onLoad((xComponentContext) => {
            this.xComponentContext3 = xComponentContext as XComponentContext;
          }).width('640px')
          .backgroundColor(Color.White);
      }.height('30%')
    }
  }
}