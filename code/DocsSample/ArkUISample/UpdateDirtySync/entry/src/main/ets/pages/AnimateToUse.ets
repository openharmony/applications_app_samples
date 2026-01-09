/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start AnimateToUse]
import { UIUtils } from '@kit.ArkUI';

@Entry
@ComponentV2
struct Index {
  @Local message: string = 'Hello World';
  @Local x: number = 0;
  @Local y: number = 0;
  @Local w: number = 200;
  @Local h: number = 50;

  @Monitor('message')
  onMsgChange() {
    console.info('message change to', this.message);
    this.animateAction();
  }

  animateAction() {
    this.getUIContext().animateTo({
      duration: 1000
    }, () => {
      // 调用applySync接口同步刷新动画尾帧，若不调用该接口则不显示动画
      UIUtils.applySync(() => {
        this.x = 100;
        this.y = 100;
      });
    });
  }

  build() {
    Column() {
      Text(this.message)
        .fontSize(20)
        .width(this.w)
        .height(this.h)
        .backgroundColor(Color.Pink)
        .onClick(() => {
          this.message = 'New Message';
        })
        .position({
          x: this.x,
          y: this.y
        })
        // [StartExclude AnimateToUse]
        .id('AnimateToUse')
        // [EndExclude AnimateToUse]
    }
    .height('100%')
    .width('100%')
  }
}
// [End AnimateToUse]

@Builder
export function animateToUse() {
  NavDestination() {
    Index();
  }
  .backgroundColor('#f1f2f3')
  .title($r('app.string.use_with_animateTo'))
}