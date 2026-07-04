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
// [Start eventTrans_menu]
@Entry
@Component
export struct EventTransSubWindowMenuExample {
  build() {
    NavDestination() {
      Column() {
      }
      .id('click')
      .bindContextMenu(this.contextMenuBuilder, ResponseType.RightClick, {
        modalMode: ModalMode.TARGET_WINDOW
      })
      .onClick(() => {
        this.getUIContext().getPromptAction().showToast({
          message: 'Clicked!'
        })
      })
      .width('100%')
      .height('100%')
    }
    // [StartExclude eventTrans_menu]
    // 请将$r('app.string.EventTransSubWindowMenu_title')替换为实际资源文件，在本示例中该资源文件的value值为"控制子窗菜单的事件透传"
    .title($r('app.string.EventTransSubWindowMenu_title'))
    // [EndExclude eventTrans_menu]
  }

  @Builder
  bindMenuBuilder() {
    Menu() {
      MenuItem({ content: 'bindMenu item' }) {

      }
    }
  }

  @Builder
  contextMenuBuilder() {
    Menu() {
      MenuItem({ content: 'contextMenu item' }) {

      }
    }
  }
}
// [End eventTrans_menu]