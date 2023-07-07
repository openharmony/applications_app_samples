// @ts-nocheck
/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import createOrGet from './SingleInstanceUtil';
import Logger from './Logger';
import systemTime from '@ohos.systemDateTime';

const TAG = 'TimerUtil';
const ONE_SECOND = 1000; // 1s


export declare type Observer = (count: number) => void;

/**
 *  一个线程启动多个setInterval可能会发生一些问题
 */
class TimerUtil {
  private observers: Observer[] = [];

  private taskId: number;
  private count: number = 0;
  private startTimestamp: number;

  startTimer(): void {
    this.clearObservers();
    this.clearCount();
    this.taskId = setInterval(() => {
      this.task();
    }, ONE_SECOND);
    this.setCurrentTimestamp();
  }

  private task(): void {
    try {
      this.count = this.count + 1;
      this.notifyObservers(this.count);
    } catch (err) {

    }
  }

  setCurrentTimestamp(): void {
    systemTime.getCurrentTime(false).then((data) => {
      this.startTimestamp = data;
    });
  }

  stopTimer(): void {
    this.clearObservers();
    if (this.taskId) {
      clearInterval(this.taskId);
    }
  }

  clearCount(): void {
    this.setCurrentTimestamp();
    this.count = 0;
  }


  registerObserver(observer: Observer): Observer {
    const index = this.observers.findIndex(val => val === observer);
    if (index < 0) {
      this.observers.push(observer);
    }
    Logger.info(`${TAG}  registerCallback ${this.observers.length}`);
    return observer;
  }

  removeObserver(observer: Observer): void {
    const index = this.observers.findIndex(val => val === observer);
    if (index > -1) {
      this.observers.splice(index, 1);
    }
    Logger.info(`${TAG}  removeObserver ${this.observers.length}`);
  }

  notifyObservers(count: number): void {
    Logger.info(`${TAG}  notifyObserver size ${this.observers.length}  ${count}`);
    this.observers.forEach((ob) => {
      ob(count);
    });
  }

  clearObservers(): void {
    this.observers = [];
  }

  getCount(): number {
    return this.count;
  }

  getTimestamp(): Promise<number> {
    return new Promise((resolve, reject) => {
      systemTime.getCurrentTime(false).then((data) => {
        resolve(data - this.startTimestamp);
      }).catch((err) => {
        reject(err);
      });
    });
  }
}

let mUtil = createOrGet(TimerUtil, TAG);

export default mUtil as TimerUtil;
