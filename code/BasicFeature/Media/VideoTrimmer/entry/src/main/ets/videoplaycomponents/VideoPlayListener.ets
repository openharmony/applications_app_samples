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

/**
 * 视频播放回调接口
 */
export interface VideoPlayListener {
  // 准备完毕
  onPrepared: (duration :number) => void;
  // 播放状态
  onPlayStatus: (isPlay : boolean) => void;

  // 播放至结尾状态回调
  onComplete: () => void;

  // 时间上报函数回调
  onTimeUpdate: (time: number) => void;

  // 比特率更新回调
  onBitrateUpdate: (bitrateList: number[]) => void;

  // 错误状态回调
  onErrorUpdate: (error: string) => void;
}
