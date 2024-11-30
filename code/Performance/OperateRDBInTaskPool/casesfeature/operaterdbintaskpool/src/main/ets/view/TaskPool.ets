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

import taskPool from '@ohos.taskpool';
import common from '@ohos.app.ability.common';
import DatabaseConnection from './DatabaseConnection';
import { Contact } from '../model/Contact';
import { logger } from '../utils/Logger';

const TAG = '[taskpool] Database';

// TODO: 知识点：在使用TaskPool时，执行的并发函数需要使用@Concurrent装饰器修饰，否则无法通过相关校验。
@Concurrent
async function queryItem(context: common.Context): Promise<Array<Contact>> {
  return await DatabaseConnection.getInstance().query(context);
}

@Concurrent
async function insertItem(context: common.Context, contact: Contact) {
  return await DatabaseConnection.getInstance().insertData(context, contact);
}

@Concurrent
async function deleteItem(context: common.Context, contact: Contact) {
  return await DatabaseConnection.getInstance().deleteData(context, contact);
}

@Concurrent
async function updateItem(context: common.Context, contact: Contact) {
  return await DatabaseConnection.getInstance().updateData(context, contact);
}

@Concurrent
async function batchInsert(context: common.Context, array: Array<Contact>): Promise<number> {
  return await DatabaseConnection.getInstance().batchInsertData(context, array);
}

export async function taskPoolExecuteQuery(context: common.Context): Promise<Array<Contact>> {
  try {
    let task: taskPool.Task = new taskPool.Task(queryItem, context); // query函数调用 需使用装饰器@Concurrent
    let result: Contact[] = await taskPool.execute(task) as Contact[];
    logger.info(TAG, 'query_result: ' + JSON.stringify(result));
    return result;
  } catch (err) {
    logger.error(TAG, 'query error:' + JSON.stringify(err));
    return [];
  }
}

export async function taskPoolExecuteInsert(context: common.Context, contact: Contact): Promise<void> {
  try {
    let task: taskPool.Task = new taskPool.Task(insertItem, context, contact); // insert函数调用 需使用装饰器@Concurrent
    await taskPool.execute(task);
  } catch (err) {
    logger.error(TAG, 'insert error:' + JSON.stringify(err));
  }
}

export async function taskPoolExecuteDelete(context: common.Context, contact: Contact): Promise<void> {
  try {
    let task: taskPool.Task = new taskPool.Task(deleteItem, context, contact); // delete函数调用 需使用装饰器@Concurrent
    await taskPool.execute(task);
  } catch (err) {
    logger.error(TAG, 'delete error:' + JSON.stringify(err));
  }
}

export async function taskPoolExecuteUpdate(context: common.Context, contact: Contact): Promise<void> {
  try {
    let task: taskPool.Task = new taskPool.Task(updateItem, context, contact); // update函数调用 需使用装饰器@Concurrent
    await taskPool.execute(task);
  } catch (err) {
    logger.error(TAG, 'update error:' + JSON.stringify(err));
  }
}

export async function taskPoolExecuteBatchInsert(context: common.Context, array: Array<Contact>): Promise<number> {
  try {
    let task: taskPool.Task = new taskPool.Task(batchInsert, context, array); // batchInsert函数调用 需使用装饰器@Concurrent
    let insertNum: number = await taskPool.execute(task) as number;
    return insertNum;
  } catch (err) {
    logger.error(TAG, 'batch insert error:' + JSON.stringify(err));
    return 0;
  }
}