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

import Logger from './Logger'
import { ChatModel, ChatContact, FriendMoment } from '../viewModel/MsgBase'
import { ChatListData } from '../viewModel/ChatListDataSource'
import Constants from '../utils/Constants'
import util from '@ohos.util'

const TAG: string = 'ChatList_DataFactory'

export async function makeDataLocal(listData: ChatListData): Promise<void> {
  Logger.info(TAG, 'makeDataLocal')
  let chatModelMockData = await getChatModelObjFromJSON()
  for (let i = 0; i < Constants.DATA_MOCK_COUNT; i++) {
    listData.pushData(chatModelMockData[i])
  }
}

export async function makeDataList(listData: Array<ChatModel>): Promise<void> {
  Logger.info(TAG, 'makeDataList')
  let chatModelMockData = await getChatModelObjFromJSON()
  for (let i = 0; i < Constants.DATA_MOCK_COUNT; i++) {
    listData.push(chatModelMockData[i])
  }
}

export async function getChatModelObjFromJSON(): Promise<Array<ChatModel>> {
  Logger.info(TAG, 'getChatModelObjFromJSON')
  let jsonObj = await getJsonObj()
  let ChatModelObj = jsonObj.ChatModel
  let ChatModelBuckets: Array<ChatModel> = new Array<ChatModel>()
  for (let i = 0; i < ChatModelObj.length; i++) {
    let contactTemp = new ChatContact(ChatModelObj[i].user.userId, ChatModelObj[i].user.userName,
      ChatModelObj[i].user.userImage)
    let chatModelTemp = new ChatModel(contactTemp, ChatModelObj[i].lastMsg, ChatModelObj[i].lastTime,
      ChatModelObj[i].unreadMsgCount)
    ChatModelBuckets.push(chatModelTemp)
  }
  return ChatModelBuckets
}


export async function getFriendMomentObjFromJSON(): Promise<Array<FriendMoment>> {
  Logger.info(TAG, 'getFriendMomentObjFromJSON')
  let jsonObj = await getJsonObj()
  let FriendMomentObj = jsonObj.FriendMoment
  let FriendMomentBuckets: Array<FriendMoment> = new Array<FriendMoment>()
  for (let i = 0; i < FriendMomentObj.length; i++) {
    let contactTemp = new ChatContact(FriendMomentObj[i].user.userId, FriendMomentObj[i].user.userName,
      FriendMomentObj[i].user.userImage)
    let chatModelTemp = new FriendMoment(FriendMomentObj[i].id, contactTemp, FriendMomentObj[i].text, '',
      FriendMomentObj[i].imageList)
    FriendMomentBuckets.push(chatModelTemp)
  }
  return FriendMomentBuckets
}

export async function getMessageListFromJSON(): Promise<Array<string>> {
  Logger.info(TAG, 'getMessageListFromJSON')
  let jsonObj = await getJsonObj()
  return jsonObj.MessageList
}

async function getJsonObj() {
  Logger.info(TAG, 'getJsonObj')
  let value = await getContext().resourceManager.getRawFileContent('mockChatModelData.json')
  let jsonObj = JSON.parse(bufferToString(value.buffer))
  return jsonObj
}

function bufferToString(buffer: ArrayBuffer): string {
  Logger.info(TAG, 'bufferToString')
  let textDecoder = util.TextDecoder.create('utf-8', {
    ignoreBOM: true
  });
  let resultPut = textDecoder.decodeWithStream(new Uint8Array(buffer), {
    stream: true
  });
  return resultPut;
}