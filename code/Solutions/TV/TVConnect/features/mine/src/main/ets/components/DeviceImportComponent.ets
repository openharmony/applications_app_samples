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
import picker from '@ohos.file.picker';
import { DiaLogComponent, LoadType } from './DiaLogComponent';
import promptAction from '@ohos.promptAction';
import { LibraryManagerFactory, LibraryManagerType } from '../model/manager/LibraryManagerFactory';
import { UpdateLibraryCallback } from '../model/callback/UpdateLibraryCallback';
import { LibraryManager, UpdateLibraryCode } from '../model/manager/LibraryManager';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 我的页面-设备库导入
 */
@Builder
export function DeviceLibraryFileImportPageItem() {
  DeviceLibraryFileImportComponent();
}

/**
 * 设备库导入UI组件
 */
@Component
struct DeviceLibraryFileImportComponent {
  selectFileUri: string | undefined = undefined; //在文件选择器中选择的文件url
  @Provide dialogText: Resource = $r('app.string.device_parse');
  @Provide loadStatus: LoadType = LoadType.LOADING;
  @State hideTaskTag: boolean = true;
  @State manager: LibraryManager = LibraryManagerFactory.getInstance().getManager(LibraryManagerType.DEVICE);
  dialogControllerProgress: CustomDialogController = new CustomDialogController({
    builder: DiaLogComponent(),
    autoCancel: true,
    customStyle: false,
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

  /**
   * 导入当前选择的文件
   */
  async importFile() {
    await this.callFilePickerSelectFile();
    if (this.selectFileUri != undefined) {
      this.dialogText = $r('app.string.device_verify');
      this.loadStatus = LoadType.LOADING;
      this.hideTaskTag = true;
      this.dialogControllerProgress.open();
      this.manager = LibraryManagerFactory.getInstance().getManager(LibraryManagerType.DEVICE);
      let callback: UpdateLibraryCallback = {
        onSuccess: () => {
          this.hideTaskTag = false;
          this.dialogText = $r('app.string.device_import_succ');
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
        },
        onDownLoading: (receivedSize: number, totalSize: number) => {
        },
        onDownLoadEnd: (code?: number, data?: object, msg?: string) => {
        },
        onVerifyEnd: (code?: number, data?: object, msg?: string) => {
          if (code == UpdateLibraryCode.VERIFY_END_FAIL) {
            this.dialogText = $r('app.string.verify_device_fail');
            callback.onFailure();
          } else if (code == UpdateLibraryCode.VERIFY_END_SUCC) {
            this.dialogText = $r('app.string.device_parse');
          }
        },
        onParseEnd: (code?: number, data?: object, msg?: string) => {
          if (code == UpdateLibraryCode.PARSE_END_SUCC) {
            this.dialogText = $r('app.string.device_import');
          } else {
            this.dialogText = $r('app.string.parse_device_fail');
            callback.onFailure();
          }
        },
        onRevertEnd: (code?: number, data?: object, msg?: string) => {
        }
      };
      this.manager.importLibrary(this.selectFileUri, callback);
    }
    this.selectFileUri = undefined;
  }

  /**
   * 打开文件选择器
   */
  async callFilePickerSelectFile(): Promise<void> {
    try {
      let documentSelectOptions = new picker.DocumentSelectOptions();
      let documentPicker = new picker.DocumentViewPicker();
      let documentSelectResult: string[] = await documentPicker.select(documentSelectOptions);
      if (documentSelectResult.length >= 1) {
        this.selectFileUri = decodeURI(documentSelectResult[0]);
      }
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error('DocumentViewPicker failed with err: ' + JSON.stringify(err));
    }
  }

  build() {
    Column() {
      SimpleItem({ name: $r('app.string.page_device_store_import') });
    }.width('100%').onClick(() => {
      this.importFile();
    });
  }
}