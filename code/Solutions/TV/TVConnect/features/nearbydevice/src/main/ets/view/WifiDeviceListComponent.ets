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

import { CommonConstants, InfDevice, Logger, LoginEvent } from '@ohos/common';
import { CloudDeviceModel } from '@ohos/connect_cloud';
import DeleteDeviceAlertDialog from './DeleteDeviceAlertDialog';
import DeviceCardComponent from './DeviceCardComponent';
import { curves, promptAction } from '@kit.ArkUI';
import { Project, HttpApi } from '@ohos/connect_cloud';
import { ConnectDialog } from './FIndConnectDeviceDialog';
import { HMInterceptorAction, HMPopInfo, HMRouterMgr } from '@hadss/hmrouter';
import { ConnectChangeAction, DeviceManagerFactory } from '@ohos/device_manager';
import { TipButton } from './TipButton';
import { ListDataSource } from '../util/ListDataSource';
import { ConnectType } from '@ohos/common/src/main/ets/inf/TypeEnum';
import { BusinessError } from '@ohos.base';
import PreferenceModel from '../viewmodel/PreferenceModel';
import { IpDeviceInfo } from '../viewmodel/IpDeviceModel';
import EmptyPage from './EmptyPage';
import { CoapDevicesScanPage } from '../pages/CoapDevicesScanPage';
import { scale } from '../util/ScreenAdaptation';

let TAG = 'WifiDeviceListComponent';
const CREATE_PROJECT: string = 'toCreateProject';

@Component
export default struct WifiDeviceListComponent {
  @State savedList: InfDevice[] = [];
  @State deviceId: string = '';
  @State isCardMode: boolean = true;
  @State showProject: boolean = false;
  @Link categoryTabIndex: number;
  @Link currentIndex: number;
  @StorageLink('currentBreakpoint') currentBreakpoint: string = '';
  @StorageLink('isWifiConnect') @Watch('wifiConnectChange') isWifiConnect: string = '';
  @State isCoapPageShow: boolean = false;

  wifiConnectChange() {
    Logger.warn(TAG, `===>wifiConnectChange, isWifiConnect: ${JSON.stringify(this.isWifiConnect)}`);
    if (this.isWifiConnect == 'connect') {
      this.isCoapPageShow = true;
    }
  }

  private icon: Resource = $r('app.media.ic_pos_view');
  private deleteController: CustomDialogController = new CustomDialogController({
    builder: DeleteDeviceAlertDialog({
      onConfirm: () => {
        PreferenceModel.getInstance().deletePreferences(this.deviceId);
        this.updateList();
      }
    })
  });
  /**
   * 设备连接弹窗
   */
  private connectDialogController: CustomDialogController = new CustomDialogController({
    builder: ConnectDialog(),
    autoCancel: true,
    customStyle: true,
    alignment: DialogAlignment.Bottom,
    backgroundColor: Color.Transparent
  });
  @StorageProp('CategoryPageShow') isPageShow: boolean = false;

  async aboutToAppear(): Promise<void> {
    this.updateList();
  }

  async updateList() {
    Logger.warn(TAG, `===>updateList, before getAllIpDevices this.savedList= ${JSON.stringify(this.savedList)}`);
  }

  aboutToDisappear(): void {
  }

  //item转场效果
  private effect: object =
    TransitionEffect.OPACITY
      .combine(TransitionEffect.scale({ x: 0, y: 0 })
        .animation({
          curve: curves.springMotion(0.6, 1.2)
        }))
      .combine(TransitionEffect.translate({ x: scale(150), y: scale(150) })
        .combine(TransitionEffect.move(TransitionEdge.END))
        .animation({
          curve: curves.springMotion()
        }))
      .combine(TransitionEffect.asymmetric(TransitionEffect.scale({ x: 0, y: 0 }), TransitionEffect.rotate({
        angle: 90
      })));

  async deleteDevice(devId: string) {

  }

  async setTopping(index: number) {
  }

  pushDeviceDetail(item: IpDeviceInfo) {
    Logger.debug(TAG, `getCloudDevice projectId= ${JSON.stringify(item)}`);
    HMRouterMgr.push({
      pageUrl: 'WifiDeviceDetailPage',
      param: {
        'udid': item.udid,
        'deviceName': item.udid,
        'ip': item.ip,
        'cloudDeviceModel': item,
      }
    });
  }

  @Builder
  MenuBuilder(index: number, id: string) {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Center }) {
      Text($r('app.string.Topping'))
        .padding({ left: $r('app.string.vp_12') })
        .width(CommonConstants.FULL_WIDTH_PERCENT)
        .lineHeight($r('app.string.vp_40'))
        .onClick(() => {
          this.setTopping(index);
        });
      Divider().strokeWidth(scale(1)).margin(scale(5)).color($r('app.color.dialog_divider_color'));
      Text($r('app.string.delete'))
        .padding({ left: $r('app.string.vp_12') })
        .width(CommonConstants.FULL_WIDTH_PERCENT)
        .lineHeight($r('app.string.vp_40'))
        .onClick(() => {
          this.deviceId = id;
          this.deleteController.open();
        });
    }
    .width($r('app.string.wh_value_160'))
    .height($r('app.string.wh_value_96'));
  }

  @Builder
  getListItem(item: IpDeviceInfo) {
    Row() {
      Image(this.icon)
        .width($r('app.string.vp_46'))
        .height($r('app.string.vp_46'))
        .draggable(false);
      Text(item.udid)
        .fontSize($r('app.string.fp_15'))
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({
          left: $r('app.string.vp_10')
        });
      Blank();
    }
    .padding({
      left: $r('app.string.vp_12'),
      right: $r('app.string.vp_12'),
      top: $r('app.string.vp_6'),
      bottom: $r('app.string.vp_6')
    })
    .justifyContent(FlexAlign.SpaceBetween)
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .onClick(() => {
      this.pushDeviceDetail(item);
    });
  }

  build() {
    Column() {
      CoapDevicesScanPage({ categoryTabIndex: this.categoryTabIndex, currentIndex: this.currentIndex });
    }
    .padding({ left: $r('app.string.wh_value_24'), right: $r('app.string.wh_value_24') })
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .height(CommonConstants.FULL_HEIGHT_PERCENT);
  }
}

@Extend(Text)
function textStyle() {
  .fontSize($r('app.string.button_font_size'))
  .fontColor($r('sys.color.ohos_dialog_text_alert'))
  .fontWeight(FontWeight.Regular);
}