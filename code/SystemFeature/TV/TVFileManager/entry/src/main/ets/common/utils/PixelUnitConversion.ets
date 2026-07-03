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
import { display } from '@kit.ArkUI';
import lpx from './Lpx';


export class Units {
  static px2fp(size: number) {
    if (display.getDefaultDisplaySync().width > 3800) {
      return px2fp(size * 1.1);
    } else {
      return px2fp(size);
    }
  }

  static px2vp(size: number) {
    if (display.getDefaultDisplaySync().width > 3800) {
      return px2vp(size * 1.1);
    } else {
      return px2vp(size);
    }
  }

  static px(size: number) {
    if (display.getDefaultDisplaySync().width > 3800) {
      return `${size * 1.1}px`;
    } else {
      return `${size}px`;
    }
  }
}
