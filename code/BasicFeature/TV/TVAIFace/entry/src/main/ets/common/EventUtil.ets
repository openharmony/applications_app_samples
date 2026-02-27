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

import { PointerUtil } from './PointerUtil';

/**
 * 事件相关工具类
 */
export class EventUtil {
  /**
   * 判断是否触发触摸事件
   * @returns 判断结果
   */
  static isTouchEvent(event: TouchEvent): boolean {


    PointerUtil.changePointStyle(event.type === TouchType.Down);

    if (event.type === TouchType.Down) {
      return false;
    }

    return event.source === SourceType.Mouse || event.source === SourceType.TouchScreen;
  }
}