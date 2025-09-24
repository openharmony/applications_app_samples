/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import { memo, __memo_context_type, __memo_id_type } from '@ohos.arkui.stateManagement';
import { Entry, Text, TextAttribute, Column, Component, Button, ButtonAttribute, ClickEvent, Row, TextAlign,
  SafeAreaEdge,Visibility, List, ListItem, ForEach, TextOverflow, Image, HorizontalAlign, Progress, ProgressType, Flex,
  FlexAlign, FlexDirection, SafeAreaType,Stack, Radio, Slider, SliderStyle, SaveButton ,SaveDescription, ButtonType,
  Scroll ,Scroller, BarState, $r, Builder, Blank, Color, ImageFit, TextInput, InputType, Placement, ItemAlign, Divider,
  JSON, DialogAlignment, SearchController, Margin, NavPathStack, Navigation, Alignment
} from '@ohos.arkui.component';
import { State, Link, MutableState, stateOf, observableProxy,  Watch } from '@ohos.arkui.stateManagement';
import hilog from '@ohos.hilog';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import { UIContext } from '@ohos.arkui.UIContext';
import router from '@ohos.router';
import { Contact, RouterParams } from '../model/Contact';
import { CommonConstants } from '../constant/CommonConstant';

@Component
export struct AddressBookList {
  private scroller: Scroller = new Scroller();
  // 数据源
  @Link dataArray: Contact[];
  @State selectIndex: number = 0;

  build() {
    Stack({ alignContent: Alignment.End }) {
      List({
        initialIndex: CommonConstants.INITIAL_INDEX,
        scroller: this.scroller
      }) {
        Column(){
          ForEach(this.dataArray, (contact: Contact) => {
            ListItem() {
              ItemComponent({ name: contact.name })
            }.margin({left: 15, right: 15} as Margin)
            .onClick((): void => {
              let options: router.RouterOptions = {
                url: 'pages/view/AddressBookDetail',
                params: new RouterParams('编辑联系人', contact)
              } as router.RouterOptions;
              this.getUIContext().getRouter().pushUrl(options);
            })
            Divider().strokeWidth('100%').height(1).color('#d9d9d9').margin({left: 15, right: 15} as Margin)
          }, (item: Contact) => item.name)
        }.width('100%')
      }
      .id('address_book_list')
      .width(CommonConstants.FULL_PERCENT)
      .scrollBar(BarState.Off)
      .layoutWeight(CommonConstants.LAYOUT_WEIGHT)
      .margin({ bottom: 100 } as Margin)

      Image($r('app.media.operate_rdb_in_taskpool_add'))
        .width(50)
        .height(50)
        .id('taskpool_add_button')
        .zIndex(CommonConstants.Z_INDEX)
        .margin({
          top: 400,
          right: CommonConstants.ADD_IMAGE_RIGHT
        } as Margin)
        .onClick(():void => {
          let options: router.RouterOptions = {
            url: 'pages/view/AddressBookEdit',
            params: new RouterParams('新增联系人', new Contact())
          }as router.RouterOptions;
          this.getUIContext().getRouter().pushUrl(options);
        });
    }
    .backgroundColor(Color.White)
  }
}

@Component
struct ItemComponent {
  @State name: string = '';

  build() {
    Text(this.name)
      .width(CommonConstants.FULL_PERCENT)
      .height(50)
      .fontSize(16)
  }
}
