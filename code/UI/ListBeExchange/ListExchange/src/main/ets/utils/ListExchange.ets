/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { ListExchangeCtrl } from '../model/ListExchangeCtrl';
import { ListInfo } from '../model/ListInfo';
import { logger } from './Logger';
import { CommonConstants } from '../common/commonConstants';

/**
 * 功能描述：
 * 1. 长按列表项，向上或向下拖动，当前列表项和目标列表项位置互换。
 * 2. 列表项向左滑动，显示删除按钮。
 * 3. 点击删除按钮，当前列表项删除。
 *
 * 实现原理：
 * 1. 创建一个数组modifier来添加自定义属性对象，根据组合手势GestureGroup来控制自定义属性的值并通过attributeModifier绑定自定义属性对象来动态加载属性。
 * 2. 然后swipeAction属性绑定删除组件，左滑显示此删除组件，点击实现列表项的删除。
 *
 * @param appInfoList - 列表数据
 * @param appInfoList - 列表元素交换类
 * @param deductionView - 列表项UI模块
 */
@Component
export struct ListExchange {
  // -------------------对外暴露变量-----------------------
  @Link appInfoList: Object[];
  // 控制列表项交换的类
  @Link listExchangeCtrl: ListExchangeCtrl<Object>;
  // 列表项Builder
  @BuilderParam deductionView: (listInfo: Object) => void;
  // --------------------私有属性----------------------------
  // 当前选定的列表项
  @State currentListItem: Object | undefined = undefined;
  // 初始化长按状态
  @State isLongPress: boolean = false;

  build() {
    Column() {
      List() {
        ForEach(this.appInfoList, (item: Object, index: number) => {
          ListItem() {
            this.deductionView(item)
          }
          .id('list_exchange_' + index)
          .zIndex(this.currentListItem === item ? 2 : 1) // 层级属性
          .swipeAction({ end: this.defaultDeleteBuilder(item) }) // 用于设置ListItem的划出组件
          .transition(TransitionEffect.OPACITY)
          .attributeModifier(this.listExchangeCtrl.getModifier(item)) //动态设置组件的属性方法， 参数为属性修改器
          .gesture(
            // 以下组合手势为顺序识别，当长按手势事件未正常触发时，则不会出发拖动手势事件
            GestureGroup(GestureMode.Sequence,
              // 长按
              LongPressGesture()
                .onAction((event: GestureEvent) => {
                  this.currentListItem = item;
                  this.isLongPress = true;
                  this.listExchangeCtrl.onLongPress(item);
                }),
              // 拖动
              PanGesture()
                .onActionUpdate((event: GestureEvent) => {
                  this.listExchangeCtrl.onMove(item, event.offsetY);
                })
                .onActionEnd((event: GestureEvent) => {
                  this.listExchangeCtrl.onDrop(item);
                  this.isLongPress = false;
                })
            ).onCancel(() => {
              if (!this.isLongPress) {
                return;
              }
              this.listExchangeCtrl.onDrop(item);
            }))
        }, (item: Object) => JSON.stringify(item))
      }
      .divider({ strokeWidth: '1px', color: 0xeaf0ef })
      .scrollBar(BarState.Off)
      .border({
        radius: {
          bottomLeft: $r('app.string.ohos_id_corner_radius_default_l'),
          bottomRight: $r('app.string.ohos_id_corner_radius_default_l')
        }
      })
      .backgroundColor(Color.White)
      .width('100%')

    }
  }

  /**
   * 删除按钮
   * @param item: 删除的列表项
   */
  @Builder
  defaultDeleteBuilder(item: Object) {
    Image($r('app.media.list_exchange_icon_delete'))
      .width($r('app.integer.list_exchange_icon_size'))
      .height($r('app.integer.list_exchange_icon_size'))
      .objectFit(ImageFit.Cover)
      .margin({ right: $r('app.integer.list_exchange_delete_icon_margin_right') })
      .interpolation(ImageInterpolation.High)// 抗锯齿
      .id('delete_button')
      .onClick(() => {
        this.listExchangeCtrl.deleteItem(item);
      })
  }

  /**
   * ListItem自定义组件(默认)
   */
  @Builder
  defaultDeductionView(listItemInfo: ListInfo) {
    Row() {
      Image(listItemInfo.icon)
        .width($r('app.integer.list_exchange_icon_size'))
        .height($r('app.integer.list_exchange_icon_size'))
        .draggable(false) // TODO：知识点：保持默认值true时，图片有默认拖拽效果，会影响Grid子组件拖拽判断，所以修改为false
      Text(listItemInfo.name)
        .margin({ left: $r('app.string.ohos_id_elements_margin_vertical_l') })
      Blank()
      Image($r('app.media.list_exchange_ic_public_drawer'))
        .width($r('app.integer.list_exchange_icon_size'))
        .height($r('app.integer.list_exchange_icon_size'))
        .objectFit(ImageFit.Cover)
        .draggable(false) // TODO：知识点：保持默认值true时，图片有默认拖拽效果，会影响Grid子组件拖拽判断，所以修改为false
    }
    .width('100%')
    .height(CommonConstants.LIST_ITEM_HEIGHT)
    .backgroundColor(Color.White)
    .padding({
      left: $r('app.string.ohos_id_card_padding_start'),
      right: $r('app.string.ohos_id_card_padding_start')
    })
  }

  aboutToAppear(): void {
    this.checkParam();
  }

  /**
   * 检查输入参数合法性
   */
  checkParam() {
    logger.info('checkParam start');
    if (!this.appInfoList.length) {
      this.appInfoList.push(new ListInfo($r('app.media.list_exchange_ic_public_cards_filled'), CommonConstants.LIST_NAME))
    }
    if (!this.deductionView) {
      this.deductionView = this.deductionView;
    }
    if (!this.listExchangeCtrl) {
      this.listExchangeCtrl = new ListExchangeCtrl();
      this.listExchangeCtrl.initData(this.appInfoList);
    }
  }
}
