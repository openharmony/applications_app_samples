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

// [Start age_friendly_tab]
import { abilityManager, Configuration } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction, uiAppearance } from '@kit.ArkUI';

@Entry
@Component
export struct AgeFriendlyTabs {
  @State fontColor: string = '#182431';
  @State selectedFontColor: string = '#007DFF';
  @State currentIndex: number = 0;
  @State currentFontSizeScale: string = '';
  @State showBuilderTab: boolean = false;
  @State fontSize: number = 15;
  private darkModeKey: string[] = Object.keys(uiAppearance.DarkMode).filter(
    key => typeof uiAppearance.DarkMode[key] === 'number');

  async setFontScale(scale: number): Promise<void> {
    let configInit: Configuration = {
      fontSizeScale: scale,
    };
    abilityManager.updateConfiguration(configInit, (err: BusinessError) => {
      if (err) {
        console.error(`updateConfiguration fail, err: ${JSON.stringify(err)}`);
        promptAction.showToast({ message: `scale:${scale}, err:${JSON.stringify(err)}` });
      } else {
        this.currentFontSizeScale = String(scale);
        if (scale > 1) {
          this.fontSize = 8;
        } else {
          this.fontSize = 15;
        }
        console.log('updateConfiguration success.');
        promptAction.showToast({ message: `scale:${scale}, updateConfiguration success.` });
      }
    });
  }

  darkMode(isDarkMode: boolean): void {
    let mode: uiAppearance.DarkMode = uiAppearance.DarkMode.ALWAYS_LIGHT;
    if (isDarkMode) {
      mode = uiAppearance.DarkMode.ALWAYS_DARK;
    }
    if (mode == uiAppearance.getDarkMode()) {
      console.info(`TitleDarkMode Set ${this.darkModeKey[mode]} successfully.`);
      return;
    }
    try {
      uiAppearance.setDarkMode(mode).then(() => {
        console.info(`TitleDarkMode Set ${this.darkModeKey[mode]} successfully.`);
      }).catch((error: Error) => {
        console.error(`TitleDarkMode Set ${this.darkModeKey[mode]} failed, ${error.message}`);
      });
    } catch (error) {
      let message = (error as BusinessError).message;
      console.error(`TitleDarkMode Set dark-mode failed, ${message}`);
    }
  }

  build() {
    // [StartExclude age_friendly_tab]
    NavDestination() {
      // [EndExclude age_friendly_tab]
      Column() {
        Column() {
          Row() {
            Text(`current fontSizeScale:${this.currentFontSizeScale}`)
              .margin({ top: 5, bottom: 5 })
              .fontSize(this.fontSize)
          }

          Row() {
            Button('1.75')
              .margin({ top: 5, bottom: 5 })
              .fontSize(this.fontSize)
              .width('40%')
              .onClick(async () => {
                await this.setFontScale(1.75);
              })
            Button('2')
              .margin({ top: 5, bottom: 5 })
              .fontSize(this.fontSize)
              .width('40%')
              .onClick(async () => {
                await this.setFontScale(2);
              })
          }.margin({ top: 25 })

          Row() {
            Button('3.2')
              .margin({ top: 5, bottom: 5 })
              .fontSize(this.fontSize)
              .width('40%')
              .onClick(async () => {
                await this.setFontScale(3.2);
              })
            Button('1')
              .margin({ top: 5, bottom: 5 })
              .fontSize(this.fontSize)
              .width('40%')
              .onClick(async () => {
                await this.setFontScale(1);
              })
          }

          Row() {
            Button('深色模式')
              .margin({ top: 5, bottom: 5 })
              .fontSize(this.fontSize)
              .width('40%')
              .onClick(async () => {
                this.darkMode(true);
              })
            Button('浅色模式')
              .margin({ top: 5, bottom: 5 })
              .fontSize(this.fontSize)
              .width('40%')
              .onClick(async () => {
                this.darkMode(false);
              })
          }
        }.alignItems(HorizontalAlign.Start)

        Column() {
          Tabs({ barPosition: BarPosition.End }) {
            TabContent() {
              Column()
                .width('100%')
                .height('100%')
                .backgroundColor(Color.Pink)
            }.tabBar(new BottomTabBarStyle($r('sys.media.ohos_app_icon'), 'OverLength'))

            TabContent() {
              Column()
                .width('100%')
                .height('100%')
                .backgroundColor(Color.Yellow)
            }.tabBar(new BottomTabBarStyle($r('sys.media.ohos_app_icon'), 'SixLine'))

            TabContent() {
              Column()
                .width('100%')
                .height('100%')
                .backgroundColor(Color.Blue)
            }.tabBar(new BottomTabBarStyle($r('sys.media.ohos_app_icon'), 'Blue'))

            TabContent() {
              Column()
                .width('100%')
                .height('100%')
                .backgroundColor(Color.Green)
            }.tabBar(new BottomTabBarStyle($r('sys.media.ohos_app_icon'), 'Green'))
          }
          .vertical(false)
          .scrollable(true)
          .barMode(BarMode.Fixed)
          .onChange((index: number) => {
            console.info(index.toString());
          })
          .width('100%')
          .backgroundColor(0xF1F3F5)
        }.width('80%').height(200)
        .margin({ top: 200 })
      }.width('100%')
    }
    // [End age_friendly_tab]
    .backgroundColor('#f1f2f3')
    .title($r('app.string.AgeFriendlyTabs_title'))
  }
}