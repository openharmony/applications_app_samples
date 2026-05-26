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

import { CommonConstants, Logger, Scene } from '@ohos/common';
import HeadTitleComponent from '../view/HeadTitleComponent';
import { SceneBean } from '../common/bean/SceneBean';
import DeviceItem from '../common/bean/DeviceItem';
import { actions, triggerCondition } from '../model/SceneCondition';
import SceneLibraryModel from '../viewmodel/SceneLibraryModel';
import { SceneLibraryManager } from '../viewmodel/SceneLibraryManager';
import { Event, SubsystemAction } from '@ohos/common/src/main/ets/database/entity/Scene';
import SceneModel from '../viewmodel/SceneModel';

let TAG = 'SceneDetailPage';

@Preview
@Component
export struct SceneDetailPage {
  @State sceneId: string = '';
  @State isEdit: boolean = false;
  @State detailName: string = '';
  // 场景详情
  private sceneDetail: Scene | null = {} as Scene;
  @StorageLink('sceneList') sceneList: SceneBean[] = [];
  @StorageLink('mySceneList') mySceneList: Scene[] = [];
  @State isLeftIcon: string | Resource = '';
  @State title: Resource = $r('app.string.scene_description');
  @State heading: Resource = $r('app.string.scene_title_desc');
  @State description: string = '';
  @State totalNum: number = 0;
  @State triggerLength: number = 0;
  @State actionsLength: number = 0;
  @State triggerName: string = '';
  @State actionsName: string = '';

  async aboutToAppear() {
    Logger.info('this.isEdit:' + this.isEdit);
    if (this.isEdit) {
      Logger.info('this.mySceneList:' + this.isEdit);
      this.sceneDetail = await this.getCustomDetail(this.sceneId);
    } else {
      this.sceneDetail = await SceneLibraryManager.getInstance().getSceneInfo(this.sceneId);
    }
    Logger.info('this.sceneDetail:' + JSON.stringify(this.sceneDetail));
    if (this.sceneDetail != null) {
      let data: SubsystemAction[] = JSON.parse(JSON.stringify(this.sceneDetail.flow[0].actions[0].actions));
      this.heading = $r('app.string.scene_title_desc', this.sceneDetail.scenarioCard.title, data[0].deviceInfo.devName);
      this.description = this.sceneDetail.scenarioCard.description;
    }
  }

  // 查询自定义场景详情
  getCustomDetail(id: string) {
    this.mySceneList = SceneModel.getInstance().getPreference() as Array<Scene>;
    Logger.info('this.mySceneList:' + JSON.stringify(this.mySceneList));
    let result: Scene = this.mySceneList.filter((item: Scene) => {
      return item.scenarioCard.scenarioCardId == id;
    })[0];
    return result;
  }

  getDeviceNum(num1: number, num2: number) {
    return num1 + num2;
  }

  getDeviceName(deviceList: Array<Event> | Array<SubsystemAction>) {
    let deviceNames: string = '';
    deviceList.forEach((item: Event | SubsystemAction, index: number) => {
      if (index == 0) {
        deviceNames += item.deviceInfo.devName;
      } else {
        deviceNames += '、' + item.deviceInfo.devName;
      }
    });
    return deviceNames;
  }

  build() {
    Column() {
      HeadTitleComponent({
        title: $title,
        isLeftIcon: $isLeftIcon
      });
      if (this.sceneDetail == null || this.sceneDetail == undefined) {

      } else {
        Column() {
          Text(this.heading)
            .setSceneText($r('app.string.font_20'), $r('app.color.scene_title_color'), 500, '28vp')
            .width(CommonConstants.FULL_WIDTH_PERCENT);
          Text(this.description)
            .setSceneText($r('app.string.font_14'), $r('app.color.scene_title_color'), 400, '20vp')
            .margin({ top: '4vp' })
            .width(CommonConstants.FULL_WIDTH_PERCENT);
        }
        .padding({ left: $r('app.string.padding_tab_left'), right: $r('app.string.padding_tab_left') })
        .justifyContent(FlexAlign.Start)
        .width(CommonConstants.FULL_WIDTH_PERCENT);
      }
    }
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .height(CommonConstants.FULL_HEIGHT_PERCENT)
    .backgroundColor($r('app.color.scene_bg'));
  }
}

@Extend(Text)
function setSceneText(size: Resource, color: Resource, weight: number, lineHeight: string) {
  .fontSize(size)
  .fontColor(color)
  .fontWeight(weight)
  .lineHeight(lineHeight);
}