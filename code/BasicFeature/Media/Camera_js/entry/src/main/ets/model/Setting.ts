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

export class Setting {
  private mirrorBol: boolean; // 镜像使能 -> 关闭
  private videoStabilizationMode: number; // 视频防抖 -> 关闭
  private exposureMode: number; // 曝光模式 -> 自动
  private focusMode: number; // 对焦模式 -> 自动
  private photoQuality: number; // 拍照质量 -> 中
  private locationBol: boolean; // 显示地理位置 -> 关闭
  private photoFormat: number; // 照片格式 -> JPG
  private photoOrientation: number; // 照片方向 -> 0
  private photoResolution: number; // 照片分辨率 -> 1920 * 1080
  private videoResolution: number; // 照片分辨率 -> 1920 * 1080
  private videoFrame: number; // 录像帧率 -> 15
  private dividerBol: boolean; // 分割线 -> 关闭
}
