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

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';

@Extend(Column) function cardStyle(){
  .backgroundColor($r('app.color.white'))
  .borderRadius(16)
  .width('100%')
  .padding(12)
}
@Entry
@Component
struct XComponentSample {
  private surfaceId : string ='';
  xcomponentController: XComponentController = new XComponentController();

  build() {
    Column() {
      TitleBar({ title: $r('app.string.xcomponent_title') })
      Column(){
        IntroductionTitle({introduction:$r('app.string.xcomponent_show')})
        Column() {
          XComponent({
            id: 'xcomponent',
            type: 'surface',
            controller: this.xcomponentController
          })
            .onLoad(() => {
              this.xcomponentController.setXComponentSurfaceSize({surfaceWidth:500,surfaceHeight:500})
              this.surfaceId = this.xcomponentController.getXComponentSurfaceId()
            })
            .width('400px')
            .height('400px')
        }
        .backgroundColor(Color.Black)
        .cardStyle()
      }
      .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
      .margin({ bottom: 100 })
    }
    .height('100%')
    .backgroundColor(($r('app.color.background_grey')))

  }
}