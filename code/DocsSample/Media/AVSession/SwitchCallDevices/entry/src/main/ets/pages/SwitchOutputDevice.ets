/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { Router } from '@kit.ArkUI';
// [Start create_castPicker]
import { AVCastPicker } from '@kit.AVSessionKit';

@Entry
@Component
struct OutputCastPicker {
  @State normalColor:Color = Color.White;
  @State activeColor:Color = Color.Blue;
  @State pickerImage: ResourceStr = $r('app.media.sound'); // 自定义资源。
  // [StartExclude create_castPicker]
  @State router: Router = new Router();
  // [EndExclude create_castPicker]
  // 创建组件，并设置大小。
  build() {
    Row() {
      Column() {
        AVCastPicker({
          normalColor: this.normalColor,
          activeColor: this.activeColor,
          customPicker: this.ImageBuilder.bind(this), // 新增自定义参数。
        })
          .size({ width: '50%', height: '20%' })
          .id('AVCastPicker')
        // [StartExclude create_castPicker]
        Blank().height(40);
        Button('back')
          .onClick(async () => {
            await this.router.pushUrl({ url: 'pages/Index' });
          })
          .size({ width: '50%', height: '10%' })
        // [EndExclude create_castPicker]
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
    }
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .height('100%')
  }

  // 自定义内容。
  @Builder
  ImageBuilder() {
    Text($r('app.string.switch_OutputDevice'))
    Image(this.pickerImage)
      .size({ width: '100%', height: '100%' })
      .backgroundColor('#00000000')
      .fillColor(Color.Black)
  }
}
// [End create_castPicker]

