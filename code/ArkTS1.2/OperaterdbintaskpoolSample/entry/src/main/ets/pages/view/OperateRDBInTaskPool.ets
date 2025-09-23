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
import { Entry, Text, TextAttribute, Column, Component, Button, ButtonAttribute, ClickEvent, Row,
  SafeAreaEdge, Image, SafeAreaType,Stack, $r, Builder, Color, Search, SearchController, Margin
} from '@ohos.arkui.component';
import { State, MutableState, stateOf, observableProxy,  Watch } from '@ohos.arkui.stateManagement';
import hilog from '@ohos.hilog';
import common from '@ohos.app.ability.common';
import resourceManager from '@ohos.resourceManager';
import { BusinessError } from '@ohos.base';
import { UIContext } from '@ohos.arkui.UIContext';
import { Contact, RouterParams } from '../model/Contact';
import { ContactManager } from '../model/ContactManager';
import { CommonConstants } from '../constant/CommonConstant';
import { AddressBookList } from './AddressBookList';
import { taskPoolExecuteQuery, taskPoolExecuteInsert, taskPoolExecuteDelete,
  taskPoolExecuteUpdate, taskPoolExecuteBatchInsert } from './TaskPool';

@Entry
@Component
struct OperateRDBInTaskPool {
  private static isInitialized: boolean = false;
  // 搜索值
  @State changeValue: string = '';
  // 搜索控制器
  private controller: SearchController = new SearchController();
  // 数据库初始化数据
  @State dataArray: Array<Contact> = [
    new Contact('艾德里安', '13333333333', 'aidelian@example.com', '江苏省南京市鼓楼区', '', 'A'),
    new Contact('阿诺德', '16666666666', 'arnold@example.com', '上海市浦东新区', '', 'A'),
    new Contact('贝拉', '11111111111', 'bella@example.com', '湖北省武汉市江汉区', '', 'B'),
    new Contact('本', '12222222222', 'ben@example.com', '四川省成都市锦江区', '', 'B'),
    new Contact('本杰明', '16666666666', 'benjieiming@example.com', '上海市浦东新区', '', 'B'),
    new Contact('卡梅隆', '17777777777', 'cameron@example.com', '陕西省西安市雁塔区', '', 'C'),
    new Contact('康纳', '10000000000', 'connor@example.com', '辽宁省沈阳市沈河区', '', 'C'),
    new Contact('卡特琳娜', '11111111111', 'katrina@example.com', '吉林省长春市朝阳区', '', 'C'),
    new Contact('丹尼尔', '17777777777', 'cameron@example.com', '陕西省西安市雁塔区', '', 'D'),
    new Contact('戴维维', '11111111111', 'katrina@example.com', '吉林省长春市朝阳区', '', 'D'),
    new Contact('艾登', '17777777777', 'cameron@example.com', '陕西省西安市雁塔区', '', 'E'),
    new Contact('艾拉', '10000000000', 'connor@example.com', '辽宁省沈阳市沈河区', '', 'E'),
    new Contact('艾里', '11111111111', 'katrina@example.com', '吉林省长春市朝阳区', '', 'E'),
    new Contact('法比而', '10000000000', 'connor@example.com', '辽宁省沈阳市沈河区', '', 'F'),
    new Contact('法里', '11111111111', 'katrina@example.com', '吉林省长春市朝阳区', '', 'F'),
  ];
  private contactManager: ContactManager = ContactManager.getInstance();
  // 路由传递数据
  @State routerData: Contact = new Contact();

  aboutToAppear(): void {
    if(!OperateRDBInTaskPool.isInitialized){
      this.syncAddressBookListData()
      this.contactManager.setContacts(this.dataArray as Array<Contact>)
      OperateRDBInTaskPool.isInitialized = true;
    }
    this.dataArray = this.contactManager.getContacts()
    setTimeout( ()=>{
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      const data = (this.getUIContext().getRouter().getParams() as RouterParams).data;
      const textData = (this.getUIContext().getRouter().getParams() as RouterParams).text;
      if (!data || !textData) {
        return;
      }
      this.routerData = data;
      // 数据插入操作
      if(textData === '新增联系人'){
        taskPoolExecuteInsert(context, this.routerData).then(() => {
          // 数据库插入成功
          this.contactManager.addContact(this.routerData)
          this.dataArray = this.contactManager.getContacts()
        }).catch((err: Error)=>{
          hilog.error(0x0000, 'testTag', 'taskPoolExecuteInsert, err: ' + err)
        })
      }

      // 数据更新操作
      if(textData === '编辑联系人'){
        taskPoolExecuteUpdate(context, this.routerData).then(() => {
          // 数据库更新成功
          this.contactManager.updateContact(this.routerData)
          this.dataArray = this.contactManager.getContacts()
        }).catch((err: Error)=>{
          hilog.error(0x0000, 'testTag', 'taskPoolExecuteUpdate, err: ' + err)
        })
      }

      // 数据删除操作
      if(textData === '删除联系人'){
        taskPoolExecuteDelete(context, this.routerData).then(() => {
          // 数据库删除成功
          this.contactManager.deleteContact(this.routerData)
          this.dataArray = this.contactManager.getContacts()
        }).catch((err: Error)=>{
          hilog.error(0x0000, 'testTag', 'taskPoolExecuteDelete, err: ' + err)
        })
      }
    },1)
  }

  syncAddressBookListData() {
    let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    taskPoolExecuteBatchInsert(context, this.dataArray)
      .then((insertNum: number) => {
        hilog.info(0x0000, 'testTag', 'taskPoolExecuteBatchInsert: ' + String(insertNum))
        // 数据查看操作
        taskPoolExecuteQuery(context).then((arr: Array<Contact>) => {
          // 数据库查看成功
          hilog.info(0x0000, 'testTag', 'taskPoolExecuteQuery, arr: ' + JSON.stringify(arr))
        }).catch((err: Error)=>{
          hilog.error(0x0000, 'testTag', 'taskPoolExecuteQuery, err: ' + err)
        })
      }).catch((err:Error)=>{
      hilog.error(0x0000, 'testTag', 'taskPoolExecuteBatchInsert, err: ' + err)
    })
  }

  build() {
    Stack() {
      Column() {
        Text('← 返回')
          .fontSize(20)
          .width('90%')
          .margin({left: 8.5, bottom: 10} as Margin)
          .onClick(():void=>{
            this.getUIContext().getRouter().back();
          })
        // 搜索框
        Search({
          value: this.changeValue,
          placeholder: '搜索',
          controller: this.controller
        })
          .searchButton(CommonConstants.SEARCH_TEXT,
            { fontColor: '#0091FF' })
          .height(40)
          .margin({
            left: 12,
            right: 12,
            bottom: 15
          } as Margin)
          .backgroundColor('#d9d9d9')
          .placeholderColor(Color.Grey)
          .placeholderFont({ size: CommonConstants.SEARCH_TEXT_SIZE, weight: CommonConstants.SEARCH_TEXT_WEIGHT })
          .textFont({ size: CommonConstants.SEARCH_TEXT_SIZE, weight: CommonConstants.SEARCH_TEXT_WEIGHT })

        // 通讯录列表
        AddressBookList({ dataArray: this.dataArray })
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
    }
  }
}