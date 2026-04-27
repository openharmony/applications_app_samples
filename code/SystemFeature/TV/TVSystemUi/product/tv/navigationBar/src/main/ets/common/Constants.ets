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
 

export default class Constants {
  public static readonly KEY_DOWN: number = 0;
  public static readonly KEY_UP: number = 1;
  public static readonly KEYCODE_NONE: number = -1;
  public static readonly KEYCODE_BACK: number = 1;
  public static readonly KEYCODE_HOME: number = 2;
  public static readonly KEYCODE_RECENT: number = 3;
  public static readonly ONE_TEMPLATE: string = '1fr';
  public static readonly THREE_TEMPLATE: string = '1fr 1fr 1fr';
  public static readonly ONE_ICON_LAYOUT: number = 1;
  public static readonly THREE_ICON_LAYOUT: number = 3;
}

export const NAVIGATIONBAR_HIDE_EVENT = 'systemui.event.NAVIGATIONBAR_HIDE';

export class NavigationBarComponentData {
  public isEnable = true;
  public backgroundColor = '#00000000';
  private contentColor = '#FFFFFFFF';
}
