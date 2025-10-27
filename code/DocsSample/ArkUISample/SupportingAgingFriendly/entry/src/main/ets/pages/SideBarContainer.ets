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

// [Start trigger_aging_friendly_by_long_press]
import { abilityManager, Configuration } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import hilog from '@ohos.hilog';

const TAG = '[Sample_SupportingAgingFriendly]';
const DOMAIN = 0xF811;
const BUNDLE = 'SupportingAgingFriendly_';

@Entry
@Component
struct SideBarContainerExample {
  @State currentFontSizeScale: number = 1;
  normalIcon: Resource = $r('app.media.icon'); // $r('app.media.icon')需要替换为开发者所需的图片资源文件
  selectedIcon: Resource = $r('app.media.icon'); // $r('app.media.icon')需要替换为开发者所需的图片资源文件
  @State arr: number[] = [1, 2, 3]; // 标签的数量和名字，一共3个标签, 01, 02,03
  @State current: number = 1; // button所在的标签页Index01
  @State title: string = 'Index01';
  // 设置字体大小
  async setFontScale(scale: number): Promise<void> {
    let configInit: Configuration = {
      language: 'zh-Ch',
      fontSizeScale: scale,
    };
    // 更新配置-字体大小
    abilityManager.updateConfiguration(configInit, (err: BusinessError) => {
      if (err) {
        hilog.info(DOMAIN, TAG, BUNDLE + `updateConfiguration fail, err: ${JSON.stringify(err)}`);
      } else {
        this.currentFontSizeScale = scale;
        hilog.info(DOMAIN, TAG, BUNDLE + 'updateConfiguration success.');
      }
    });
  }

  build() {
    SideBarContainer(SideBarContainerType.Embed) {
      Column() {
        ForEach(this.arr, (item: number) => {
          Column({ space: 5 }) {
            Image(this.current === item ? this.selectedIcon : this.normalIcon).width(64).height(64);
            Text('0' + item)
              .fontSize(25)
              .fontColor(this.current === item ? '#0A59F7' : '#999')
              .fontFamily('source-sans-pro,cursive,sans-serif')
          }
          .onClick(() => {
            this.current = item;
            this.title = 'Index0' + item;
          })
        }, (item: string) => item)
      }.width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
      // $r('sys.color.mask_fifth')需要替换为开发者所需的字符串资源文件
      .backgroundColor($r('sys.color.mask_fifth'))

      Column() {
        Text(this.title);
        // $r('app.string.one_multiple')需要替换为开发者所需的字符串资源文件
        Button($r('app.string.one_multiple')).onClick(() => {
          this.setFontScale(1)
        }).margin(10);

        // $r('app.string.one_point_seven_five_multiple')需要替换为开发者所需的字符串资源文件
        Button($r('app.string.one_point_seven_five_multiple')).onClick(() => {
          this.setFontScale(1.75)
        }).margin(10);

        // $r('app.string.two_multiple')需要替换为开发者所需的字符串资源文件
        Button($r('app.string.two_multiple')).onClick(() => {
          this.setFontScale(2)
        }).margin(10);

        // $r('app.string.three_point_two_multiple')需要替换为开发者所需的字符串资源文件
        Button($r('app.string.three_point_two_multiple')).onClick(() => {
          this.setFontScale(3.2)
        }).margin(10);
      }
      .margin({ top: 50, left: 20, right: 30 });
    }
    .controlButton({
      icons: {
        // $r('sys.media.ohos_ic_public_drawer_open_filled') 需要替换为开发者所需的资源文件
        hidden: $r('sys.media.ohos_ic_public_drawer_open_filled'),
        // $r('sys.media.ohos_ic_public_drawer_close')需要替换为开发者所需的资源文件
        shown: $r('sys.media.ohos_ic_public_drawer_close')
      }
    })
    .sideBarWidth(150)
    .minSideBarWidth(50)
    .maxSideBarWidth(300)
    .minContentWidth(0)
    .onChange((value: boolean) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'status:' + value);
    })
    .divider({ strokeWidth: '1vp', color: Color.Gray, startMargin: '4vp', endMargin: '4vp' });
  }
}
// [End trigger_aging_friendly_by_long_press]
