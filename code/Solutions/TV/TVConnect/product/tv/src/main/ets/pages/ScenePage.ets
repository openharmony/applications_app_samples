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

import {
  AddScenePage,
  DeviceControlPage,
  SceneDetailPage,
  AddConditionPage,
  EquipmentSelection
} from '@ohos/scenelibrary';
import { CommonConstants, Logger } from '@ohos/common';
import router from '@ohos.router';


@Entry
@Component
struct ScenePage {
  @State type: number = 0;
  @State sceneId: string = '';
  @State category: number = -1;
  @State isEdit: boolean = false;
  @State currentDataStr: string = '';

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string | number | boolean>;
    this.type = params.type as number;
    if (params.id) {
      this.sceneId = params.id as string;
    }
    if (params.category) {
      this.category = params.category as number;
    }
    if (params.isEdit) {
      this.isEdit = params.isEdit as boolean;
    }
    if (params.currentDataStr) {
      this.currentDataStr = params.currentDataStr as string;
    }
  }

  build() {
    Column() {
      if (this.type == 0) {
        // 创建互联场景
        AddScenePage({
          addClick: (type: number, isEdit?: boolean, item?: string) => {
            router.pushUrl({
              url: 'pages/ScenePage',
              params: {
                type: 3,
                category: type,
                isEdit: isEdit,
                currentDataStr: item
              }
            }).catch((error: Error) => {
              Logger.error('LauncherPage pushUrl error ' + JSON.stringify(error));
            });
          }
        });

        // 摄像头demo
      } else if (this.type == 1) {
        DeviceControlPage({
          isEdit: this.isEdit,
          sceneId: this.sceneId,
          clickCallback: () => {
            router.pushUrl({
              url: 'pages/ScenePage',
              params: { type: 2, id: this.sceneId, isEdit: this.isEdit }
            }).catch((error: Error) => {
              Logger.error('LauncherPage pushUrl error ' + JSON.stringify(error));
            });
          }
        });
      } else if (this.type == 2) {
        SceneDetailPage({
          isEdit: this.isEdit,
          sceneId: this.sceneId
        });
      } else if (this.type == 3) {
        AddConditionPage({
          type: this.category,
          isEdit: this.isEdit,
          currentDataStr: this.currentDataStr,
          addClick: (type: number) => {
            router.pushUrl({
              url: 'pages/ScenePage',
              params: { type: 5, category: type }
            }).catch((error: Error) => {
              Logger.error('LauncherPage pushUrl error ' + JSON.stringify(error));
            });
          }
        });
      } else if (this.type == 4) {
        AddScenePage({
          isEdit: this.isEdit,
          sceneId: this.sceneId,
          addClick: (type: number) => {
            router.pushUrl({
              url: 'pages/ScenePage',
              params: { type: 3, category: type }
            }).catch((error: Error) => {
              Logger.error('LauncherPage pushUrl error ' + JSON.stringify(error));
            });
          }
        });
      } else if (this.type == 5) {
        EquipmentSelection({ type: this.category, });
      }

    }
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .height(CommonConstants.FULL_HEIGHT_PERCENT);
  }
}