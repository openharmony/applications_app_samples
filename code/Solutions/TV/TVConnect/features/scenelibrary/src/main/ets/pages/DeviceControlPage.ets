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

import { CommonConstants, Logger, RelativeRules, Scene } from '@ohos/common';
import HeadTitleComponent from '../view/HeadTitleComponent';
import { DevicesDragView } from '../view/DevicesDragView';
import SceneManager from '../viewmodel/SceneManager';
import common from '@ohos.app.ability.common';
import DevicesModel from '../viewmodel/DeviceModel';
import { promptAction, router } from '@kit.ArkUI';
import SceneModel from '../viewmodel/SceneModel';
import RenameAlertDialog from '../view/RenameAlertDialog';
import DeviceItem from '../common/bean/DeviceItem';
import { SceneLibraryManager } from '../viewmodel/SceneLibraryManager';
import { Event, SubsystemAction } from '@ohos/common/src/main/ets/database/entity/Scene';
import DragSceneConstants from '../common/constants/DragSceneConstants';

@Preview
@Component
export struct DeviceControlPage {
  originSize: number = DragSceneConstants.DEVICE_CIRCULAR_SIZE;
  @State sceneDetail: Scene | null = {} as Scene;
  @State sceneName: string = '';
  @State sceneId: string = '';
  @Provide devicesModel: DevicesModel = new DevicesModel();
  @Provide triggers: DeviceItem[] = [];
  @Provide actions: DeviceItem[] = [];
  @State isLeftIcon: string | Resource = $r('app.media.scene_detail_tip');
  @State templateIndex: number = 0;
  @State templateName: string = '';
  @StorageLink('mySceneList') mySceneList: Scene[] = [];
  @StorageLink('isUpdate') isUpdate: boolean = false;
  @StorageLink('isImport') isImport: boolean = false;
  @State isEdit: boolean = false;
  private renameController: CustomDialogController = new CustomDialogController({
    builder: RenameAlertDialog({
      onConfirm: () => {
        if (this.templateName) {
          this.saveScene(this.templateName);
        } else {
          this.toast($r('app.string.add_scene_name_empty_tip'));
        }
      },
      name: this.templateName
    })
  });
  clickCallback: () => void = () => {
  };

  // 判断是否编辑完成
  isEditComplete() {
    let triggersLength: number = this.triggers.filter((item: DeviceItem) => {
      return item.deviceId == '';
    }).length;
    let actionsLength: number = this.actions.filter((item: DeviceItem) => {
      return item.deviceId == '';
    }).length;
    return triggersLength == 0 && actionsLength == 0;
  }

  // 获取默认场景名称
  getDefaultName() {
    this.templateIndex = Number(SceneModel.getInstance().getDefaultKey('customKey' + this.sceneId));
    if (this.templateIndex > 1 && this.sceneDetail != null) {
      this.templateName = this.sceneDetail.scenarioCard.title + this.templateIndex;
    }
  }

  // 保存场景
  async saveScene(name: string) {
    if (this.isEdit) {
      if (this.sceneDetail != null) {
        this.sceneDetail.flow[0].trigger.events.map((item: Event, index: number) => {
          item.deviceInfo.devId = this.triggers[index].deviceId;
          item.deviceInfo.devName = this.triggers[index].deviceName;
          item.deviceInfo.devType = this.triggers[index].deviceType;
        });
        let data: SubsystemAction[] = JSON.parse(JSON.stringify(this.sceneDetail.flow[0].actions[0].actions));
        data.map((item: SubsystemAction, index: number) => {
          item.deviceInfo.devId = this.actions[index].deviceId;
          item.deviceInfo.devName = this.actions[index].deviceName;
          item.deviceInfo.devType = this.actions[index].deviceType;
        });
      }
    } else {
      if (this.sceneDetail != null) {
        this.sceneDetail.scenarioCard.scenarioCardId = this.mySceneList.length + 1 + '';
        this.sceneDetail.scenarioCard.title = name;
        this.sceneDetail.flow[0].trigger.events.map((item: Event, index: number) => {
          item.deviceInfo.devId = this.triggers[index].deviceId;
          item.deviceInfo.devName = this.triggers[index].deviceName;
          item.deviceInfo.devType = this.triggers[index].deviceType;
        });
        let data: SubsystemAction[] = JSON.parse(JSON.stringify(this.sceneDetail.flow[0].actions[0].actions));
        data.map((item: SubsystemAction, index: number) => {
          item.deviceInfo.devId = this.actions[index].deviceId;
          item.deviceInfo.devName = this.actions[index].deviceName;
          item.deviceInfo.devType = this.actions[index].deviceType;
        });
        this.sceneDetail.flow[0].actions[0].actions = data;
        this.mySceneList.unshift(this.sceneDetail);
      }
      SceneModel.getInstance().putCustomKey('customKey' + this.sceneId, Number(this.templateIndex) + 1);
    }
    await SceneModel.getInstance().putPreference(this.mySceneList);
    this.toast($r('app.string.scene_save_tip'));
    this.isUpdate = true;
    router.back();
  }

  toast(msg: string | Resource) {
    promptAction.showToast({
      message: msg,
      duration: 2000,
      bottom: '160vp'
    });
  }

  // 查询自定义场景详情
  getCustomDetail(id: string) {
    this.mySceneList = SceneModel.getInstance().getPreference() as Array<Scene>;
    let result: Scene = this.mySceneList.filter((item: Scene) => {
      return item.scenarioCard.scenarioCardId == id;
    })[0];
    return result;
  }

  async aboutToAppear() {
    let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    //初始化操作
    SceneManager.init(context);
    this.devicesModel.getDevice();
    Logger.info('DeviceControlPage isEdit:' + this.isEdit);
    if (this.isEdit) {
      this.sceneDetail = this.getCustomDetail(this.sceneId);
      this.sceneName = this.sceneDetail.scenarioCard.title;
      this.sceneDetail.flow[0].trigger.events.forEach((item: Event) => {
        this.devicesModel.triggers.push(new DeviceItem(item.deviceInfo.devId,
          this.devicesModel.getDeviceIcon(item.deviceInfo.devType), item.deviceInfo.devName, item.deviceInfo.devType));
        this.triggers.push(new DeviceItem(item.deviceInfo.devId,
          this.devicesModel.getDeviceIcon(item.deviceInfo.devType), item.deviceInfo.devName, item.deviceInfo.devType));
      });
      let data: SubsystemAction[] = JSON.parse(JSON.stringify(this.sceneDetail.flow[0].actions[0].actions));
      data.forEach((item: SubsystemAction) => {
        this.devicesModel.actions.push(new DeviceItem(item.deviceInfo.devId,
          this.devicesModel.getDeviceIcon(item.deviceInfo.devType), item.deviceInfo.devName, item.deviceInfo.devType));
        this.actions.push(new DeviceItem(item.deviceInfo.devId,
          this.devicesModel.getDeviceIcon(item.deviceInfo.devType), item.deviceInfo.devName, item.deviceInfo.devType));
      });
    } else {
      let sceneInfo: Scene | null = await SceneLibraryManager.getInstance().getSceneInfo(this.sceneId);
      if (sceneInfo != null) {
        this.sceneDetail = sceneInfo;
        this.sceneName = this.sceneDetail.scenarioCard.title;
        this.sceneDetail.flow[0].trigger.events.forEach((item: Event, index: number) => {
          this.triggers.push(new DeviceItem(item.deviceInfo.devId, '', item.deviceInfo.devName,
            item.deviceInfo.devType));
        });
        let data: SubsystemAction[] = JSON.parse(JSON.stringify(this.sceneDetail.flow[0].actions[0].actions));
        data.forEach((item: SubsystemAction) => {
          this.actions.push(new DeviceItem(item.deviceInfo.devId, '', item.deviceInfo.devName, item.deviceInfo.devType));
        });
      }
      this.getDefaultName();
    }
  }

  aboutToDisappear(): void {
    this.triggers = [];
    this.actions = [];
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Column() {
        HeadTitleComponent({
          title: $sceneName,
          isLeftIcon: $isLeftIcon,
          clickCallback: () => {
            this.clickCallback();
          }
        });
      }
      .focusable(true)
      .defaultFocus(true);

      DevicesDragView();
      Button($r('app.string.execution_scenario'), { type: ButtonType.Capsule, stateEffect: true })
        .width('50%')
        .opacity(this.isEditComplete() ? 1 : 0.4)
        .height($r('app.string.btn_height'))
        .margin({ bottom: $r('app.string.btn_margin_bottom') })
        .onClick(() => {
          if (!this.isEditComplete()) {
            return;
          }
          if (this.templateName) {
            this.renameController.open();
          } else {
            if (this.sceneDetail != null) {
              this.saveScene(this.sceneDetail.scenarioCard.title);
            }
          }
        });
    }
    .linearGradient({
      angle: 180,
      colors: [['rgba(10,89,247,0.1)', 0.1], ['rgba(255,255,255,0)', 0.21], ['rgba(255,255,255,0)', 0.77],
        ['rgba(10,89,247,0.1)', 1.0]]
    })
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .height(CommonConstants.FULL_HEIGHT_PERCENT);
  }
}