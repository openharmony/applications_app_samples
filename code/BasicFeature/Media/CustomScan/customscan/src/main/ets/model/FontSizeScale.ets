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

import { logger } from '../common/util/Logger';

export class FontSizeScale {
  public static getLimitFontSize(fontSizeScale: number, maxScale: number, res: Resource): number | string | Resource {
    let fontSizePx: number;
    try {
      fontSizePx = getContext().resourceManager.getNumber(res.id);
    } catch (error) {
      logger.error( `Failed to flush preference. Code: ` + error.code);
      return res;
    }
    let fontSizeVp: number = px2vp(fontSizePx);
    return fontSizeScale > maxScale ? `${fontSizeVp * maxScale}vp` : fontSizeVp;
  }
}