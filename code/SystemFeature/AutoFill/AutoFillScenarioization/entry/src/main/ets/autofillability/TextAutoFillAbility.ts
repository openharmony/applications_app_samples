/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { autoFillManager, AutoFillExtensionAbility, UIExtensionContentSession } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'autoFill';
const DOMAIN_NUMBER: number = 0xFF00;
const BOTTOM_LEFT: number = 6;

function suggestWords(input: string, words: string[]): string[] {
  if (input.length < 1) {
    return []; // 如果输入的字符少于1个，则不提供联想
  }
  return words.filter(word => word.includes(input));
}

export default class TextAutoFillAbility extends AutoFillExtensionAbility {
  onCreate(): void {
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'autofill onCreate');
    AppStorage.setOrCreate('contextEvent', this.context);
  }

  onDestroy(): void {
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'autofill onDestroy');
  }

  onSessionDestroy(session: UIExtensionContentSession) {
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'autofill onSessionDestroy');
    hilog.info(DOMAIN_NUMBER, TAG, 'session content: %{public}s', JSON.stringify(session));
  }

  onForeground(): void {
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'autofill onForeground');
  }

  onBackground(): void {
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'autofill onBackground');
  }

  onUpdateRequest(request: autoFillManager.UpdateRequest): void {
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'autofill onUpdateRequest');
    let storage = LocalStorage.getShared();
    let fillCallback = storage.get<autoFillManager.FillRequestCallback>('fillCallback');
    let size: autoFillManager.PopupSize = {
      width: 656,
      height: 149
    };
    fillCallback.setAutoFillPopupConfig({
      popupSize: size,
      placement: BOTTOM_LEFT
    });
    let nameList: string = '';
    for (let i = 0; i < request.viewData.pageNodeInfos.length; i++) {
      nameList = request.viewData.pageNodeInfos[i].value;
    }
    const words = ['lily', 'linda', 'john', 'tom', 'peter'];
    let suggestions: Array<string> = suggestWords(nameList, words);

    request.viewData.pageNodeInfos.find((item) => {
      if (item.isFocus && item.value.length != 0 && item.autoFillType == autoFillManager.AutoFillType.PERSON_FULL_NAME) {
        this.context.eventHub.emit('updateRequestData', suggestions);
      }
    })
  }

  onFillRequest(session: UIExtensionContentSession, request: autoFillManager.FillRequest, callback: autoFillManager.FillRequestCallback) {
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'autofill onFillRequest');
    AppStorage.setOrCreate('interface', 'actionStr');
    try {
      let storage_fill = new LocalStorage(
        {
          'session': session,
          'message': 'AutoFill Page',
          'fillCallback': callback,
          'viewData': request.viewData,
          'pageNodeInfos': request.viewData.pageNodeInfos,
          'autoFillType': request.type
        });
      let size: autoFillManager.PopupSize = {
        width: 656,
        height: 220
      };
      callback.setAutoFillPopupConfig({
        popupSize: size,
        placement: BOTTOM_LEFT
      });
      session.loadContent('autofillpages/SelectorList', storage_fill);
    } catch (err) {
      hilog.error(DOMAIN_NUMBER, TAG, '%{public}s', 'autofill failed to load content');
    }
  }

  onSaveRequest(session: UIExtensionContentSession, request: autoFillManager.SaveRequest, callback: autoFillManager.SaveRequestCallback) {
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'autofill onSaveRequest');
    let storage_save = new LocalStorage(
      {
        'session': session,
        'message': 'AutoFill Page',
        'saveCallback': callback,
        'viewData': request.viewData
      });
    session.loadContent('autofillpages/SavePage', storage_save);
  }
}