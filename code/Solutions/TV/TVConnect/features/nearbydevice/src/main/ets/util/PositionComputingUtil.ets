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
import DragSceneConstants from '../constants/DragSceneConstants';
import DragSceneInitParams from '../viewmodel/DragSceneInitParams';
import Point from '../viewmodel/Point';
import emitter from '@ohos.events.emitter';
import { EventConstants } from '@ohos/common/src/main/ets/constants/EventConstants';
import { Logger } from '@ohos/common';
import TrigonometricFunctionUtil from './TrigonometricFunctionUtil';

export default class PositionComputerUtil {
  private static instance: PositionComputerUtil = new PositionComputerUtil();

  private constructor() {
  }

  public static getInstance(): PositionComputerUtil {
    return PositionComputerUtil.instance;
  }

  //这里point的x、y的单位使用vp，因为使用时，默认单位也是vp
  public pointArray: Point[] = [];
  //当前使用的初始化参数
  public currentParams?: DragSceneInitParams;

  init() {
    //当窗体变化
    let innerEvent: emitter.InnerEvent = {
      eventId: EventConstants.ON_WINDOWS_SIZE_CHANGE_EVENT,
      priority: emitter.EventPriority.LOW
    };
    emitter.on(innerEvent, (data: emitter.EventData) => {
      const params: DragSceneInitParams = DragSceneInitParams.getInstance();
      Logger.debug('PositionComputerUtil.generateAllPoint(),params=' + JSON.stringify(params));
      this.initCurrentPoints(params);
    });
  }

  initCurrentPoints(params: DragSceneInitParams) {
    this.currentParams = params;
    this.pointArray = this.generateAllPoint(params);
  }

  /**
   * 根据初始化参数，生成所有点位
   */
  public generateAllPoint(params: DragSceneInitParams): Array<Point> {
    const arr: Point[] = [];
    //基础和中心间距
    let length = params.deviceSize / 2 + params.centerSize / 2 + params.deviceMinSpace;
    //一圈之后的增量长度
    let incrementalLength = params.deviceSize + params.deviceMinSpace;
    let circleTime: number = 1;
    let angle = 0;
    let placeTime = 0;
    //微调角度，增加随机性
    const fineTuningAngle = params.modifyAngle / 10;
    //微调长度，增加随机性
    const fineTuningLength = params.deviceMinSpace / 2;
    while (arr.length < DragSceneConstants.MAX_DEVICE_NUM && placeTime < DragSceneConstants.MAX_DEVICE_NUM * 2) {
      if (placeTime != 0) {
        angle += params.modifyAngle / circleTime + this.getRandomNumber() * fineTuningAngle;
      }
      //如果已经超过一圈了，length需要变化
      if (angle > circleTime * 360 * circleTime - params.modifyAngle / 2) {
        circleTime++;
        length += (incrementalLength + fineTuningLength * this.getRandomNumber());
      }
      const point = TrigonometricFunctionUtil.computePoint(angle, length);
      point.setAngle(angle);
      Logger.debug(`尝试放置point：angle=${angle},length=${length},x=${point.x},y=${point.y}，placeTime=${placeTime}`);
      if (this.isLegalPoint(point, params)) {
        arr.push(point);
      }
      placeTime++;
    }
    Logger.debug(`放置结束，arr.length=${arr.length}}`);
    return arr;
  }

  // 生成一个范围在 [-1, 1) 的随机数
  getRandomNumber() {
    return (Math.random() * 2) - 1;
  }


  /**
   * 判断point是否可完全在屏幕显示
   * @param point
   */
  isLegalPoint(point: Point, params: DragSceneInitParams): boolean {
    const halfDeviceSize = px2vp(params!.deviceSize / 2);
    const halfDisplayWidth = px2vp(params!.displayWidth / 2);

    const halfDisplayHeight = params!.displayHeight / 2;
    if (point.x + halfDeviceSize > halfDisplayWidth) {
      return false;
    }

    if (point.x - halfDeviceSize < -halfDisplayWidth) {
      return false;
    }

    if (point.y + halfDeviceSize > halfDisplayHeight) {
      return false;
    }
    if (point.y - halfDeviceSize < -halfDisplayHeight) {
      return false;
    }
    return true;
  }

  /**
   * 根据index获取point
   * @param index
   * @returns
   */
  getPointByIndex(index: number): Point {
    if (this.pointArray.length == 0) {
      return new Point(0, 0);
    }
    if (index >= this.pointArray.length) {
      index = index % this.pointArray.length;
    }
    return this.pointArray[index];
  }
};