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
import DragSceneConstants from '../../../../../constants/DragSceneConstants';
import PositionComputerUtil from '../../../../../util/PositionComputingUtil';
import ResourceUtil from '../../../../../util/ResourceUtil';
import DragSceneInitParams from '../../../../../viewmodel/DragSceneInitParams';
import Point from '../../../../../viewmodel/Point';

export default class TunnelPointModel {
  private constructor() {
  }

  public static instance: TunnelPointModel = new TunnelPointModel();

  public static getInstance(): TunnelPointModel {
    return TunnelPointModel.instance;
  }


  public points: Point[] = [];

  /**
   * 初始化我的点位数据
   */
  init() {
    const params: DragSceneInitParams = DragSceneInitParams.getInstance();
    params.centerSize = ResourceUtil.getNumberToPx(params.context!, $r('app.string.control_circle_size'));
    this.points = PositionComputerUtil.getInstance().generateAllPoint(params);
  }

  getTopOrBottomPoint(isTop: boolean): Point | null {
    for (let i = 0; i < this.points.length; i++) {
      const point: Point = this.points[i];
      const isRightDirection = isTop ? point.isTop() : point.isBottom();
      if (isRightDirection && !point.hasAllotted) {
        point.hasAllotted = true;
        return point;
      }
    }
    return null;
  }
};