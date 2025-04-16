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

import fs from '@ohos.file.fs';
import { BusinessError } from '@kit.BasicServicesKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit'; // 相册管理模块
import { promptAction } from '@kit.ArkUI';
import router from '@ohos.router';
import { CustomTabBar } from '../customcomponents/CustomTabBar';
import { logger } from '../utils/Logger';
import { TabBarType } from '../model/TabBarModel';
import { VideoPlayListener } from '../videoplaycomponents/VideoPlayListener';
import { WorkItem, WORK_LIST_DATA } from '../model/WorkItemModel';
import { WorkListDataSource } from '../model/WorkListDataSource';
import { XComponentVideo } from '../videoplaycomponents/XComponentVideo';

const CACHE_COUNT: number = 4; // 列表预加载数量
const LIST_FRICTION: number = 0.6; // 搜索框的摩擦力
const VIDEO_LIST_LAYOUT_WEIGHT: number = 1; // 视频列表权重

const TAG: string = 'videoTrimmer_videolist';

/**
 * 功能描述：本示例主要介绍视频的剪辑压缩及保存到服务器。使用FFmpeg命令对相册中的视频选取时间段进行压缩、剪辑，并使用request.agent将剪辑后的视频保存到服务器。
 *
 * 推荐场景：在平台上发布视频
 *
 * 核心组件：
 * 1.VideoTrimmerView 视频裁剪组件
 * 2.RangeSeekBarView 裁剪范围选择
 * 3.VideoTrimmerOption 裁剪选项，定义了裁剪最大、最小时间以及压缩比
 * 4.RequestUpload 上传类，将文件上传到服务器
 * 5.RequestDownload 下载类，从服务器上下载文件到本地
 *
 * 实现步骤：
 * 1. 实行顶部栏TopBar()，点击顶部栏的“添加”按钮从相册中选择视频进行剪辑保存等操作。
 * 2. 使用LazyForEach渲染当前已发布的视频信息，并实现时间轴效果。
 * 3. 点击某一条视频信息的图片进入到该视频的浏览界面。
 * 4. 点击视频浏览界面右上角的图片按钮，打开“分享到”界面，点击分享界面里的下载按钮，将该视频下载到相册。
 * 5. 点击顶部栏的“添加”按钮，从相册中选择要编辑的视频，选取后会将视频保存到缓存中。
 * 6. 通过MP4Parser的ffmpegCmd方法截取缓存中视频的首页图片进行显示。
 * 7. 点击顶部右上角的“保存”按钮，可以将缓存中的视频上传到服务器进行保存；点击视频的图片则进入到视频裁剪界面。
 * 8. 在视频裁剪界面，选取要裁剪的时间段后，点击底部“完成”按钮，裁剪成功后会返回到上一个界面进行保存。
 */

@Component
export struct VideoTrimmerHomePage {
  @State currentIndex: TabBarType = TabBarType.DISCOVER; // Tab组件当前选中index值
  private workList: WorkListDataSource = new WorkListDataSource(); // 视频信息集合
  @StorageLink('addWorkItem') @Watch('getUploadWorkItem') addWorkItem: WorkItem =
    new WorkItem('', '', '', '', '', true); // 上传到服务器的视频信息
  @State isLoading: boolean = true; // 视频是否加载中
  @State centerIndex: number = -1; // List显示区域内中间子组件索引值
  @State localSelectVideoUrl: Array<string> = []; // 选择的图片视频地址
  controller: VideoController = new VideoController();
  @State isPlaying: boolean = false; // 是否播放状态
  // 视频播放回调接口
  @State mVideoPlayListener: VideoPlayListener = {
    onPrepared: () => {
    },
    onPlayStatus: (isPlay: boolean) => {
      this.isPlaying = isPlay;
    },
    onComplete() {
    },
    onTimeUpdate(time: number) {
    },
    onBitrateUpdate(bitrateList: number[]) {
    },
    onErrorUpdate(error: string) {
    },
  }

  // 获取并添加新发表的视频信息
  getUploadWorkItem(): void {
    if (this.addWorkItem.videoSrc !== undefined && this.addWorkItem.videoSrc !== '') {
      logger.info(TAG,
        `videoTrimmer_upload back, isDayTop:${this.addWorkItem.isDayTop}, date: ${this.addWorkItem.date}`);
      this.workList.addData(0, this.addWorkItem);
      AppStorage.setOrCreate('addWorkItem', new WorkItem('', '', '', '', '', false));
    }
  }

  /**
   * 将图库中的视频保存到沙箱中
   */
  async saveFileToSandbox(filePathString: string): Promise<void> {
    this.localSelectVideoUrl[0] = filePathString;
    try {
      // 打开图库中视频的文件
      let resFile = fs.openSync(filePathString, fs.OpenMode.READ_ONLY);

      const dateStr = (new Date().getTime()).toString()
      let newPath = getContext().cacheDir + '/' + `${dateStr + resFile.name}`;
      // 将图库中的视频保存到沙箱中
      fs.copyFileSync(resFile.fd, newPath);
      // 新的路径
      this.localSelectVideoUrl[0] = newPath;
      logger.info(TAG,
        `selectPhotoFromAlbum, VideoUpload url:${this.localSelectVideoUrl[0].toString()}`);
      if (this.localSelectVideoUrl[0] !== undefined && this.localSelectVideoUrl[0] !== '') {
        // 进入到视频剪辑页面
        router.pushUrl({
          url: 'pages/VideoUpload',
          params: { value: this.localSelectVideoUrl[0] }
        })
      }
    } catch (err) {
      logger.error(TAG, `selectPhotoFromAlbum.select failed :, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  /**
   * 拉起图库选择视频
   */
  async selectVideoFromAlbum(): Promise<void> {
    // 创建图库选项实例
    const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    // 设置选择的媒体文件类型
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE;
    // 设置选择媒体文件的最大数目
    photoSelectOptions.maxSelectNumber = 1;
    // 创建图库选择器实例
    const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
    // 调用photoViewPicker.select()接口拉起图库界面进行图片选择，图片选择成功后，返回photoSelectResult结果集。
    photoViewPicker.select(photoSelectOptions).then((photoSelectResult) => {
      if (photoSelectResult !== null && photoSelectResult !== undefined) {
        // 将视频保存到沙箱中
        this.saveFileToSandbox(photoSelectResult.photoUris[0]);
      }
    }).catch((err: BusinessError) => {
      logger.error(TAG,
        `selectPhotoFromAlbum PhotoViewPicker.select failed :, error code: ${err.code}, message: ${err.message}.`);
    })
  }

  aboutToAppear(): void {
    // 将视频是信息推入空数组
    WORK_LIST_DATA.forEach((work: WorkItem) => {
      this.workList.pushData(work);
    })
  }

  build() {
    Column() {
      this.TopBar();
      this.LazyForEachListPage();
      CustomTabBar({ currentIndex: $currentIndex });
    }
    .backgroundColor(Color.Black)
    .height($r('app.string.video_trimmer_full_size'))
  }

  /**
   * 顶部栏
   */
  @Builder
  TopBar() {
    Row() {
      Blank()
      Text($r('app.string.video_trimmer_workitem'))
        .fontSize($r('app.integer.video_trimmer_video_item_news_name_font_size'))
        .fontWeight(FontWeight.Normal)
        .fontColor(Color.White)
      Blank()
      Text($r('app.string.video_trimmer_btn_add'))
        .id('txt_add_video')
        .fontSize($r('app.integer.video_trimmer_video_item_news_name_font_size'))
        .fontWeight(FontWeight.Normal)
        .fontColor(Color.White)
        .margin({ right: $r('app.integer.video_trimmer_top_padding') })
        .alignSelf(ItemAlign.End)
        .onClick(async () => {
          // 调用Toast显示提示:此样式仅为案例展示
          await this.selectVideoFromAlbum();
        })
    }
    .padding({ top: $r('app.integer.video_trimmer_top_padding'), bottom: $r('app.integer.video_trimmer_top_padding') })
    .width($r('app.string.video_trimmer_full_size'))
    .backgroundColor($r('app.color.video_trimmer_list_detail_color'))
    .justifyContent(FlexAlign.SpaceAround)
  }

  // 绘制单个视频
  @Builder
  drawVideoItem(workItem: WorkItem, index: number) {
    Row() {
      // 画左边时间轴
      Column() {
        if (workItem.isDayTop) {
          Column()
            .width(1)
            .height($r('app.integer.video_trimmer_list_item_top_height'))
            .backgroundColor(Color.Gray)
          Column() {
            Circle()
              .width($r('app.integer.video_trimmer_list_item_circle_size'))
              .height($r('app.integer.video_trimmer_list_item_circle_size'))
              .strokeWidth($r('app.integer.video_trimmer_list_item_circle_stroke'))
              .stroke(Color.Yellow)
              .margin({
                top: $r('app.integer.video_trimmer_list_item_circle_margin'),
                bottom: $r('app.integer.video_trimmer_list_item_circle_margin')
              })
          }
          .position({
            x: $r('app.integer.video_trimmer_list_item_time_position_x'),
            y: $r('app.integer.video_trimmer_list_item_time_position_y')
          })
          .width($r('app.integer.video_trimmer_list_item_time_top_width'))
          .height($r('app.integer.video_trimmer_list_item_time_top_height'))
        }
        Column()
          .width(1)
          .height($r('app.integer.video_trimmer_video_height_day'))
          .backgroundColor(Color.Gray)
      }
      .width(1)
      .height(workItem.isDayTop ? $r('app.integer.video_trimmer_video_height_daytop') :
      $r('app.integer.video_trimmer_video_height_day'))
      .margin({ left: $r('app.integer.video_trimmer_list_item_time_top_maigin_left') })

      // 画视频区域
      Column() {
        // 顶部日期信息
        this.VideoTop(workItem, index);
        // 视频播放组件
        XComponentVideo({
          centerIndex: this.centerIndex,
          work: workItem,
          index: index,
          isPlaying: this.isPlaying,
          videoPlayListener: this.mVideoPlayListener,
          onXComponentClick: (videoSrc: string) => {
            router.pushUrl({
              url: 'pages/VideoDetail',
              params: { value: videoSrc }
            })
          },
        })
          .id('video_index_' + index.toString())
          .height($r('app.integer.video_trimmer_component_video_height'))
          .backgroundColor($r('app.color.video_trimmer_list_detail_color'))
        // 底部详细信息
        this.VideoBottomDetail(workItem, index);
      }
      .margin({
        left: $r('app.integer.video_trimmer_list_item_xc_margin_left'),
        right: $r('app.integer.video_trimmer_list_item_xc_margin_right')
      })
      .height(workItem.isDayTop ? $r('app.integer.video_trimmer_video_height_daytop') :
      $r('app.integer.video_trimmer_video_height_day'))
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width($r('app.string.video_trimmer_full_size'))
    .height(workItem.isDayTop ? $r('app.integer.video_trimmer_video_height_daytop') :
    $r('app.integer.video_trimmer_video_height_day'))
  }

  @Builder
  VideoTop(item: WorkItem, index: number) {
    if (item.isDayTop) {
      Row() {
        Text(item.date)
          .width($r('app.string.video_trimmer_full_size'))
          .fontSize($r('app.integer.video_trimmer_video_item_news_name_font_size'))
          .fontColor(Color.White)
          .alignSelf(ItemAlign.Start)
          .align(Alignment.Start)
      }
      .padding({ top: $r('app.integer.video_trimmer_top_date_padding') })
      .height($r('app.integer.video_trimmer_list_item_date_height'))
      .width($r('app.string.video_trimmer_full_size'))
    }
  }

  /**
   * 视频底部详情页面
   */
  @Builder
  VideoBottomDetail(item: WorkItem, index: number) {
    Row() {
      Text(item.labels)
        .fontSize($r('app.integer.video_trimmer_video_item_news_performer_font_size'))
        .fontColor(Color.White)
        .alignSelf(ItemAlign.Start)
        .align(Alignment.Start)
    }
    .padding({ top: $r('app.integer.video_trimmer_top_padding') })
    .justifyContent(FlexAlign.SpaceBetween)
    .width($r('app.string.video_trimmer_full_size'))
    .height($r('app.integer.video_trimmer_list_detail_height'))
    .backgroundColor($r('app.color.video_trimmer_list_detail_color'))

    Row() {
      Text(item.author + ' ' + item.time)
        .fontSize($r('app.integer.video_trimmer_font_size_12'))
        .fontColor(Color.White)
      Image($r('app.media.video_trimmer_chat'))
        .height($r('app.integer.video_trimmer_list_chat_img_size'))
        .width($r('app.integer.video_trimmer_list_chat_img_size'))
        .objectFit(ImageFit.ScaleDown)
        .backgroundColor($r('app.color.video_trimmer_list_detail_color'))
        .onClick(() => {
          // 调用Toast显示提示:此样式仅为案例展示
          promptAction.showToast({ message: $r('app.string.video_trimmer_toast_tips') });
        })
    }
    .padding({ bottom: $r('app.integer.video_trimmer_top_padding') })
    .height($r('app.integer.video_trimmer_list_detail_height'))
    .width($r('app.string.video_trimmer_full_size'))
    .backgroundColor($r('app.color.video_trimmer_list_detail_color'))
    .justifyContent(FlexAlign.SpaceBetween)
  }

  /**
   * 视频列表视图
   */
  @Builder
  LazyForEachListPage() {
    Column() {
      List() {
        LazyForEach(this.workList, (work: WorkItem, index: number) => {
          ListItem() {
            this.drawVideoItem(work, index);
          }
        }, (item: string) => item)
      }
      // TODO：知识点：LazyForEach懒加载可以通过设置cachedCount来指定缓存数量，在设置cachedCount后，除屏幕内显示的ListItem组件外，
      // 还会预先将屏幕可视区外指定数量的列表项数据缓存。
      .cachedCount(CACHE_COUNT)
      .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
        this.centerIndex = centerIndex; // 获取List显示区域内中间子组件索引值
      })
      .listDirection(Axis.Vertical) // 排列方向
      .scrollBar(BarState.Off)
      .friction(LIST_FRICTION)
      .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
      .width($r('app.string.video_trimmer_lazy_foreach_list_page_list_width'))
      .height($r('app.string.video_trimmer_lazy_foreach_list_page_width'))
    }
    .width($r('app.string.video_trimmer_lazy_foreach_list_page_width'))
    .height($r('app.string.video_trimmer_lazy_foreach_list_page_width'))
    .padding({ top: $r('app.integer.video_trimmer_lazy_foreach_list_page_list_padding_top') })
    .layoutWeight(VIDEO_LIST_LAYOUT_WEIGHT)
  }
}