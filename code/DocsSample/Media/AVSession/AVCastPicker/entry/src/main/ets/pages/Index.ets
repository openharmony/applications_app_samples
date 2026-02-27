/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { VideoSessionController } from '../controller/VideoSessionController';
import { VideoPlayerController } from '../controller/VideoPlayerController';
import { VideoCastController } from '../controller/VideoCastController';
import { VideoPlay } from './VideoPlayPage';
import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { WantAgent, wantAgent } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
// [Start set_avMetadata]
// 与session声明不在同一文件时，需要import
// [Start create_avSession]
import  { avSession }  from '@kit.AVSessionKit'; // 导入AVSession模块

// 声明全局的session对象，此写法是加在class类外的声明，如果需要在class类内申明全局变量，需要去掉 export let
export let session: avSession.AVSession;
// [StartExclude create_avSession]
// [StartExclude set_avMetadata]
let currentAVSession: avSession.AVSession | undefined = undefined;

class VideoPlayParam {
  videoType: string;
  videoTime: number = 0;
  videoIndex: number = 0;

  constructor(videoType: string, videoTime?: number, videoIndex?: number) {
    this.videoType = videoType;
    if (videoTime) {
      this.videoTime = videoTime;
    }
    if (videoIndex) {
      this.videoIndex = videoIndex;
    }
  }
}

function startContinuousTask(context: common.UIAbilityContext): WantAgent {
  let wantAgentInfo: wantAgent.WantAgentInfo = {
    // 点击通知后，将要执行的动作列表
    wants: [
      {
        bundleName: context.abilityInfo.bundleName,
        abilityName: context.abilityInfo.name
      }
    ],
    // 点击通知后，动作类型
    actionType: wantAgent.OperationType.START_ABILITY,
    // 使用者自定义的一个私有值
    requestCode: 0,
    // 点击通知后，动作执行属性
    wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
  };

  // 通过wantAgent模块的getWantAgent方法获取WantAgent对象
  let wantAgentObj = wantAgent.getWantAgent(wantAgentInfo).catch((error: Error) => {
    let err = error as BusinessError
    if (err.code) {
      console.error(`Failed to request to start running in background. Error: ${error}`);
    }
  });

  backgroundTaskManager.startBackgroundRunning(context,
    backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK, wantAgentObj).then(() => {
    console.info('Succeeded in requesting to start running in background');
  }).catch((error: BusinessError) => {
    console.error(`Failed to request to start running in background. Code: ${error.code}, message: ${error.message}`);
  });

  return wantAgentObj;
}
// [EndExclude set_avMetadata]
// [EndExclude create_avSession]
@Entry
@Component
struct Index {
  // [StartExclude set_avMetadata]
  // [StartExclude create_avSession]
  @StorageLink('avSessionController') avSessionController ?: VideoSessionController = undefined;
  @StorageLink('castingList') castingList: string[] = [];
  @StorageLink('avPlayerController') avPlayerController?: VideoPlayerController = undefined;
  @StorageLink('avCastController') @Watch('avCastControllerChange') avCastPlayerController?: VideoCastController =
    undefined;
  @Provide remoteControlPathStack: NavPathStack = new NavPathStack();
  @State ifShowBack: boolean = false;
  @State avCastControllerState?: avSession.PlaybackState = avSession.PlaybackState.PLAYBACK_STATE_INITIAL;
  @State videoPlayPathStack: NavPathStack = new NavPathStack();
  // [EndExclude create_avSession]
  // 创建session
  async createSession(context: common.UIAbilityContext) {
    // 创建的AVSession在基础播控与投播场景可以共用
    session = await avSession.createAVSession(context, 'video_test', 'video'); // 'audio'代表音频应用，'video'代表视频应用
    // [StartExclude create_avSession]
    let wantAgentObj = startContinuousTask(context);
    session.setLaunchAbility(wantAgentObj).catch((error: Error) => {
      let err = error as BusinessError
      if (err.code) {
        console.error('Set launch ability failed, cause: %{public}s', JSON.stringify(err));
      }
    });
    // [EndExclude create_avSession]
    await session.activate();
    // 请按照如下参数设置，告知系统应用当前支持投播，才能成功投播。
    session.setExtras({
      requireAbilityList: ['url-cast'],
    });
    console.info(`Session created. sessionId: ${session.sessionId}`);
  }

  // [StartExclude create_avSession]
  // [EndExclude set_avMetadata]
  public setAVMetadata(playInfo: avSession.AVMediaDescription): Promise<void> {
    const metadata: avSession.AVMetadata = {
      assetId: playInfo.assetId, // 需要配置实际id
      title: playInfo.title, // 播放媒体资源的标题
      subtitle: playInfo.subtitle, // 播放媒体资源的副标题
      // 发现Cast+ Stream 和 DLNA协议设备，TYPE_CAST_PLUS_STREAM为默认必选。
      filter: avSession.ProtocolType.TYPE_CAST_PLUS_STREAM | avSession.ProtocolType.TYPE_DLNA,
      mediaImage: playInfo.mediaImage,
      artist: playInfo.artist,
      // 如果是DRM资源，配置支持的DRM uuid 用于设备过滤。非DRM资源不配置。
      drmSchemes: ['3d5e6d35-9b9a-41e8-b843-dd3c6e72c42c']
    };
    return session.setAVMetadata(metadata);
  }

  public setSessionListener() {
    // 请按照自检接入表按需注册并实现基础播控的控制指令，以下为举例
    session?.on('play', () => {
    });
    session?.on('pause', () => {
    });
  }

  // [StartExclude set_avMetadata]
  @Builder
  OverlayNode() {
    if (!this.ifShowBack){
      Row() {
        SymbolGlyph($r('sys.symbol.wireless_projection'))
          .fontSize(28)
          .fontColor([Color.White])
      }
      .width(56)
      .height(56)
      .backgroundColor('#0A59F7')
      .borderRadius(28)
      .justifyContent(FlexAlign.Center)
      .offset({
        x: -2,
        y: -66
      })
      .onClick(() => {
        this.ifShowBack = true;
      })
      .visibility(this.remoteControlPathStack.size()===0 &&
                  this.castingList.length !== 0 ? Visibility.Visible : Visibility.None)
    }else {
      Column() {
        Row() {
          SymbolGlyph($r('sys.symbol.arrowshape_turn_up_left'))
            .fontSize(28)
            .fontColor([Color.Black])
        }
        .width(48)
        .height(48)
        .backgroundColor('#E8E8E8')
        .borderRadius('50%')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          let videoPlayParam = new VideoPlayParam(this.castingList[0], 0, this.avCastPlayerController?.videoIndex);
          this.videoPlayPathStack.replacePath({ name: 'detail', param: videoPlayParam });
          this.remoteControlPathStack.replacePath({ name: 'detail', param: -1 });
        })

        Row() {
          SymbolGlyph($r('sys.symbol.wireless_projection'))
            .fontSize(28)
            .fontColor([Color.White])
        }
        .onClick(() => {
          this.ifShowBack = false;
        })
        .width(56)
        .height(56)
        .backgroundColor('#0A59F7')
        .borderRadius('50%')
        .justifyContent(FlexAlign.Center)

        Row() {
          SymbolGlyph(this.avCastControllerState === avSession.PlaybackState.PLAYBACK_STATE_PLAY ?
            $r('sys.symbol.pause_circle') : $r('sys.symbol.play_circle'))
            .fontSize(28)
            .fontColor([Color.Black])
        }
        .onClick(() => {
          if (this.avCastControllerState === avSession.PlaybackState.PLAYBACK_STATE_PLAY &&
          this.avCastPlayerController) {
            this.avCastPlayerController.setAVCastPause();
          } else if (this.avCastControllerState === avSession.PlaybackState.PLAYBACK_STATE_PAUSE &&
          this.avCastPlayerController) {
            this.avCastPlayerController.setAVCastPlay();
          }
        })
        .width(48)
        .height(48)
        .backgroundColor('#E8E8E8')
        .borderRadius('50%')
        .justifyContent(FlexAlign.Center)
      }
      .backgroundColor('#EFF0F3')
      .borderRadius(30)
      .width(60)
      .height(188)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        top: 8,
        bottom: 8
      })
      .visibility(this.remoteControlPathStack.size()===0 &&
       this.castingList.length !== 0 ? Visibility.Visible : Visibility.None)
    }
  }

  @Builder
  PageMap(name: string, param: VideoPlayParam) {
    VideoPlay({ videoType: param.videoType, videoIndex: param.videoIndex })
  }

  avCastControllerChange() {
    this.avCastControllerState = this.avCastPlayerController?.state;
  }

  build() {
    RelativeContainer() {
      Navigation(this.videoPlayPathStack) {
        Column() {
          Row() {
            Text($r('app.string.title'))
              .fontSize(30)
              .fontWeight(FontWeight.Bold)
          }
          .height(112)
          .width('100%')
          .padding({
            left: 16,
            right: 16,
            bottom: 8
          })
          .alignItems(VerticalAlign.Bottom)

          Column() {
            Text($r('app.string.subtitle'))
              .height(48)
              .fontSize(16)
              .fontWeight(500)
            Row() {
              Image($r('app.media.video_cover_0'))
                .height('100%')
                .width(156)
                .borderRadius(10)
              Column() {
                Text($r('app.string.online_video'))
                  .fontSize(14)
                  .margin({
                    bottom: 2
                  })
                Text($r('app.string.online_video_describe'))
                  .fontSize(12)
                  .fontColor('rgba(0,0,0,0.6)')
              }
              .height('100%')
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.Start)
              .layoutWeight(1)
              .padding({
                left: 8
              })
            }
            .onClick(() => {
              let videoPlayParam = new VideoPlayParam('network');
              this.videoPlayPathStack.pushPath({ name: 'detail', param: videoPlayParam });
            })
            .width('100%')
            .height(88)
            .margin({
              bottom: 12
            })

            Row() {
              Image($r('app.media.video_cover_0'))
                .height('100%')
                .width(156)
                .borderRadius(10)
              Column() {
                Text($r('app.string.local_video'))
                  .fontSize(14)
                  .margin({
                    bottom: 2
                  })
                Text($r('app.string.local_video_describe'))
                  .fontSize(12)
                  .fontColor('rgba(0,0,0,0.6)')
              }
              .height('100%')
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.Start)
              .layoutWeight(1)
              .padding({
                left: 8
              })
            }
            .onClick(() => {
              let videoPlayParam = new VideoPlayParam('localWork');
              this.videoPlayPathStack.pushPath({ name: 'detail', param: videoPlayParam });
            })
            .width('100%')
            .height(88)
          }
          .alignItems(HorizontalAlign.Start)
          .padding({
            left: 16,
            right: 16,
          })
          .width('100%')
          .layoutWeight(1)
          .backgroundColor(Color.White)
        }
        .onClick(() => {
          this.ifShowBack = false;
        })
      }
      .navBarWidth(this.videoPlayPathStack.size() === 0 ? '100%' : '50%')
      .width('100%')
      .mode(NavigationMode.Auto)
      .navDestination(this.PageMap)
      .hideToolBar(true)
      .overlay(this.OverlayNode(), {
        align: Alignment.BottomEnd,
        offset: { x: -24,
          y: -136 }
      })
    }
    .width('100%')
    .height('100%')
  }
  // [EndExclude create_avSession]
  // [EndExclude set_avMetadata]
}
// [End create_avSession]
// [End set_avMetadata]