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

/**
 *  设备扫描页面，默认附近设备连接页面，职责：
 *  1、检查wifi和蓝牙设置；
 *  2、扫描附近设备；
 *  3、展示扫描页面：拖拽展示和列表展示两种显示可选；
 *  4、执行连接操作；
 *  5、展示设备详情弹窗。
 */

import SettingAlertDialog from '../view/SettingAlertDialog';
import { DevicesDragView, Sheet } from '../view/DevicesDragView';
import DeviceDiscoverManager from '../viewmodel/DeviceDiscoverManager';
import emitter from '@ohos.events.emitter';
import { EventConstants } from '@ohos/common/src/main/ets/constants/EventConstants';
import { CommonConstants, EnvManager, getProtocolCode, Logger, ProtocolType } from '@ohos/common';
import DevicesModel from '../viewmodel/DevicesModel';
import ScanRunner from '../viewmodel/ScanRunner';
import common from '@ohos.app.ability.common';
import DevicesManager from '../viewmodel/DevicesManager';
import { DevicesListView, ListClick } from '../view/DevicesListView';
import ScanModel, { ScanState } from '../viewmodel/ScanModel';
import DragModel from '../viewmodel/DragModel';
import { HMRouterMgr } from '@hadss/hmrouter';

@Preview
@Component
export struct DevicesScanPage {
  @Provide scanModel: ScanModel = DeviceDiscoverManager.getInstance().getScanModel();
  @Provide devicesModel: DevicesModel = DevicesManager.getInstance().getDeviceModel();
  @Provide dragModel: DragModel = new DragModel();
  @Provide noAccessCode: string[] = [];
  @Provide @Watch('onClickFromSheet') sheet: Sheet = Sheet.getContext();
  @Provide @Watch('onClickFromSheet') listClick: ListClick = ListClick.getContext();
  @State @Watch('onDragSceneFinishInit') finishInit: boolean = false;
  @Link categoryTabIndex: number;
  @Link currentIndex: number;
  //是否是drag模式
  @LocalStorageLink('isDragMode') isDragMode: boolean = true;
  controller: CustomDialogController = new CustomDialogController({
    builder: SettingAlertDialog(
      {
        onConfirm: async (): Promise<void> => await this.onSettingConfirm()
      }
    ),
    customStyle: true,
    alignment: DialogAlignment.Center,
  });

  onDragSceneFinishInit() {
    const checked = AppStorage.get<boolean>('accessChecked');
    Logger.debug('DevicesScanPage', `onDragSceneFinishInit this.finishInit: ${this.finishInit}, checked: ${checked}`);
    if (this.finishInit && !checked) {
      this.checkAccess(true);
      AppStorage.setOrCreate<boolean>('accessChecked', true);
    }
  }

  //点击已连接设备，进入详情
  onClickFromSheet() {
    let productID = DevicesManager.getInstance().getConnectingDevice()?.getProductID();
    Logger.warn('===>连接的设备点击进入详情页 onClickFromSheet: connectingDevice: ' +
    JSON.stringify(this.devicesModel.connectingDevice));
    let deviceName = this.devicesModel.connectingDevice?.name;
    Logger.warn(`===> deviceName: ${deviceName}, productID: ${productID}`);
    HMRouterMgr.push({
      pageUrl: 'DeviceDetailPage',
      param: { 'productId': productID, 'deviceName': deviceName, 'enterType': 0 }
    });
  }

  async onSettingConfirm() {
    let noAccessArray: string[] = EnvManager.getInstance().getNoAccessCodes();
    this.controller.close();
    if (noAccessArray.length != 0) {
      if (noAccessArray.includes(getProtocolCode(ProtocolType.BLE))) {
        await EnvManager.getInstance().enableAccessByCode(getContext(this), getProtocolCode(ProtocolType.BLE));
      }
      if (noAccessArray.includes(getProtocolCode(ProtocolType.WIFI))) {
        await EnvManager.getInstance().enableAccessByCode(getContext(this), getProtocolCode(ProtocolType.WIFI));
      }
    }
    await this.checkAccess();
  }

  /**
   * 重新检查环境状态
   */
  async startScanCheck() {
    Logger.debug('DevicesScanPage', '===>invoke function recheckEnvState()');
    Logger.debug(`DevicesScanPage`, `===>startScanCheck if: ${(!EnvManager.getInstance().isNoAccess()) &&
      (this.scanModel.currentScanState == ScanState.NOT_START)}`);
    if (!EnvManager.getInstance().isNoAccess() && this.scanModel.currentScanState == ScanState.NOT_START) {
      this.startScan();
    }
  }

  /**
   * 只有第一次，所有权限都不存在时，提示权限弹窗
   * @param first
   */
  async checkAccess(first: boolean = false) {
    this.noAccessCode = await EnvManager.getInstance().recheckNoAccessCodes();
    Logger.debug('DevicesScanPage', `===>this.noAccessCode = ${this.noAccessCode}, first: ${first}`);
    Logger.debug('DevicesScanPage', `===>checkAccess if: ${(EnvManager.getInstance().isNoAccess() && first)}`);
    if (EnvManager.getInstance().isNoAccess() && first) {
      this.controller.open();
    } else {
      this.startScanCheck();
    }
  }

  aboutToAppear() {
    Logger.info('DeviceScanPage',
      `===>aboutToAppear isDragMode: ${this.isDragMode}, this.currentIndex: ${this.currentIndex}`);
    let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    //初始化操作
    ScanRunner.init(context);
    // 当应用到前台后重新检查
    let innerEvent: emitter.InnerEvent = {
      eventId: EventConstants.ON_FOREGROUND_EVENT
    };
    emitter.on(innerEvent, () => {
      this.checkAccess();
    });
  }

  startScan() {
    DeviceDiscoverManager.getInstance().startScan();
  }

  stopScan() {
    DeviceDiscoverManager.getInstance().stopScan();
  }

  aboutToDisappear() {
    console.log('aboutToDisappear()');
  }

  build() {
    Stack() {
      if (this.isDragMode) {
        DevicesDragView({
          finishInit: this.finishInit,
          categoryTabIndex: this.categoryTabIndex,
          currentIndex: this.currentIndex
        });
      } else {
        DevicesListView();
      }
    }
    .backgroundColor($r('app.color.default_background'))
    .height('100%');
  }
}