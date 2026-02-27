/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// [Start fixedPlaybackControlCommands]
import { avSession as AVSessionManager } from '@kit.AVSessionKit';
// [StartExclude fixedPlaybackControlCommands]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [EndExclude fixedPlaybackControlCommands]

@Entry
@Component
struct Index {
  @State message: string = 'hello world';
  // [StartExclude fixedPlaybackControlCommands]
  @State logMessages: string = '';
  aboutToAppear(): void {
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
  }
  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    const newLog = `[${timestamp}] ${prefix} ${msg}`;
    let logs = this.logMessages ? this.logMessages.split('\n') : [];
    logs.push(newLog);
    if (logs.length > 15) {
      logs.shift();
    }
    this.logMessages = logs.join('\n');
  }
  // [EndExclude fixedPlaybackControlCommands]

  build() {
    Column() {
      // [StartExclude fixedPlaybackControlCommands]
      Text(this.logMessages)
        .fontSize(12)
        .fontColor('#52C41A')
        .width('90%')
        .padding(10)
        .backgroundColor('#F0F0F0')
        .borderRadius(8)
        .margin({ bottom: 10 })
      // [EndExclude fixedPlaybackControlCommands]
      Text(this.message)
        .onClick(async () => {
          let context = this.getUIContext().getHostContext() as Context;
          // 假设已经创建了一个session，如何创建session可以参考之前的案例。
          let type: AVSessionManager.AVSessionType = 'audio';
          let session = await AVSessionManager.createAVSession(context, 'SESSION_NAME', type);
          // [StartExclude fixedPlaybackControlCommands]
          await session.activate();
          // [EndExclude fixedPlaybackControlCommands]
          // 一般在监听器中会对播放器做相应逻辑处理。
          // 不要忘记处理完后需要通过set接口同步播放相关信息，参考上面的用例。
          session.on('play', () => {
            console.info(`on play , do play task`);
            // [StartExclude fixedPlaybackControlCommands]
            if (globalLogUpdate) {
              globalLogUpdate('on play , do play task', false);
            }
            // [EndExclude fixedPlaybackControlCommands]
            // 如暂不支持该指令，请勿注册；或在注册后但暂不使用时，通过session.off('play')取消监听。
            // 处理完毕后，请使用SetAVPlaybackState上报播放状态。
          });
          session.on('pause', () => {
            console.info(`on pause , do pause task`);
            // [StartExclude fixedPlaybackControlCommands]
            if (globalLogUpdate) {
              globalLogUpdate('on pause , do pause task', false);
            }
            // [EndExclude fixedPlaybackControlCommands]
            // 如暂不支持该指令，请勿注册；或在注册后但暂不使用时，通过session.off('pause')取消监听。
            // 处理完毕后，请使用SetAVPlaybackState上报播放状态。
          });
          session.on('stop', () => {
            console.info(`on stop , do stop task`);
            // [StartExclude fixedPlaybackControlCommands]
            if (globalLogUpdate) {
              globalLogUpdate('on stop , do stop task', false);
            }
            // [EndExclude fixedPlaybackControlCommands]
            // 如暂不支持该指令，请勿注册；或在注册后但暂不使用时，通过session.off('stop')取消监听。
            // 处理完毕后，请使用SetAVPlaybackState上报播放状态。
          });
          session.on('playNext', () => {
            console.info(`on playNext , do playNext task`);
            // [StartExclude fixedPlaybackControlCommands]
            if (globalLogUpdate) {
              globalLogUpdate('on playNext , do playNext task', false);
            }
            // [EndExclude fixedPlaybackControlCommands]
            // 如暂不支持该指令，请勿注册；或在注册后但暂不使用时，通过session.off('playNext')取消监听。
            // 处理完毕后，请使用SetAVPlaybackState上报播放状态，使用SetAVMetadata上报媒体信息。
          });
          session.on('playPrevious', () => {
            console.info(`on playPrevious , do playPrevious task`);
            // [StartExclude fixedPlaybackControlCommands]
            if (globalLogUpdate) {
              globalLogUpdate('on playPrevious , do playPrevious task', false);
            }
            // [EndExclude fixedPlaybackControlCommands]
            // 如暂不支持该指令，请勿注册；或在注册后但暂不使用时，通过session.off('playPrevious')取消监听。
            // 处理完毕后，请使用SetAVPlaybackState上报播放状态，使用SetAVMetadata上报媒体信息。
          });
          session.on('fastForward', () => {
            console.info(`on fastForward , do fastForward task`);
            // [StartExclude fixedPlaybackControlCommands]
            if (globalLogUpdate) {
              globalLogUpdate('on fastForward , do fastForward task', false);
            }
            // [EndExclude fixedPlaybackControlCommands]
            // 如暂不支持该指令，请勿注册；或在注册后但暂不使用时，通过session.off('fastForward')取消监听。
            // 处理完毕后，请使用SetAVPlaybackState上报播放状态和播放position。
          });
          session.on('rewind', () => {
            console.info(`on rewind , do rewind task`);
            // [StartExclude fixedPlaybackControlCommands]
            if (globalLogUpdate) {
              globalLogUpdate('on rewind , do rewind task', false);
            }
            // [EndExclude fixedPlaybackControlCommands]
            // 如暂不支持该指令，请勿注册；或在注册后但暂不使用时，通过session.off('rewind')取消监听。
            // 处理完毕后，请使用SetAVPlaybackState上报播放状态和播放position。
          });
          session.on('seek', (time) => {
            console.info(`on seek , the seek time is ${time}`);
            // [StartExclude fixedPlaybackControlCommands]
            if (globalLogUpdate) {
              globalLogUpdate(`on seek , the seek time is ${time}`, false);
            }
            // [EndExclude fixedPlaybackControlCommands]
            // 如暂不支持该指令，请勿注册；或在注册后但暂不使用时，通过session.off('seek')取消监听。
            // 处理完毕后，请使用SetAVPlaybackState上报播放状态和播放position。
          });
          session.on('setSpeed', (speed) => {
            console.info(`on setSpeed , the speed is ${speed}`);
            // [StartExclude fixedPlaybackControlCommands]
            if (globalLogUpdate) {
              globalLogUpdate(`on setSpeed , the speed is ${speed}`, false);
            }
            // [EndExclude fixedPlaybackControlCommands]
            // 实现具体功能。
          });
          session.on('setLoopMode', (mode) => {
            console.info(`on setLoopMode , the loop mode is ${mode}`);
            // [StartExclude fixedPlaybackControlCommands]
            if (globalLogUpdate) {
              globalLogUpdate(`on setLoopMode , the loop mode is ${mode}`, false);
            }
            // [EndExclude fixedPlaybackControlCommands]
            // 如暂不支持该指令，请勿注册；或在注册后但暂不使用时，通过session.off('setLoopMode')取消监听。
            // 应用自定下一个模式，处理完毕后，请使用SetAVPlaybackState上报切换后的LoopMode。
          });
          session.on('toggleFavorite', (assetId) => {
            console.info(`on toggleFavorite , the target asset Id is ${assetId}`);
            // [StartExclude fixedPlaybackControlCommands]
            if (globalLogUpdate) {
              globalLogUpdate(`on toggleFavorite , the target asset Id is ${assetId}`, false);
            }
            // [EndExclude fixedPlaybackControlCommands]
            // 如暂不支持该指令，请勿注册；或在注册后但暂不使用时，通过session.off('toggleFavorite')取消监听。
            // 处理完毕后，请使用SetAVPlaybackState上报收藏结果isFavorite。
          });
          // [StartExclude fixedPlaybackControlCommands]
          try {
            let controller = await session.getController();
            await controller.sendControlCommand({ command: 'play' });
            await controller.sendControlCommand({ command: 'pause' });
            await controller.sendControlCommand({ command: 'stop' });
            await controller.sendControlCommand({ command: 'playNext' });
            await controller.sendControlCommand({ command: 'playPrevious' });
            await controller.sendControlCommand({ command: 'fastForward' });
            await controller.sendControlCommand({ command: 'rewind' });
            await controller.sendControlCommand({ command: 'seek', parameter: 5000 });
            await controller.sendControlCommand({ command: 'setSpeed', parameter: 2.0 });
            await controller.sendControlCommand({ command: 'setLoopMode', parameter: AVSessionManager.LoopMode.LOOP_MODE_SHUFFLE });
            await controller.sendControlCommand({ command: 'toggleFavorite', parameter: '12345' });
            await new Promise<void>(resolve => setTimeout(resolve, 2000));
          } catch (err) {
            if (globalLogUpdate) {
              globalLogUpdate(`Controller error: ${err.message}`, true);
            }
          }
          session.destroy((err) => {
            if (err) {
              console.error(`Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
            } else {
              console.info(`Destroy : SUCCESS `);
            }
          });
          // [EndExclude fixedPlaybackControlCommands]
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End fixedPlaybackControlCommands]