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
import { ChatModel, ChatContact } from '../viewModel/MsgBase'
import { ChatListData } from '../viewModel/ChatListDataSource'
import Constants from '../utils/Constants'
import util from '@ohos.util'

const TAG: string = 'ChatList_DataFactory'

async function makeDataLocal(listData: ChatListData): Promise<void> {
  Logger.info(TAG, 'makeDataLocal')
  let chatModelMockData = await getChatModelObjFromJSON()
  for (let i = 0; i < Constants.DATA_MOCK_COUNT; i++) {
    listData.pushData(chatModelMockData[i])
  }
}

async function makeDataList(listData: Array<ChatModel>): Promise<void> {
  Logger.info(TAG, 'makeDataLocal')
  let chatModelMockData = await getChatModelObjFromJSON()
  for (let i = 0; i < Constants.DATA_MOCK_COUNT; i++) {
    listData.push(chatModelMockData[i])
  }
}

async function getChatModelObjFromJSON(): Promise<Array<ChatModel>> {
  let value = await getContext().resourceManager.getRawFileContent('mockChatModelData.json')
  let jsonObj = JSON.parse(bufferToString(value.buffer))
  let ChatModelObj = jsonObj.ChatModel
  let ChatModelBuckets: Array<ChatModel> = new Array<ChatModel>()
  for (let i = 0; i < ChatModelObj.length; i++) {
    let contactTemp = new ChatContact(ChatModelObj[i].user.userId, ChatModelObj[i].user.userName, ChatModelObj[i].user.userImage)
    let chatModelTemp = new ChatModel(contactTemp, ChatModelObj[i].lastMsg, ChatModelObj[i].lastTime, ChatModelObj[i].unreadMsgCount)
    ChatModelBuckets.push(chatModelTemp)
  }
  return ChatModelBuckets
}

async function getMessageListFromJSON(): Promise<Array<string>> {
  let value = await getContext().resourceManager.getRawFileContent('mockChatModelData.json')
  let jsonObj = JSON.parse(bufferToString(value.buffer))
  let MessageList = jsonObj.MessageList
  return MessageList
}

function bufferToString(buffer: ArrayBuffer): string {
  let textDecoder = util.TextDecoder.create('utf-8', {
    ignoreBOM: true
  });
  let resultPut = textDecoder.decodeWithStream(new Uint8Array(buffer), {
    stream: true
  });
  return resultPut;
}

export { makeDataLocal, makeDataList, getMessageListFromJSON}