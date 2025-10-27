/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import RpcTool from '../tool/RpcTool';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { rpc } from '@kit.IPCKit';
import DevParams from '../utils/DevParams';

interface Options {
  value:string;
}
@Component
@Preview
export struct DevParamsComponent {
  @Link devParams: DevParams;
  @State index: number = 0;
  @State bindButtonState: boolean = true;

  aboutToAppear() {
  }

  build() {
    Column({space:30}) {
      Row() {
        Text($r('app.string.dev_type'))
          .padding({left:10})
          .fontSize(20)
        Text(this.devParams.devType.toString())
          .width('40%')
          .backgroundColor('#0C182431')
          .margin({left: 8})
          .height('6%')
      }.width('100%')
      .margin({left:35})

      Row() {
        Text($r('app.string.vendor_id'))
          .padding({left:10})
          .fontSize(20)
        Text(this.devParams.vendorId)
          .width('40%')
          .backgroundColor('#0C182431')
          .margin({left: 28})
          .height('6%')
      }.width('100%')
      .margin({left:35})

      Row() {
        Text($r('app.string.product_id'))
          .padding({left:10})
          .fontSize(20)
        Text(this.devParams.productId)
          .width('40%')
          .backgroundColor('#0C182431')
          .margin({left: 8})
          .height('6%')
      }.width('100%')
      .margin({left:35})

      Row() {
        Text($r('app.string.revision'))
          .padding({left:10})
          .fontSize(20)
        Text(this.devParams.revision)
          .width('40%')
          .backgroundColor('#0C182431')
          .margin({left: 8})
          .height('6%')
      }.width('100%')
      .margin({left:35})

      Row() {
        Text($r('app.string.volume'))
          .padding({left:10})
          .fontSize(20)
        Text(this.devParams.volumeStrType)
          .width('40%')
          .backgroundColor('#0C182431')
          .margin({left: 48})
          .height('6%')
      }.width('100%')
      .margin({left:35})

      Row() {
        Text($r('app.string.block_num'))
          .padding({left:10})
          .fontSize(20)
        Text(this.devParams.blockNum.toString())
          .width('40%')
          .backgroundColor('#0C182431')
          .margin({left: 48})
          .height('6%')
      }.width('100%')
      .margin({left:35})

      Row() {
        Text($r('app.string.block_volume'))
          .padding({left:10})
          .fontSize(20)
        Text(this.devParams.blockVolume.toString())
          .width('40%')
          .backgroundColor('#0C182431')
          .margin({left: 28})
          .height('6%')
      }.width('100%')
      .margin({left:35})
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}