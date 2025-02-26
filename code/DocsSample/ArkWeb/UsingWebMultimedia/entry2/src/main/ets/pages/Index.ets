/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { webview } from '@kit.ArkWeb';
import { BuilderNode, FrameNode, NodeController, NodeRenderType, UIContext } from '@kit.ArkUI';
import { AVPlayerDemo, AVPlayerListener } from './PlayerDemo';

// 实现 webview.NativeMediaPlayerBridge 接口。
// ArkWeb 内核调用该类的方法来对 NativeMediaPlayer 进行播控。
class NativeMediaPlayerImpl implements webview.NativeMediaPlayerBridge {
  private surfaceId: string;
  mediaSource: string;
  private mediaHandler: webview.NativeMediaPlayerHandler;
  nativePlayerInfo: NativePlayerInfo;
  nativePlayer: AVPlayerDemo;
  httpHeaders: Record<string, string>;

  constructor(
    nativePlayerInfo: NativePlayerInfo, handler: webview.NativeMediaPlayerHandler, mediaInfo: webview.MediaInfo) {
    console.log(`NativeMediaPlayerImpl.constructor, surface_id[${mediaInfo.surfaceInfo.id}]`);
    this.nativePlayerInfo = nativePlayerInfo;
    this.mediaHandler = handler;
    this.surfaceId = mediaInfo.surfaceInfo.id;
    this.mediaSource = mediaInfo.mediaSrcList.find((item)=>{item.source.indexOf('.mp4') > 0})?.source
      || mediaInfo.mediaSrcList[0].source;
    this.httpHeaders = mediaInfo.headers;
    this.nativePlayer = new AVPlayerDemo();

    // 使用同层渲染功能，将视频及其播控组件绘制到网页中
    this.nativePlayerInfo.node_controller = new MyNodeController(
      this.nativePlayerInfo, this.surfaceId, this.mediaHandler, this, NodeRenderType.RENDER_TYPE_TEXTURE);
    this.nativePlayerInfo.node_controller.build();
    this.nativePlayerInfo.show_native_media_player = true;

    console.log(
      `NativeMediaPlayerImpl.mediaSource: ${this.mediaSource}, headers: ${JSON.stringify(this.httpHeaders)}`);
  }

  updateRect(x: number, y: number, width: number, height: number): void {
    let width_in_vp = px2vp(width);
    let height_in_vp = px2vp(height);
    console.log(`updateRect(${x}, ${y}, ${width}, ${height}), vp:{${width_in_vp}, ${height_in_vp}}`);
    this.nativePlayerInfo.updateNativePlayerRect(x, y, width, height);
  }

  play() {
    console.log('NativeMediaPlayerImpl.play');
    this.nativePlayer.play();
  }
  pause() {
    console.log('NativeMediaPlayerImpl.pause');
    this.nativePlayer.pause();
  }
  seek(targetTime: number) {
    console.log(`NativeMediaPlayerImpl.seek(${targetTime})`);
    this.nativePlayer.seek(targetTime);
  }
  setVolume(volume: number) {
    console.log(`NativeMediaPlayerImpl.setVolume(${volume})`);
    this.nativePlayer.setVolume(volume);
  }
  setMuted(muted: boolean) {
    console.log(`NativeMediaPlayerImpl.setMuted(${muted})`);
  }
  setPlaybackRate(playbackRate: number) {
    console.log(`NativeMediaPlayerImpl.setPlaybackRate(${playbackRate})`);
    this.nativePlayer.setPlaybackRate(playbackRate);
  }
  release() {
    console.log('NativeMediaPlayerImpl.release');
    this.nativePlayer?.release();
    this.nativePlayerInfo.show_native_media_player = false;
    this.nativePlayerInfo.node_width = 300;
    this.nativePlayerInfo.node_height = 150;
    this.nativePlayerInfo.destroyed();
  }
  enterFullscreen() {
    console.log('NativeMediaPlayerImpl.enterFullscreen');
  }
  exitFullscreen() {
    console.log('NativeMediaPlayerImpl.exitFullscreen');
  }
}

// 监听NativeMediaPlayer的状态，然后通过 webview.NativeMediaPlayerHandler 将状态上报给 ArkWeb 内核。
class AVPlayerListenerImpl implements AVPlayerListener {
  handler: webview.NativeMediaPlayerHandler;
  component: NativePlayerComponent;

  constructor(handler: webview.NativeMediaPlayerHandler, component: NativePlayerComponent) {
    this.handler = handler;
    this.component = component;
  }
  onPlaying() {
    console.log('AVPlayerListenerImpl.onPlaying');
    this.handler.handleStatusChanged(webview.PlaybackStatus.PLAYING);
  }
  onPaused() {
    console.log('AVPlayerListenerImpl.onPaused');
    this.handler.handleStatusChanged(webview.PlaybackStatus.PAUSED);
  }
  onDurationChanged(duration: number) {
    console.log(`AVPlayerListenerImpl.onDurationChanged(${duration})`);
    this.handler.handleDurationChanged(duration);
  }
  onBufferedTimeChanged(buffered: number) {
    console.log(`AVPlayerListenerImpl.onBufferedTimeChanged(${buffered})`);
    this.handler.handleBufferedEndTimeChanged(buffered);
  }
  onTimeUpdate(time: number) {
    this.handler.handleTimeUpdate(time);
  }
  onEnded() {
    console.log('AVPlayerListenerImpl.onEnded');
    this.handler.handleEnded();
  }
  onError() {
    console.log('AVPlayerListenerImpl.onError');
    this.component.has_error = true;
    setTimeout(()=>{
      this.handler.handleError(1, 'Oops!');
    }, 200);
  }
  onVideoSizeChanged(width: number, height: number) {
    console.log(`AVPlayerListenerImpl.onVideoSizeChanged(${width}, ${height})`);
    this.handler.handleVideoSizeChanged(width, height);
    this.component.onSizeChanged(width, height);
  }
  onDestroyed(): void {
    console.log('AVPlayerListenerImpl.onDestroyed');
  }
}

interface ComponentParams {
  text: string;
  text2: string;
  playerInfo: NativePlayerInfo;
  handler: webview.NativeMediaPlayerHandler;
  player: NativeMediaPlayerImpl;
}

// 自定义的播放器组件
@Component
struct NativePlayerComponent {
  params?: ComponentParams;
  @State bgColor: Color = Color.Red;
  mXComponentController: XComponentController = new XComponentController();

  videoController: VideoController = new VideoController();
  offset_x: number = 0;
  offset_y: number = 0;
  @State video_width_percent: number = 100;
  @State video_height_percent: number = 100;
  view_width: number = 0;
  view_height: number = 0;
  video_width: number = 0;
  video_height: number = 0;

  fullscreen: boolean = false;
  @State has_error: boolean = false;

  onSizeChanged(width: number, height: number) {
    this.video_width = width;
    this.video_height = height;
    let scale: number = this.view_width / width;
    let scaled_video_height: number = scale * height;
    this.video_height_percent = scaled_video_height / this.view_height * 100;
    console.log(
      `NativePlayerComponent.onSizeChanged(${width},${height}), video_height_percent[${this.video_height_percent }]`);
  }

  build() {
    Column() {
      Stack() {
        XComponent({ id: 'video_player_id', type: XComponentType.SURFACE, controller: this.mXComponentController })
          .width(this.video_width_percent + '%')
          .height(this.video_height_percent + '%')
          .onLoad(()=>{
            if (!this.params) {
              console.log('this.params is null');
              return;
            }
            console.log('NativePlayerComponent.onLoad, params[' + this.params
              + '], text[' + this.params.text + '], text2[' + this.params.text2
              + '], web_tab[' + this.params.playerInfo + '], handler[' + this.params.handler + ']');
            this.params.player.nativePlayer.setSurfaceID(this.mXComponentController.getXComponentSurfaceId());

            this.params.player.nativePlayer.avPlayerLiveDemo({
              url: this.params.player.mediaSource,
              listener: new AVPlayerListenerImpl(this.params.handler, this),
              httpHeaders: this.params.player.httpHeaders,
            });
          })
        Column() {
          Row() {
            Button(this.params?.text)
              .height(50)
              .border({ width: 2, color: Color.Red })
              .backgroundColor(this.bgColor)
              .onClick(()=>{
                console.log(`NativePlayerComponent.Button[${this.params?.text}] is clicked`);
                this.params?.player.nativePlayer?.play();
              })
              .onTouch((event: TouchEvent) => {
                event.stopPropagation();
              })
            Button(this.params?.text2)
              .height(50)
              .border({ width: 2, color: Color.Red })
              .onClick(()=>{
                console.log(`NativePlayerComponent.Button[${this.params?.text2}] is clicked`);
                this.params?.player.nativePlayer?.pause();
              })
              .onTouch((event: TouchEvent) => {
                event.stopPropagation();
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceEvenly)
        }
        if (this.has_error) {
          Column() {
            Text('Error')
              .fontSize(30)
          }
          .backgroundColor('#eb5555')
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
        }
      }
    }
    .width('100%')
    .height('100%')
    .onAreaChange((oldValue: Area, newValue: Area) => {
      console.log(`NativePlayerComponent.onAreaChange(${JSON.stringify(oldValue)}, ${JSON.stringify(newValue)})`);
      this.view_width = new Number(newValue.width).valueOf();
      this.view_height = new Number(newValue.height).valueOf();
      this.onSizeChanged(this.video_width, this.video_height);
    })
  }
}

@Builder
function NativePlayerComponentBuilder(params: ComponentParams) {
  NativePlayerComponent({ params: params })
    .backgroundColor(Color.Green)
    .border({ width: 1, color: Color.Brown })
    .width('100%')
    .height('100%')
}

// 通过 NodeController 来动态创建自定义的播放器组件， 并将组件内容绘制到 surfaceId 指定的 surface 上。
class MyNodeController extends NodeController {
  private rootNode: BuilderNode<[ComponentParams]> | undefined;
  playerInfo: NativePlayerInfo;
  listener: webview.NativeMediaPlayerHandler;
  player: NativeMediaPlayerImpl;

  constructor(playerInfo: NativePlayerInfo,
    surfaceId: string,
    listener: webview.NativeMediaPlayerHandler,
    player: NativeMediaPlayerImpl,
    renderType: NodeRenderType) {
    super();
    this.playerInfo = playerInfo;
    this.listener = listener;
    this.player = player;
    let uiContext = AppStorage.get<UIContext>('UIContext');
    this.rootNode = new BuilderNode(uiContext as UIContext, { surfaceId: surfaceId, type: renderType });
    console.log(
      `MyNodeController,
      rootNode[${this.rootNode}],
      playerInfo[${playerInfo}],
      listener[${listener}],
      surfaceId[${surfaceId}]`);
  }

  makeNode(): FrameNode | null {
    if (this.rootNode) {
      return this.rootNode.getFrameNode() as FrameNode;
    }
    return null;
  }

  build() {
    let params: ComponentParams = {
      'text': 'play',
      'text2': 'pause',
      playerInfo: this.playerInfo,
      handler: this.listener,
      player: this.player
    };
    if (this.rootNode) {
      this.rootNode.build(wrapBuilder(NativePlayerComponentBuilder), params);
    }
  }

  postTouchEvent(event: TouchEvent) {
    return this.rootNode?.postTouchEvent(event);
  }
}

class Rect {
  x: number = 0;
  y: number = 0;
  width: number = 0;
  height: number = 0;

  static toNodeRect(rectInPx: webview.RectEvent) : Rect {
    let rect = new Rect();
    rect.x = px2vp(rectInPx.x);
    rect.y = px2vp(rectInPx.x);
    rect.width = px2vp(rectInPx.width);
    rect.height = px2vp(rectInPx.height);
    return rect;
  }
}

@Observed
class NativePlayerInfo {
  public web: WebComponent;
  public embed_id: string;
  public player: webview.NativeMediaPlayerBridge;
  public node_controller?: MyNodeController;
  public show_native_media_player: boolean = false;
  public node_pos_x: number;
  public node_pos_y: number;
  public node_width: number;
  public node_height: number;

  playerComponent?: NativeMediaPlayerComponent;

  constructor(web: WebComponent, handler: webview.NativeMediaPlayerHandler, videoInfo: webview.MediaInfo) {
    this.web = web;
    this.embed_id = videoInfo.embedID;

    let node_rect = Rect.toNodeRect(videoInfo.surfaceInfo.rect);
    this.node_pos_x = node_rect.x;
    this.node_pos_y = node_rect.y;
    this.node_width = node_rect.width;
    this.node_height = node_rect.height;

    this.player = new NativeMediaPlayerImpl(this, handler, videoInfo);
  }

  updateNativePlayerRect(x: number, y: number, width: number, height: number) {
    this.playerComponent?.updateNativePlayerRect(x, y, width, height);
  }

  destroyed() {
    let info_list = this.web.native_player_info_list;
    console.log(`NativePlayerInfo[${this.embed_id}] destroyed, list.size[${info_list.length}]`);
    this.web.native_player_info_list = info_list.filter((item) => item.embed_id != this.embed_id);
    console.log(`NativePlayerInfo after destroyed, new_list.size[${this.web.native_player_info_list.length}]`);
  }
}

@Component
struct NativeMediaPlayerComponent {
  @ObjectLink playerInfo: NativePlayerInfo;

  aboutToAppear() {
    this.playerInfo.playerComponent = this;
  }

  build() {
    NodeContainer(this.playerInfo.node_controller)
      .width(this.playerInfo.node_width)
      .height(this.playerInfo.node_height)
      .offset({x: this.playerInfo.node_pos_x, y: this.playerInfo.node_pos_y})
      .backgroundColor(Color.Transparent)
      .border({ width: 2, color: Color.Orange })
      .onAreaChange((oldValue, newValue) => {
        console.log(
          `NodeContainer[${this.playerInfo.embed_id}].onAreaChange(
            [${oldValue.width} x ${oldValue.height}]->[${newValue.width} x ${newValue.height}]`));
      })
  }

  updateNativePlayerRect(x: number, y: number, width: number, height: number) {
    let node_rect = Rect.toNodeRect({x, y, width, height});
    this.playerInfo.node_pos_x = node_rect.x;
    this.playerInfo.node_pos_y = node_rect.y;
    this.playerInfo.node_width = node_rect.width;
    this.playerInfo.node_height = node_rect.height;
  }
}

@Entry
@Component
struct WebComponent {
  controller: WebviewController = new webview.WebviewController();
  page_url: Resource = $rawfile('main.html');

  @State native_player_info_list: NativePlayerInfo[] = [];

  area?: Area;

  build() {
    Column() {
      Stack({alignContent: Alignment.TopStart}) {
        ForEach(this.native_player_info_list, (item: NativePlayerInfo) => {
          if (item.show_native_media_player) {
            NativeMediaPlayerComponent({ playerInfo: item })
          }
        }, (item: NativePlayerInfo) => {
          return item.embed_id;
        })
        Web({ src: this.page_url, controller: this.controller })
          .enableNativeMediaPlayer({ enable: true, shouldOverlay: true })
          .onPageBegin(() => {
            this.controller.onCreateNativeMediaPlayer((
              handler: webview.NativeMediaPlayerHandler, mediaInfo: webview.MediaInfo) => {
              console.log('onCreateNativeMediaPlayer(' + JSON.stringify(mediaInfo) + ')');
              let nativePlayerInfo = new NativePlayerInfo(this, handler, mediaInfo);
              this.native_player_info_list.push(nativePlayerInfo);
              return nativePlayerInfo.player;
            });
          })
          .onNativeEmbedGestureEvent((event) => {
            if (!event.touchEvent || !event.embedId) {
              event.result?.setGestureEventResult(false);
              return;
            }
            console.log(`WebComponent.onNativeEmbedGestureEvent, embedId[${event.embedId}]`);
            let native_player_info = this.getNativePlayerInfoByEmbedId(event.embedId);
            if (!native_player_info) {
              console.log(`WebComponent.onNativeEmbedGestureEvent, embedId[${event.embedId}], no native_player_info`);
              event.result?.setGestureEventResult(false);
              return;
            }
            if (!native_player_info.node_controller) {
              console.log(`WebComponent.onNativeEmbedGestureEvent, embedId[${event.embedId}], no node_controller`);
              event.result?.setGestureEventResult(false);
              return;
            }
            let ret = native_player_info.node_controller.postTouchEvent(event.touchEvent);
            console.log(`WebComponent.postTouchEvent, ret[${ret}], touchEvent[${JSON.stringify(event.touchEvent)}]`);
            event.result?.setGestureEventResult(ret);
          })
          .width('100%')
          .height('100%')
          .onAreaChange((oldValue: Area, newValue: Area) => {
            oldValue;
            this.area = newValue;
          })
      }
    }
  }

  getNativePlayerInfoByEmbedId(embedId: string) : NativePlayerInfo | undefined {
    return this.native_player_info_list.find((item)=> item.embed_id == embedId);
  }
}
