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
import { GoodsInfo } from '../../model/DetailMode';

@Component
export struct Choice {
  @LocalStorageProp('goodsInfo') goodsInfo: GoodsInfo = new GoodsInfo();

  build() {
    Row() {
      Text($r('app.string.selected'))
        .fontSize(14)
        .fontColor($r('app.color.blank'))

      Text(this.goodsInfo.introduction)
        .fontSize(14)
        .padding({ left: 16 })
        .textAlign(TextAlign.Start);

      Blank()

      Image($r('app.media.alternative'))
        .width(12)
        .aspectRatio(1)
        .objectFit(ImageFit.Contain)
    }
    .padding(12)
    .width('100%')
    .borderRadius(16)
    .backgroundColor($r('app.color.white'))
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}