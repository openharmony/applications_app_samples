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
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { CustomDialogTvComponent, DialogContent } from '../../default/layout/CustomDialogTvComponent';
import { CustomDialogContentStyle, SettingItemStyle, SourcetoolConstants } from '../../common/constants/StyleConstants';
import { KeyCode } from '../../common/constants/KeyCode';
import update from '@ohos.update';
import promptAction from '@ohos.promptAction';
import fileAccess from '@ohos.data.fileAccess';
import lpx from '../../common/Lpx';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import { BusinessError, commonEventManager, systemParameterEnhance } from '@kit.BasicServicesKit';
import volumeManager from '@ohos.file.volumeManager';
import { fileIo as fs } from '@kit.CoreFileKit';
import { UsbUpdateDesComponent } from '../../default/layout/UsbUpdateDesComponent';
import { Duration } from '../../common/constants/Duration';
import { EventUtil } from '../../common/EventUtil';
import PreferenceUtils from '../../staticSubscriber/PreferencesUtil';
import { connection } from '@kit.NetworkKit';

const SOFTWARE_UPDATE_KEY = 'versionDigestInfo'
const TAG = '[SoftwareUpdate] : ';
const SANDBOX_PATH: string = '/storage/External/';
const MOUNT_PATH: string = '/mnt/data/external/';
const EVENT_DATA_VOLUME_MOUNTED: string = 'usual.event.data.VOLUME_MOUNTED';
const EVENT_DATA_VOLUME_UNMOUNTED: string = 'usual.event.data.VOLUME_UNMOUNTED';
const UPDATE_DIALOG_WIDTH: number = 692;
const UPDATE_DIALOG_HEIGHT: number = 332;
const UPDATE_DOWNLOAD_DURATION: number = 3000;
const UPDATE_MAX_RETRY_TIMES: number = 100;

let subscriber: commonEventManager.CommonEventSubscriber;

/**
 * 软件更新
 */

let saveVersionDigest: update.VersionDigestInfo = { versionDigest: '' }
let preferenceTool = new PreferenceUtils(getContext(), saveVersionDigest)

@Entry
@Component
struct SoftwareUpdate {
  @State imageUrl: string = Ratio.resName('usb_device')
  @State des: string = '软件更新'
  @State settingList: SettingItemTvModel[] = []
  @State @Watch('updateText') updateState: string = ''
  @State checking: boolean = false
  @State focusIndex: number = -1
  @State @Watch('saveVersionDigestInfo') curProgress: number = 0
  @State currentVersionInfo: string = ''
  @State isUsbUpdateFocused: boolean = false;
  @State isUsbDeviceMounted: boolean = false;
  @State isUpdatePackageExisted: boolean = false;
  @State versionDigestInfo: update.VersionDigestInfo = { versionDigest: '' }
  @State isStart:  boolean = false;
  @State isMove:boolean = false
  private netCon: connection.NetConnection = connection.createNetConnection();
  @State isNetConn: boolean = false;
  volumePath: string = '';
  upgradePackagesPath: string = '';
  displayArr: string[] = [];
  private upgradeInfo: update.UpgradeInfo = {
    upgradeApp: 'com.ohos.settings',
    businessType: {
      vendor: update.BusinessVendor.PUBLIC,
      subType: 1
    }
  };
  private dialogContent: DialogContent = new DialogContent('', '', '', '', 0, 0);
  private otaUpdater: update.Updater = update.getOnlineUpdater(this.upgradeInfo);
  private customDialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogTvComponent({
      cancel: () => {
        this.customDialogController.close();
      },
      confirm: (): void => this.confirmFunc(),
      content: this.dialogContent,
      contentStyle: CustomDialogContentStyle.titleContent
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })

  showList(){
    console.log('showList:',JSON.stringify(this.settingList));
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  aboutToAppear() {
    LogUtil.info(TAG + 'settings SoftwareUpdate  EntryComponent aboutToAppear in');
    this.isStart = false
    try {
      this.displayArr =
        getContext().resourceManager.getStringArrayValueSync($r('app.strarray.software_update_titles').id);
      let otaUpdate = new SettingItemTvModel();
      otaUpdate.name = this.displayArr[0];
      otaUpdate.style = SettingItemStyle.amplifying;
      otaUpdate.arrowVisible = Visibility.Hidden

      let usbUpdate = new SettingItemTvModel();
      usbUpdate.name = this.displayArr[1];
      usbUpdate.style = SettingItemStyle.default;
      usbUpdate.arrowVisible = Visibility.Hidden

      this.settingList.push(otaUpdate, usbUpdate);
    } catch (error) {
      let message = (error as BusinessError).message;
      console.error(TAG, `aboutToAppear getStringArrayValueSync failed, message: ${message}.`);
    }
    this.getOTAUpdater();
    this.getCurrentVersionInfo();

    this.registerSubscriber();
    this.getVolumePath();
    this.onNetRegister()
  }

  onPageShow(): void {
    let version = preferenceTool.getPreValue(SOFTWARE_UPDATE_KEY)
    if (version.versionDigest != '') {
      this.isStart = false
      this.downloadProgressShow(version)
    } else {
      this.isStart = true
    }
  }

  aboutToDisappear(): void {
    try {
      commonEventManager.unsubscribe(subscriber, this.unsubscribeCB);
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(TAG, `Failed to unsubscribe. Code is ${err.code}, message is ${err.message}`);
    }
    this.offNetRegister()
  }


  /**
   * 注册网络监听
   */
  onNetRegister(){
    // 创建NetConnection对象
    // 先使用register接口注册订阅事件
    this.netCon.register((error: BusinessError) => {
      console.log(TAG, '开始网络监听')
      console.error(JSON.stringify(error));
    });
    // 订阅网络可用事件。调用register后，才能接收到此事件通知
    this.netCon.on('netAvailable', (data: connection.NetHandle) => {
      this.isNetConn = true;
      console.info(TAG, 'Succeeded netAvailable isNetConn:' + this.isNetConn);
    });

    this.netCon.on('netCapabilitiesChange', (data: connection.NetCapabilityInfo) => {
      if (data.netCap.bearerTypes[0] === 3) {
        this.isNetConn = true
      } else if (data.netCap.bearerTypes[0] === 1) {
        this.isNetConn = true
      } else {
        this.isNetConn = false
        console.log(TAG, 'Succeeded netCapabilitiesChange NetBear: ' + 'isNetConn: ' + this.isNetConn)
      }
    });

    // 订阅网络丢失事件。调用register后，才能接收到此事件通知
    this.netCon.on('netUnavailable', () => {
      this.isNetConn = false
      console.info(TAG, 'Succeeded to get unavailable isNetConn:' + this.isNetConn);
    });

    this.netCon.on('netLost', () => {
      this.isNetConn = false
      console.info(TAG, 'Succeeded to get netlost isNetConn：' + this.isNetConn);
    });
  }

  /**
   *取消网络监听
   */
  offNetRegister(){
    // 使用unregister接口取消订阅
    this.netCon.unregister((error: BusinessError) => {
      console.log(TAG, '取消网络监听')
    });
  }

  private registerSubscriber() {
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [
        'usual.event.data.VOLUME_UNMOUNTED',
        'usual.event.data.VOLUME_MOUNTED',
      ]
    };
    commonEventManager.createSubscriber(subscribeInfo)
      .then((commonEventSubscriber: commonEventManager.CommonEventSubscriber) => {
        console.info(TAG, 'Succeeded in creating subscriber.');
        subscriber = commonEventSubscriber;
        try {
          commonEventManager.subscribe(subscriber, (error, data) => {
            this.subscribeCB(error, data);
          });
        } catch (error) {
          let err: BusinessError = error as BusinessError;
          console.error(TAG, `Failed to subscribe. Code is ${err.code}, message is ${err.message}`);
        }
      })
      .catch((err: BusinessError) => {
        console.error(`Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
      });
  }

  private subscribeCB(err: BusinessError, data: commonEventManager.CommonEventData) {
    if (err) {
      console.error(TAG, `Failed to subscribeCB. Code is ${err.code}, message is ${err.message}`);
    } else {
      console.info(TAG, `Succeeded in subscribeCB, data is ` + JSON.stringify(data));
      if (data.event === EVENT_DATA_VOLUME_MOUNTED) {
        this.alertMessage($r('app.string.usb_device_mounted'));
        this.isUsbDeviceMounted = true;
        this.getVolumePath();
      } else if (data.event === EVENT_DATA_VOLUME_UNMOUNTED) {
        this.alertMessage($r('app.string.usb_device_unmounted'));
        this.isUsbDeviceMounted = false;
      }
    }
  }

  private unsubscribeCB(err: BusinessError) {
    if (err) {
      console.error(TAG, `Failed to unsubscribe. Code is ${err.code}, message is ${err.message}`);
    } else {
      console.info(TAG, 'Succeeded in unsubscribing.');
    }
  }

  async checkUpdateFileExist(): Promise<void> {
    if (!this.volumePath) {
      console.error(TAG, 'checkUpdateFileExist getVolumePath error.');
      return;
    }
    let targetFullFile = `${this.volumePath}/updater_full.zip`;
    let targetDiffFile = `${this.volumePath}/updater_diff.zip`;

    let sandboxFullPath = targetFullFile.replace(MOUNT_PATH, SANDBOX_PATH);
    let sandboxDiffPath = targetDiffFile.replace(MOUNT_PATH, SANDBOX_PATH);
    console.debug(TAG,
      'checkUpdateFileExist sandboxFullPath = ' + sandboxFullPath + ',sandboxDiffPath =' + sandboxDiffPath);

    try {
      if (await fs.accessSync(sandboxDiffPath)) {
        console.info(TAG, 'checkUpdateFileExist found diff upgrade package.');
        this.isUpdatePackageExisted = true;
        this.upgradePackagesPath = sandboxDiffPath;
      } else if (await fs.accessSync(sandboxFullPath)) {
        console.info(TAG, 'checkUpdateFileExist found full upgrade package.');
        this.isUpdatePackageExisted = true;
        this.upgradePackagesPath = sandboxFullPath;
      } else {
        this.isUpdatePackageExisted = false;
        console.error(TAG, 'checkUpdateFileExist found file failed.');
      }
    } catch (error) {
      console.error(TAG, 'checkUpdateFileExist error, ' + JSON.stringify(error));
    }
  }

  async getVolumePath(): Promise<void> {
    await volumeManager.getAllVolumes().then((volumes: volumeManager.Volume[]) => {
      if (!volumes || volumes.length === 0) {
        console.error(TAG, 'getVolumePath error.');
        this.isUsbDeviceMounted = false;
        return;
      }
      if (volumes.length > 1) {
        this.alertMessage($r('app.string.volume_length_large'));
        this.isUsbDeviceMounted = false;
        return;
      } else {
        this.isUsbDeviceMounted = true;
        this.volumePath = volumes[0].path;
        console.debug(TAG, 'getVolumePath volumePath =' + this.volumePath);
      }
    }).catch((error: BusinessError) => {
      console.error(TAG, 'getVolumePath error, ' + JSON.stringify(error));
    });
  }

  // 获取当前版本信息
  getCurrentVersionInfo() {
    try {
      this.currentVersionInfo = systemParameterEnhance.getSync('const.product.software.version')
      this.settingList[0].setChooseDes(this.currentVersionInfo)
    }catch (err) {
      this.currentVersionInfo = '未获取到系统版本'
      LogUtil.error(TAG + '系统版本未获取到' + JSON.stringify(err))
    }
  }

  // 获取OTA升级信息
  getOTAUpdater() {
    try {
      const upgradeInfo: update.UpgradeInfo = {
        upgradeApp: 'com.ohos.settings',
        businessType: {
          vendor: update.BusinessVendor.PUBLIC,
          subType: 1
        }
      };
      this.otaUpdater = update.getOnlineUpdater(upgradeInfo);
      LogUtil.info(TAG + 'getOTAUpdater success, OTAUpdater: ' + JSON.stringify(this.otaUpdater));
    } catch (error) {
      LogUtil.info(TAG + 'getOTAUpdater fail, err: ' + JSON.stringify(error));
      this.alertMessage('获取在线升级对象失败！');
    }
  }

  saveVersionDigestInfo() {
    AppStorage.setOrCreate('ProgressValue', this.curProgress)
  }

  updateText() {
    AppStorage.setOrCreate('updateStateValue', this.updateState)
  }

  // 显示下载的进度条
  downloadProgressShow(versionDigestInfo: update.VersionDigestInfo) {
    LogUtil.info(TAG + 'downloadProgressShow enter')
    this.isStart = false
    let times = 0;
    let showBefore = -1;
    let id = setInterval(() => {
      this.otaUpdater.getTaskInfo()
        .then((info) => {
          if (!info.existTask) {
            LogUtil.info(TAG + 'task info not exist');
            clearInterval(id);
            this.alertMessage('任务信息不存在!');
            this.isStart = true;
            return;
          }
          LogUtil.info(TAG + 'getTaskInfo taskInfo: ' + JSON.stringify(info));
          if (info.taskBody.progress > 0 && info.taskBody.progress < 100) {
            LogUtil.info(TAG + 'getTaskInfo 0 < progress < 100, curProgress: ' + this.curProgress);
            this.curProgress = info.taskBody.progress;
          } else {
            LogUtil.info(TAG + 'getTaskInfo !(0 < progress < 100), curProgress: ' + this.curProgress + ' ; times: ' +
              times);
            if (info.taskBody.progress === 100) {
              this.curProgress = info.taskBody.progress;
              clearInterval(id);
              LogUtil.info(TAG + 'OTA download success');
              this.dialogContent = new DialogContent('升级包下载完成', '是否进行升级包安装？', '取消', '安装', 692, 332);
              this.confirmFunc = () => {
                this.isStart = true;
                this.OTAUpgrade(versionDigestInfo);
                this.customDialogController.close();
              }
              this.customDialogController.open();
            }
          }
          this.updateState = getContext().resourceManager.getStringSync($r('app.string.software_update_progress'),
            this.curProgress.toString())
          if (times >= UPDATE_MAX_RETRY_TIMES) {
            LogUtil.info(TAG + 'getTaskInfo times >= 20, times: ' + times);
            this.otaUpdater.pauseDownload(versionDigestInfo, { isAllowAutoResume: false });
            clearInterval(id);
            this.alertMessage('下载中断');
          }
          if (this.curProgress === showBefore) {
            times++;
          } else {
            times = 0;
          }
          showBefore = this.curProgress;
        })
    }, UPDATE_DOWNLOAD_DURATION);
  }

  getString(res: Resource): string {
    return getContext().resourceManager.getStringSync(res.id)
  }

  // OTA升级检查新版本
  OTACheckNewVersion() {
    this.otaUpdater.checkNewVersion()
      .then((checkResult) => {
        LogUtil.info(TAG + 'OTA checkNewVersion success, checkResult: ' + JSON.stringify(checkResult));
        this.checking = false
        if (!checkResult.isExistNewVersion) {
          LogUtil.info(TAG + 'no new version');
          this.alertMessage('没有新版本存在！');
          this.updateState = '已是最新版本'
          return;
        }
        this.updateState = '';
        let versionDigestInfo = checkResult.newVersionInfo.versionDigestInfo;
        this.updateState = this.getString($r('app.string.new_version'))
        this.dialogContent =
          new DialogContent('已检测到新版本', '是否进行升级包下载？', '取消下载', '下载升级包', 692, 332);
        this.confirmFunc = () => {
          this.OTADownload(versionDigestInfo);
          this.customDialogController.close();
        }
        this.customDialogController.open();
      })
      .catch((err: Error) => {
        LogUtil.info(TAG + 'OTA checkNewVersion fail, err: ' + JSON.stringify(err));
        if(err.message == 'CheckNewVersion TimeOut'){
          this.alertUpgradeMessage('已是最新版本！');
          this.updateState = '已是最新版本'
          this.checking = false
          setTimeout(() => {
            this.updateState = ''
          }, 10000)
        } else {
          this.alertUpgradeMessage('在线检查新版本系统失败！');
          this.updateState = '检查更新失败'
          this.checking = false
          setTimeout(() => {
            this.updateState = ''
          }, 10000)
        }
      })
  }

  // 下载
  OTADownload(versionDigestInfo: update.VersionDigestInfo) {
    this.versionDigestInfo = versionDigestInfo;
    preferenceTool.setPreValue(SOFTWARE_UPDATE_KEY, this.versionDigestInfo);
    let ss = preferenceTool.getPreValue(SOFTWARE_UPDATE_KEY)
    const downloadOptions: update.DownloadOptions = {
      allowNetwork: 1, // 允许数据网络下载
      order: 1 // 下载
    };
    this.otaUpdater.download(versionDigestInfo, downloadOptions)
      .then(() => {
        this.downloadProgressShow(versionDigestInfo);
      })
      .catch((err: Error) => {
        LogUtil.info(TAG + 'OTA download fail, err: ' + JSON.stringify(err));
        this.isStart = true
        this.alertMessage('在线下载升级包失败！');
      })
  }

  OTAUpgrade(versionDigestInfo: update.VersionDigestInfo) {
    this.otaUpdater.upgrade(versionDigestInfo, { order: 2 })
      .then(() => {
        LogUtil.info(TAG + 'OTA upgrade success');
        this.getCurrentVersionInfo()
        this.alertMessage('安装升级包成功！');
      })
      .catch((err: Error) => {
        LogUtil.info(TAG + 'OTA upgrade fail, err: ' + JSON.stringify(err));
        this.alertMessage('安装升级包失败！');
      })
  }

  alertMessage(message: string | Resource) {
    try {
      promptAction.showToast({
        message: message,
        duration: 3000
      });
    } catch (error) {
      LogUtil.info(TAG + 'AlertMessage fail, err: ' + JSON.stringify(error));
    }
  }

  alertUpgradeMessage(message: string | Resource) {
    try {
      promptAction.showToast({
        message: message,
        duration: 10000
      });
    } catch (error) {
      LogUtil.info(TAG + 'AlertMessage fail, err: ' + JSON.stringify(error));
    }
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
          title: '软件更新',
          onFocusHandle: (item: SettingItemTvModel) => {
            if (item.name === this.displayArr[0]) {
              this.isUsbUpdateFocused = false;
            } else if (item.name === this.displayArr[1]) {
              this.isUsbUpdateFocused = true;
            }
          },
          onMouseClickHandle:(item: SettingItemTvModel)=>{
            if (item.name === this.displayArr[0]) {
              this.isUsbUpdateFocused = false;
            } else if (item.name === this.displayArr[1]) {
              this.isUsbUpdateFocused = true;
            }
          }
        })
          .width(ConfigData.WH_50_100)
          .height('100%')
          .margin({ left: lpx(84) })
          .focusable(true)

        UpdateProgress({
          settingList:this.settingList,
          isStart: this.isStart,
          curProgress: this.curProgress,
          updateState: this.updateState,
          checking: this.checking,
          currentVersionInfo: this.currentVersionInfo,
          onClickEvent: () => {
            if(this.isNetConn){
              this.updateState = '正在检查...'
              this.checking = true
              setTimeout(() => {
                this.OTACheckNewVersion()
              }, 3000)
            } else {
              this.alertMessage('当前无网络连接，请检查网络连接！')
            }
          }
        }).focusable(true)
          .onFocus(() => {
            this.focusIndex = 1;
            LogUtil.info('onFocus button ');
          })
          .onBlur(() => {
            this.focusIndex = -1;
          }).visibility(this.isUsbUpdateFocused ? Visibility.None : Visibility.Visible)

        UsbUpdateDesComponent({
          des: this.isUsbDeviceMounted ? $r('app.string.usb_update_query') : $r('app.string.usb_update_unavailable'),
          isUsbDeviceMounted: this.isUsbDeviceMounted,
          onClickHandle: async () => {
            await this.checkUpdateFileExist();
            console.log(TAG, 'Show update dialog, isUpdatePackageExisted = ' + this.isUpdatePackageExisted);
            if (this.isUpdatePackageExisted) {
              try {
                let dialogArray =
                  getContext().resourceManager.getStringArrayValueSync($r('app.strarray.software_update_dialog').id);
                this.dialogContent =
                  new DialogContent(dialogArray[0], dialogArray[1], dialogArray[2], dialogArray[3], UPDATE_DIALOG_WIDTH,
                    UPDATE_DIALOG_HEIGHT);
                this.confirmFunc = () => {
                  console.log(TAG, 'Click upgrade dialog confirm button.');
                  this.customDialogController.close();
                  this.applyNewVersion();
                }
                this.customDialogController.open();
              } catch (error) {
                let message = (error as BusinessError).message;
                console.error(TAG, `UsbUpdateDesComponent getStringArrayValueSync failed, message: ${message}.`);
              }
            } else {
              this.alertMessage($r('app.string.update_packages_not_exist'));
            }
          }
        })
          .width(ConfigData.WH_50_100)
          .height(ConfigData.WH_100_100)
          .visibility(this.isUsbUpdateFocused ? Visibility.Visible : Visibility.None)
      }
      .width(ConfigData.WH_100_100)
      .height(ConfigData.WH_100_100)
    }

  }

  private confirmFunc = () => {
  };

  private applyNewVersion() {
    let localUpdater = update.getLocalUpdater();
    const upgradeFiles: update.UpgradeFile[] = [{
      fileType: update.ComponentType.OTA,
      filePath: this.upgradePackagesPath
    }];

    console.info(TAG, 'Start to applyNewVersion, path =' + this.upgradePackagesPath);
    localUpdater.applyNewVersion(upgradeFiles).then(() => {
      console.debug(TAG, `ApplyNewVersion success.`);
    }).catch((err: BusinessError) => {
      console.error(TAG, `ApplyNewVersion error ${JSON.stringify(err)}.`);
    });
  }
}

@Component
struct UpdateProgress {
  @Link settingList:SettingItemTvModel[]
  @Prop @Watch('check') curProgress: number
  @Prop updateState: string
  @Prop checking: boolean
  @Prop currentVersionInfo: string
  @State focusIndex: number = -1
  @Prop isStart: boolean
  @State loadState: ProgressStatus = ProgressStatus.PROGRESSING
  @State isDownload: boolean = false

  check() {
    if (this.curProgress != 0) {
      this.loadState = ProgressStatus.PROGRESSING
    }
    this.isDownload = true
  }

  build() {
    Column() {
      Stack() {
        if (this.isDownload) {
          Progress({ value: this.curProgress, total: 100, type: ProgressType.Ring })
            .backgroundColor('rgba(255, 255, 255, 0.38)')
            .width(lpx(361))
            .color(this.judgeColor(this.checking, this.isDownload))
            .style({
              strokeWidth: lpx(36),
              status: ProgressStatus.PROGRESSING
            })
        } else {
          Progress({ value: 0, total: 100, type: ProgressType.Ring })
            .backgroundColor('rgba(255, 255, 255, 0.38)')
            .width(lpx(361))
            .color(this.judgeColor(this.checking, this.isDownload))
            .style({
              strokeWidth: lpx(36),
              status: ProgressStatus.LOADING
            })
        }

        Column() {
          Text('OpenHarmony')
            .fontSize(lpx(40))
            .fontWeight(FontWeight.Bold)
            .fontColor('rgba(255, 255, 255, 0.86)')
          Text(this.currentVersionInfo.replace('OpenHarmony-', ''))
            .fontSize(lpx(20))
            .fontColor('rgba(140, 140, 140, 1)')
            .height(lpx(29))
            .fontWeight(FontWeight.Medium)
        }
      }

      Text(this.curProgress == 100 ? '下载完成' : this.updateState)
        .height(lpx(28))
        .fontSize(lpx(24))
        .fontColor(0xCCCCCC)
        .textAlign(TextAlign.Center)
        .margin(lpx(48))

      Button('检查更新')
        .enabled(this.isStart)
        .fontColor(this.focusIndex == 0 ? 'rgba(7, 7, 7, 1)' : 'rgba(255, 255, 255, 1)')
        .fontSize(lpx(36))
        .height(lpx(82))
        .backgroundColor(this.focusIndex == 0 ? 'rgba(222, 222, 222, 1)' : 'rgba(86, 86, 86, 1)')
        .focusable(true)
        .padding({
          left: lpx(38),
          right: lpx(38),
        })
        .onFocus(() => {
          this.focusIndex = 0
this.settingList[1].setIsDisableFocus(true)
        })
        .onBlur(() => {
          this.focusIndex = -1
          this.settingList[1].setIsDisableFocus(false)
        })
        .onHover((isHover: boolean) => {
          this.focusIndex = isHover ? 0 : -1
        })
        .onTouch((event) => {
          if (!EventUtil.isTouchEvent(event)) {
            return;
          }
          if (event.sourceTool !== SourceTool.Pen &&
            event.sourceTool !== SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK) {
            return;
          }
        })
        .onClick(()=>{
          this.onClickEvent()
        })
        .stateStyles({
          focused: {
            .border({
              color: Color.Transparent
            })
          }
        })
    }
    .width(ConfigData.WH_50_100)
    .height(ConfigData.WH_100_100)
    .padding({ top: lpx(228) })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)

  }

  judgeColor(checking: boolean, isDownLoad: boolean): Resource {
    if (isDownLoad) {
      return $r('app.color.loading_progress')
    } else {
      if (checking) {
        return $r('app.color.loading_progress')
      } else {
        return $r('app.color.loading_progress_trans')
      }
    }
  }

  private onClickEvent: Function = () => {
  };
  private onKeyEventHandle: Function = (event: KeyEvent) => {
  };
}

interface RootInfoType {
  value: fileAccess.RootInfo,
  done: boolean
}

interface ResultType {
  value: fileAccess.FileInfo,
  done: boolean
}
