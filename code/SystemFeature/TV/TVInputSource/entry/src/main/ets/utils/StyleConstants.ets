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

export enum SettingItemStyle {
  default = 0, // 默认右箭头
  switch, // 开关;
  valueChange, // 左右箭头改变值;
  singleChoose, // 单选框;
  ip ,// ip设置;
  info//仅显示选项信息;
}

export enum CustomDialogButtonStyle {
  default = 0, // 默认“取消”、“确认” 2个按钮
  single // “确认” 1个按钮;
}

export enum CustomDialogContentStyle {
  default = 0, // 默认文字描述（不带标题）
  titleContent, // 文字描述（带标题）;
  input, // 输入框（不带标题）;
  titleInput // 输入框（带标题）;
}

export class StyleConstants {
  public static readonly DEFAULT_BG_COLOR = '#ff262e3c';
  public static readonly DEFAULT_DIALOG_COLOR = '#323232';
  public static readonly DEFAULT_BACKGROUND_IMAGE = '../../resources/base/media/default_background.png';
}

export enum SourceType {
  SOURCE_MEDIA,
  SOURCE_HDMI1,
  SOURCE_HDMI2,
  SOURCE_HDMI3,
  SOURCE_HDMI4,
  SOURCE_CVBS1,
  SOURCE_DTMB,
  SOURCE_DVBC,
  SOURCE_DVBT,
  SOURCE_CAST,
  SOURCE_GRAPHIC,
  SOURCE_NETWORK,
  SOURCE_BUTT
}
