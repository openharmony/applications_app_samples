/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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
export default class Constants {
  // COMMON EVENT
  public static readonly COMM_EVENT_ANSWER_FROM_HOST: string = 'COMM_EVENT_ANSWER_FROM_HOST'; // 公共事件，接听  聊天示例->Voice
  public static readonly COMM_EVENT_HANGUP_FROM_HOST: string = 'COMM_EVENT_HANGUP_FROM_HOST'; // 挂断，拒接 聊天示例->Voice

  public static readonly COMM_EVENT_ANSWER_FROM_VOICE: string = 'COMM_EVENT_ANSWER_FROM_VOICE'; //  公共事件，接听 Voice->聊天示例
  public static readonly COMM_EVENT_HANGUP_FROM_VOICE: string = 'COMM_EVENT_HANGUP_FROM_VOICE'; // 挂断，拒接 Voice->聊天示例

  // ability 参数
  public static readonly START_ABILITY_EVENT_KEY = 'START_ABILITY_EVENT_KEY'; // 启动ability事件 key
  public static readonly START_ABILITY_EVENT_CALL = 'START_ABILITY_CALL'; // 启动ability事件：请求通话
  public static readonly START_ABILITY_EVENT_ANSWER = 'START_ABILITY_ANSWER'; // 启动ability事件：被请求通话

  public static readonly START_ABILITY_DATA_KEY = 'START_ABILITY_DATA_KEY'; // 启动ability数据参数,这里传通话人的id

  public static readonly BUNDLE_NAME = 'com.samples.voicecalldemo'; // 启动ability的BUNDLENAME
  public static readonly ABILITY_NAME = 'EntryAbility'; // 启动ability的ABILITYNAME
}
