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
import common from '@ohos.app.ability.common';
import emitter from '@ohos.events.emitter';
import { EventConstants } from '@ohos/common/src/main/ets/constants/EventConstants';
import { Logger } from '@ohos/common';
import ResourceUtil from '../util/ResourceUtil';

/**
 * 拖拽场景，初始化参数，此处size都是用px作为单位
 */
export default class DragSceneInitParams {
  //可展示宽度，就是window宽度
  public displayWidth: number = 0;
  //可展示高度，window高度-底部导航栏-顶部状态栏-附近设备标题高度
  public displayHeight: number = 0;
  //设备最大尺寸（包含下方文字）
  public deviceSize: number = 0;
  //控制中心图标的尺寸
  public centerSize: number = 0;
  //设备之间最小间隔
  public deviceMinSpace: number = 0;
  //最大显示设备数量
  public maxDeviceNum: number = DragSceneConstants.MAX_DEVICE_NUM;
  //变更角度
  public modifyAngle: number = DragSceneConstants.MODIFY_ANGLE;
  public titleHeight: number = 0;
  public bottomBarHeight: number = 0;
  public context?: common.UIAbilityContext;
  //单例配置
  private static instance: DragSceneInitParams = new DragSceneInitParams();

  private constructor() {
  }

  public static getInstance(): DragSceneInitParams {
    return DragSceneInitParams.instance;
  }

  initParams(context: common.UIAbilityContext) {
    this.context = context;
    //当窗体变化
    let innerEvent: emitter.InnerEvent = {
      eventId: EventConstants.ON_WINDOWS_SIZE_CHANGE_EVENT,
      priority: emitter.EventPriority.HIGH
    };
    emitter.on(innerEvent, (data: emitter.EventData) => {
      if (data.data) {
        this.displayWidth = data.data['width'];
        this.displayHeight = data.data['height'] - this.bottomBarHeight - this.titleHeight * 2;
        Logger.debug('receive windows size change event: width=' + this.displayWidth + ' ,height=' +
        this.displayHeight);
      }
    });

    this.deviceSize = this.getDeviceIconSize(context);
    this.centerSize = this.getNumberToPx(context, $r('app.string.origin_circle_size'));
    this.titleHeight = this.getNumberToPx(context, $r('app.string.tab_bar_height'));
    this.bottomBarHeight = this.getNumberToPx(context, $r('app.string.tab_bar_height'));
    this.deviceMinSpace = this.getNumberToPx(context, DragSceneConstants.DEVICE_MIN_SPACE);

    Logger.debug('DragSceneInitParams.initParams finish, params: ' + JSON.stringify(this));
  }

  getDeviceIconSize(context: common.UIAbilityContext): number {
    return this.getNumberToPx(context, DragSceneConstants.DEVICE_ITEM_BG_SIZE) +
    this.getNumberToPx(context, DragSceneConstants.DEVICE_ITEM_PADDING) +
    this.getNumberToPx(context, DragSceneConstants.DEVICE_ITEM_NAME_SIZE);
  }

  getNumberToPx(context: common.UIAbilityContext, floatResource: Resource): number {
    return ResourceUtil.getNumberToPx(context, floatResource);
  }
};