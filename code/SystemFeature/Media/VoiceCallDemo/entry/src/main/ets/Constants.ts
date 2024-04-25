/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

export default class Constants {
  /**
   * work message 和  callback
   */

  // 录制相关
  public static readonly WORK_MESSAGE_CAPTURER_START: number = 1001; // 启动录制
  public static readonly WORK_MESSAGE_CAPTURER_STOP: number = 1002; // 停止录制
  // worker 和 ui 线程的数据通讯
  public static readonly WORK_MESSAGE_CAPTURER_SEND: number = 1003; // 发送采集数据

  // 播放相关
  public static readonly WORK_MESSAGE_RENDERER_START: number = 2001; // 启动播放
  public static readonly WORK_MESSAGE_RENDERER_STOP: number = 2002; // 停止播放
  // worker 和 ui 线程的数据通讯
  public static readonly WORK_MESSAGE_RENDERER_RECV: number = 2003; // 接收渲染数据


  // emmit UI state
  public static readonly EVENT_UI_CALL = 101; // 拨号页
  public static readonly EVENT_UI_ANSWER = 102; // 接听页
  public static readonly EVENT_UI_VOICE = 103; // 通话页


  //COMMOM EVENT
  public static readonly COMM_EVENT_ANSWER_FROM_HOST: string = 'COMM_EVENT_ANSWER_FROM_HOST'; // 公共事件，接听  聊天示例->Voice
  public static readonly COMM_EVENT_HANGUP_FROM_HOST: string = 'COMM_EVENT_HANGUP_FROM_HOST'; // 挂断，拒接 聊天示例->Voice

  public static readonly COMM_EVENT_ANSWER_FROM_VOICE: string = 'COMM_EVENT_ANSWER_FROM_VOICE'; //  公共事件，接听 Voice->聊天示例
  public static readonly COMM_EVENT_HANGUP_FROM_VOICE: string = 'COMM_EVENT_HANGUP_FROM_VOICE'; // 挂断，拒接 Voice->聊天示例

  //ability 参数
  public static readonly START_ABILITY_EVENT_KEY = 'START_ABILITY_EVENT_KEY'; // 启动ability事件 key
  public static readonly START_ABILITY_EVENT_CALL = 'START_ABILITY_CALL'; // 启动ability事件：请求通话
  public static readonly START_ABILITY_EVENT_ANSWER = 'START_ABILITY_ANSWER'; // 启动ability事件：被请求通话

  public static readonly START_ABILITY_DATA_KEY = 'START_ABILITY_DATA_KEY'; // 启动ability数据参数,这里传通话人的id

}