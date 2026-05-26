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

export enum ScanState {
  //未扫描
  NOT_START,
  //扫描中
  SCANNING,
  //扫描结束
  SCANNING_FINISH,
}

@Observed
export default class ScanModel {
  public currentScanState: ScanState = ScanState.NOT_START;
  //扫描剩余时间，单位s
  public scanLastTime: number = 0;
  private intervalId: number = 0;

  /**
   * 记录扫描时间，因为拖拽和列表切换的时候，开启动画的时间需要调整。animationTo主动结束的方法还没找到。
   * @param time 单位毫秒
   */
  startScan(time: number) {
    this.scanLastTime = time / 1000;
    this.intervalId = setInterval(() => {
      if (this.scanLastTime > 0) {
        this.scanLastTime--;
      } else {
        clearInterval(this.intervalId);
      }
    }, 1000);
  }
}