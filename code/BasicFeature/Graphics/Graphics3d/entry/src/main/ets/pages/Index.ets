/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import router from '@ohos.router';

@Entry
@Component
struct Index {
  onJumpClick(target_url: string, target_id: number): void {
    router.pushUrl({ url: target_url }, router.RouterMode.Single, (err) => {
      if (err) {
        console.error('Invoke pushUrl failed, code is ${err.code}, message is ${err.message}');
        return;
      }
    });
  }

  build() {
    List() {
      ListItem() {
        Button("container")
          .id("index_container")
          .onClick(() => {
            this.onJumpClick('graphics3d/container', 0);
          })
      }
      ListItem() {
        Button("node_base")
          .id("index_node")
          .onClick(() => {
            this.onJumpClick('graphics3d/node_base', 0);
          })
      }
      ListItem() {
        Button("node_camera")
          .id("index_camera")
          .onClick(() => {
            this.onJumpClick('graphics3d/node_camera', 0);
          })
      }
      ListItem() {
        Button("node_light")
          .id('index_light')
          .onClick(() => {
            this.onJumpClick('graphics3d/node_light', 0);
          })
      }

      ListItem() {
        Button("scene_environment")
          .id('index_environment')
          .onClick(() => {
            this.onJumpClick('graphics3d/scene_environment', 0);
          })
      }
      ListItem() {
        Button("scene_animation")
          .id('index_animation')
          .onClick(() => {
            this.onJumpClick('graphics3d/scene_animation', 0);
          })
      }
      ListItem() {
        Button("scene_shader")
          .id('index_shader')
          .onClick(() => {
            this.onJumpClick('graphics3d/scene_shader', 0);
          })
      }
    }.alignListItem(ListItemAlign.Center)
    .width('100%')
    .height('100%')
  }
}
