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

// [Start liveform_EntryFormAbility]
// entry/src/main/ets/entryformability/EntryFormAbility.ets
import { formInfo, formProvider, FormExtensionAbility } from '@kit.FormKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Constants } from '../common/Constants';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'EntryFormAbility';
const DOMAIN_NUMBER: number = 0xFF00;

export default class EntryFormAbility extends FormExtensionAbility {
  async onFormEvent(formId: string, message: string) {
    let shortMessage: string = JSON.parse(message)['message'];

    // 当接收的message为requestOverflow，触发互动卡片动效
    if (shortMessage === 'requestOverflow') {
      let formRect: formInfo.Rect = await formProvider.getFormRect(formId);
      this.requestOverflow(formId, formRect.width, formRect.height);
      return;
    }
  }

  private requestOverflow(formId: string, formWidth: number, formHeight: number): void {
    if (formWidth <= 0 || formHeight <= 0) {
      hilog.info(DOMAIN_NUMBER, TAG, 'requestOverflow failed, form size is not correct.');
      return;
    }

    // 基于卡片自身尺寸信息，计算卡片动效渲染区域
    let left: number = -Constants.OVERFLOW_LEFT_RATIO * formWidth;
    let top: number = -Constants.OVERFLOW_TOP_RATIO * formHeight;
    let width: number = Constants.OVERFLOW_WIDTH_RATIO * formWidth;
    let height: number = Constants.OVERFLOW_HEIGHT_RATIO * formHeight;
    let duration: number = Constants.OVERFLOW_DURATION;

    // 发起互动卡片动效申请
    try {
      formProvider.requestOverflow(formId, {
        // 动效申请范围
        area: {
          left: left,
          top: top,
          width: width,
          height: height
        },
        // 动效持续时间
        duration: duration,
        // 指定是否使用系统提供的默认切换动效
        useDefaultAnimation: true,
      }).then(() => {
        hilog.info(DOMAIN_NUMBER, TAG, 'requestOverflow requestOverflow succeed');
      }).catch((error: BusinessError) => {
        hilog.info(DOMAIN_NUMBER, TAG, `requestOverflow requestOverflow catch error` + `,
          code: ${error.code}, message: ${error.message}`);
      })
    } catch (e) {
      hilog.info(DOMAIN_NUMBER, TAG, `requestOverflow call requestOverflow catch error` + `,
        code: ${e.code}, message: ${e.message}`);
    }
  }
}
// [End liveform_EntryFormAbility]