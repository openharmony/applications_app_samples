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

import display from '@ohos.display'
import Logger from '../model/Logger'

const TAG: string = '[ShowInfo]'

@CustomDialog
export struct ShowInfo {
  private defaultOrAllScreen?: boolean
  private allScreens?: display.Display[]
  private defaultScreens?: display.Display
  private dialogController?: CustomDialogController
  scroller: Scroller = new Scroller();

  @Builder infoText(types: Resource, infos: string) {
    Row() {
      Text(types)
        .margin({ left: '5%', right: '5%'})
        .fontSize(22)
        .width('35%')
        .fontColor('#182431')
        .textAlign(TextAlign.Start)
      Text(infos)
        .fontSize(22)
        .width('55%')
        .textAlign(TextAlign.End)
        .fontColor('#828a90')
        .id('smallRectId')
    }
    .width('93%')
    .height(54)
    .margin(5)
  }

  screenInfo(types: string) {
    Logger.info(TAG, `defaultOrAllScreen = ${this.defaultOrAllScreen}`)
    let info: string = ''
    let yes: string | undefined = AppStorage.get<string>('yes');
    let no: string | undefined = AppStorage.get<string>('no');
    if (this.defaultOrAllScreen) {
      const SCREEN_INFO: Record<string, string> = {
        "id": `${this.defaultScreens!.id}`,
        "name": `${this.defaultScreens!.name}`,
        "refreshRate": `${this.defaultScreens!.refreshRate}`,
        "width": `${this.defaultScreens!.width}`,
        "height": `${this.defaultScreens!.height}`,
        "alive": `${this.defaultScreens!.alive ? yes : no}`,
        "state": `${this.defaultScreens!.state}`,
        "rotation": `${this.defaultScreens!.rotation}`,
        "densityDPI": `${this.defaultScreens!.densityDPI}`,
        "orientation": `${this.defaultScreens!.orientation}`,
        "densityPixels": `${this.defaultScreens!.densityPixels}`,
        "scaledDensity": `${this.defaultScreens!.scaledDensity}`,
        "xDPI": `${this.defaultScreens!.xDPI}`,
        "yDPI": `${this.defaultScreens!.yDPI}`
      }
      info = SCREEN_INFO[types]
    } else {
      let ids: string = '';
      let refreshRates: string = '';
      let widths: string = '';
      let heights: string = '';
      let names: string = '';
      let alives: string = '';
      let states: string = '';
      let rotations: string = '';
      let densityDPIs: string = '';
      let orientations: string = '';
      let densityPixelszs: string = '';
      let scaledDensitys: string = '';
      let xDPIs: string = '';
      let yDPIs: string = '';


      for (let i = 0; i < this.allScreens!.length; i++) {
        ids = `${ids} ${this.allScreens![i].id}`;
        refreshRates = `${refreshRates} ${this.allScreens![i].refreshRate}`;
        widths = `${widths} ${this.allScreens![i].width}`;
        heights = `${heights} ${this.allScreens![i].height}`;
        names = `${names} ${this.allScreens![i].name}`;
        alives = `${alives} ${this.allScreens![i].alive ? yes : no}`;
        states = `${states} ${this.allScreens![i].state}`;
        rotations = `${rotations} ${this.allScreens![i].rotation}`;
        densityDPIs = `${densityDPIs} ${this.allScreens![i].densityDPI}`;
        orientations = `${orientations} ${this.allScreens![i].orientation}`;
        densityPixelszs = `${densityPixelszs} ${this.allScreens![i].densityPixels}`;
        scaledDensitys = `${scaledDensitys} ${this.allScreens![i].scaledDensity}`;
        xDPIs = `${xDPIs} ${this.allScreens![i].xDPI}`;
        yDPIs = `${yDPIs} ${this.allScreens![i].yDPI}`;
      }
      const SCREENS_INFO: Record<string, string> = {
        "id": ids,
        "name": names,
        "refreshRate": refreshRates,
        "width": widths,
        "height": heights,
        "alive": alives,
        "state": states,
        "rotation": rotations,
        "densityDPI": densityDPIs,
        "orientation": orientations,
        "densityPixels": densityPixelszs,
        "scaledDensity": scaledDensitys,
        "xDPI": xDPIs,
        "yDPI": yDPIs
      }
      info = SCREENS_INFO[types]
    }
    Logger.info(TAG, `this info is ${info}`)
    return info
  }

  build() {
    Column() {
      Text($r('app.string.info'))
        .margin({ left: '10%', right: '10%' ,bottom: '11px'})
        .fontSize(28)
        .width('90%')
        .height(56)
        .id('deviceInfo')

      Column() {
        Scroll(this.scroller) {
          Column() {
            this.infoText($r('app.string.id'), this.screenInfo('id'));
            this.infoText($r('app.string.devname'), this.screenInfo('name'));
            this.infoText($r('app.string.alive'), this.screenInfo('alive'));
            this.infoText($r('app.string.state'), this.screenInfo('state'));
            this.infoText($r('app.string.refreshRate'), this.screenInfo('refreshRate'));
            this.infoText($r('app.string.rotation'), this.screenInfo('rotation'));
            this.infoText($r('app.string.width'), this.screenInfo('width'));
            this.infoText($r('app.string.height'), this.screenInfo('height'));
            this.infoText($r('app.string.densityDPI'), this.screenInfo('densityDPI'));
            this.infoText($r('app.string.orientation'), this.screenInfo('orientation'));
            this.infoText($r('app.string.densityPixels'), this.screenInfo('densityPixels'));
            this.infoText($r('app.string.scaledDensity'), this.screenInfo('scaledDensity'));
            this.infoText($r('app.string.xDPI'), this.screenInfo('xDPI'));
            this.infoText($r('app.string.yDPI'), this.screenInfo('yDPI'));
          }
          .width('100%')
          .borderRadius(10)
          .backgroundColor("#ffffff")
          .alignItems(HorizontalAlign.Start)
        }
        .id('scroller')
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.On)
        .scrollBarColor('#828a90')
        .scrollBarWidth('15px')

        Button($r('app.string.cancel'))
          .id('cancelShow')
          .width('60%')
          .height(40)
          .fontSize(22)
          .fontColor('#007dff')
          .backgroundColor('#ffffff')
          .margin({ top: '12px', left: '20%', right: '20%', bottom: '5%'})
          .onClick(() => {
            this.dialogController!.close();
          })
      }
      .alignItems(HorizontalAlign.Center)
      .backgroundColor("#ffffff")
      .width('100%')
      .height('80%')
      .margin({ left: '5%', right: '5%' })
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#ffffff")
    .onClick(() => {
      this.dialogController!.close();
    })
  }
}