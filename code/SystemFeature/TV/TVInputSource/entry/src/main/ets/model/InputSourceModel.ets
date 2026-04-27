/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import LogUtil from '../utils/LogUtil';
import { SettingItemStyle } from '../utils/StyleConstants';
import BaseModel from './BaseModel';

const TAG = 'InputSourceModel';

export class InputSourceModel extends BaseModel {
  public name: string = ''; // 设置名

  public chooseDes: string = ''; // 设置选项选择后的描述

  public value: string = ''; // 设置值

  public isOn: boolean = false; // 开关状态

  public isSelect: boolean = false; // 选中状态

  public focusIndex: number = -1;

  public style: SettingItemStyle = SettingItemStyle.default; // item类型

  public pageUrl: string = ''; // 跳转路径

  public img: ResourceStr = ''; // 描述图片路径

  public selectedimg: ResourceStr = ''; // 描述图片选中的路径

  public des: string = ''; // 描述

  public ips: string[] = []; // ip地址（包含dns、网关、子网掩码等）

  public focusKeys: string[] = []; // 当前组件绑定的焦点键

  public isSetFocusKey: boolean = false; // 是否为当前组件设置focusKey，针对SettingItemTvComponent组件的title，值取focusKeys的第一个

  public isEnable: boolean = true; // 设置当前item是否可用

  public isNeedBg: boolean = true; // 是否需要背景色

  public isDefault: boolean = false; // 是否为默认

  public isDisableFocus: boolean = false; // 是否禁用当前组件获焦

  public imageMargin: number = 0;

  constructor() {
    super();
    LogUtil.info(`${TAG} init`);
  }

  public setIsOn = (isOn: boolean): void => {
    this.isOn = isOn;
  };

  public setIsDefault = (): void => {
    this.isDefault = !this.isDefault;
  };

  public setIsSelect = (isSelect: boolean): void => {
    this.isSelect = isSelect;
  };

  public setValue = (value: string): void => {
    this.value = value;
  };

  public setDes = (value: string): void => {
    this.des = value;
  };

  public setStyle = (value: SettingItemStyle): void => {
    this.style = value;
  };

  public setIsDisableFocus = (value: boolean): void => {
    this.isDisableFocus = value;
  };

  public setIsEnable = (flag: boolean): void => {
    this.isEnable = flag;
  };

}
