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

import { AnimationUtils } from '../utils/AnimationUtils';
import { globalIdle } from '../utils/GlobalScreenSaver';
import { FeaturePage } from './FeaturePage';
import { MediaExperiencePage } from './MediaExperiencePage';
import { ProductSpecPage } from './ProductSpecPage';
import { SmartLifePage } from './SmartLifePage';
import { SupportPage } from './SupportPage';

@Entry
@Component
struct Index {
  @State currentTab: number = 0;
  @State tabs: string[] = ['产品规格', '功能特性', '智慧生活', '服务支持'];
  @State FocusId: number = -1;
  @State isFocusable: boolean = true;
  @State isTab: boolean = false;
  @State isOtherFocusable: boolean = true;
  @State isOnNewWant: boolean = false;

  aboutToAppear(): void {
    this.getUIContext().getFocusController().activate(true, false);
  }

  onPageShow(): void {
    // 重进时其他地方可以获焦（解决焦点闪一下的问题）
    this.isOtherFocusable = true;
    // 从后台进来
    if (AppStorage.get('isOnNewWant')) {
      this.isOnNewWant = true;
    }
    // 退出轮播后执行
    if (AppStorage.get('isTab')) {
      this.isFocusable = true;
      this.isTab = true;
      focusControl.requestFocus('tab' + this.currentTab.toString());
    }
    globalIdle.startDetect();
  }

  onPageHide(): void {
    globalIdle.stopDetect();
    AppStorage.setOrCreate<boolean>('isTab', this.isTab);
    // 如果焦点在tab上，就在退出时让其他地方不可获焦
    if (this.isTab) {
      this.isOtherFocusable = false;
    }
  }

  build() {
    Stack() {
      Image(this.currentTab == 0 ? $r('app.media.backgroundIMage') : $r('app.media.backgroundphoto'))
        .width('100%')
        .height('100%');
      Column() {
        // 内容区域
        Stack() {
          if (this.currentTab === 0) {
            ProductSpecPage();
          } else if (this.currentTab === 1) {
            FeaturePage({
              isOtherFocusable: this.isOtherFocusable,
              isTab: this.isTab,
              childrenOnBlur: () => {
                this.isFocusable = true;
                this.isTab = true;
                focusControl.requestFocus('tab' + this.currentTab);
              }
            });
          } else if (this.currentTab === 2) {
            SmartLifePage({
              isOtherFocusable: this.isOtherFocusable,
              isTab: this.isTab,
              childrenOnBlur: () => {
                this.isFocusable = true;
                this.isTab = true;
                focusControl.requestFocus('tab' + this.currentTab);
              }
            });
          } else if (this.currentTab === 3) {
            SupportPage({
              isTab: this.isTab,
              childrenOnBlur: () => {
                this.isFocusable = true;
                this.isTab = true;
                focusControl.requestFocus('tab' + this.currentTab);
              }
            });
          }
        }
        .width('100%')
        .height(0)
        .layoutWeight(1)
        .margin(10);

      }.width('100%')
      .height('100%');

      // 底部Tab栏
      this.buildTabBar();

    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.Bottom)
    .align(Alignment.Bottom);
  }

  @Builder
  buildTabBar() {
    Row() {
      ForEach(this.tabs, (tab: string, index: number) => {
        Row() {
          Text(tab)
            .fontSize('32lpx')
            .letterSpacing(0)
            .lineHeight('38lpx')
            .textAlign(TextAlign.Center)
            .fontColor(this.currentTab === index ?
              (this.FocusId == index ? 'rgba(0,0,0,0.86)' : 'rgba(255,255,255,0.86)') : 'rgba(255,255,255,0.86)')
            .fontWeight(500)
            .backgroundColor(Color.Transparent)
            .borderRadius('34lpx')
            .backgroundColor(this.currentTab === index ?
              (this.FocusId == index ? 'rgba(255,255,255,0.86)' : 'rgba(255,255,255,0.3)') : 'rgba(255,255,255,0)')
            .padding({
              left: '24lpx',
              right: '24lpx',
              top: '10lpx',
              bottom: '10lpx'
            })
            .focusable(this.isFocusable)
            .defaultFocus(true)
            .id('tab' + index.toString())
            .onFocus(() => {
              this.isTab = true;
              if (this.isOnNewWant) {
                this.isFocusable = true;
                setTimeout(() => {
                  this.isOnNewWant = false;
                }, 300);
              } else {
                this.currentTab = index;
              }
              this.FocusId = this.currentTab;
            })
            .onHover((isOnHover) => {
              globalIdle.resetTimer();
              if (isOnHover) {
                this.currentTab = index;
                this.FocusId = index;
                this.isTab = true;
              }
            })
            .onClick(() => {
              globalIdle.resetTimer();
              AnimationUtils.createScaleAnimation();
              this.currentTab = index;
            })
            .onKeyEvent(() => {
              globalIdle.resetTimer();

            });

        }
        // 以下注释最好不要删掉，用来加焦点框的
        .padding('2lpx')
        .borderRadius('40lpx')
        .justifyContent(FlexAlign.Center);
      });

    }
    .stateStyles({
      focused: {
        .border({
          color: Color.White
        });
      }
    })
    .padding('2lpx')
    .justifyContent(FlexAlign.Center)
    .margin({ bottom: '64lpx' })
    .borderRadius('135lpx')
    .backgroundColor('rgba(255,255,255,0.1)')
    .onFocus(() => {
      this.isTab = true;
    })
    .onBlur(() => {
      this.FocusId = -1;
      this.isFocusable = false;
    })
    .border({
      width: '2lpx',
      color: 'rgba(255,255,255,0.2)'
    })
    .shadow({
      radius: 8,
      color: '#1A000000',
      offsetX: 0,
      offsetY: -2
    })
    .linearGradient({

      colors: [['rgba(255, 255, 255, 0)', 0.0], ['rgba(255, 255, 255, 0.15)', 0.5],
        ['rgba(255, 255, 255, 0.3)', 1]]
    })
    .margin({ bottom: '70lpx', });

  }
}