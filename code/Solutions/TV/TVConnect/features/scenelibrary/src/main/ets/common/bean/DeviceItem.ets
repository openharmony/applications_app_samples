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
import { actionBean } from '../../model/SceneCondition';
import ActionItem from './ActionItem';
import Point from './Point';

/**
 * 单个设备的数据
 */
@Observed
export default class DeviceItem {
  public deviceId: string = '';
  public image: Resource | string = $r('app.media.ic_device');
  public deviceName: string = '';
  public deviceType: string = '';
  public actions: Array<actionBean> | undefined = [];
  public point: Point = new Point(0, 0);

  constructor(deviceId: string, image: Resource | string, deviceName: string, deviceType: string,
    actions?: Array<actionBean>) {
    this.deviceId = deviceId;
    this.image = image;
    this.deviceName = deviceName;
    this.deviceType = deviceType;
    this.actions = actions;
  }
}