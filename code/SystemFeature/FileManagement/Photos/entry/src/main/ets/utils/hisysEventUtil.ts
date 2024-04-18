/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import hiSysEvent from '@ohos.hiSysEvent';
import { Log } from './Log';

const TAG = 'hisysEventUtil';

export function hiSysEventDataQueryTimedOut(interfaceName: string): number {
  let timeOutId = setTimeout((): void => {
    let params: Object = {
      FAULT_ID: 'DATA_QUERY_OVERTIME',
      MSG: interfaceName + ' Querying 1s data timed out.'
    };
    let info: hiSysEvent.SysEventInfo = {
      domain: 'PHOTOS_APP',
      name: 'PHOTOS_FAULT',
      eventType: hiSysEvent.EventType.FAULT,
      params: params
    };
    hiSysEvent.write(info, (err: Error): void => {
      if (err != null) {
        Log.error(TAG, 'fail to return hiSysEvent');
      }
    });
  },1000);
  return timeOutId;
}
