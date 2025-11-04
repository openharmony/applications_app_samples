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
import { abilityDelegatorRegistry } from '@kit.TestKit';

// [Start polymorphicEffect_popup]
@Entry
@Component
export struct PolymorphicEffectPopupExample {
  @State scan: string =
    this.getUIContext().getHostContext()?.resourceManager.getStringByNameSync('Scan_title') as string;
  @State createGroupChat: string =
    this.getUIContext().getHostContext()?.resourceManager.getStringByNameSync('Create_group_chat') as string;
  @State electronicWorkCard: string =
    this.getUIContext().getHostContext()?.resourceManager.getStringByNameSync('Electronic_work_card') as string;
  private menus: Array<string> = [this.scan, this.createGroupChat, this.electronicWorkCard];

  // popup构造器定义弹框内容
  @Builder
  popupItemBuilder(name: string, action: string) {
    PopupItemChild({ childName: name, childAction: action })
  }

  // popup构造器定义弹框内容
  @Builder
  popupBuilder() {
    Column() {
      ForEach(
        this.menus,
        (item: string, index) => {
          this.popupItemBuilder(item, String(index))
        },
        (item: string, index) => {
          return item
        })
    }
    .padding(8)
  }

  @State customPopup: boolean = false;

  build() {
    NavDestination() {
      Column() {
        Button('click me')
          .id('click me')
          .onClick(() => {
            this.customPopup = !this.customPopup
          })
          .bindPopup(
            this.customPopup,
            {
              builder: this.popupBuilder, // 气泡的内容
              placement: Placement.Bottom, // 气泡的弹出位置
              popupColor: Color.White, // 气泡的背景色
              onStateChange: (event) => {
                if (!event.isVisible) {
                  this.customPopup = false
                }
              }
            })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }.backgroundColor('#f1f2f3')
    // $r('app.string.PolymorphicEffectPopupExample_title')需要替换为开发者所需的资源文件。
    .title($r('app.string.PolymorphicEffectPopupExample_title'))
  }
}

@Component
struct PopupItemChild {
  @Prop childName: string = '';
  @Prop childAction: string = '';
  @State selected: string =
    this.getUIContext().getHostContext()?.resourceManager.getStringByNameSync('Selected') as string;

  build() {
    Row({ space: 8 }) {
      // $r('app.media.startIcon')需要替换为开发者所需的图像资源文件。
      Image($r('app.media.startIcon'))
        .width(24)
        .height(24)
      Text(this.childName)
        .fontSize(16)
    }
    .width(130)
    .height(50)
    .padding(8)
    .onClick(() => {
      this.getUIContext().getPromptAction().showToast({ message: this.selected + this.childName })
    })
    .stateStyles({
      normal: {
        .backgroundColor(Color.White)
      },
      pressed: {
        .backgroundColor('#1fbb7d')
      }
    })
  }
}
// [End polymorphicEffect_popup]