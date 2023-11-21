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

import type featureAbility from '@ohos.ability.featureAbility';
import type Want from '@ohos.app.ability.Want';
import formBindingData from '@ohos.app.form.formBindingData';
import formInfo from '@ohos.app.form.formInfo';
import formProvider from '@ohos.app.form.formProvider';
import dataPreferences from '@ohos.data.preferences';
import hilog from '@ohos.hilog';

const TAG: string = '[Sample_FAModelAbilityDevelop]';
const domain: number = 0xFF00;
const DATA_STORAGE_PATH: string = 'form_store';
let storeFormInfo = async (formId: string, formName: string, tempFlag: boolean, context: featureAbility.Context): Promise<void> => {
  // 此处仅对卡片ID：formId，卡片名：formName和是否为临时卡片：tempFlag进行了持久化
  let formInfo: Record<string, string | number | boolean> = {
    formName: 'formName',
    tempFlag: 'tempFlag',
    updateCount: 0
  };
  try {
    const storage = await dataPreferences.getPreferences(context, DATA_STORAGE_PATH);
    // put form info
    await storage.put(formId, JSON.stringify(formInfo));
    hilog.info(domain, TAG, `storeFormInfo, put form info successfully, formId: ${formId}`);
    await storage.flush();
  } catch (err) {
    hilog.error(domain, TAG, `failed to storeFormInfo, err: ${JSON.stringify(err as Error)}`);
  }
};

let deleteFormInfo = async (formId: string, context: featureAbility.Context): Promise<void> => {
  try {
    const storage = await dataPreferences.getPreferences(context, DATA_STORAGE_PATH);
    // del form info
    await storage.delete(formId);
    hilog.info(domain, TAG, `deleteFormInfo, del form info successfully, formId: ${formId}`);
    await storage.flush();
  } catch (err) {
    hilog.error(domain, TAG, `failed to deleteFormInfo, err: ${JSON.stringify(err)}`);
  }
};

class LifeCycle {
  onCreate: (want: Want) => formBindingData.FormBindingData = (want) => ({ data: '' });
  onCastToNormal: (formId: string) => void = (formId) => {
  };
  onUpdate: (formId: string) => void = (formId) => {
  };
  onVisibilityChange: (newStatus: Record<string, number>) => void = (newStatus) => {
    let obj: Record<string, number> = {
      'test': 1
    };
    return obj;
  };
  onEvent: (formId: string, message: string) => void = (formId, message) => {
  };
  onDestroy: (formId: string) => void = (formId) => {
  };
  onAcquireFormState?: (want: Want) => formInfo.FormState = (want) => (0);
  onShare?: (formId: string) => Record<string, number | string | boolean | object | undefined | null> = (formId) => {
    let obj: Record<string, number> = {
      test: 1
    };
    return obj;
  };
}

let obj: LifeCycle = {
  onCreate(want: Want) {
    hilog.info(domain, TAG, 'FormAbility onCreate');
    if (want.parameters) {
      let formId = String(want.parameters['ohos.extra.param.key.form_identity']);
      let formName = String(want.parameters['ohos.extra.param.key.form_name']);
      let tempFlag = Boolean(want.parameters['ohos.extra.param.key.form_temporary']);
      // 将创建的卡片信息持久化，以便在下次获取/更新该卡片实例时进行使用
      // 此接口请根据实际情况实现，具体请参考：FormExtAbility Stage模型卡片实例
      hilog.info(domain, TAG, 'FormAbility onCreate' + formId);
      storeFormInfo(formId, formName, tempFlag, this.context);
    }

    // 使用方创建卡片时触发，提供方需要返回卡片数据绑定类
    let obj: Record<string, string> = {
      title: 'titleOnCreate',
      detail: 'detailOnCreate'
    };
    let formData: formBindingData.FormBindingData = formBindingData.createFormBindingData(obj);
    return formData;
  },
  onCastToNormal(formId: string) {
    // 使用方将临时卡片转换为常态卡片触发，提供方需要做相应的处理
    hilog.info(domain, TAG, 'FormAbility onCastToNormal');
  },
  onUpdate(formId: string) {
    // 若卡片支持定时更新/定点更新/卡片使用方主动请求更新功能，则提供方需要重写该方法以支持数据更新
    hilog.info(domain, TAG, 'FormAbility onUpdate');
    let obj: Record<string, string> = {
      title: 'titleOnUpdate',
      detail: 'detailOnUpdate'
    };
    let formData: formBindingData.FormBindingData = formBindingData.createFormBindingData(obj);
    // 调用updateForm接口去更新对应的卡片，仅更新入参中携带的数据信息，其他信息保持不变
    formProvider.updateForm(formId, formData).catch((error: Error) => {
      hilog.error(domain, TAG, 'FormAbility updateForm, error:' + JSON.stringify(error));
    });
  },
  onVisibilityChange(newStatus: Record<string, number>) {
    // 使用方发起可见或者不可见通知触发，提供方需要做相应的处理，仅系统应用生效
    hilog.info(domain, TAG, 'FormAbility onVisibilityChange');
  },
  onEvent(formId: string, message: string) {
    // 若卡片支持触发事件，则需要重写该方法并实现对事件的触发
    let obj: Record<string, string> = {
      title: 'titleOnEvent',
      detail: 'detailOnEvent'
    };
    let formData: formBindingData.FormBindingData = formBindingData.createFormBindingData(obj);
    // 调用updateForm接口去更新对应的卡片，仅更新入参中携带的数据信息，其他信息保持不变
    formProvider.updateForm(formId, formData).catch((error: Error) => {
      hilog.error(domain, TAG, 'FormAbility updateForm, error:' + JSON.stringify(error));
    });
    hilog.info(domain, TAG, 'FormAbility onEvent');
  },
  onDestroy(formId: string) {
    // 删除卡片实例数据
    hilog.info(domain, TAG, 'FormAbility onDestroy');
    // 删除之前持久化的卡片实例数据
    // 此接口请根据实际情况实现，具体请参考：FormExtAbility Stage模型卡片实例
    deleteFormInfo(formId, this.context);
  },
  onAcquireFormState(want: Want) {
    hilog.info(domain, TAG, 'FormAbility onAcquireFormState');
    return formInfo.FormState.READY;
  }
};

export default obj;