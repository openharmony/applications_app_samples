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

import {
  Entry,
  Text,
  TextAttribute,
  Column,
  Component,
  Button,
  ButtonAttribute,
  ClickEvent,
  List, Image, $r, AlphabetIndexer, Margin, ForEach, Color, TextAlign, ImageFit, JSON
} from '@ohos.arkui.component';
import { State, MutableState, stateOf, observableProxy } from '@ohos.arkui.stateManagement';
import relationalStore from '@ohos.data.relationalStore';
import type common from '@ohos.app.ability.common';
import { Contact } from '../model/Contact';
import { ValuesBucket } from '@ohos.data.ValuesBucket';
import { STORE_CONFIG, SQL_CREATE_TABLE, TABLE_NAME } from '../constant/RdbConstant';
import { BusinessError } from '@ohos.base';
import DatabaseConnection from './DatabaseConnection';
import hilog from '@ohos.hilog';

async function queryItem(context: common.Context): Promise<Array<Contact>> {
  return await DatabaseConnection.getInstance().query(context);
}

async function insertItem(context: common.Context, contact: Contact) {
  return await DatabaseConnection.getInstance().insertData(context, contact);
}

async function deleteItem(context: common.Context, contact: Contact) {
  return await DatabaseConnection.getInstance().deleteData(context, contact);
}

async function updateItem(context: common.Context, contact: Contact) {
  return await DatabaseConnection.getInstance().updateData(context, contact);
}

async function batchInsert(context: common.Context, array: Array<Contact>): Promise<number> {
  return await DatabaseConnection.getInstance().batchInsertData(context, array);
}

export async function taskPoolExecuteQuery(context: common.Context): Promise<Array<Contact>> {
  try {
    let task = new taskpool.Task(queryItem, context);
    let result: Contact[]= await taskpool.execute(task) as Contact[];
    hilog.info(0x0000, 'testTag', 'query_result: ' + JSON.stringify(result));
    return result;
  } catch (err:Error) {
    hilog.error(0x0000, 'testTag', 'query error:' + JSON.stringify(err));
    return [] as Contact[];
  }
}

export async function taskPoolExecuteInsert(context: common.Context, contact: Contact): Promise<void> {
  try {
    let task = new taskpool.Task(insertItem, context, contact);
    await taskpool.execute(task);
  } catch (err:Error) {
    hilog.error(0x0000, 'testTag', 'insert error:' + JSON.stringify(err));
  }
}

export async function taskPoolExecuteDelete(context: common.Context, contact: Contact): Promise<void> {
  try {
    let task = new taskpool.Task(deleteItem, context, contact);
    await taskpool.execute(task);
  } catch (err:Error) {
    hilog.error(0x0000, 'testTag', 'delete error:' + JSON.stringify(err));
  }
}

export async function taskPoolExecuteUpdate(context: common.Context, contact: Contact): Promise<void> {
  try {
    let task = new taskpool.Task(updateItem, context, contact);
    await taskpool.execute(task);
  } catch (err:Error) {
    hilog.error(0x0000, 'testTag', 'update error:' + JSON.stringify(err));
  }
}

export async function taskPoolExecuteBatchInsert(context: common.Context, array: Array<Contact>): Promise<number> {
  try {
    let task = new taskpool.Task(batchInsert, context, array);
    let insertNum: number = await taskpool.execute(task) as number;
    return insertNum;
  } catch (err:Error) {
    hilog.error(0x0000, 'testTag', 'batch insert error:' + JSON.stringify(err));
    return 0 as number;
  }
}