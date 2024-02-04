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
import image from '@ohos.multimedia.image';
import { CommonConstants } from '../common/constant/CommonConstants';
import { ImageUtils } from '../utils/ImageUtil';
import { AdjustImageView } from './AdjustImageView';
import { AdjustThreadView } from './AdjustThreadView';
import { ImageView } from './ImageView';

@Component
export struct ThreadDataTransferHomePage {
  @Provide pixelMap: image.PixelMap | undefined = undefined;
  @Provide isPixelMapChanged: boolean = false;
  @Provide isParamsByTransfer: boolean = false;
  @Provide currentAdjustData: number = CommonConstants.ADJUST_SLIDER_VALUE;
  @Provide currentTaskNum: number = CommonConstants.ADJUST_TASK_VALUE;
  @State message: string = '';
  @StorageLink('timeCost') @Watch('timeCostChanged') timeCost: String = '';

  aboutToAppear() {
    this.pixelInit();
  }

  timeCostChanged(): void {
    let timeCost: string | undefined = AppStorage.get<string>('timeCost');
    if (timeCost !== undefined) {
      this.message = timeCost;
    }
  }

  build() {
    Column() {
      Column() {
        AdjustThreadView()
      }
      .width($r('app.string.layout_100_percent'))
      .height($r('app.string.layout_20_percent'))
      Column() {
        Row(){
          Text($r('app.string.running_time'))
            .fontColor(Color.White)
            .fontSize($r('app.float.result_font_size'))
          Text(this.message)
            .fontColor(Color.White)
            .fontSize($r('app.float.result_font_size'))
        }
      }
      .width($r('app.string.layout_100_percent'))
      .height($r('app.string.layout_10_percent'))
      Column() {
        ImageView()
      }
      .width($r('app.string.layout_100_percent'))
      .height($r("app.string.layout_60_percent"))
      Column() {
        AdjustImageView()
      }
      .align(Alignment.End)
      .width($r('app.string.layout_100_percent'))
      .height($r('app.string.layout_10_percent'))
    }
    .width($r('app.string.layout_100_percent'))
    .height($r('app.string.layout_100_percent'))
    .backgroundColor(Color.Black)

  }

  pixelInit() : void{
    ImageUtils.createPixelMapFromResource($r('app.media.nightView'), getContext()).then(pixelMap => {
      this.pixelMap = pixelMap;
      this.currentAdjustData = CommonConstants.ADJUST_SLIDER_VALUE;
    });
  }
}
