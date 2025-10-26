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
// [Start Common_Utils]
// common/Utils.ets
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

export class PixelUtils {
  public static uiContext : UIContext | undefined;
  static setUIContext(uiContext : UIContext) : void {
    PixelUtils.uiContext = uiContext;
  }

  static vp2px(vpValue: number, uiContext?: UIContext): number | undefined {
    let _uiContext = uiContext??PixelUtils.uiContext;
    if (!_uiContext || !_uiContext.isAvailable()) {
      hilog.error(DOMAIN, 'testTag', `Can't get UIContext`);
      return undefined;
    }
    return _uiContext.vp2px(vpValue)
  }

  static fp2px(fpValue: number, uiContext?: UIContext): number | undefined {
    let _uiContext = uiContext??PixelUtils.uiContext;
    if (!_uiContext || !_uiContext.isAvailable()) {
      hilog.error(DOMAIN, 'testTag', `Can't get UIContext`);
      return undefined;
    }
    return _uiContext.fp2px(fpValue)
  }

  lpx2px(lpxValue: number, uiContext?: UIContext): number | undefined {
    let _uiContext = uiContext??PixelUtils.uiContext;
    if (!_uiContext || !_uiContext.isAvailable()) {
      hilog.error(DOMAIN, 'testTag', `Can't get UIContext`);
      return undefined;
    }
    return _uiContext.lpx2px(lpxValue)
  }
}
// [End Common_Utils]