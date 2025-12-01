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

// [Start display_page]
// Index.ets
import { Theme, ThemeControl } from '@kit.ArkUI';
import { gAppTheme } from './AppTheme';

//在页面build前执行ThemeControl
ThemeControl.setDefaultTheme(gAppTheme);

@Entry
@Component
struct DisplayPage {
  @State menuItemColor: ResourceColor = $r('sys.color.background_primary');

  onWillApplyTheme(theme: Theme) {
    this.menuItemColor = theme.colors.backgroundPrimary;
  }

  build() {
    Column() {
      List({ space: 10 }) {
        ListItem() {
          Column({ space: '5vp' }) {
            Text('Color mode')
              .margin({ top: '5vp', left: '14fp' })
              .width('100%')
            Row() {
              Column() {
                Text('Light')
                  .fontSize('16fp')
                  .textAlign(TextAlign.Start)
                  .alignSelf(ItemAlign.Center)
                Radio({ group: 'light or dark', value: 'light' })
                  .checked(true)
              }
              .width('50%')

              Column() {
                Text('Dark')
                  .fontSize('16fp')
                  .textAlign(TextAlign.Start)
                  .alignSelf(ItemAlign.Center)
                Radio({ group: 'light or dark', value: 'dark' })
              }
              .width('50%')
            }
          }
          .width('100%')
          .height('90vp')
          .borderRadius('10vp')
          .backgroundColor(this.menuItemColor)
        }

        ListItem() {
          Column() {
            Text('Brightness')
              .width('100%')
              .margin({ top: '5vp', left: '14fp' })
            Slider({ value: 40, max: 100 })
          }
          .width('100%')
          .height('70vp')
          .borderRadius('10vp')
          .backgroundColor(this.menuItemColor)
        }

        ListItem() {
          Column() {
            Row() {
              Column({ space: '5vp' }) {
                Text('Touch sensitivity')
                  .fontSize('16fp')
                  .textAlign(TextAlign.Start)
                  .width('100%')
                Text('Increase the touch sensitivity of your screen' +
                  ' for use with screen protectors')
                  .fontSize('12fp')
                  .fontColor(Color.Blue)
                  .textAlign(TextAlign.Start)
                  .width('100%')
              }
              .alignSelf(ItemAlign.Center)
              .margin({ left: '14fp' })
              .width('75%')

              Toggle({ type: ToggleType.Switch, isOn: true })
                .margin({ right: '14fp' })
                .alignSelf(ItemAlign.Center)
            }
            .width('100%')
            .height('80vp')
          }
          .width('100%')
          .borderRadius('10vp')
          .backgroundColor(this.menuItemColor)
        }
        ListItem() {
          Column() {
            Text('Warning')
              .width('100%')
              .margin({ top: '5vp', left: '14fp' })
            Button('Text')
              .type(ButtonType.Capsule)
              .role(ButtonRole.ERROR)
              .width('40%')
          }
          .width('100%')
          .height('70vp')
          .borderRadius('10vp')
          .backgroundColor(this.menuItemColor)
        }
      }
    }
    .padding('10vp')
    .backgroundColor('#dcdcdc')
    .width('100%')
    .height('100%')
  }
}
// [End display_page]