/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import type { FillRequest, SaveRequest, FillRequestCallback, SaveRequestCallback } from 'application/AutoFillRequest';
import type UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import AutoFillExtensionAbility from '@ohos.app.ability.AutoFillExtensionAbility';
import Logger from '../log/Logger';

const AUTOFILLTYPE = 3;

export default class AutoFillAbility extends AutoFillExtensionAbility {
  onCreate(): void {
    Logger.info('testTag', '%{public}s', 'autofill onCreate');
  }

  onDestroy(): void {
    Logger.info('testTag', '%{public}s', 'autofill onDestroy');
  }

  onSessionDestroy(session: UIExtensionContentSession): void {
    Logger.info('testTag', '%{public}s', 'autofill onSessionDestroy');
    Logger.info('testTag', 'session content: %{public}s', JSON.stringify(session));
  }

  onForeground(): void {
    Logger.info('testTag', '%{public}s', 'autofill onForeground');
  }

  onBackground(): void {
    Logger.info('testTag', '%{public}s', 'autofill onBackground');
  }

  onFillRequest(session: UIExtensionContentSession, request: FillRequest, callback: FillRequestCallback): void {
    Logger.info('testTag', '%{public}s', 'autofill onFillRequest');
    Logger.info('testTag', 'fill requestCallback: %{public}s', JSON.stringify(callback));
    Logger.info('get request viewData: ', JSON.stringify(request.viewData));
    try {
      let storageFill = new LocalStorage(
        {
          'session': session,
          'message': 'AutoFill Page',
          'fillCallback': callback,
          'viewData': request.viewData,
          'pageNodeInfos': request.viewData.pageNodeInfos,
        });
      request.viewData.pageNodeInfos.forEach((item) => {
        if (item.autoFillType === AUTOFILLTYPE) {
          session.loadContent('autofillpages/AutoFillNewPassWord', storageFill);
        } else {
          session.loadContent('autofillpages/AutoFillControl', storageFill);
        }
      });
    } catch (err) {
      Logger.error('testTag', '%{public}s', 'autofill failed to load content');
    }
  }

  onSaveRequest(session: UIExtensionContentSession, request: SaveRequest, callback: SaveRequestCallback): void {
    Logger.info('testTag', '%{public}s', 'autofill onSaveRequest');

    let storageSave = new LocalStorage(
      {
        'session': session,
        'message': 'AutoFill Page',
        'saveCallback': callback,
        'viewData': request.viewData
      });
    session.loadContent('autofillpages/SavePage', storageSave);
  }
}
