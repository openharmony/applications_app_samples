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

// [Start obtain_mediaquery_all]
// [Start obtain_mediaquery_import]
import { mediaquery } from '@kit.ArkUI';
// [End obtain_mediaquery_import]
import { window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct MediaQueryExample {
  @State color: string = '#DB7093';
  @State text: string = 'Portrait';
  // 当设备横屏时条件成立
  // [Start obtain_mediaquery_listener]
  listener:mediaquery.MediaQueryListener = this.getUIContext().getMediaQuery().matchMediaSync('(orientation: landscape)');
  // [End obtain_mediaquery_listener]

  // 当满足媒体查询条件时，触发回调
  // [Start obtain_mediaquery_Portrait]
  onPortrait(mediaQueryResult:mediaquery.MediaQueryResult) {
    if (mediaQueryResult.matches as boolean) { // 若设备为横屏状态，更改相应的页面布局
      // [StartExclude obtain_mediaquery_Portrait]
      this.color = '#FFD700';
      this.text = 'Landscape';
      // [EndExclude obtain_mediaquery_Portrait]
    } else {
      // [StartExclude obtain_mediaquery_Portrait]
      this.color = '#DB7093';
      this.text = 'Portrait';
      // [EndExclude obtain_mediaquery_Portrait]
    }
  }

  // [StartExclude obtain_mediaquery_Portrait]
  aboutToAppear() {
    // 绑定当前应用实例
    // 绑定回调函数
    // [EndExclude obtain_mediaquery_Portrait]
    this.listener.on('change', (mediaQueryResult: mediaquery.MediaQueryResult) => {
      // [StartExclude obtain_mediaquery_Portrait]
      this.onPortrait(mediaQueryResult);
      // [EndExclude obtain_mediaquery_Portrait]
    });
    // [StartExclude obtain_mediaquery_Portrait]
  }
  // [EndExclude obtain_mediaquery_Portrait]
  // [End obtain_mediaquery_Portrait]

  aboutToDisappear() {
    // 解绑listener中注册的回调函数
    this.listener.off('change');
  }

  // 改变设备横竖屏状态函数
  private changeOrientation(isLandscape: boolean) {
    // 获取UIAbility实例的上下文信息
    let context:common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    // 调用该接口手动改变设备横竖屏状态
    window.getLastWindow(context).then((lastWindow) => {
      lastWindow.setPreferredOrientation(isLandscape ? window.Orientation.LANDSCAPE : window.Orientation.PORTRAIT);
    });
  }

  build() {
    Column({ space: 50 }) {
      Text(this.text).fontSize(50).fontColor(this.color);
      Text('Landscape').fontSize(50).fontColor(this.color).backgroundColor(Color.Orange)
        .onClick(() => {
          this.changeOrientation(true);
        });
      Text('Portrait').fontSize(50).fontColor(this.color).backgroundColor(Color.Orange)
        .onClick(() => {
          this.changeOrientation(false);
        });
    }
    .width('100%').height('100%')
  }
}
// [End obtain_mediaquery_all]