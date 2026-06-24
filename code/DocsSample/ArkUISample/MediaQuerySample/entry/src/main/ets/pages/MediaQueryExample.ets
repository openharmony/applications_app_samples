/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [Start obtain_mediaquery_all]
import { LengthMetrics, mediaquery, window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct MediaQueryExample {
  @State color: string = '#DB7093';
  @State text: string = 'Portrait';
  @State dir: FlexDirection = FlexDirection.Column
  @State textHeight: string = '30%'
  @State textWidth: string = '100%'
  // 当设备横屏时条件成立
  listener: mediaquery.MediaQueryListener =
    this.getUIContext().getMediaQuery().matchMediaSync('(orientation: landscape)');

  // 当满足媒体查询条件时，触发回调
  onPortrait(mediaQueryResult: mediaquery.MediaQueryResult) {
    if (mediaQueryResult.matches as boolean) { // 若设备为横屏状态，更改相应的文本内容与字体颜色
      this.color = '#FFD700';
      this.text = 'Landscape';
      this.dir = FlexDirection.Row;
      this.textHeight = '100%'
      this.textWidth = '33%'
    } else {
      this.color = '#DB7093';
      this.text = 'Portrait';
      this.dir = FlexDirection.Column;
      this.textHeight = '33%'
      this.textWidth = '100%'
    }
  }

  aboutToAppear() {
    // 绑定当前应用实例
    // 绑定回调函数
    this.listener.on('change', (mediaQueryResult: mediaquery.MediaQueryResult) => {
      this.onPortrait(mediaQueryResult)
    });
  }

  aboutToDisappear() {
    // 解绑listener中注册的回调函数
    this.listener.off('change');
  }

  // 改变设备横竖屏状态函数
  private changeOrientation(isLandscape: boolean) {
    // 获取UIAbility实例的上下文信息
    let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    // 调用该接口手动改变设备横竖屏状态
    window.getLastWindow(context).then((lastWindow) => {
      lastWindow.setPreferredOrientation(isLandscape ? window.Orientation.LANDSCAPE : window.Orientation.PORTRAIT)
    });
  }

  build() {
    Column({ space: 30 }) {
      Text(this.text).fontSize(24).fontColor(this.color)
      Text('Landscape').fontSize(50).fontColor(this.color).backgroundColor(Color.Orange)
        .onClick(() => {
          this.changeOrientation(true);
        })
      Text('Portrait').fontSize(50).fontColor(this.color).backgroundColor(Color.Orange)
        .onClick(() => {
          this.changeOrientation(false);
        })
      Flex({ direction: this.dir, space: { main: LengthMetrics.vp(10), cross: LengthMetrics.vp(5) } }) {
        Text('1')
          .height(this.textHeight)
          .width(this.textWidth)
          .textAlign(TextAlign.Center)
          .backgroundColor('rgb(0, 74, 175)')
        Text('2')
          .height(this.textHeight)
          .width(this.textWidth)
          .textAlign(TextAlign.Center)
          .backgroundColor('rgb(39, 135, 217)')
        Text('3')
          .height(this.textHeight)
          .width(this.textWidth)
          .textAlign(TextAlign.Center)
          .backgroundColor('rgb(240, 250, 255)')
      }.layoutWeight(1)
      .width('100%')
    }
    .width('100%').height('100%')
  }
}
// [End obtain_mediaquery_all]