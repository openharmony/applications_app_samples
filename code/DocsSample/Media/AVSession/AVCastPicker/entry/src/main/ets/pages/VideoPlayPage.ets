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

import { common } from '@kit.AbilityKit';
import { VideoPlayingView } from '../view/VideoPlayingView';
import { RemoteControlPage } from './RemoteControlPage';
import { EpisodeChoose } from '../view/CommonView';
import { VideoData, NET_SOURCES, LOC_SOURCES } from '../model/VideoData';
import { VideoCastController } from '../controller/VideoCastController';
import { VideoSessionController } from '../controller/VideoSessionController';
import { VideoPlayerController } from '../controller/VideoPlayerController';
import { VideoCastingView } from '../view/VideoCastingView';

const uiContext: UIContext | undefined = AppStorage.get('uiContext');

@Component
export struct VideoPlay {
  @StorageLink('avSessionController') avSessionController ?: VideoSessionController = undefined;
  @StorageLink('avPlayerController') avPlayerController ?: VideoPlayerController = undefined;
  @StorageLink('avCastController') avCastController ?: VideoCastController = undefined;
  @StorageLink('deviceName') deviceName: string = '';
  @StorageLink('castingList') castingList: string[] = [];
  @Consume remoteControlPathStack: NavPathStack;
  @Provide videoType: string = '';
  @State videoPlayPathStack: NavPathStack = new NavPathStack();
  @State episodeChooseIndex: number = 0;
  @State volume: number = 20;
  @State videoIndex: number = 0;
  @State videoList: VideoData[] = [];
  @State videoEpisode: number[] = [];

  @Builder
  PageMap(name: string, param: number) {
    if (param === -1) {
      RemoteControlPage({ videoList: this.videoList, videoIndex: this.videoIndex });
    } else {
      RemoteControlPage({ videoList: this.videoList, videoIndex: this.videoIndex, avplayerTime: param });
    }
  }

  aboutToAppear(): void {
    if (this.videoType === 'network') {
      this.videoList = NET_SOURCES;
    } else {
      this.videoList = LOC_SOURCES;
    }
    this.videoList.forEach((item, index: number) => {
      this.videoEpisode.push(index + 1);
    })
  }

  build() {
    NavDestination() {
      Navigation(this.remoteControlPathStack) {
        VideoPlayingView({
          videoList: this.videoList,
          videoIndex: this.videoIndex,
          episodeChooseIndex: this.episodeChooseIndex,
          videoPlayPathStack: this.videoPlayPathStack
        })
          .visibility(this.castingList.includes(this.videoType) ? Visibility.None : Visibility.Visible)
        VideoCastingView({
          videoList: this.videoList,
          videoIndex: this.videoIndex,
          episodeChooseIndex: this.episodeChooseIndex,
          videoPlayPathStack: this.videoPlayPathStack
        })
          .visibility(this.castingList.includes(this.videoType) ? Visibility.Visible : Visibility.None)
          .onClick(() => {
            this.remoteControlPathStack.pushPath({ name: 'detail' });
          })
        Column() {
          Text($r('app.string.episode_choose'))
            .height(48)
            .fontWeight(500)
            .fontSize(16)
            .alignSelf(ItemAlign.Start)
          EpisodeChoose({
            numberTest: this.videoEpisode, videoIndex: this.videoIndex,
            episodeChooseIndex: this.episodeChooseIndex
          })
        }
        .width('100%')
        .padding({
          left: 16,
          right: 16
        })
      }
      .width('100%')
      .mode(NavigationMode.Auto)
      .navDestination(this.PageMap)
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.videoPlayPathStack = context.pathStack;
    })
    .onBackPressed(() => {
      if (this.avPlayerController) {
        this.avPlayerController.releasePlayer();
        this.avPlayerController = undefined;
      }
      if (this.castingList.length === 0) {
        if (this.avSessionController) {
          this.avSessionController.releaseAvSessionListener(uiContext?.getHostContext() as common.UIAbilityContext);
          this.avSessionController = undefined;
        }
      }
      return false;
    })
  }
}

