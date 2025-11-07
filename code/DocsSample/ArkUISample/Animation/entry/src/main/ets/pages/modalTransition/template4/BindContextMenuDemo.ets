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

// [Start bind_context_menu_demo]
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct BindContextMenuDemo {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private menu: string[] = [this.context.resourceManager.getStringByNameSync('modal_transition_text25'),
    this.context.resourceManager.getStringByNameSync('modal_transition_text26'),
    this.context.resourceManager.getStringByNameSync('modal_transition_text27')];
  // $r('app.media.xxx')需要替换为开发者所需的图像资源文件。
  private pics: Resource[] = [$r('app.media.icon_1'), $r('app.media.icon_2')];

  // 通过@Builder构建自定义菜单项
  @Builder
  myMenu() {
    Column() {
      ForEach(this.menu, (item: string) => {
        Row() {
          Text(item)
            .fontSize(18)
            .width('100%')
            .textAlign(TextAlign.Center)
        }
        .padding(15)
        .border({ width: { bottom: 1 }, color: 0xcccccc })
      })
    }
    .width(140)
    .borderRadius(15)
    .shadow({ radius: 15, color: 0xf1f1f1 })
    .backgroundColor(0xf1f1f1)
  }

  build() {
    Column() {
      Row() {
        Text(this.context.resourceManager.getStringByNameSync('modal_transition_text28'))
          .fontSize(20)
          .fontColor(Color.White)
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding({ top: 20, bottom: 20 })
      }
      .backgroundColor(0x007dfe)

      Column() {
        ForEach(this.pics, (item: Resource) => {
          Row() {
            Image(item)
              .width('100%')
              .draggable(false)
          }
          .padding({
            top: 20,
            bottom: 20,
            left: 10,
            right: 10
          })
          .bindContextMenu(this.myMenu, ResponseType.LongPress)
        })
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
  }
}

// [End bind_context_menu_demo]