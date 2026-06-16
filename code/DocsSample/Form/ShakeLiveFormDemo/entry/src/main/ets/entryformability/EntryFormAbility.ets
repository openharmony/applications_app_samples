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
  formInfo,
  formProvider,
  FormExtensionAbility,
  formBindingData,
} from '@kit.FormKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Constants } from '../common/Constants';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { Want } from '@kit.AbilityKit';

const DOMAIN = 0x0000;
const TAG  = 'testTag';

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want: Want): formBindingData.FormBindingData {
    hilog.info(DOMAIN, TAG, '%{public}s', 'FormAbility onAddForm');
    return formBindingData.createFormBindingData('');
  }

  onCastToNormalForm(formId: string): void {
  }

  onUpdateForm(formId: string, wantParams?: Record<string, Object>): void {
    hilog.info(DOMAIN, TAG, 'FormAbility onUpdateForm:%{public}s', JSON.stringify(wantParams));
    try {
      formProvider.getFormRect(formId).then((rect: formInfo.Rect) => {
        this.requestOverflow(formId, rect.width, rect.height);
      })
    } catch (e) {
      hilog.error(DOMAIN, TAG, 'requestOverflow error: %{public}s', JSON.stringify(e));
      return;
    }
  }

  onChangeFormVisibility(newStatus: Record<string, number>): void {
  }

  onRemoveForm(formId: string): void {
  }

  onFormLocationChanged(formId: string, newFormLocation: formInfo.FormLocation): void {
  }

  async onFormEvent(formId: string, message: string) {
    hilog.info(DOMAIN, TAG, '%{public}s', 'FormAbility onFormEvent');
    let shortMessage: string = JSON.parse(message)['message'];
    // 当接收的 message 为 requestOverflow，触发互动卡片动效
    if (shortMessage === 'requestOverflow') {
      try {
        formProvider.getFormRect(formId).then((rect: formInfo.Rect) => {
          this.requestOverflow(formId, rect.width, rect.height);
        })
      } catch (e) {
        hilog.error(DOMAIN, TAG, 'requestOverflow error: %{public}s', JSON.stringify(e));
        return;
      }
    }
  }

  private requestOverflow(formId: string, formWidth: number, formHeight: number): void {
    if (formWidth <= 0 || formHeight <= 0) {
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
        area: { left: left, top: top, width: width, height: height },
        // 动效持续时间
        duration: duration,
        // 指定是否使用系统提供的默认切换动效
        useDefaultAnimation: true,
      }).then(() => {
        hilog.info(DOMAIN, TAG, '%{public}s', 'requestOverflow succeed');
      }).catch((error: BusinessError) => {
        hilog.error(DOMAIN, TAG, 'requestOverflow error: %{public}s', JSON.stringify(error));
      })
    } catch (e) {
      hilog.error(DOMAIN, TAG, 'requestOverflow error: %{public}s', JSON.stringify(e));
    }
  }
}