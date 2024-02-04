/*
* Copyright (C) 2024 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import audio from '@ohos.multimedia.audio';
import audioHaptic from '@ohos.multimedia.audioHaptic';
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';

const NOTIFICATION_INDEX = 0;
const RINGTONE_INDEX = 1;
const ALARM_INDEX = 2;
const AUDIO_MUTE_INDEX = 3;
const HAPTICS_MUTE_INDEX = 4;
const PLAYER_CONTAINER = [NOTIFICATION_INDEX, RINGTONE_INDEX, ALARM_INDEX,
    AUDIO_MUTE_INDEX, HAPTICS_MUTE_INDEX];

@Entry
@Component
struct AudioHaptic {
  @State message: string = 'Hello World'
  private appContext?: common.Context;
  private audioHapticManager: audioHaptic.AudioHapticManager = audioHaptic.getAudioHapticManager();
  private audioHapticPlayerInstance: audioHaptic.AudioHapticPlayer | undefined = undefined;
  private audioHapticPlayers: audioHaptic.AudioHapticPlayer[] = [];
  @State lastState: Array<Boolean> = [false, false];
  @State stateText: Array<string> = ['ic_pause', 'ic_pause', 'ic_pause', 'ic_pause', 'ic_pause'];
  @State stateImg: Array<Resource> = [$r('app.media.ic_pause_norm'), $r('app.media.ic_pause_norm'),
    $r('app.media.ic_pause_norm')];
  @State playState: Array<String> = ['pause', 'pause', 'pause'];
  @State clickState: Array<Boolean> = [true, true, true, true, true];
  @State isSync: boolean = true;
  @State isMuteAudio: boolean = false;
  @State isMuteHaptics : boolean = false;
  @State iconOpacity: Array<number> = [1, 1, 1, 1, 1];
  @State idList: Array<number> = [];
  @State fillColor:Array<string> = ['#182431', '#182431'];
  @State vibrationImg: Resource = $r("app.media.ic_vibrations");
  private audioUri = 'file://data/notification.wav'; // 需更改为目标音频资源的Uri
  private hapticUri = 'file://data/notification.wav'; // 需更改为目标振动资源的Uri

  aboutToAppear(): void {
    console.log(`aboutToAppear`)
  }

  async init(): Promise<void> {
    console.info(`init start`);
    if (this.appContext) {
      return;
    }
    this.stateImg = [$r('app.media.ic_pause_norm'), $r('app.media.ic_pause_norm'), $r('app.media.ic_pause_norm')];
    this.stateText = ['ic_pause', 'ic_pause', 'ic_pause', 'ic_pause', 'ic_pause'];
    await this.createTypePlayer();
  }

  onBackPress(): void {
    this.over();
  }

  async onPageHide(): Promise<void> {
    this.over();
  }

   onPageShow(): void {
     console.log(`page show`)
     this.init();
  }

  async createTypePlayer(): Promise<void> {
    console.info(`createTypePlayer palyer len: ${this.audioHapticPlayers.length}`);
    if (this.audioHapticPlayers.length > 0) {
      await this.releaseTypePlayer();
    }
    let options: audioHaptic.AudioHapticPlayerOptions = {muteAudio:this.isMuteAudio, muteHaptics:this.isMuteHaptics};
    this.lastState = [this.isMuteAudio, this.isMuteHaptics];
    for (let index = 0; index < PLAYER_CONTAINER.length - 2; index++) {
      let id = await this.hapticRegisterSource(index);
      this.idList.push(id);
      try {
        await this.setAudioStreamUsage(id, index);
        this.audioHapticPlayerInstance = await this.audioHapticManager.createPlayer(id, options);
        console.info(`createTypePlayer id: ${id}, muteAudio: ${options.muteAudio} muteHaptics: ${options.muteHaptics}`);
        this.audioHapticPlayers.push(this.audioHapticPlayerInstance);
        await this.listenStreamState(index);
      } catch (err) {
        let error = err as BusinessError;
        console.error(`createTypePlayer ${index} Error: ${JSON.stringify(error)}`);
        return;
      }
    }
    console.info(`createTypePlayer end`);
  }

  async releaseTypePlayer(): Promise<void> {
    console.info(`releaseTypePlayer idList: ${this.idList.toString()}`);
    for (let tmp = 0; tmp < this.audioHapticPlayers.length; tmp++) {
      try {
        await this.audioHapticPlayers[tmp].off('endOfStream');
        await this.audioHapticPlayers[tmp].release();
        await this.audioHapticManager.unregisterSource(this.idList[tmp]);
      } catch (err) {
        let error = err as BusinessError;
        console.error(`releaseTypePlayer ${tmp} Error: ${JSON.stringify(error)}`);
        return;
      }
    }
    this.idList = [];
    this.audioHapticPlayers = [];
    console.info(`releaseTypePlayer end`);
  }

  play(index: number): void {
    this.audioHapticPlayers[index].start().then(() => {
      console.info(`Promise returned to indicate that start playing successfully.`);
      console.log(`play current stateText: ${this.stateText.toString()}`)
      console.log(`play current playState: ${this.playState.toString()}`)
    }).catch((err: BusinessError) => {
      console.error(`Failed to start playing. ${err}`);
    });
  }

  stop(index: number): void {
    this.audioHapticPlayers[index].stop().then(() => {
      console.info(`Promise returned to indicate that stop playing successfully.`);
      console.log(`stop current stateText: ${this.stateText.toString()}`)
      console.log(`stop current playState: ${this.playState.toString()}`)
    }).catch((err: BusinessError) => {
      console.error(`Failed to stop playing. ${err}`);
    });
  }

  async over(): Promise<void> {
    console.info(`over start`);
    console.log(`over current stateText: ${this.stateText.toString()}`)
    console.log(`over current playState: ${this.playState.toString()}`)
    this.appContext = undefined;
    await this.releaseTypePlayer();
    console.info(`over end`);
  }

  async hapticRegisterSource(type: number): Promise<number>{
    console.info(`hapticRegisterSource start`);
    switch (type) {
      case 0:
      // 需更改为通知类型目标音频资源的Uri
        this.audioUri = 'file://data/notification.wav';
      // 需更改为通知类型目标振动资源的Uri
        this.hapticUri = 'file://data/notification.json';
        break;
      case 1:
      // 需更改为铃声类型目标音频资源的Uri
        this.audioUri = 'file://data/ringtone.wav';
      // 需更改为铃声类型目标振动资源的Uri
        this.hapticUri = 'file://data/ringtone.json';
        break;
      case 2:
      // 需更改为闹钟类型目标音频资源的Uri
        this.audioUri = 'file://data/alarm.wav';
      // 需更改为闹钟类型目标音频资源的Uri
        this.hapticUri = 'file://data/alarm.json';
        break;
      default :
        break;
    }
    let id = 0;
    try {
      id = await this.audioHapticManager.registerSource(this.audioUri, this.hapticUri);
    } catch (err) {
      let error = err as BusinessError;
      console.error(`registerSource Error: ${JSON.stringify(error)}`);
    }
    console.info(`hapticRegisterSource return id: ${id}`);
    return id;
  }

  async setAudioStreamUsage(id: number, index: number): Promise<void> {
    console.info(`SetAudioStreamUsage start`);
    let usage: audio.StreamUsage = audio.StreamUsage.STREAM_USAGE_NOTIFICATION;
    let latencyMode: audioHaptic.AudioLatencyMode = audioHaptic.AudioLatencyMode.AUDIO_LATENCY_MODE_FAST;
    if (index === 0) {
      console.log('notification type fast mode ')
    } else if (index === 1) {
      usage = audio.StreamUsage.STREAM_USAGE_RINGTONE;
      latencyMode = audioHaptic.AudioLatencyMode.AUDIO_LATENCY_MODE_NORMAL;
    } else {
      usage = audio.StreamUsage.STREAM_USAGE_ALARM;
      latencyMode = audioHaptic.AudioLatencyMode.AUDIO_LATENCY_MODE_NORMAL;
    }
    try {
      await this.audioHapticManager.setAudioLatencyMode(id, latencyMode);
      await this.audioHapticManager.setStreamUsage(id, usage);
    } catch (err) {
      let error = err as BusinessError;
      console.error(`SetAudioStreamUsage ${index}  Error: ${JSON.stringify(error)}`);
      return;
    }
    console.info(`SetAudioStreamUsage end`);
  }

  async listenStreamState(index: number): Promise<void> {
    console.info(`listenStreamState start`);
    console.log(`current stateText: ${this.stateText.toString()}`)
    console.log(`current playState: ${this.playState.toString()}`)
    try {
      this.audioHapticPlayers[index].on('endOfStream', async() => {
        await this.changeState(index);
        console.info(`Receive the callback of endOfStream.`);
      });
    } catch (err) {
      let error = err as BusinessError;
      console.error(`SetAudioStreamUsage ${index}  Error: ${JSON.stringify(error)}`);
      return;
    }
  }

  async syncCreateTypePlayer(): Promise<void> {
    console.log(`this.isMuteAudio: ${this.isMuteAudio} this.isMuteHaptics: ${this.isMuteHaptics}
          this.isSync: ${this.isSync}`)
    if (this.lastState[0] == this.isMuteAudio && this.lastState[1] == this.isMuteHaptics) {
      console.log(`The audio and haptic status is the same as last time`);
      return;
    }
    if (!this.isSync) {
      await this.createTypePlayer();
      this.isSync = true;
    } else {
      console.log(`The status of audio and topic has not changed`)
    }
  }

  async changeState(index: number): Promise<void> {
    console.log(`current stateText: ${this.stateText.toString()}`)
    console.log(`current playState: ${this.playState.toString()}`)
    this.iconOpacity[index] = 1;
    if (this.playState[index] == 'pause') {
      await this.syncCreateTypePlayer();
      this.stateImg[index] = $r('app.media.ic_play_norm');
      this.stateText[index] = 'ic_play';
      this.play(index);
    } else {
      this.clickState[index] = false;
      this.stateImg[index] = $r('app.media.ic_pause_norm');
      this.stateText[index] = 'ic_pause';
      this.stop(index);
    }

    let result = PLAYER_CONTAINER.filter(item =>{
      return item != index;
    })
    result.forEach(item =>{
      if (this.playState[index] == 'pause') {
        this.iconOpacity[item] = 0.2;
        this.clickState[item] = false;
        this.stateText[item] = 'ic_play_no';
      } else {
        this.iconOpacity[item] = 1;
        this.clickState[item] = true;
        this.stateText[item] = 'ic_pause';
      }
    })
    this.playState[index] = this.playState[index]  == 'play' ? 'pause' : 'play'
    this.clickState[index] = true;
  }

  build() {
    Column() {
      Column() {
        Row() {
          Navigation() {
            NavRouter() {
              NavDestination() {
              }
            }
          }
          .height('100%')
          .width('100%')
          .hideBackButton(false)
          .titleMode(NavigationTitleMode.Mini)
          .title($r('app.string.AudioHaptic'))
          .mode(NavigationMode.Stack);
        }.height('8.2%').width('100%').id('btn_back_index')
        .onClick(async () => {
          await router.pushUrl({ url: 'pages/Index' });
        });
        Column() {
          Row() {
            Row() {
              Image($r('app.media.ic_music')).width(24).height(24)
              Text($r('app.string.NotificationType'))
                .fontSize(16)
                .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
                .fontColor('#182431')
                .fontWeight(500)
                .width(192)
                .height(22)
                .margin({ left: '4.4%'});
            }.width('66.7%').height('7.2%').margin({ left: '3.3%' });
            Text(this.stateText[NOTIFICATION_INDEX])
              .id('notification_state_text')
              .fontSize(10)
              .fontColor(Color.White)
              .width(1)
              .height(1);
            Image(this.stateImg[NOTIFICATION_INDEX])
              .width('10%')
              .height('4.6%')
              .margin({left:'8.9%', right: '4.4%' })
              .id('play_notification_type')
              .onClick(() => {
                if (this.clickState[NOTIFICATION_INDEX]) {
                  this.changeState(NOTIFICATION_INDEX);
                } else {
                  console.error("无法操作")
                }
              }).opacity(this.iconOpacity[NOTIFICATION_INDEX])
          }
        }
        .backgroundColor(Color.White)
        .borderRadius(16)
        .margin({bottom:'1.5%'}) // NOTIFICATION

        Column() {
          Row() {
            Row() {
              Image($r('app.media.ic_ring')).width(24).height(24);
              Text($r('app.string.RingtoneType'))
                .fontSize(16)
                .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
                .fontColor('#182431')
                .fontWeight(500)
                .width(192)
                .height(22)
                .margin({ left: '4.4%'});
            }.width('66.7%').height('7.2%').margin({ left: '3.3%' });
            Text(this.stateText[RINGTONE_INDEX])
              .id('ringtone_state_text')
              .fontSize(10)
              .fontColor(Color.White)
              .width(1)
              .height(1);
            Image(this.stateImg[RINGTONE_INDEX])
              .width('10%')
              .height('4.6%')
              .margin({left:'8.9%',right: '4.4%' })
              .id('play_ringtone_type')
              .onClick(() => {
                if (this.clickState[RINGTONE_INDEX]) {
                  this.changeState(RINGTONE_INDEX);
                } else {
                  this.stateText[RINGTONE_INDEX] = 'ic_play_no';
                  console.error("无法操作")
                }
              }).opacity(this.iconOpacity[RINGTONE_INDEX]);
          }
        }
        .backgroundColor(Color.White)
        .borderRadius(16)
        .margin({bottom:'1.5%'}) // RINGTONE

        Column() {
          Row() {
            Row() {
              Image($r('app.media.ic_alarm')).width(24).height(24);
              Text($r('app.string.AlarmType'))
                .fontSize(16)
                .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
                .fontColor('#182431')
                .fontWeight(500)
                .width(192)
                .height(22)
                .margin({ left: '4.4%'});
            }.width('66.7%').height('7.2%').margin({ left: '3.3%' });
            Text(this.stateText[ALARM_INDEX])
              .id('alarm_state_text')
              .fontSize(10)
              .fontColor(Color.White)
              .width(1)
              .height(1);
            Image(this.stateImg[ALARM_INDEX])
              .width('10%')
              .height('4.6%')
              .margin({left:'8.9%', right: '4.4%' })
              .id('play_alarm_type')
              .onClick(() => {
                if (this.clickState[ALARM_INDEX]) {
                  this.changeState(ALARM_INDEX);
                } else {
                  this.stateText[ALARM_INDEX] = 'ic_play_no';
                  console.error("无法操作")
                }
              }).opacity(this.iconOpacity[ALARM_INDEX]);
          }
        }
        .backgroundColor(Color.White)
        .borderRadius(16)
        .margin({bottom:'1.5%'}) // ALARM
      }.justifyContent(FlexAlign.Start).width('100%');

      Row() {
        Column() {
          Image($r('app.media.ic_Mute'))
            .width(24)
            .height(24)
            .margin({top: '1%', left:'18.3%', right:'18.3%'})
            .fillColor(this.fillColor[0])
          Text($r('app.string.MUTE_AUDIO'))
            .fontSize(10)
            .width('94.8%')
            .height('25%')
            .textAlign(TextAlign.Center)
            .fontColor(this.fillColor[0])
            .margin({ top: '0.4%', right: '1.10%', bottom: '0.00vp', left: '1.10%' });
          Text(this.stateText[AUDIO_MUTE_INDEX])
            .id('audio_mute_state_text').fontSize(10).fontColor(Color.White).opacity(0);
        }
        .width('50%')
        .height('100%')
        .opacity(this.iconOpacity[AUDIO_MUTE_INDEX])
        .id('btn_audio_mute')
        .onClick(async () => {
          if (this.clickState[AUDIO_MUTE_INDEX]) {
            console.log(`current stateText: ${this.stateText.toString()}`)
            this.isMuteAudio = !(this.isMuteAudio);
            console.error(`isMuteAudio ${this.isMuteAudio}`)
            this.isSync = false;
            this.fillColor[0] = this.fillColor[0] == '#007DFF' ? '#182431' : '#007DFF';
            if (this.stateText[AUDIO_MUTE_INDEX] == 'ic_play') {
              this.stateText[AUDIO_MUTE_INDEX] = 'ic_pause';
            } else {
              this.stateText[AUDIO_MUTE_INDEX] = 'ic_play'
            }
            console.log(`end current stateText: ${this.stateText.toString()}`)
          } else {
            this.stateText[AUDIO_MUTE_INDEX] = 'ic_play_no';
            console.error("无法操作")
          }
        }) // AUDIO_MUTE

        Column() {
          Image(this.vibrationImg)
            .width(24)
            .height(24)
            .margin({top: '1%', left:'18.3%', right:'18.3%'})
          Text($r('app.string.MUTE_HAPTICS'))
            .fontSize(10)
            .width('94.8%')
            .height('25%')
            .textAlign(TextAlign.Center)
            .fontColor(this.fillColor[1])
            .padding({ top: '0', right: '0.00vp', bottom: '0.00vp', left: '0.00vp' })
            .margin({ top: '0.4%', right: '1.10%', bottom: '0.00vp', left: '1.10%' });
          Text(this.stateText[HAPTICS_MUTE_INDEX])
            .id('haptic_mute_state_text').fontSize(10).fontColor(Color.White).opacity(0);
        }
        .width('50%')
        .height('100%')
        .opacity(this.iconOpacity[HAPTICS_MUTE_INDEX])
        .id('btn_haptic_mute')
        .onClick(async () => {
          if (this.clickState[HAPTICS_MUTE_INDEX]) {
            console.log(`current stateText: ${this.stateText.toString()}`)
            this.isMuteHaptics = !(this.isMuteHaptics);
            console.error(`isMuteHaptics ${this.isMuteHaptics}`)
            this.isSync = false;
            this.fillColor[1] = this.fillColor[1] == '#007DFF' ? '#182431' : '#007DFF';
            this.vibrationImg = this.fillColor[1] == '#182431' ? $r("app.media.ic_vibrations") : $r("app.media.ic_vibrations_blue");
            if (this.stateText[HAPTICS_MUTE_INDEX] == 'ic_play') {
              this.stateText[HAPTICS_MUTE_INDEX] = 'ic_pause';
            } else {
              this.stateText[HAPTICS_MUTE_INDEX] = 'ic_play'
            }
            console.log(`end current stateText: ${this.stateText.toString()}`)
          } else {
            this.stateText[HAPTICS_MUTE_INDEX] = 'ic_play_no';
            console.error("无法操作")
          }
        }) // HAPTICS_MUTE
      }
      .height('7.2%')
      .width('86.6%')
      .margin({ left: '6.7%',right: '6.7%'});
    }.height('100%').width('100%').backgroundColor('#f1f3f5').justifyContent(FlexAlign.SpaceBetween);
  }
}
