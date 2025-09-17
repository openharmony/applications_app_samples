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
import { Entry, Text, TextAttribute, Column, Component, Button, ClickEvent, Row, TextAlign, SafeAreaEdge,
  List, ListItem, ForEach, TextOverflow, Image, HorizontalAlign, Progress, Flex ,FlexAlign, SafeAreaType,
  Stack, Radio, Slider, $r, Builder, Blank, Color, ImageFit,
  TextInput, InputType, Placement, ItemAlign, Divider, Margin, Padding, FontWeight
} from '@ohos.arkui.component';
import { State, MutableState, stateOf, observableProxy, Prop, Watch } from '@ohos.arkui.stateManagement';
import hilog from '@ohos.hilog';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import { UIContext } from '@ohos.arkui.UIContext';
import { CommonConstants } from '../constant/CommonConstant';
import { Contact, RouterParams } from '../model/Contact';
import router from '@ohos.router';

@Entry
@Component
struct AddressBookDetail {
  @State isChange: boolean = false;
  @State sourceData: Contact = new Contact('艾德里安', '13333333333', 'aidelian@example.com', '江苏省南京市鼓楼区',
    'operate_rdb_in_taskpool_photo1.jpg', 'A');

  aboutToAppear(): void {
    setTimeout(()=>{
      if(this.getUIContext().getRouter().getParams()) {
        const data = (this.getUIContext().getRouter().getParams() as RouterParams).data;
        if (!data) {
          return;
        }
        this.sourceData = data;
      }
    },1);
  }

  @Builder
  navDestinationTitle(name: string | undefined) {
    Row() {
      Column() {
        Image($r('app.media.operate_rdb_in_taskpool_arrow_left'))
          .width(28)
          .height(28)
      }
      .justifyContent(FlexAlign.Center)
      .width(40)
      .height(40)
      .borderRadius(CommonConstants.BORDER_RADIUS_PROMINENT)
      .backgroundColor('#E5E7E9')
      .onClick(():void => {
        this.getUIContext().getRouter().back();
      })

      Text(name)
        .fontWeight(FontWeight.Bold)
        .fontSize(20)
        .width(100)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ left: 20 } as Margin)
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(56)
    .backgroundColor(Color.White)
    .margin({ bottom: 16 } as Margin)
  }

  @Builder
  phoneBuilder() {
    Row() {
      Column() {
        Text(this.sourceData.phone)
          .fontSize(19)
          .fontWeight(FontWeight.Bold)
          .fontColor('#222222')
          .width(CommonConstants.HALF_PERCENT)
          .height(25)

        Text($r('app.string.operate_rdb_in_taskpool_detail_phone'))
          .fontSize(15)
          .fontColor('#A9A9A9')
          .width(CommonConstants.HALF_PERCENT)
          .height(25)
      }

      Row(){
        Image($r('app.media.operate_rdb_in_taskpool_phone'))
          .width(25)
          .height(25)

      }.width(45)
      .height(45)
      .backgroundColor('#009e76')
      .borderRadius(CommonConstants.BORDER_RADIUS_SOFT)
      .justifyContent(FlexAlign.Center)

      Row(){
        Image($r('app.media.operate_rdb_in_taskpool_message'))
          .width(25)
          .height(25)
      }.width(45)
      .height(45)
      .backgroundColor('#1b7af8')
      .borderRadius(CommonConstants.BORDER_RADIUS_SOFT)
      .justifyContent(FlexAlign.Center)
    }
    .height(40)
    .width(CommonConstants.FULL_PERCENT)
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ top:40 } as Margin)
  }

  @Builder
  videoBuilder() {
    Row() {
      Text($r('app.string.operate_rdb_in_taskpool_detail_video'))
        .fontSize(19)
        .fontWeight(FontWeight.Bold)
        .fontColor('#222222')
        .width(CommonConstants.HALF_PERCENT)
        .height(50)

      Row(){
        Image($r('app.media.operate_rdb_in_taskpool_video'))
          .width(25)
          .height(25)

      }.width(45)
      .height(45)
      .backgroundColor('#ff5d5b')
      .borderRadius(CommonConstants.BORDER_RADIUS_SOFT)
      .justifyContent(FlexAlign.Center)
    }
    .height(60)
    .width(CommonConstants.FULL_PERCENT)
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ top: 30 } as Margin)
  }

  @Builder
  emailBuilder() {
    Column() {
      Text(this.sourceData.email)
        .fontSize(19)
        .fontWeight(FontWeight.Bold)
        .fontColor('#222222')
        .width(CommonConstants.FULL_PERCENT)
        .height(25)
      Text($r('app.string.operate_rdb_in_taskpool_detail_email'))
        .fontSize( 15)
        .fontColor('#A9A9A9')
        .width(CommonConstants.FULL_PERCENT)
        .height(25)
    }
    .height(60)
    .width(CommonConstants.FULL_PERCENT)
    .margin({ top: 30 } as Margin)
  }

  @Builder
  addressBuilder() {
    Column() {
      Text(this.sourceData.address)
        .fontSize(19)
        .fontWeight(FontWeight.Bold)
        .fontColor('#222222')
        .width(CommonConstants.FULL_PERCENT)
        .height(25)

      Text($r('app.string.operate_rdb_in_taskpool_detail_address'))
        .fontSize(15)
        .fontColor('#A9A9A9')
        .width(CommonConstants.FULL_PERCENT)
        .height(25)
    }
    .height(60)
    .width(CommonConstants.FULL_PERCENT)
    .margin({ top: 30 } as Margin)
  }

  build() {
    Column() {
      // 导航栏
      this.navDestinationTitle(this.sourceData.name);
      // 头像
      Image($r('app.media.operate_rdb_in_taskpool_portrait'))
        .width(100)
        .height(100)
        .backgroundColor('#d9d9d9')
        .border({
          width: CommonConstants.BORDER_WIDTH_BOLD,
          color: Color.White,
          radius: CommonConstants.BORDER_RADIUS_FULLY
        })

      // 姓名
      Text(this.sourceData.name)
        .fontSize(40)
        .fontColor('#222222')
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Center)
        .width(CommonConstants.FULL_PERCENT)
        .height(50)
        .margin({ top: 10 } as Margin)

      this.phoneBuilder();
      this.videoBuilder();
      this.emailBuilder();
      this.addressBuilder();

      Blank();

      Row(){
        Button($r('app.string.operate_rdb_in_taskpool_dialog_edit_button_text'))
          .fontSize(17)
          .width('40%')
          .fontColor(Color.White)
          .height(45)
          .backgroundColor('#1b7af8')
          .onClick(():void=>{
            let params:RouterParams = new RouterParams('编辑联系人', this.sourceData);
            let options: router.RouterOptions = {
              url: 'pages/view/AddressBookEdit',
              params: params as RouterParams
            } as router.RouterOptions;
            this.getUIContext().getRouter().pushUrl(options);
          })

        Button($r('app.string.operate_rdb_in_taskpool_dialog_delete_button_text'))
          .fontSize(17)
          .width('40%')
          .fontColor(Color.White)
          .height(45)
          .backgroundColor('#ff5d5b')
          .onClick(():void=>{
            let params:RouterParams = new RouterParams('删除联系人', this.sourceData);
            let options: router.RouterOptions = {
              url: 'pages/view/OperateRDBInTaskPool',
              params: params as RouterParams
            } as router.RouterOptions;
            this.getUIContext().getRouter().pushUrl(options);
          })

      }.width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({top: 24, bottom: 24} as Margin)
    }
    .padding({
      left: 24,
      right: 24
    } as Padding)
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .backgroundColor(Color.White)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
