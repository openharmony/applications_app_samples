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

import { OperateRDBInTaskPool } from 'operaterdbintaskpool';

@Entry
@Component
struct Index {
  build() {
    Column() {
      /**
       * 功能描述：本示例通过通讯录场景实例进行讲解，介绍了在 TaskPool 线程中操作关系型数据库的方法，涵盖了单条插入（新增联系人）、批量插入（通讯录同步）、删除（删除联系人）、修改（更新联系人信息）和查询等基本操作。
       * 参数介绍：无
       */
      OperateRDBInTaskPool()

    }
    .height('100%')
    .width('100%')
  }
}