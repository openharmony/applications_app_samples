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

import { SettingBackground } from '../../default/layout/SettingBackground';
import { Ratio } from '../../common/Ratio';
import lpx from '../../common/Lpx';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { KeyCode } from '../../common/constants/KeyCode';
import { Duration } from '../../common/constants/Duration';
import { ColorMetrics } from '@kit.ArkUI';
import oneConnectShare from '@ohos.oneConnect.fileShare';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

const MODULE_TAG = ConfigData.TAG + '.oneConnectShare -> ';
const bundleName = 'com.ohos.settings'
const SHARE_OPENING_TIME_10_MIN = 10;
const SHARE_OPENING_TIME_UNLIMITED = 0;
let shareManager: oneConnectShare.ShareManager | undefined = undefined;
const SHARE_BUNDLENAME = 'com.ohos.oneconnect.share'
const SHARE_ABILITYNAME = 'ServiceExtAbility'
const SHARE_UNAVAILABLE_ERROR_CODES: number[] = [201, 202, 801, 2501000];

@Entry
@Component
struct oneConnectSharePage {
  @State oneConnectShareIsOn: boolean = false;
  @State openingTimeText: Resource | string = $r('app.string.endTextEmpty');
  @State imageUrl: string = Ratio.resName('icon_share')
  @State des: string | Resource = $r('app.string.one_connect');
  @State settingList: SettingItemTvModel[] = []
  private pageTranState: boolean = false; //判断是进场动效还是出场动效
  private shareServiceAvailable: boolean = true;
  @StorageLink('shareOpenTime') @Watch('refreshText') shareOpenTime: number = SHARE_OPENING_TIME_10_MIN;
  private openingTimeDialogController: CustomDialogController = new CustomDialogController({
    builder: OpeningTimeDialog({
      openingTimeText: $openingTimeText,
    }),
    alignment: DialogAlignment.Center,
    offset: ({ dx: 0, dy: 0 }),
    autoCancel: false,
    customStyle: true
  });

  pageTransition() {
    if (this.pageTranState) {
      PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Left)
      PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Left)
    } else {
      PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Right)
      PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Right)
    }
  }

  updateShareSwitchState(isOn: boolean) {
    this.oneConnectShareIsOn = isOn;
    if (this.settingList.length > 0) {
      this.settingList[0].setIsOn(isOn)
    }
  }

  getBusinessErrorCode(err: Object): number {
    const businessError = err as BusinessError;
    return typeof businessError.code === 'number' ? businessError.code : 0;
  }

  getBusinessErrorMessage(err: Object): string {
    const businessError = err as BusinessError;
    return typeof businessError.message === 'string' ? businessError.message : '';
  }

  handleShareFailure(action: string, err: Object) {
    const code = this.getBusinessErrorCode(err);
    const message = this.getBusinessErrorMessage(err);
    if (SHARE_UNAVAILABLE_ERROR_CODES.includes(code)) {
      this.shareServiceAvailable = false;
      shareManager = undefined;
      this.updateShareSwitchState(false);
      LogUtil.info(MODULE_TAG + `${action} unavailable, code=${code}`);
      return;
    }
    LogUtil.error(MODULE_TAG + `${action} failed, code=${code}, message=${message}`);
  }

  aboutToAppear() {
    LogUtil.info(MODULE_TAG + 'aboutToAppear');
    this.init();
    this.refreshText();
  }

  onPageShow() {
    if (!this.shareServiceAvailable) {
      this.updateShareSwitchState(false);
      return;
    }
    try {
      shareManager = oneConnectShare.createShareManager(bundleName)
      let isOn: boolean | undefined = shareManager.getShareStatus();
      this.updateShareSwitchState(isOn || false);
    } catch (err) {
      this.handleShareFailure('getShareStatus', err);
    }
    LogUtil.info(MODULE_TAG + `this.oneConnectShareIsOn = ${JSON.stringify(this.oneConnectShareIsOn)}`);
    if (shareManager == undefined || !this.shareServiceAvailable) {
      return;
    }

    try {
      shareManager.on('shareStatusChange', (isOn: boolean) => {
        this.updateShareSwitchState(isOn)
      });
    } catch (err) {
      this.handleShareFailure('shareStatusChange', err);
    }
  }

  onPageHide(): void {
    this.pageTranState = false
  }

  aboutToDisappear() {
    LogUtil.info(MODULE_TAG + 'aboutToDisappear');
    if (shareManager != undefined) {
      try {
        shareManager.off('shareStatusChange');
        oneConnectShare.releaseShareManager(shareManager);
        LogUtil.info(MODULE_TAG + 'releaseShareManager success')
      } catch (err) {
        LogUtil.info(MODULE_TAG + 'releaseShareManager failed err:' + JSON.stringify(err))
      } finally {
        shareManager = undefined;
      }

    }
  }

  refreshText() {
    this.openingTimeText =
      this.shareOpenTime == SHARE_OPENING_TIME_UNLIMITED ? $r('app.string.share_opening_time_unlimited')
        : $r('app.string.share_opening_time_minutes', this.shareOpenTime);
    this.settingList[1].setChooseDes(this.openingTimeText)
  }

  init() {
    let setting1 = new SettingItemTvModel();
    setting1.name = '文件互传';
    setting1.isOn = this.oneConnectShareIsOn
    setting1.style = SettingItemStyle.switch
    setting1.description = $r('app.string.one_connect_share');

    let setting2 = new SettingItemTvModel();
    setting2.name = '开启时间';
    setting2.style = SettingItemStyle.default;
    setting2.chooseDes = this.openingTimeText;
    setting2.description = $r('app.string.share_opening_time');

    this.settingList.push(setting1, setting2);
  }

  onShareEvent(isOn: boolean) {
    if (!this.shareServiceAvailable || shareManager == undefined) {
      this.updateShareSwitchState(false);
      return
    }
    if (isOn) {
      LogUtil.info(MODULE_TAG + `before enableShare`);
      try {
        shareManager.enableShare();
        this.updateShareSwitchState(true);
        this.startOneConnect()
      } catch (err) {
        this.handleShareFailure('enableShare', err);
      }
    } else {
      LogUtil.info(MODULE_TAG + `before disableShare`);
      try {
        shareManager.disableShare();
        this.updateShareSwitchState(false);
        this.killOneConnect()
      } catch (err) {
        this.handleShareFailure('disableShare', err);
      }
    }
  }

  startOneConnect() {
    let startWant: Want = {
      bundleName: SHARE_BUNDLENAME,
      abilityName: SHARE_ABILITYNAME,
      parameters: {
        stopFlag: '0'
      }
    }
    globalThis.settingsAbilityContext.startAbilityForResult(startWant,
      (err: BusinessError, result: common.AbilityResult) => {
        if (err.code) {
          // 处理业务逻辑错误
          console.error(`startAbilityForResult failed, code is ${err.code}, message is ${err.message}`);
          return;
        }
        // 执行正常业务
        console.info('startAbilityForResult succeed');
      });
  }

  killOneConnect() {
    let stopWant: Want = {
      bundleName: SHARE_BUNDLENAME,
      abilityName: SHARE_ABILITYNAME,
      parameters: {
        stopFlag: '1'
      }
    }
    globalThis.settingsAbilityContext.startAbilityForResult(stopWant,
      (err: BusinessError, result: common.AbilityResult) => {
        if (err.code) {
          // 处理业务逻辑错误
          console.error(`startAbilityForResult failed, code is ${err.code}, message is ${err.message}`);
          return;
        }
        // 执行正常业务
        console.info('startAbilityForResult succeed');
      });
  }

  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)

      Row() {
        SettingListTvComponent({
          settingList: this.settingList,
          title: '设备互传',
          onMouseClickHandle: (item: SettingItemTvModel) => {
            if (item.name === '开启时间') {
                this.openingTimeDialogController?.open();
            }
          },
          onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {
          },
          onFocusHandle: (item: SettingItemTvModel) => {
            this.des = item.description
          },
          onToggleChangedHandle: (item: SettingItemTvModel, isOn: boolean) => {
            this.onShareEvent(isOn)
          }
        })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
          .margin({ left: lpx(84) })


        SettingItemDesLayout({ imageUrl: this.imageUrl, des: this.des })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)

      }
    }
  }
}


@CustomDialog
struct OpeningTimeDialog {
  controller?: CustomDialogController;
  private openingTime: number[] = [SHARE_OPENING_TIME_10_MIN, SHARE_OPENING_TIME_UNLIMITED];
  @Link openingTimeText: Resource;
  @StorageLink('shareOpenTime') shareOpenTime: number = SHARE_OPENING_TIME_10_MIN;

  changeShareTime(item:number){
    this.controller?.close();
    LogUtil.info(MODULE_TAG + `onChange, item = ${item}`);
    if (item === SHARE_OPENING_TIME_10_MIN) {
      if (shareManager != undefined) {
        shareManager.setShareOpenTime(10);
      }
    } else {
      if (shareManager != undefined) {
        shareManager.setShareOpenTime(0);
      }
    }
    this.shareOpenTime = shareManager?.getShareOpenTime() || 0;
    console.log('lzh shareManager?.getShareOpenTime() ' + shareManager?.getShareOpenTime())
  }

  build() {
    Column() {
      Column() {
        Text($r('app.string.share_opening_time'))
          .fontSize(lpx(40))
          .fontWeight(500)
          .alignSelf(ItemAlign.Start)
          .fontColor('#D8D8D8')

        List() {
          ForEach(this.openingTime, (item: number, index) => {
            ListItem() {
              Column() {
                Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                  Text(item === SHARE_OPENING_TIME_UNLIMITED ? $r('app.string.share_opening_time_unlimited') :
                  $r('app.string.share_opening_time_minutes', item))
                    .fontFamily('HarmonyHeiTi')
                    .fontSize(lpx(30))
                    .fontWeight(FontWeight.Normal)
                    .fontColor('#D8D8D8')

                  Radio({ value: '', group: 'radioGroup' })
                    .checked(this.shareOpenTime === item ? true : false)
                    .height(lpx(30))
                    .width(lpx(30))
                    .onChange((value: boolean) => {
                      if (value) {
                        this.controller?.close();
                        LogUtil.info(MODULE_TAG + `onChange, item = ${item}`);
                        if (item === SHARE_OPENING_TIME_10_MIN) {
                          if (shareManager != undefined) {
                            shareManager.setShareOpenTime(10);
                          }
                        } else {
                          if (shareManager != undefined) {
                            shareManager.setShareOpenTime(0);
                          }
                        }
                        this.shareOpenTime = shareManager?.getShareOpenTime() || 0;
                        console.log('lzh shareManager?.getShareOpenTime() ' + shareManager?.getShareOpenTime())
                      }
                    })
                    .margin({ right: $r('app.float.distance_6') })
                    .defaultFocus(this.shareOpenTime === item)
                    .focusBox({
                      strokeColor: ColorMetrics.rgba(216, 216, 216)
                    })
                }
                .height(lpx(100))

                Divider()
                  .strokeWidth(lpx(1))
                  .color('#83d8d8d8')
              }
            }.onClick(()=>{
              this.changeShareTime(item)
            })
          })
        }

        Text($r('app.string.cancel_share_time'))
          .fontSize($r('app.float.font_14'))
          .fontColor('#D8D8D8')
          .alignSelf(ItemAlign.Center)
          .onClick(() => {
            this.controller?.close();
          })
          .focusBox({
            strokeColor: ColorMetrics.rgba(216, 216, 216)
          })
          .margin({ top: lpx(40) })
          .width(lpx(248))
          .height(lpx(72))
          .textAlign(TextAlign.Center)
          .borderRadius(lpx(200))
          .fontSize(lpx(36))
          .focusable(true)
      }
      .padding(lpx(36))
      .alignItems(HorizontalAlign.Center)
      .backgroundColor('#b3000000')
      .borderRadius(lpx(20))
    }
    .width(lpx(600))
  }
}
