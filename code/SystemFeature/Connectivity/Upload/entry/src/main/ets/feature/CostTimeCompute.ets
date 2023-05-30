/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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
import request from '@ohos.request'

export default class CostTimeCompute {
  lastTimeStr: string = "";
  startDownloadTime: Date = null;
  timerId: number;
  costTime: number = 0;
  private lastTimeChangeCallback: (str: string) => {}
  private getProgress: () => number
  private getTotal: () => {}
  private getCostTime: (str: string) => {}
  private getSpeedSize: (str: string) => {}
  private getDownloadTask: () => request.DownloadTask
  private showChinese: boolean;
  private lastProgress = 0;

  constructor(lastTimeChangeCallback, getProgress, getTotal, getCostTime = null, showChinese = true, getSpeedSize = null) {
    this.lastTimeChangeCallback = lastTimeChangeCallback;
    this.getProgress = getProgress;
    this.getTotal = getTotal;
    this.getCostTime = getCostTime;
    this.getSpeedSize = getSpeedSize;
    this.showChinese = showChinese;
  }

  //开始或者恢复剩余时间计算
  startCostTime() {
    if (this.costTime == 0) {
      this.startDownloadTime = new Date();
    } else {
      this.startDownloadTime = new Date(Date.now() - this.costTime);
    }
    this.timerId = setInterval(() => {
      this.computeLastTime();
      this.computeSpeed();
    }, 1000, 0);
  }

  cancelCostTime() {
    this.pauseCostTime();
    this.costTime = 0;
    this.lastTimeStr = "";
    this.lastProgress = 0;
  }

  pauseCostTime() {
    this.startDownloadTime = null;
    if (this.timerId != null) {
      clearInterval(this.timerId);
    }
    this.timerId = null;
  }

  //计算下载速度
  private computeSpeed() {
    if (this.getSpeedSize == null) {
      return;
    }
    const newProgress: number = this.getProgress();
    const newSize = newProgress - this.lastProgress;
    this.lastProgress = newProgress;
    this.getSpeedSize(this.compareSize(newSize));
  }

  //计算剩余下载时间
  private computeLastTime() {
    this.costTime = Date.now() - this.startDownloadTime.getTime();
    if (this.getProgress() != 0) {
      let lastTime = Math.floor(this.costTime / (this.getProgress() as number) * (this.getTotal() as number)) - this.costTime;
      this.lastTimeStr = this.getTimeStr(lastTime);
      this.lastTimeChangeCallback(this.lastTimeStr);
    }
    if (this.getCostTime != null) {
      this.getCostTime(this.getTimeStr(this.costTime));
    }
  }

  private compareSize(bits: number): string {
    if (bits > 1024 * 1024) {
      const m = bits / (1024 * 1024);
      return m.toFixed(1) + "MB/s";
    } else if (bits > 1024) {
      const k = bits / 1024;
      return k.toFixed(1) + "KB/s";
    } else {
      return bits + "B/s"
    }
  }

  private getTimeStr(ms: number) {
    let second = Math.floor(ms / 1000);
    const minStr = Math.floor(second / 60);
    const secStr = Math.floor(second % 60);
    return this.placeHolder(minStr) + ":" + this.placeHolder(secStr);
  }

  private placeHolder(n: number): string {
    if (n <= 0) {
      return "00";
    }
    return n < 10 ? ('0' + n) : ("" + n)
  }
}