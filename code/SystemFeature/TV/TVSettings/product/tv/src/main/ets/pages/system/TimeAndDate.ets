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
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { CustomDialogContentStyle, SettingItemStyle } from '../../common/constants/StyleConstants';
import { KeyCode } from '../../common/constants/KeyCode';
import { Ratio } from '../../common/Ratio';
import lpx from '../../common/Lpx';
import settings from '@ohos.settings';
import systemDateTime from '@ohos.systemDateTime';
import { getNetworkTime, NTPConfig } from '@ohos/ntp';
import { CustomDialogTvComponent, DialogContent } from '../../default/layout/CustomDialogTvComponent';
import { i18n } from '@kit.LocalizationKit';
import promptAction from '@ohos.promptAction';
import { Duration } from '../../common/constants/Duration';
import { commonEventManager } from '@kit.BasicServicesKit';

const TAG = 'TimeAndData'

/**
 *时间和日期
 */

@Entry
@Component
struct TimeAndData {
  @State imageUrl: string = Ratio.resName('icon_system')
  @State des: string = '设置时间和日期'
  @State desTime: string = getContext(this).resourceManager.getStringByNameSync('change_time_and_date')
  @State settingList: SettingItemTvModel[] = []
  @State focusIndex: number = -1
  @State isOn: boolean = false;
  @State is24Hours: boolean = false;
  @State date: string = '';
  @State time: string = '';
  @State ntpResult: string = ''
  @State timeoutResult: string | undefined = ''
  @StorageLink('AUTO_GAIN_TIME') isAutoGainTime: string = ''
  @StorageLink('is24Format') TIME_FORMAT: string = ''
  @State settingdataDate: string = ''
  @State settingdataTime: string = ''
  private isSettingdataTime: boolean = false //判断settingdata中是否存储时间
  dateFormat = new Intl.DateTimeFormat('zh-Cn', { year: 'numeric', month: 'long', day: 'numeric' })
  time12Format = new Intl.DateTimeFormat('zh-Cn', {
    hour: '2-digit',
    minute: '2-digit',
    hour12: true
  })
  time24Format = new Intl.DateTimeFormat('zh-Cn', {
    hour: '2-digit',
    minute: '2-digit',
    hourCycle: 'h23',
    hour12: false
  })
  private content: DialogContent = new DialogContent(this.desTime, '', '', '', 784, 500);
  dateDialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogTvComponent({
      cancel: (): void => this.onCancel(),
      confirm: (): void => this.onSureConfirm(),
      content: this.content,
      contentStyle: CustomDialogContentStyle.DatePicker
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })
  timeDialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogTvComponent({
      cancel: (): void => this.onCancel(),
      confirm: (): void => this.onSureConfirm(),
      content: this.content,
      contentStyle: CustomDialogContentStyle.TimePicker
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })
  sureDateDialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogTvComponent({
      cancel: (): void => this.onCancel(),
      confirm: (): void => this.onConfirm(),
      content: new DialogContent('提示', `是否确定修改？`, '取消', '确定', 692, 332),
      contentStyle: CustomDialogContentStyle.titleContent
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })
  onSureConfirm() {
    this.sureDateDialogController.open()
  }
  onConfirm() {
    this.setTime()
    this.dateDialogController.close()
    this.timeDialogController.close()
    this.sureDateDialogController.close()
  }

  onCancel() {
    this.dateDialogController.close()
    this.timeDialogController.close()
    this.sureDateDialogController.close()
  }

  //日期时间显示24小时格式渲染
  setTimeFormat(type: 'date' | 'time', value: boolean, time: number): string {
    if (type === 'date') {
      this.date = this.dateFormat.format(time)
      return this.date
    } else {
      if (value) {
        this.time = this.time24Format.format(time)
        return this.time
      } else {
        this.time = this.time12Format.format(time)
        return this.time
      }
    }
  }

  //设置时间
  setTime() {
    this.settingList[1].setChooseDes(this.setTimeFormat('date', this.is24Hours, this.content.customTime))
    if (this.is24Hours) {
      this.settingList[2].setChooseDes(this.setTimeFormat('time', this.is24Hours, this.content.customTime))
    } else {
      this.settingList[2].setChooseDes(this.setTimeFormat('time', this.is24Hours, this.content.customTime))
    }
    systemDateTime.setTime(this.content.customTime, () => {
      settings.setValueSync(getContext(),'settings.auto.time',JSON.stringify(this.content.customTime))
    })

    commonEventManager.publish('user.event.SET_TIME', (err) => {});
  }

  //获取系统24小时设置
  get24HourFormat() {
    this.TIME_FORMAT =
      settings.getValueSync(getContext(), settings.date.TIME_FORMAT, '', settings.domainName.DEVICE_SHARED)
    if (this.TIME_FORMAT === 'true') {
      this.is24Hours = true
    } else {
      this.is24Hours = false
    }
  }

  //系统时间24制设置
  set24HourFormat() {
    this.is24Hours = !this.is24Hours
    i18n.System.set24HourClock(this.is24Hours)
    let dateTime = new Date()
    this.settingList[3].setChooseDes(this.setTimeFormat('time', this.is24Hours, dateTime.getTime()))
    if (this.is24Hours) {
      this.TIME_FORMAT = 'true'
      AppStorage.setOrCreate('is24Format', this.TIME_FORMAT)
      settings.setValueSync(getContext(), settings.date.TIME_FORMAT, this.TIME_FORMAT,
        settings.domainName.DEVICE_SHARED)
    } else {
      this.TIME_FORMAT = 'false'
      AppStorage.setOrCreate('is24Format', this.TIME_FORMAT)
      settings.setValueSync(getContext(), settings.date.TIME_FORMAT, this.TIME_FORMAT,
        settings.domainName.DEVICE_SHARED)
    }
  }

  async getNetTime() {
    //socket 连接 获取阿里云NTP服务器时间
    let config: NTPConfig | undefined = undefined
    config = {
      server: 'ntp.aliyun.com',
      port: 123,
      delayTime: 2000
    }
    getNetworkTime(config)
      .then((date: Date) => {
        let setDate = new Date()
        LogUtil.log(TAG + '--获取NTP服务器成功time：' + date)
        setDate.setTime(date.getTime())
        this.settingList[1].setChooseDes(this.setTimeFormat('date', this.is24Hours, date.getTime()))
        this.settingList[2].setChooseDes(this.setTimeFormat('time', this.is24Hours, date.getTime()))
        systemDateTime.setTime(date.getTime(), () => {
          LogUtil.info(TAG + `setDate finish`)
          settings.setValueSync(getContext(),'settings.auto.time','')
        })
        config = undefined
      })
      .catch((err: Error) => {
        this.timeoutResult = JSON.stringify(err.message)
        LogUtil.log(TAG + '--获取网络时间失败：' + this.timeoutResult)
        promptAction.showToast({
          message:  $r('app.string.failed_to_get_network_time'),
          duration: 2000
        });
        config = undefined
      })
  }

  getTimeSetting() {
    this.isAutoGainTime =
      settings.getValueSync(getContext(), settings.date.AUTO_GAIN_TIME, '', settings.domainName.DEVICE_SHARED)
    if (this.isAutoGainTime === 'false') {
      this.isOn = false
    } else {
      this.isOn = true
      this.getNetTime()
    }
  }

  isAutoTime() {
    this.isOn = !this.isOn



    for (let i = 1; i <= 2; i++) {
      this.settingList[i].setIsEnable(!this.isOn);
      this.settingList[i].setIsDisableFocus(this.isOn)
    }
    if (this.isOn) {
      this.isAutoGainTime = 'true'
      AppStorage.setOrCreate('AUTO_GAIN_TIME', this.isAutoGainTime)
      settings.setValueSync(getContext(), settings.date.AUTO_GAIN_TIME, this.isAutoGainTime,
        settings.domainName.DEVICE_SHARED)
      LogUtil.info(TAG + '设置isAUTO_GAIN_TIME为' + this.isAutoGainTime)
      this.getNetTime()
    } else {
      this.isAutoGainTime = 'false'
      AppStorage.setOrCreate('AUTO_GAIN_TIME', this.isAutoGainTime)
      settings.setValueSync(getContext(), settings.date.AUTO_GAIN_TIME, this.isAutoGainTime,
        settings.domainName.DEVICE_SHARED)
      LogUtil.info(TAG + '设置isAUTO_GAIN_TIME为' + this.isAutoGainTime)
    }
    console.log('===ClickonisAutoTime')
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  /**
   * 从settingdata中获取上一次存储的时间
   */
  getTimeFromSettingdata(isOn:boolean){
    if (!isOn) {
      let settingDataTime = settings.getValueSync(getContext(), 'settings.auto.time', '')
      if (settingDataTime && settingDataTime != '') {
        this.isSettingdataTime = true
        try {
          let newDate = new Date(Number(settingDataTime))
          this.settingdataDate = this.setTimeFormat('date', this.is24Hours, newDate.getTime())
          this.settingdataTime = this.setTimeFormat('time', this.is24Hours, newDate.getTime())
          //设置settingdata中的时间作为当前的时间
          systemDateTime.setTime(Number(settingDataTime))
          try {
            //拿取时间之后，就将settingdata中的时间清空
            settings.setValueSync(getContext(), 'settings.auto.time', '')
            LogUtil.info(TAG + '清空数据库中时间出现成功');
          } catch (e) {
            LogUtil.info(TAG + '清空数据库中时间出现错误：' + JSON.stringify(e));
          }
        } catch (e) {
          LogUtil.info(TAG + '从数据库获取日期出现错误：' + JSON.stringify(e));
        }
      } else {
        LogUtil.info(TAG + 'settingdata未存储时间')
      }
    } else {
      LogUtil.info(TAG + '当前的开关是开启的,不需要读取settingdata的时间')
    }
  }

  aboutToAppear() {

    LogUtil.info(TAG + 'settings TimeAndDate  EntryComponent aboutToAppear in');
    this.get24HourFormat()
    this.getTimeSetting()
    this.getTimeFromSettingdata(this.isOn)
    this.time = this.setTimeFormat('time', this.is24Hours, new Date().getTime())
    this.date = this.setTimeFormat('date', this.is24Hours, new Date().getTime())
    let item1 = new SettingItemTvModel()
    item1.name = '自动设置';
    item1.isOn = this.isOn;
    item1.style = SettingItemStyle.switch
    let item2 = new SettingItemTvModel()
    item2.name = '24小时制';
    item2.isOn = this.is24Hours;
    item2.style = SettingItemStyle.switch
    let item3 = new SettingItemTvModel()
    item3.name = '日期设置';
    item3.chooseDes = this.isSettingdataTime ? this.settingdataDate : this.date;
    item3.isEnable = !this.isOn;
    item3.isDisableFocus = this.isOn;
    item3.style = SettingItemStyle.default
    let item4 = new SettingItemTvModel()
    item4.name = '时间设置';
    item4.chooseDes = this.isSettingdataTime ? this.settingdataTime : this.time;
    item4.isEnable = !this.isOn;
    item4.isDisableFocus = this.isOn;
    item4.style = SettingItemStyle.default

    this.settingList.push(item1, item3, item4);
  }

  onPageHide(): void {
    this.isSettingdataTime = false
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
          title: '时间和日期',
          onMouseClickHandle:(item:SettingItemTvModel)=>{
            if (item.name === '自动设置') {
                this.isAutoTime()
            }
            if(!this.isOn){
              if (item.name === '日期设置') {
                this.dateDialogController.open()
              }
              if (item.name === '时间设置') {
                this.timeDialogController.open()
              }
              if (item.name === '24小时制') {
                this.set24HourFormat()
              }
            }
          },
          onToggleChangedHandle: (item: SettingItemTvModel, isOn: boolean) => {
            this.isAutoTime()
          }
        })
          .width(ConfigData.WH_48_100)
          .height('100%')
          .margin({ left: lpx(84) })

        SettingItemDesLayout({ imageUrl: this.imageUrl, des: this.des })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
      }
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
}
