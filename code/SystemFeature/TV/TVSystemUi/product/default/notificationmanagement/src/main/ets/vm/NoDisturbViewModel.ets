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
 

import ConfigData from '../common/constants';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import NoDisturbingModel from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/model/noDisturbingModel';
import NoDisturbComponentViewModel from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/vm/noDisturbComponentViewModel';
import FeaturesConfigData, {DoNotDisturbType} from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/common/constants';

const TAG = 'NotificationManagement-NoDisturbViewModel';
const CONST_DAY_LENGTH = 24*3600*1000;

@Observed
export default class NoDisturbViewModel extends NoDisturbComponentViewModel {

  public startDateClue = '';
  public startTimeClue = '';
  public endDateClue = '';
  private endTimeClue = '';

  viewModelInit(): void{
    Log.showDebug(TAG, 'ViewModelInit');
    void this.getNextDayLabel();
    this.getNoDisturbingDate.bind(this)();
  }
  getNoDisturbingDate(): void {
    Log.showDebug(TAG, 'getNoDisturbingDate');
    NoDisturbingModel.getNoDisturbingDate((data) => {
      Log.showInfo(TAG, 'getNoDisturbingDate data:' + JSON.stringify(data));
      this.repeatMode = data.type??0;
      this.startTime = data.begin??'';
      this.endTime = data.end??'';
      Log.showInfo(TAG, `getNoDisturbingDate this.repeatMode : ${this.repeatMode}, this.startTime : ${this.startTime}, this.endTime : ${this.endTime}`)
      this.setClues.bind(this)();
    });
  }

  // setClues 根据 repeatMode 类型分两套逻辑处理时间提示文案：
  // TYPE_CLEARLY（精确时间段）需要拼接日期+时间，其他模式只需时间，
  // 跨午夜场景（startTime >= endTime）自动在结束时间前加"次日"标签，避免用户误读时间段。
  setClues(): void {
    Log.showDebug(TAG, 'setClues');
    if (this.repeatMode == DoNotDisturbType.TYPE_DAILY ||
    this.repeatMode == DoNotDisturbType.TYPE_ONCE ||
    this.repeatMode == DoNotDisturbType.TYPE_CLEARLY) {
      this.isEffective = true;
    } else {
      this.isEffective = false;
    }
    let tmpStartDateTime = null;
    let tmpEndDateTime = null;
    if (this.repeatMode == DoNotDisturbType.TYPE_CLEARLY) {
      tmpStartDateTime = this.getDateByDateTime(this.startTime);
      tmpEndDateTime = this.getDateByDateTime(this.endTime);
      this.startDateClue = this.getDateLabel(this.startTime);
      this.startTimeClue = NoDisturbingModel.formatTime(tmpStartDateTime);
      this.endDateClue = this.getDateLabel(this.endTime);
      this.endTimeClue = NoDisturbingModel.formatTime(tmpEndDateTime);
    } else {
      tmpStartDateTime = this.getDateByHHMI(this.startTime);
      tmpEndDateTime = this.getDateByHHMI(this.endTime);
      this.startDateClue = '';
      this.startTimeClue = this.startTime;
      this.endDateClue = '';
      if (tmpStartDateTime.getTime() >= tmpEndDateTime.getTime()) {
        this.endTimeClue = this.nextDayLabel + this.endTime;
      } else {
        this.endTimeClue = this.endTime;
      }
    }
    this.defaultStartTime = tmpStartDateTime;
    this.defaultEndTime = tmpEndDateTime;
    this.repeatName = this.refreshRepeatName(this.repeatMode);
  }

  onStartTimeAccept(data: string): void {
    Log.showDebug(TAG, 'onStartTimeAccept');
    this.startTime = data;
    if (this.repeatMode == DoNotDisturbType.TYPE_CLEARLY) {
      let tmpDateTime = this.getDateByDateTime(this.startTime);
      if (this.defaultEndTime.getTime() < tmpDateTime.getTime()) {
        this.startTime = this.endTime;
      }
    }
    this.setClues();
    this.setNoDisturbingDate();

  }

  onEndTimeAccept(data: string): void {
    Log.showDebug(TAG, 'onEndTimeAccept');
    this.endTime = data;
    if (this.repeatMode == DoNotDisturbType.TYPE_CLEARLY) {
      let tmpDateTime = this.getDateByDateTime(this.endTime);
      if (tmpDateTime.getTime() < this.defaultStartTime.getTime()) {
        this.endTime = this.startTime;
      }
    }
    this.setClues();
    this.setNoDisturbingDate();
  }

  // 切换到 TYPE_CLEARLY 模式时重置开始时间为当前时刻、结束时间为次日同时刻，
  // 其他模式则重置为空时间占位符，是为了给用户一个合理的默认值，
  // 避免模式切换后沿用上一个模式的时间导致时间段语义错乱。
  onRepeatModeAccect(data: number): void {
    Log.showDebug(TAG, 'onRepeatModeAccect');
    this.repeatMode = data;
    if (this.repeatMode == DoNotDisturbType.TYPE_CLEARLY) {
      let dateSource = new Date();
      this.startTime = NoDisturbingModel.formatDate(dateSource) + ' ' + FeaturesConfigData.TIME_EMPTY;
      this.endTime = NoDisturbingModel.formatDate(new Date(dateSource.getTime() + CONST_DAY_LENGTH)) + ' ' + FeaturesConfigData.TIME_EMPTY;
    } else {
      this.startTime = FeaturesConfigData.TIME_EMPTY;
      this.endTime = FeaturesConfigData.TIME_EMPTY;
    }
    this.setClues();
    this.setNoDisturbingDate();
  }

  setDateIntoDateTime(dateSource: Date, inputData: string): string {
    let result = inputData + ' ' + NoDisturbingModel.formatTime(dateSource);
    return result;
  }

  setTimeIntoDateTime(dateSource: Date, inputData: string): string {
    let result = NoDisturbingModel.formatDate(dateSource) + ' ' + inputData;
    return result;
  }

  onCancel(): void {
    Log.showDebug(TAG, 'onCancel');
  }
}
