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

import { CommonConstants, DefaultDialog, Logger, LoginEvent } from '@ohos/common';
import { CloudDeviceModel } from '@ohos/connect_cloud';
import DeleteDeviceAlertDialog from './DeleteDeviceAlertDialog';
import DeviceCardComponent from './DeviceCardComponent';
import { ColorMetrics, curves, LengthMetrics, promptAction } from '@kit.ArkUI';
import { Project, HttpApi } from '@ohos/connect_cloud';
import { ConnectDialog } from './FIndConnectDeviceDialog';
import { HMInterceptorAction, HMPopInfo, HMRouterMgr } from '@hadss/hmrouter';
import { ConnectChangeAction, DeviceManagerFactory } from '@ohos/device_manager';
import { TipButton } from './TipButton';
import { ListDataSource } from '../util/ListDataSource';
import { ConnectType } from '@ohos/common/src/main/ets/inf/TypeEnum';
import { BusinessError } from '@ohos.base';
import MenuDialog from './MenuDialog';
import { inputConsumer, KeyAction, KeyCode } from '@kit.InputKit';
import { scale } from '../util/ScreenAdaptation';

let TAG = 'DeviceListComponent';
const CREATE_PROJECT: string = 'toCreateProject';

let menuKey = 2067;
let keyOptionsMenu: inputConsumer.KeyOptions = {
  preKeys: [],
  finalKey: menuKey,
  isFinalKeyDown: false,
  finalKeyDownDuration: 1000
};

@Component
export default struct DeviceListComponent {
  @State devicesList: ListDataSource<CloudDeviceModel> = new ListDataSource();
  @State projectList: Project[] = [];
  @StorageLink('currentProject') currentSelect: Project | undefined = undefined;
  @StorageLink('needRefreshDeviceList') @Watch('onNeedRefresh') refreshTimestamp: number = 0;
  @State deviceId: string = '';
  @State isCardMode: boolean = true;
  @State showProject: boolean = false;
  @State refreshCounter: number = 0;
  @Link categoryTabIndex: number;
  @StorageLink('currentBreakpoint') currentBreakpoint: string = '';
  @State currentDeviceId: string = '';
  @State setTopping1: number = 0;
  private icon: Resource = $r('app.media.ic_pos_view');
  private deleteController: CustomDialogController = new CustomDialogController({
    builder: DeleteDeviceAlertDialog({
      onConfirm: () => {
        this.deleteDevice(this.deviceId);
      }
    })
  });
  private menuDialogController: CustomDialogController = new CustomDialogController({
    builder: MenuDialog({
      deviceId: this.currentDeviceId,
      deleteDevice: (devId: string): Promise<void> => this.deleteDevice(devId),
      setToppingindex: this.setTopping1,
      setTopping: (index: number): Promise<void> => this.setTopping(index),
    }),
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
  @StorageProp('LOGIN_STORAGE') @Watch('getProjectList') isLogin: boolean = false;
  @StorageProp('CategoryPageShow') isPageShow: boolean = false;

  getProjectList() {
    Logger.debug(TAG + `===>getProjectList`);
    if (this.isLogin) {
      HttpApi.getInstance().getAllProject().then(async (res: Project[]) => {
        Logger.debug(TAG + `===>getAllProject.then res: ${JSON.stringify(res)}`);
        this.projectList = res;
        let createProject = new Project();
        createProject.name = getContext().resourceManager.getStringSync($r('app.string.to_create_project').id);
        createProject.id = CREATE_PROJECT;
        this.projectList.push(createProject);
        if (this.projectList.length > 0 && !this.currentSelect) {
          this.currentSelect = this.projectList[0];
        }
        this.getDevicesList();
      });
    } else {
      this.currentSelect = undefined;
    }
  }

  aboutToAppear(): void {
    DeviceManagerFactory.getDeviceManager().registerConnectStateChanged(TAG, (data: ConnectChangeAction) => {
      let res: CloudDeviceModel[] = this.devicesList.getAllData();
      let index: number = res.findIndex(item => item.deviceId == data.deviceId);
      if (index == -1) {
        Logger.debug(TAG + `connect state change, can not find device id`);
        return;
      }
      let item: CloudDeviceModel = this.devicesList.getData(index);
      if (data.action == ConnectType.ONLINE) {
        item.status = 'online';
      } else {
        item.status = 'offline';
      }
      this.devicesList.changeData(index, item);
    });
    this.getProjectList();
    DeviceManagerFactory.getDeviceManager().registerDeviceBindChanged(TAG, (projectId: string) => {
      Logger.debug(TAG + `===>device bind change, projectId: ${projectId}`);
      if (this.currentSelect?.id == projectId) {
        Logger.debug(TAG + `===>this.currentSelect?.id:${this.currentSelect?.id}, projectId: ${projectId}`);
        this.getDevicesList();
      }
    });
  }

  aboutToDisappear(): void {
    DeviceManagerFactory.getDeviceManager().unRegisterConnectStateChanged(TAG);
  }

  onNeedRefresh(): void {
    Logger.info(TAG, '===>onNeedRefresh1, timestamp123: ' + this.refreshTimestamp + ', refresh device list');
    DeviceManagerFactory.getDeviceManager().registerConnectStateChanged(TAG, (data: ConnectChangeAction) => {
      let res: CloudDeviceModel[] = this.devicesList.getAllData();
      let index: number = res.findIndex(item => item.deviceId == data.deviceId);
      if (index == -1) {
        Logger.debug(TAG + `connect state change, can not find device id`);
        return;
      }
      let item: CloudDeviceModel = this.devicesList.getData(index);
      if (data.action == ConnectType.ONLINE) {
        item.status = 'online';
      } else {
        item.status = 'offline';
      }
      this.devicesList.changeData(index, item);
    });
    this.getProjectList();
    DeviceManagerFactory.getDeviceManager().registerDeviceBindChanged(TAG, (projectId: string) => {
      Logger.debug(TAG + `===>device bind change, projectId: ${projectId}`);
      if (this.currentSelect?.id == projectId) {
        Logger.debug(TAG + `===>this.currentSelect?.id:${this.currentSelect?.id}, projectId: ${projectId}`);
        this.getDevicesList();
      }
    });
  }

  async getDevicesList() {
    Logger.info(TAG + `===>getDevicesList start`);
    let res: CloudDeviceModel[] =
      await DeviceManagerFactory.getDeviceManager().getCloudDevice(this.currentSelect?.id as string);
    Logger.info(TAG + `===>getDevicesList got ${res.length} devices`);
    this.devicesList.refreshData(res);
    Logger.info(TAG + `===>getDevicesList refreshData completed, total: ${this.devicesList.totalCount()}`);
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
    Logger.info(TAG, `===>deleteDevice start, devId=${devId}`);
    if (this.currentSelect) {
      HttpApi.getInstance().deleteDevice(devId, this.currentSelect?.id as string).then(async () => {
        promptAction.showToast({ message: $r('app.string.delete_dev_success') });
        Logger.info(TAG, `===>deleteDevice success, calling getDevicesList`);
        AppStorage.setOrCreate('needRefreshDeviceList', Date.now());
      }).catch((e: BusinessError) => {
        Logger.error(TAG, `delete device error = ${JSON.stringify(e)}`);
        promptAction.showToast({ message: $r('app.string.delete_dev_failed') });
      });
    }
  }

  async setTopping(index: number) {
    let res = this.devicesList.getData(index);
    this.devicesList.deleteData(index);
    this.devicesList.addData(0, res);
  }

  pushDeviceDetail(item: CloudDeviceModel) {
    Logger.debug(TAG, `getCloudDevice projectId= ${JSON.stringify(item)}`);
    HMRouterMgr.push({
      pageUrl: 'DeviceDetailPage',
      param: {
        'deviceId': item.deviceId,
        'projectId': item.projectId,
        'deviceName': item.name,
        'enterType': 1,
        'productId': item.productId,
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
  ListTopBuilder() {
    Column() {
      Row() {
        Row() {
          Text(this.currentSelect?.name)
            .textStyle()
            .margin({ right: $r('app.string.text_margin_right') });
          Image($r('app.media.down_arrow'))
            .width($r('app.string.down_arrow_width'))
            .height($r('app.string.vp_5'));
        }.onClick(() => {
          this.showProject = !this.showProject;
        });

        Blank();
        Image($r('app.media.ic_public_edit'))
          .width($r('app.string.icon_width'))
          .height($r('app.string.wh_value_24'))
          .onClick(() => {
            this.showProject = false;
            HMRouterMgr.push({
              pageUrl: 'project/EditProjectPage',
              param: { projectId: this.currentSelect?.id as string }
            }, {
              onResult: (popInfo: HMPopInfo) => {
                this.getProjectList();
              }
            });
          })
          .margin({ right: $r('app.string.distance_8') });
        Image(this.isCardMode ? $r('app.media.ic_public_view_grid') : $r('app.media.ic_public_view_list'))
          .width($r('app.string.icon_width'))
          .height($r('app.string.wh_value_24'))
          .onClick(() => {
            this.showProject = false;
            this.isCardMode = !this.isCardMode;
          });
      }
      .width(CommonConstants.FULL_WIDTH_PERCENT)
      .alignItems(VerticalAlign.Center)

      .padding({ right: $r('app.string.vp_12'), left: $r('app.string.vp_12') });

      Text($r('app.string.device_number', this.devicesList.totalCount()))
        .fontSize($r('app.string.fp_12'))
        .fontColor($r('sys.color.mask_secondary'))
        .width(CommonConstants.FULL_WIDTH_PERCENT)
        .padding({ left: $r('app.string.vp_12') });
    }
    .height($r('app.string.tab_bar_height'))
    .margin({ bottom: $r('app.string.vp_14') })
    .padding({ top: $r('app.string.vp_10') });
  }

  @Builder
  ListViewBuilder() {
    List() {
      LazyForEach(this.devicesList, (item: CloudDeviceModel, index: number) => {
        ListItem() {
          this.getListItem(item);
        }.transition(this.effect)
        .bindContextMenu(this.MenuBuilder(index, item.deviceId), ResponseType.LongPress);
      }, (item: CloudDeviceModel) => JSON.stringify(item));
    }
    .divider({
      strokeWidth: $r('app.string.vp_1'),
      startMargin: $r('app.string.vp_60'),
      endMargin: $r('app.string.vp_10'),
      color: $r('app.color.divider_color')
    })
    .layoutWeight(1)
    .borderRadius($r('app.string.vp_14'))
    .backgroundColor($r('app.color.white'))
    .scrollBar(BarState.Off);
  }

  @Builder
  ListCardBuilder() {
    Grid(new Scroller()) {
      LazyForEach(this.devicesList, (item: CloudDeviceModel, index: number) => {
        GridItem() {
          DeviceCardComponent({
            icon: this.icon,
            name: item.name,
            isEnabled: item.status == 'online',
            enableCallback: (value: boolean) => {
            }
          });
        }
        .onClick(() => {
          this.pushDeviceDetail(item);
        })
        .bindContextMenu(this.MenuBuilder(index, item.deviceId), ResponseType.LongPress)
        .borderRadius($r('app.string.radius_16'))
        .focusable(true) // 使 Column 可聚焦
        .focusBox({
          margin: LengthMetrics.px(10),
          strokeColor: ColorMetrics.resourceColor($r('app.color.button_text_color')),
          strokeWidth: LengthMetrics.px(2)
        })
        .onKeyEvent((event: KeyEvent): boolean => {
          // 检测是否按下“菜单键”
          if (event.keyCode === KeyCode.KEYCODE_MENU && event.type === KeyType.Up) {
            this.currentDeviceId = item.deviceId;
            this.setTopping1 = index;
            this.menuDialogController.open(); // 弹出菜单
            return true; // 消费事件，防止冒泡
          }
          return false;
        });
      }, (item: CloudDeviceModel) => JSON.stringify(item));
    }
    .columnsTemplate(this.currentBreakpoint == 'lg' ? '1fr 1fr 1fr 1fr' : '1fr 1fr')
    .columnsGap($r('app.string.vp_12'))
    .rowsGap($r('app.string.vp_12'))
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .layoutWeight(1)
    .margin({ top: $r('app.string.10_vp') })
    .padding(scale(5));
  }

  @Builder
  getListItem(item: CloudDeviceModel) {
    Row() {
      Image(this.icon)
        .width($r('app.string.vp_46'))
        .height($r('app.string.vp_46'))
        .draggable(false);
      Text(item.name)
        .fontSize($r('app.string.fp_15'))
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({
          left: $r('app.string.vp_10')
        });
      Blank();
      Toggle({ type: ToggleType.Switch, isOn: item.status == 'online' });
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

  @Builder
  chooseProject() {
    List() {
      ForEach(this.projectList, (item: Project) => {
        ListItem() {
          Row() {
            Text(item.name).textStyle();
            Blank();
            if (item.name == this.currentSelect?.name) {
              Text($r('app.string.select'));
            }
          }.width(CommonConstants.FULL_WIDTH_PERCENT)
          .height($r('app.string.wh_value_48'))
          .onClick(() => {
            if (item.id == CREATE_PROJECT) {
              HMRouterMgr.push({
                pageUrl: 'project/CreateProjectPage'
              }, {
                onResult: (popInfo: HMPopInfo) => {
                  this.getProjectList();
                }
              });
            } else {
              this.currentSelect = item;
              this.getDevicesList();
            }
            this.showProject = false;
          });
        };
      });
    }
    .padding({ left: $r('app.string.vp_12'), right: $r('app.string.vp_12') })
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .divider({ strokeWidth: $r('app.string.vp_1') });
  }

  @Builder
  tipPage() {
    Stack() {
      TipButton({
        btnStyle: {
          btnRes: $r('app.string.login'),
          clickEvent: () => {
            HMRouterMgr.push({
              pageUrl: 'AccountLoginPagePage'
            });
            return HMInterceptorAction.DO_NEXT;
          },
          backgroundColor: $r('app.color.default_button_bg'),
          fontColor: $r('app.color.black')
        }
      });
    }
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .height(CommonConstants.FULL_WIDTH_PERCENT);
  }

  build() {
    Column() {
      Stack() {
        if (this.isLogin) {
          Column() {
            if (this.isCardMode) {
              this.ListCardBuilder();
            } else {
              this.ListViewBuilder();
            }
          }
          .justifyContent(FlexAlign.Start)
          .width(CommonConstants.FULL_WIDTH_PERCENT)
          .height(CommonConstants.FULL_WIDTH_PERCENT)
          .padding({ left: $r('app.string.vp_12'), right: $r('app.string.vp_12') });

          if (this.showProject) {
            Column() {
              Column() {
                this.chooseProject();
              }.backgroundColor(Color.White)
              .padding({ left: $r('app.string.vp_12'), right: $r('app.string.vp_12') })
              .borderRadius($r('app.string.wh_value_24'));
            }
            .width(CommonConstants.FULL_WIDTH_PERCENT)
            .borderRadius({ topLeft: $r('app.string.wh_value_24'), topRight: $r('app.string.wh_value_24') })
            .height(CommonConstants.FULL_HEIGHT_PERCENT)
            .backgroundColor($r('sys.color.mask_fourth'))
            .onClick(() => {
              this.showProject = false;
            });
          }
        } else {
          this.tipPage();
        }
      }
      .width(CommonConstants.FULL_WIDTH_PERCENT)
      .height(CommonConstants.FULL_WIDTH_PERCENT)
      .borderRadius($r('app.string.vp_20'))
      .alignContent(Alignment.Top)
      .backgroundColor($r('app.color.canConnect_device_bg'));
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
