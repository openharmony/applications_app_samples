/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import hiTraceMeter from '@ohos.hiTraceMeter';
import util from '@ohos.util';
import Logger from './Logger';
import { ChatModel, ChatContact, FriendMoment } from '../viewmodel/MsgBase';
import { ChatListData } from '../viewmodel/ChatListDataSource';
import Constants from './Constants';

const TAG: string = 'ChatList_DataFactory';
const MOCK_DATA_FILE_DIR: string = 'mockChatOneModelData.json';
const MAKE_DATA_LOCAL_TRACE: string = 'ChatList_MakeDataLocal_HiTrace';
const MAKE_DATA_LOCAL_TRACE_ID: number = 1; // makeDataLocal 中使用的 taskId
const MAKE_DATA_LIST_TRACE: string = 'ChatList_MakeDataList_HiTrace';
const MAKE_DATA_LIST_TRACE_ID: number = 2; // makeDataList 中使用的 taskId

class JsonObjType {
  MessageList: Array<string> = new Array<string>();
  ChatModel: Array<ChatModel> = new Array<ChatModel>();
  FriendMoment: Array<FriendMoment> = new Array<FriendMoment>();
}

/**
 * 加载聊天列表数据，到参数传入的懒加载数据列表中
 * @param listData 懒加载数据列表
 */
export async function makeDataLocal(listData: ChatListData, MockDataFileDir: string): Promise<void> {
  Logger.info(TAG, 'makeDataLocal');
  hiTraceMeter.startTrace(MAKE_DATA_LOCAL_TRACE, MAKE_DATA_LOCAL_TRACE_ID);
  let chatModelMockData = await getChatModelObjFromJSON(MockDataFileDir);
  for (let i = 0; i < Constants.DATA_MOCK_COUNT; i++) {
    listData.pushData(chatModelMockData[i]);
  }
  Logger.info(TAG, 'makeDataLocal'+JSON.stringify(listData.totalCount()));
  hiTraceMeter.finishTrace(MAKE_DATA_LOCAL_TRACE, MAKE_DATA_LOCAL_TRACE_ID);
}

/**
 * 加载聊天列表数据，到参数传入的数据列表中
 * @param listData 普通数据列表
 */
export async function makeDataList(listData: Array<ChatModel>, MockDataFileDir: string): Promise<void> {
  Logger.info(TAG, 'makeDataList');
  hiTraceMeter.startTrace(MAKE_DATA_LIST_TRACE, MAKE_DATA_LIST_TRACE_ID);
  let chatModelMockData = await getChatModelObjFromJSON(MockDataFileDir);
  for (let i = 0; i < Constants.DATA_MOCK_COUNT; i++) {
    listData.push(chatModelMockData[i]);
  }
  hiTraceMeter.finishTrace(MAKE_DATA_LIST_TRACE, MAKE_DATA_LIST_TRACE_ID);
}

/**
 * 获取ChatModel的模拟数据列表
 */
export async function getChatModelObjFromJSON(MockDataFileDir: string): Promise<Array<ChatModel>> {
  Logger.info(TAG, 'getChatModelObjFromJSON');
  let jsonObj: JsonObject = new JsonObject(MockDataFileDir);
  return await jsonObj.getChatModelObj(MockDataFileDir);
}

/**
 * 获取FriendMoment的模拟数据列表
 */
export async function getFriendMomentObjFromJSON(): Promise<Array<FriendMoment>> {
  Logger.info(TAG, 'getFriendMomentObjFromJSON');
  let jsonObj: JsonObject = new JsonObject(MOCK_DATA_FILE_DIR);
  return await jsonObj.getFriendMomentObj();
}

/**
 * 获取聊天内容模拟数据
 */
export async function getMessageListFromJSON(): Promise<string[]> {
  Logger.info(TAG, 'getMessageListFromJSON');
  let jsonObj: JsonObject = new JsonObject(MOCK_DATA_FILE_DIR);
  return await jsonObj.getMessageList();
}

class JsonObject {
  private jsonFileDir: string = '';

  constructor(jsonFileDir: string) {
    this.jsonFileDir = jsonFileDir;
  }

  async getFriendMomentObj(): Promise<Array<FriendMoment>> {
    let value = await getContext().resourceManager.getRawFileContent(this.jsonFileDir);
    let jsonObj: JsonObjType = JSON.parse(this.bufferToString(value.buffer)) as JsonObjType;
    let friendMomentBuckets: Array<FriendMoment> = new Array<FriendMoment>();
    if (jsonObj.FriendMoment === undefined) {
      Logger.error(TAG + '_JsonObject_getFriendMomentObj', 'Expected FriendMoment field in json, but not found');
      return friendMomentBuckets;
    }
    // 映射json数据为FriendMoment对象
    let friendMomentObj = jsonObj.FriendMoment;
    for (let i = 0; i < friendMomentObj.length; i++) {
      let contactTemp = new ChatContact(friendMomentObj[i].user.userId, friendMomentObj[i].user.userName,
        friendMomentObj[i].user.userImage);
      let chatModelTemp = new FriendMoment(friendMomentObj[i].id, contactTemp, friendMomentObj[i].text, '',
        friendMomentObj[i].imageList);
      friendMomentBuckets.push(chatModelTemp);
    }
    return friendMomentBuckets;
  }

  async getChatModelObj(MockDataFileDir: string): Promise<Array<ChatModel>> {
    let value = await getContext().resourceManager.getRawFileContent(MockDataFileDir);
    let jsonObj: JsonObjType = JSON.parse(this.bufferToString(value.buffer)) as JsonObjType;
    let chatModelBuckets: Array<ChatModel> = new Array<ChatModel>();
    if (jsonObj.ChatModel === undefined) {
      Logger.error(TAG + '_getChatModelObjFromJSON', 'Expected ChatModel field in json, but not found');
      return chatModelBuckets;
    }
    // 映射json数据为ChatModel对象
    let chatModelObj = jsonObj.ChatModel;
    for (let i = 0; i < chatModelObj.length; i++) {
      let contactTemp = new ChatContact(chatModelObj[i].user.userId, chatModelObj[i].user.userName,
        chatModelObj[i].user.userImage);
      let chatModelTemp = new ChatModel(contactTemp, chatModelObj[i].lastMsg, chatModelObj[i].lastTime,
        chatModelObj[i].unreadMsgCount);
      chatModelBuckets.push(chatModelTemp);
    }
    return chatModelBuckets;
  }

  async getMessageList(): Promise<Array<string>> {
    let value = await getContext().resourceManager.getRawFileContent(this.jsonFileDir);
    let jsonObj: JsonObjType = JSON.parse(this.bufferToString(value.buffer)) as JsonObjType;
    let messageBuckets: Array<string> = new Array<string>();
    if (jsonObj.MessageList === undefined) {
      Logger.error(TAG + '_getMessageListFromJSON', 'Expected MessageList field in json, but not found');
      return messageBuckets;
    }
    return jsonObj.MessageList;
  }

  private bufferToString(buffer: ArrayBuffer): string {
    Logger.info(TAG, 'bufferToString');
    let textDecoder = util.TextDecoder.create('utf-8', {
      ignoreBOM: true
    });
    let resultPut = textDecoder.decodeWithStream(new Uint8Array(buffer), {
      stream: true
    });
    return resultPut;
  }
}