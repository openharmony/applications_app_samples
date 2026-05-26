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
import ActionItem from '../common/bean/ActionItem';
import DeviceItem from '../common/bean/DeviceItem';
import DevicesModel from '../viewmodel/DeviceModel';


// 单个选择项的渲染
@Component
struct ModeItem {
  @State type: number = 0;
  @State mode: ActionItem = new ActionItem('', '', '', false);
  @StorageLink('modeId') modeId: string = ''; // 共享父组件属性
  @StorageLink('actionId') actionId: string = '';

  @Builder
  renderModeItem(fontColor: string, bgColor: string, value: string) {
    Flex({ direction: FlexDirection.Column }) {
      Flex() {
        Text(value)
          .fontSize(16)
          .fontColor(fontColor);
      }
      .height('100%')
      .width('100%')
      .backgroundColor(bgColor)
      .borderRadius(12)
      .padding({
        left: 14,
        top: 14,
        bottom: 14
      });
    };
  }

  build() {
    Flex() {
      // 选中项和其他选项的样式有不同
      if (this.type == 1) {
        if (this.modeId == this.mode.id) {
          this.renderModeItem('#0A59F7', '#E6EEFF', this.mode.name);
        } else {
          this.renderModeItem('rgba(0,0,0,0.9)', '', this.mode.name);
        }
      } else {
        if (this.actionId == this.mode.id) {
          this.renderModeItem('#0A59F7', '#E6EEFF', this.mode.name);
        } else {
          this.renderModeItem('rgba(0,0,0,0.9)', '', this.mode.name);
        }
      }
    }.height(48);
  }
}

// 下拉菜单组件
@Component
export struct SelectorList {
  @StorageLink('modeId') modeId: string = ''; // 共享父组件属性
  @StorageLink('actionId') actionId: string = '';
  @StorageLink('showSelector') showSelector: boolean = false; // 共享父组件属性
  @StorageLink('showSelector1') showSelector1: boolean = false; // 共享父组件属性
  @StorageLink('deviceName') deviceName: string = '';
  @StorageLink('actionName') actionName: string = '';
  @StorageLink('deviceType') deviceType: string = '';
  @StorageLink('modesData') modesData: DevicesModel = new DevicesModel();
  @State type: number = 0;

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
      Text(this.type.toString() + 'type');
      Text(this.modeId.toString() + 'modeId');
      // 循环产生下拉菜单
      ForEach(this.type == 1 ? this.modesData.deviceList : this.modesData.getActions(this.modeId),
        (item: ActionItem) => {
          Flex() {
            ModeItem({ mode: item, type: this.type });
          }
          // 为每一项绑定点击事件
          .onClick(() => {
            if (this.type == 1) {
              if (this.modeId !== item.id) {
                this.modeId = item.id;
                this.deviceName = item.name;
                this.deviceType = item.type;
                this.actionName = '';
                this.actionId = '';
                console.info('this.modeId===' + this.modeId);
              }
            } else if (this.type == 2) {
              if (this.actionId !== item.id) {
                this.actionId = item.id;
                this.actionName = item.name;
                console.info('this.actionId===' + this.actionId);
              }
            }
            this.showSelector = false;
            this.showSelector1 = false;
          });

        }, (item: ActionItem) => JSON.stringify(item));
    }
    .constraintSize({ maxHeight: $r('app.string.origin_circle_size') })
    .width('100%')
    .backgroundColor('#fff')
    .borderRadius(16)
    .shadow({
      radius: 50,
      color: 'rgba(0,0,30,0.1500)'
    })
    .padding({
      left: $r('app.string.p_12'),
      right: $r('app.string.p_12'),
      top: $r('app.string.p_12'),
      bottom: $r('app.string.p_12')
    })
    .position({
      x: 0,
      y: 115
    })
    .zIndex(2);
  }
}