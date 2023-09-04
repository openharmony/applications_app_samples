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

import Logger from './Logger';
import { ChatModel, ChatContact, FriendMoment } from '../viewModel/MsgBase';
import { ChatListData } from '../viewModel/ChatListDataSource';
import Constants from '../utils/Constants';
import util from '@ohos.util';

const TAG: string = 'ChatList_DataFactory';
const CHAT_MODEL_JSON_KEY: string = 'ChatModel';
const FRIEND_MOMENT_JSON_KEY: string = 'FriendMoment';
const MSG_LIST_JSON_KEY: string = 'MessageList';

export async function makeDataLocal(listData: ChatListData): Promise<void> {
  Logger.info(TAG, 'makeDataLocal');
  let chatModelMockData = await getChatModelObjFromJSON();
  for (let i = 0; i < Constants.DATA_MOCK_COUNT; i++) {
    listData.pushData(chatModelMockData[i]);
  }
}

export async function makeDataList(listData: Array<ChatModel>): Promise<void> {
  Logger.info(TAG, 'makeDataList');
  let chatModelMockData = await getChatModelObjFromJSON();
  for (let i = 0; i < Constants.DATA_MOCK_COUNT; i++) {
    listData.push(chatModelMockData[i]);
  }
}

export async function getChatModelObjFromJSON(): Promise<Array<ChatModel>> {
  Logger.info(TAG, 'getChatModelObjFromJSON');
  let jsonObj = await getJsonObj();
  let chatModelBuckets: Array<ChatModel> = new Array<ChatModel>();
  if (!jsonObj.hasOwnProperty(CHAT_MODEL_JSON_KEY)) {
    Logger.error(TAG + '_getChatModelObjFromJSON', 'Expected ChatModel field in json, but not found');
    return chatModelBuckets;
  }
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


export async function getFriendMomentObjFromJSON(): Promise<Array<FriendMoment>> {
  Logger.info(TAG, 'getFriendMomentObjFromJSON');
  let jsonObj = await getJsonObj();
  let friendMomentBuckets: Array<FriendMoment> = new Array<FriendMoment>();
  if (!jsonObj.hasOwnProperty(FRIEND_MOMENT_JSON_KEY)) {
    Logger.error(TAG + '_getFriendMomentObjFromJSON', 'Expected FriendMoment field in json, but not found');
    return friendMomentBuckets;
  }
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

export async function getMessageListFromJSON(): Promise<Array<string>> {
  Logger.info(TAG, 'getMessageListFromJSON');
  let jsonObj = await getJsonObj();
  let messageBuckets: Array<string> = new Array<string>();
  if (!jsonObj.hasOwnProperty(MSG_LIST_JSON_KEY)) {
    Logger.error(TAG + '_getMessageListFromJSON', 'Expected MessageList field in json, but not found');
    return messageBuckets;
  }
  return jsonObj.MessageList;
}

async function getJsonObj() {
  Logger.info(TAG, 'getJsonObj');
  let value = await getContext().resourceManager.getRawFileContent('mockChatModelData.json');
  let jsonObj = JSON.parse(bufferToString(value.buffer));
  return jsonObj;
}

function bufferToString(buffer: ArrayBuffer): string {
  Logger.info(TAG, 'bufferToString');
  let textDecoder = util.TextDecoder.create('utf-8', {
    ignoreBOM: true
  });
  let resultPut = textDecoder.decodeWithStream(new Uint8Array(buffer), {
    stream: true
  });
  return resultPut;
}