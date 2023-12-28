/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import type Base from '@ohos.base';
import type fileFs from '@ohos.file.fs';
import formBindingData from '@ohos.app.form.formBindingData';
import FormExtensionAbility from '@ohos.app.form.FormExtensionAbility';
import formInfo from '@ohos.app.form.formInfo';
import formProvider from '@ohos.app.form.formProvider';
import fs from '@ohos.file.fs';
import hilog from '@ohos.hilog';
import request from '@ohos.request';
import type Want from '@ohos.app.ability.Want';

const TAG: string = 'WgtImgUpdateEntryFormAbility';
const DOMAIN_NUMBER: number = 0xFF00;

export default class WgtImgUpdateEntryFormAbility extends FormExtensionAbility {
  // 在添加卡片时，打开一个本地图片并将图片内容传递给卡片页面显示
  onAddForm(want: Want): formBindingData.FormBindingData {
    // 假设在当前卡片应用的tmp目录下有一个本地图片：head.PNG
    let tempDir = this.context.getApplicationContext().tempDir;
    hilog.info(DOMAIN_NUMBER, TAG, `tempDir: ${tempDir}`);
    // 打开本地图片并获取其打开后的fd
    let file: fileFs.File;
    let imgBear: Record<string, number>;
    try {
      file = fs.openSync(tempDir + '/' + 'head.PNG');
      imgBear = {
        'imgBear': file.fd
      };
    } catch (e) {
      hilog.error(DOMAIN_NUMBER, TAG, `openSync failed: ${JSON.stringify(e as Base.BusinessError)}`);
    };

    class FormDataClass {
      text: string = 'Image: Bear';
      imgName: string = 'imgBear';
      loaded: boolean = true;
      formImages: Record<string, number> = imgBear;
    }

    let formData = new FormDataClass();

    // 将fd封装在formData中并返回至卡片页面
    return formBindingData.createFormBindingData(formData);
  }

  onFormEvent(formId: string, message: string): void {
    let param: Record<string, string> = {
      'text': '刷新中...'
    };
    let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(param);
    formProvider.updateForm(formId, formInfo);
    // 注意：FormExtensionAbility在触发生命周期回调时被拉起，仅能在后台存在5秒
    // 建议下载能快速下载完成的小文件，如在5秒内未下载完成，则此次网络图片无法刷新至卡片页面上
    let netFile = 'https://cn-assets.gitee.com/assets/mini_app-e5eee5a21c552b69ae6bf2cf87406b59.jpg'; // 需要在此处使用真实的网络图片下载链接
    let tempDir = this.context.getApplicationContext().tempDir;
    let fileName = 'file' + Date.now();
    let tmpFile = tempDir + '/' + fileName;
    request.downloadFile(this.context, {
      url: netFile, filePath: tmpFile, enableMetered: true, enableRoaming: true
    }).then((task) => {
      task.on('complete', () => {
        hilog.info(DOMAIN_NUMBER, TAG, 'ArkTSCard download complete: %{public}s', tmpFile);
        let file: fileFs.File;
        let fileInfo: Record<string, string | number> = {};
        try {
          file = fs.openSync(tmpFile);
          fileInfo[fileName] = file.fd;
        } catch (e) {
          hilog.error(DOMAIN_NUMBER, TAG, `openSync failed: ${JSON.stringify(e as Base.BusinessError)}`);
        };

        class FormDataClass {
          text: string = 'Image: Bear' + fileName;
          imgName: string = fileName;
          loaded: boolean = true;
          formImages: object = fileInfo;
        }

        let formData = new FormDataClass();
        let formInfo = formBindingData.createFormBindingData(formData);
        formProvider.updateForm(formId, formInfo).then(() => {
          hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'FormAbility updateForm success.');
        }).catch((error: Base.BusinessError) => {
          hilog.error(DOMAIN_NUMBER, TAG, `FormAbility updateForm failed: ${JSON.stringify(error)}`);
        });
      });
      task.on('fail', (err: number) => {
        hilog.info(DOMAIN_NUMBER, TAG, `ArkTSCard download task failed. Cause: ${JSON.stringify(err)}`);
        let param: Record<string, string> = {
          'text': '刷新失败'
        };
        let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(param);
        formProvider.updateForm(formId, formInfo);
      });
    }).catch((err: Base.BusinessError) => {
      hilog.error(DOMAIN_NUMBER, TAG, `Failed to request the download. Cause: ${JSON.stringify(err)}`);
    });
  }

  onAcquireFormState(want: Want): formInfo.FormState {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
}