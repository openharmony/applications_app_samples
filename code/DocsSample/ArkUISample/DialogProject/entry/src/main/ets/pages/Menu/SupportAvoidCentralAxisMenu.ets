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

// [Start avoid_central_axis_menu]
@Entry
@Component
export struct SupportAvoidCentralAxisMenuExample {
  @State message: string = 'Hello World';
  // 请在resources\base\element\string.json文件中配置name为'xxx'，value为非空字符串的资源
  @State upScreen: string =
    this.getUIContext().getHostContext()?.resourceManager.getStringByNameSync('Upper_half_screen') as string;
  @State middleAxle: string =
    this.getUIContext().getHostContext()?.resourceManager.getStringByNameSync('Middle_axle') as string;
  @State lowerScreen: string =
    this.getUIContext().getHostContext()?.resourceManager.getStringByNameSync('Lower_half_screen') as string;
  @State zone: string =
    this.getUIContext().getHostContext()?.resourceManager.getStringByNameSync('zone') as string;
  @State hoverModeStart: string =
    this.getUIContext().getHostContext()?.resourceManager.getStringByNameSync('hoverMode_start') as string;
  // 请将$r('app.media.startIcon')替换为实际资源文件
  private iconStr: Resource = $r('app.media.startIcon');
  @State index: number = 0;
  @State arrayStr: Array<string> = [this.upScreen, this.middleAxle, this.lowerScreen];
  @State enableHoverMode: boolean | undefined = true;
  @State showInSubwindow: boolean = false;
  @State placement: Placement | undefined = undefined;

  @Builder
  MyMenu1() {
    Menu() {
      // 请将$r('app.string.menu_selection')替换为实际资源文件，在本示例中该资源文件的value值为"菜单选项"
      MenuItem({ startIcon: this.iconStr, content: $r('app.string.menu_selection') })
      MenuItem({ startIcon: this.iconStr, content: $r('app.string.menu_selection') })
      MenuItem({ startIcon: this.iconStr, content: $r('app.string.menu_selection') })
      MenuItem({ startIcon: this.iconStr, content: $r('app.string.menu_selection') })
    }
  }

  @State isShow: boolean = false;

  build() {
    NavDestination() {
      RelativeContainer() {
        Column() {
          Button(this.zone + this.arrayStr[this.index])
            .onClick(() => {
              if (this.index < 2) {
                this.index++
              } else {
                this.index = 0
              }
            })

          Button(this.hoverModeStart + this.enableHoverMode)
            .id('hoverMode_start')
            .onClick(() => {
              if (this.enableHoverMode === undefined) {
                this.enableHoverMode = true
              } else if (this.enableHoverMode === true) {
                this.enableHoverMode = false
              } else {
                this.enableHoverMode = undefined
              }
            })

          Button('MenuPlacement:' + this.placement)
            .onClick(() => {
              if (this.placement === undefined) {
                this.placement = Placement.Bottom
              } else if (this.placement === Placement.Bottom) {
                this.placement = Placement.Top
              } else {
                this.placement = undefined
              }
            })
        }

        Row() {
          Button('Menu')
            .fontWeight(FontWeight.Bold)
            .bindMenu(this.MyMenu1(), {
              enableHoverMode: this.enableHoverMode,
              showInSubWindow: this.showInSubwindow,
              placement: this.placement
            })

          Select([{ value: 'text1' }, { value: 'text2' }, { value: 'text3' }, { value: 'text4' }, { value: 'text5' },
            { value: 'text6' }, { value: 'text7' }, { value: 'text8' }, { value: 'text9' }, { value: 'text10' },
            { value: 'text11' },
            { value: 'text12' }])
            .value('Select')

        }
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .margin({
          top: this.index === 2 ? 330 : this.index === 1 ? 50 : 0,
          bottom: this.index === 0 ? 330 : 0
        })
      }
      .height('100%')
      .width('100%')
    }
    // [StartExclude avoid_central_axis_menu]
    // 请将$r('app.string.SupportAvoidCentralAxisMenu_title')替换为实际资源文件，在本示例中该资源文件的value值为"菜单支持避让中轴"
    .title($r('app.string.SupportAvoidCentralAxisMenu_title'))
    // [EndExclude avoid_central_axis_menu]
  }
}
// [End avoid_central_axis_menu]