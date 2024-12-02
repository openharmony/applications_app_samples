/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import dataPreferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import { CategoryContact, Contact } from '../model/Contact';
import { promptAction } from '@kit.ArkUI';
import { ContactDataSource } from '../model/DataSource';
import { getJsonData } from '../model/DataJson';
import { taskPoolExecuteQuery, taskPoolExecuteBatchInsert } from './TaskPool';
import { AddressBookList } from './AddressBookList';
import { CommonConstants } from '../constant/CommonConstant';

const context: common.Context = getContext(this).getApplicationContext();

/**
 * 功能描述: 本示例通过通讯录场景实例进行讲解，介绍了在 TaskPool 线程中操作关系型数据库的方法，涵盖了单条插入（新增联系人）、批量插入（通讯录同步）、删除（删除联系人）、修改（更新联系人信息）和查询等基本操作
 *
 * 推荐场景: 需要持久化存储数据的场景，如：通讯录、记事本等
 *
 * 核心组件:
 * 1. OperateRDBInTaskPool.queryRDB
 * 2. ContactDataSource
 *
 * 实现步骤:
 * 1. 首先，构建一个关系型数据库并封装数据库操作方法
 * 2. 创建任务池（taskpool）为数据库操作提供一个多线程的运行环境，将创建好的任务(新增、删除、修改、查询操作)
 * 放入taskpool内部任务队列，在子线程中实现数据库增删改查的任务，以此防止阻塞主线程。执行完成后，将结果回调至
 * 主线程，从而在主线程中更新数据源和用户界面
 * 3. 在taskpool线程中操作关系型数据库方法的调用，将结果回调至主线程，在回调中来操作数据源
 */
@Component
export struct OperateRDBInTaskPool {
  @Provide pageInfos: NavPathStack = new NavPathStack();
  // 搜索值
  @State changeValue: string = '';
  // 通讯录同步进度，进度条初始值为0
  @State syncProgressValue: number = 0;
  // 通讯录同步进度，进入页面默认同步
  @State isHiddenProgress: Boolean = true;
  // 通讯录同步进度，进入页面默认同步
  @State isSyncAddressBookList: Boolean = true;
  @State syncButtonEnable: boolean = true;
  @State syncButtonString: ResourceStr = $r('app.string.operate_rdb_in_taskpool_sync_book');
  // 搜索控制器
  private controller: SearchController = new SearchController();
  // 数据库
  @State dataArray: Record<string, Contact[]> = {};
  // 数据源
  @State sourceArray: ContactDataSource = new ContactDataSource();
  // A-Z索引数据
  @StorageLink('categoryArray') categoryArray: Array<string> = [];
  // 数据同步进度
  @State currentValue: number = 0;
  // 数据同步总数
  private totalValue: number = 0;
  @StorageLink('avoidAreaTopToModule') avoidAreaTopToModule: number = 0;

  aboutToAppear(): void {
    // 判断数据库是否同步当前json通讯录数据
    dataPreferences.getPreferences(context, 'operateRDBInTaskPoolStore')
      .then((preferences: dataPreferences.Preferences) => {
        preferences.get('isSyncAddressBookList', false)
          .then((isSyncAddressBookList: dataPreferences.ValueType) => {
            if (isSyncAddressBookList) {
              this.queryRDB()
            } else {
              this.isSyncAddressBookList = false
            }
          })
      });
  }

  /*
   * 查询数据库数据组装数据源
   */
  queryRDB() {
    taskPoolExecuteQuery(context).then((contact: Array<Contact>) => {
      this.dataArray = contact.reduce((accumulator, item) => {
        // 如果类别不存在，则创建一个新的数组
        if (!accumulator[item.category]) {
          accumulator[item.category] = [];
        }
        // 将当前项添加到相应类别的数组中
        accumulator[item.category].push(item);
        return accumulator;
      }, {} as Record<string, Contact[]>);

      // 清空类别数组
      this.categoryArray = [];

      // 使用 Object.entries() 遍历键值对
      Object.entries(this.dataArray).forEach(data => {
        let categoryContact: CategoryContact = { category: data[0], itemsContact: data[1] }
        this.categoryArray.push(data[0]);
        this.sourceArray.pushData(categoryContact);
      });
    });
  }

  /*
   * 从json文件同步数据到数据库（数据库批量插入，模仿大量数据分批插入）
   */
  syncAddressBookListData() {
    this.totalValue = getJsonData('addressbook.json').length;
    for (let i = 0; i < this.totalValue; i += 10) {
      // 批量数据插入操作 （分批每10条为一个单位）
      taskPoolExecuteBatchInsert(context, getJsonData('addressbook.json').slice(i, i + 10))
        .then((insertNum: number) => {
          if (insertNum === 0 || undefined) {
            this.isHiddenProgress = true;
            promptAction.showToast({ message: $r('app.string.operate_rdb_in_taskpool_sync_book_fail') });
            return;
          }
          this.currentValue += insertNum;
          if (this.currentValue === this.totalValue) {
            this.syncButtonString = $r('app.string.operate_rdb_in_taskpool_sync_book_done');
            setTimeout(() => {
              this.isHiddenProgress = true;
              this.isSyncAddressBookList = true;
              this.syncButtonEnable = false;
              this.queryRDB();
              dataPreferences.getPreferences(context, 'operateRDBInTaskPoolStore')
                .then((preferences: dataPreferences.Preferences) => {
                  preferences.put('isSyncAddressBookList', true)
                    .then(() => {
                      preferences.flush()
                    })
                });
            }, 1000);
          }
        });
    }
  }

  build() {
    Navigation(this.pageInfos) {
      Stack() {
        Column() {
          // 搜索框
          Search({
            value: this.changeValue,
            placeholder: $r('app.string.operate_rdb_in_taskpool_search_text'),
            controller: this.controller
          })
            .searchButton(CommonConstants.SEARCH_TEXT,
              { fontColor: $r('app.color.operate_rdb_in_taskpool_search_button_color') })
            .height($r('app.integer.operate_rdb_in_taskpool_search_height'))
            .margin({
              left: $r('app.integer.operate_rdb_in_taskpool_search_margin_left'),
              right: $r('app.integer.operate_rdb_in_taskpool_search_margin_right')
            })
            .backgroundColor($r('app.color.operate_rdb_in_taskpool_search_background_color'))
            .placeholderColor(Color.Grey)
            .placeholderFont({ size: CommonConstants.SEARCH_TEXT_SIZE, weight: CommonConstants.SEARCH_TEXT_WEIGHT })
            .textFont({ size: CommonConstants.SEARCH_TEXT_SIZE, weight: CommonConstants.SEARCH_TEXT_WEIGHT })
            .visibility(this.isSyncAddressBookList ? Visibility.Visible : Visibility.Hidden)
            .onSubmit((value: string) => {
              // 如果没有输入数据，就使用占位符作为默认数据
              promptAction.showToast({ message: $r('app.string.operate_rdb_in_taskpool_prompt_text') });
              return;
            })
          // 通讯录列表
          AddressBookList({ sourceArray: this.sourceArray, pageInfos: this.pageInfos })
            .visibility(this.isSyncAddressBookList ? Visibility.Visible : Visibility.Hidden)
        }
        .width(CommonConstants.FULL_PERCENT)
        .height(CommonConstants.FULL_PERCENT)

        // 未同步数据的页面布局
        if (!this.isSyncAddressBookList) {
          Column({ space: CommonConstants.SYNC_COLUMN_SPACE }) {
            // 同步进度条
            Progress({
              value: CommonConstants.PROGRESS_ORIGIN_VALUE,
              total: this.totalValue,
              type: ProgressType.Linear
            })
              .height(CommonConstants.PROGRESS_HEIGHT)
              .value(this.currentValue)
              .color(Color.Green)
              .borderColor(Color.Green)
              .backgroundColor($r('app.color.operate_rdb_in_taskpool_progress_background_color'))
              .borderColor(Color.Green)
              .borderWidth(CommonConstants.BORDER_WIDTH_FINE)
              .borderRadius(CommonConstants.BORDER_RADIUS_SLIGHT)
              .margin({
                left: $r('app.integer.operate_rdb_in_taskpool_progress_margin_left'),
                right: $r('app.integer.operate_rdb_in_taskpool_progress_margin_right')
              })
              .visibility(this.isHiddenProgress ? Visibility.Hidden : Visibility.Visible)
            // 同步按钮
            Button(this.syncButtonString, { type: ButtonType.Capsule })
              .backgroundColor($r('app.color.operate_rdb_in_taskpool_sync_button_color'))
              .width($r('app.integer.operate_rdb_in_taskpool_sync_button_width'))
              .height($r('app.integer.operate_rdb_in_taskpool_sync_button_height'))
              .enabled(this.syncButtonEnable)
              .visibility(this.isSyncAddressBookList ? Visibility.Hidden : Visibility.Visible)
              .onClick(() => {
                this.syncButtonEnable = false;
                this.syncButtonString = $r('app.string.operate_rdb_in_taskpool_sync_book_loading');
                this.isHiddenProgress = false;
                this.syncAddressBookListData();
              })
          }
          .zIndex(CommonConstants.Z_INDEX)
          .width(CommonConstants.FULL_PERCENT)
          .height($r('app.integer.operate_rdb_in_taskpool_sync_height'))
        }
      }
    }
    .padding({ top: px2vp(this.avoidAreaTopToModule) })
    .hideTitleBar(true)
    .backgroundColor(Color.White)
  }
}