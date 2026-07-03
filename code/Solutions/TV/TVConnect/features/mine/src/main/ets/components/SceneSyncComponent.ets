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
import { SimpleItem } from './ListComponents';
import promptAction from '@ohos.promptAction';
import { DiaLogComponent, LoadType } from './DiaLogComponent';
import { LibraryManagerFactory, LibraryManagerType } from '../model/manager/LibraryManagerFactory';
import { UpdateLibraryCallback } from '../model/callback/UpdateLibraryCallback';
import { LibraryManager, UpdateLibraryCode } from '../model/manager/LibraryManager';
import { UpgradeSceneLibrarySuccData } from '../model/cloud/Response';
import { LengthMetrics } from '@kit.ArkUI';
import { scale } from '../model/utils/ScreenAdaptation';

@Builder
export function SceneSyncComponent() {
  SceneSync();
}

@Component
struct SceneSync {
  @Provide dialogText: Resource = $r('app.string.device_parse');
  @Provide loadStatus: LoadType = LoadType.LOADING;
  @State hideTaskTag: boolean = true;
  @State manager: LibraryManager = LibraryManagerFactory.getInstance().getManager(LibraryManagerType.SCENE);
  @State currentUpgradeVersionCode: string = '';
  @State currentVersionCode: string = '';
  @State fontColor: ResourceStr = $r('app.color.default_text_color');
  @State fontSize: ResourceStr = $r('app.string.font_20');
  @State isFontWeight: boolean = false;
  numfmt: Intl.NumberFormat = new Intl.NumberFormat(['en-GB', 'zh'], { style: 'percent' });
  dialogControllerProgress: CustomDialogController = new CustomDialogController({
    builder: DiaLogComponent(),
    autoCancel: true,
    customStyle: true,
    alignment: DialogAlignment.Default,
    cancel: () => {
      if (this.hideTaskTag) {
        try {
          promptAction.showToast({ message: $r('app.string.task_background'), duration: 1500 });
        } catch (error) {
        }
      }
    }
  });

  aboutToAppear(): void {
    this.currentVersionCode = this.manager.currentVersionCode;
    let _this = this;
    this.manager.registerUpdateLibraryListener(() => {
      this.manager.getLibraryVersion().then(() => {
        _this.currentVersionCode = this.manager.currentVersionCode;
      });
    });
  }

  async updateSceneLibrary() {
    this.dialogText = $r('app.string.check_scene_version');
    this.loadStatus = LoadType.LOADING;
    this.hideTaskTag = true;
    this.dialogControllerProgress.open();
    this.manager = LibraryManagerFactory.getInstance().getManager(LibraryManagerType.SCENE);
    let callback: UpdateLibraryCallback = {
      onSuccess: () => {
        this.hideTaskTag = false;
        this.dialogText = $r('app.string.scene_import_succ');
        this.loadStatus = LoadType.SUCC;
        setTimeout(() => {
          this.dialogControllerProgress.close();
        }, 2000);
      },
      onFailure: (code?: number, data?: object, msg?: string) => {
        this.hideTaskTag = false;
        this.loadStatus = LoadType.FAIL;
        setTimeout(() => {
          this.dialogControllerProgress.close();
        }, 2000);
      },
      onStart: () => {
      },
      onCheckVersionEnd: (code?: number, data?: object, msg?: string) => {
        if (code == UpdateLibraryCode.CHECK_VERSION_END_FAIL) {
          this.dialogText = $r('app.string.check_scene_version_fail');
          callback.onFailure();
        } else if (code == UpdateLibraryCode.CHECK_VERSION_END_SUCC_NO_UPDATE) {
          this.hideTaskTag = false;
          this.dialogText = $r('app.string.check_scene_version_no_update');
          this.loadStatus = LoadType.SUCC;
          setTimeout(() => {
            this.dialogControllerProgress.close();
          }, 2000);
        } else if (code == UpdateLibraryCode.CHECK_VERSION_END_SUCC_NEED_UPDATE) {
          this.currentUpgradeVersionCode = (data as UpgradeSceneLibrarySuccData).scenelibVersion;
          this.dialogText = $r('app.string.download_scene', this.currentUpgradeVersionCode, '0%');
        }
      },
      onDownLoading: (receivedSize: number, totalSize: number) => {
        this.dialogText = $r('app.string.download_scene', this.currentUpgradeVersionCode,
          '' + this.numfmt.format(receivedSize / totalSize));
      },
      onDownLoadEnd: (code?: number, data?: object, msg?: string) => {
        if (code == UpdateLibraryCode.DOWNLOAD_END_FAIL) {
          this.dialogText = $r('app.string.download_scene_fail');
          callback.onFailure();
        } else if (code == UpdateLibraryCode.DOWNLOAD_END_SUCC) {
          this.dialogText = $r('app.string.scene_verify');
        }
      },
      onVerifyEnd: (code?: number, data?: object, msg?: string) => {
        if (code == UpdateLibraryCode.VERIFY_END_FAIL) {
          this.dialogText = $r('app.string.verify_scene_fail');
          callback.onFailure();
        } else if (code == UpdateLibraryCode.VERIFY_END_SUCC) {
          this.dialogText = $r('app.string.scene_parse');
        }
      },
      onParseEnd: (code?: number, data?: object, msg?: string) => {
        if (code == UpdateLibraryCode.PARSE_END_SUCC) {
          this.dialogText = $r('app.string.scene_import');
        } else {
          this.dialogText = $r('app.string.parse_scene_fail');
          callback.onFailure();
        }
      },
      onRevertEnd: (code?: number, data?: object, msg?: string) => {
      }
    };
    this.manager.SyncLibrary(callback);
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.page_scene_store_sync'))
          .fontColor(this.fontColor)
          .fontWeight(this.isFontWeight ? FontWeight.Bold : FontWeight.Medium)
          .fontSize(this.fontSize)
          .focusable(true)
          .focusBox({
            strokeWidth: LengthMetrics.px(0)
          })
          .onFocus(() => {
            this.fontColor = $r('app.color.text_color_white');
            this.fontSize = $r('app.string.font_22');
            this.isFontWeight = true;
          })
          .onBlur(() => {
            this.fontColor = $r('app.color.default_text_color');
            this.fontSize = $r('app.string.font_20');
            this.isFontWeight = false;
          });
        Blank();
        Text(this.currentVersionCode)
          .fontColor($r('app.color.default_text_color'))
          .fontSize($r('app.string.font_16'))
          .margin({ right: $r('app.string.10_vp') });
      }.margin(scale(10)).width('100%');
    }.width('100%').padding({ left: scale(10) }).onClick(() => {

    });
  }
}