'use static'
/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start network_file_refresh]
// [Start local_file_refresh]
// entry/src/main/ets/entryformability/EntryFormAbility.ets
import { Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo } from '@kit.CoreFileKit';
import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { http } from '@kit.NetworkKit';
import { Configuration } from '@ohos.app.ability.Configuration';
import common from '@ohos.app.ability.common';
import { AppStorage } from '@ohos.arkui.stateManagement';

const TAG: string = 'EntryFormAbility';
const DOMAIN_NUMBER: int = 0xFF00;
const TEXT1: string = '刷新中...'
const TEXT2: string = '刷新失败'

function onAcquireFormStateCallback(want: Want): formInfo.FormState {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  hilog.info(DOMAIN_NUMBER, TAG, 'OnAcquireFormState register success');
  return formInfo.FormState.READY;
}

function onAcquireFormDataCallback(formId: string): Record<string, Object> {
  hilog.info(DOMAIN_NUMBER, TAG, 'onAcquireFormDataCallback success');
  let param: Record<string, Object> = {};
  param = {
    'title': 'onAcquireFormData'
  };
  return param;
}

function onShareFormCallback(formId: string): Record<string, Object> {
  hilog.info(DOMAIN_NUMBER, TAG, 'onAcquireFormDataCallback success');
  let param: Record<string, Object> = {};
  param = {
    'title': 'onShareForm'
  };
  return param;
}

class FormDataClass {
  public text: string = '';
  public loaded: boolean = false;
  // 卡片需要显示图片场景,必须和下列字段formImages中的key 'imgBear'相同。
  public imgName: string = '';
  // 卡片需要显示图片场景,必填字段(formImages不可缺省或改名), 'imgBear'对应fd
  public formImages: Record<string, number> = {};
}

export default class EntryFormAbility extends FormExtensionAbility {
  constructor() {
    hilog.info(DOMAIN_NUMBER, TAG, 'constructor register call');
    try {
      this.onStop = () => {
        hilog.info(DOMAIN_NUMBER, TAG, 'OnStop callback success');
      }
      hilog.info(DOMAIN_NUMBER, TAG, 'OnStop register success');
    } catch (err) {
      hilog.error(DOMAIN_NUMBER, TAG, `OnStop catch error code: ${err?.code}, message: ${err?.message}`);
    }

    this.onAcquireFormState = onAcquireFormStateCallback;
  }

  // [StartExclude network_file_refresh]
  onAddForm(want: Want): formBindingData.FormBindingData {
    // 假设在当前卡片应用的tmp目录下有一个本地图片：head.PNG
    let tempDir = this.context.getApplicationContext().tempDir;
    hilog.info(DOMAIN_NUMBER, TAG, `tempDir: ${tempDir}`);
    let imgMap: Record<string, number> = {};
    try { // 打开本地图片并获取其打开后的fd, FormExtensionAbility进程销毁时释放
      let file = fileIo.openSync(tempDir + '/' + 'head.PNG');
      imgMap['imgBear'] = file.fd;
    } catch (error) {
      hilog.info(DOMAIN_NUMBER, TAG, `openSync failed: code ${error?.code}, message ${error?.message}`);
    }

    let formData = new FormDataClass();
    formData.text = 'Image: Bear';
    formData.loaded = true;
    formData.imgName = 'imgBear';
    formData.formImages = imgMap; // 将fd封装在formData中并返回至卡片页面
    return formBindingData.createFormBindingData(formData);
  }

  // [EndExclude network_file_refresh]
  // [StartExclude local_file_refresh]
  onFormEvent(formId: string, message: string): void {
    let param: Record<string, string> = {
      'text': TEXT1
    };
    let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(param);
    formProvider.updateForm(formId, formInfo);

    // 注意：FormExtensionAbility在触发生命周期回调时被拉起，仅能在后台存在5秒
    // 建议下载能快速下载完成的小文件，如在5秒内未下载完成，则此次网络图片无法刷新至卡片页面上
    let netFile =
      'https://cn-assets.gitee.com/assets/mini_app-e5eee5a21c552b69ae6bf2cf87406b59.jpg'; // 需要在此处使用真实的网络图片下载链接
    let tempDir = this.context.getApplicationContext().tempDir;
    let fileName = 'file' + Date.now();
    let tmpFile = tempDir + '/' + fileName;
    let imgMap: Record<string, number> = {};
    let httpRequest = http.createHttp()
    httpRequest.request(netFile).then((data) => {
      if (data?.responseCode == http.ResponseCode.OK) {
        try {
          let imgFile = fileIo.openSync(tmpFile, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
          imgMap[fileName] = imgFile.fd;
          let writeLen: long = fileIo.writeSync(imgFile.fd, data.result as ArrayBuffer);
          hilog.info(DOMAIN_NUMBER, TAG, `write data to file succeed and size is: ${writeLen}`);
          hilog.info(DOMAIN_NUMBER, TAG, `ArkTSCard download complete: ${tmpFile}`);
          let formData = new FormDataClass();
          formData.text = 'Image: Bear' + fileName;
          formData.loaded = true;
          formData.imgName = fileName;
          formData.formImages = imgMap;
          let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData);
          hilog.info(DOMAIN_NUMBER, TAG, `doy ${JSON.stringify(formInfo)}`);
          formProvider.updateForm(formId, formInfo).then(() => {
            hilog.info(DOMAIN_NUMBER, TAG, 'FormAbility updateForm success.');
          }).catch((error) => {
            hilog.error(DOMAIN_NUMBER, TAG, `Operation updateForm failed. Cause: ${JSON.stringify(error)}`);
          });
        } catch (error) {
          hilog.error(DOMAIN_NUMBER, TAG, `openSync failed: code ${error?.code}, message ${error?.message}`);
        }

      } else {
        hilog.error(DOMAIN_NUMBER, TAG, 'ArkTSCard download task failed');
        let param: Record<string, string> = {
          'text': TEXT2
        };
        let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(param);
        formProvider.updateForm(formId, formInfo);
      }
      httpRequest.destroy();
    }).catch((e) => {
      hilog.error(DOMAIN_NUMBER, TAG, `request failed. code: ${e.code}, message: ${e.message}`);
    })
  }

  // [EndExclude local_file_refresh]
  onCastToNormalForm(formId: string): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onCastToNormalForm testing');
  }

  onUpdateForm(formId: string, wantParams?: Record<string, Object>): void {
    hilog.info(DOMAIN_NUMBER, TAG, `onUpdateForm callback, formid:${formId}`);
  }

  onChangeFormVisibility(newStatus: Record<string, int>): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onChangeFormVisibility testing ' + JSON.stringify(newStatus));
  }

  onRemoveForm(formId: string): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onRemoveForm testing');
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onConfigurationUpdate testing');
  }

  onFormLocationChanged(formId: string, newFormLocation: formInfo.FormLocation): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onFormLocationChanged testing');
  }
}

// [End local_file_refresh]
// [End network_file_refresh]