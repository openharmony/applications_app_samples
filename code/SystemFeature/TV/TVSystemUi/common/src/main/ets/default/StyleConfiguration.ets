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
 

import CommonStyleManager from './CommonStyleManager';
import { deviceInfo } from '@kit.BasicServicesKit';

const TAG = 'Common-StyleConfiguration';
const deviceTypeInfo = deviceInfo.deviceType;

export class CommonStyle {
  public statusBarFontSize: Length = deviceTypeInfo === 'phone' ? '12fp' : '16fp';
  public statusBarIconWidth: Length = '24vp';
  public statusBarIconHeight: Length = '24vp';
  public statusBarMarginLeftRight: Length = deviceTypeInfo === 'phone' ? '0vp' : $r('app.float.status_bar_margin_left_right');
  public deviceTypeInfo = deviceTypeInfo;
}

export default class StyleConfiguration {
  static getCommonStyle(): CommonStyle {
    const key: string = TAG + '-Common';
    return CommonStyleManager.getStyle(key, new CommonStyle());
  }
}