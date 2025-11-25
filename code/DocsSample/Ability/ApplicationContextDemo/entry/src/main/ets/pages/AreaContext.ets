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

// [Start scene_area_context_start]
// AreaContext.ets
import { contextConstant, common } from '@kit.AbilityKit';

@Entry
@Component
struct AreaContext {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  build() {
    Column() {
      // [StartExclude scene_area_context_start]
      Text('top')
        .width('50vp')
      // [EndExclude scene_area_context_start]
      List({ initialIndex: 0 }) {
        // [StartExclude scene_area_context_start]
        ListItem() {
          Row() {
            Text('list')
              .width('60vp')
          }
        }
        // [EndExclude scene_area_context_start]
        ListItem() {
          Row() {
            // [StartExclude scene_area_context_start]
            Text('list')
              .width('50vp')
            // [EndExclude scene_area_context_start]
          }
          .onClick(() => {
            // 存储普通信息前，切换到EL1设备级加密
            if (this.context.area === contextConstant.AreaMode.EL2) { // 获取area
              this.context.area = contextConstant.AreaMode.EL1; // 修改area
              this.getUIContext().getPromptAction().showToast({
                message: 'SwitchToEL1'
              });
            }
            // 存储普通信息
          })
        }
        // [StartExclude scene_area_context_start]
        .width('100%')
        // [EndExclude scene_area_context_start]
        ListItem() {
          Row() {
            // [StartExclude scene_area_context_start]
            Text('list')
              .width('50vp')
            // [EndExclude scene_area_context_start]
          }
          .onClick(() => {
            // 存储敏感信息前，切换到EL2用户级加密
            if (this.context.area === contextConstant.AreaMode.EL1) { // 获取area
              this.context.area = contextConstant.AreaMode.EL2; // 修改area
              this.getUIContext().getPromptAction().showToast({
                message: 'SwitchToEL2'
              });
            }
            // 存储敏感信息
          })
        }
        // [StartExclude scene_area_context_start]
        .width('100%')
        // [EndExclude scene_area_context_start]
      }
      // [StartExclude scene_area_context_start]
      .width('100%')
      // [EndExclude scene_area_context_start]
    }
    // [StartExclude scene_area_context_start]
    .width('100%')
    // [EndExclude scene_area_context_start]
  }
}
// [End scene_area_context_start]