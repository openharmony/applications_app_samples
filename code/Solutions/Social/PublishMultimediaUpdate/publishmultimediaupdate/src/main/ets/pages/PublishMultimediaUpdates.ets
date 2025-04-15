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
import { promptAction, ToolBar, ToolBarOptions, ItemState } from '@kit.ArkUI';
import { FriendMoment, CommentData } from '../model/BasicDataSource';
import { OneMoment } from '../components/OneMoment';
import { ListConstants } from '../constants/ListConstants';
import { mockData } from '../model/mockdata';
import { CommentInputDialog } from './CommentInputDialog';

const typeVideo: string = 'video';
const typeText: string = 'text';
const typeImage: string = 'image';

/**
 * 功能描述: 本示例主要介绍使用@ohos.file.photoAccessHelper实现访问系统相册获取媒体资源的多媒体发布场景
 *
 * 推荐场景: 需要调用系统图库的场景，如：上传图库图片、发布朋友圈等
 *
 * 核心组件:
 * 1. CommentInputDialog
 *
 * 实现步骤：
 * 1.使用LazyForEach+cacheCount+@Reusable实现懒加载列表。
 * 2.创建ListScroller对象，将ListScroller对象绑定到List组件内。
 * 3.在需要记录当前位置时通过currentOffset方法存储当前偏移量historyOffset，在需要跳转时用scrollTo方法跳转。
 */
@Component
export struct PublishMultimediaUpdates {
  private cachedCountNumber: number = 3; // 懒加载缓存数
  @State toolbarList: ToolBarOptions = new ToolBarOptions()
  private controller1: TabsController = new TabsController()
  listScroller: ListScroller = new ListScroller(); // scroller控制器
  @State commentList: CommentData = new CommentData(); // 评论列表
  @State textInComment: string = ''; // 评论中的文字
  @State imageInComment: string = ''; // 评论中的图片列表
  @State videoInComment: string = '' // 评论中的视频列表
  @State dialogType: string = typeText; // 弹窗类型
  private scroller: ListScroller = new ListScroller();
  // 评论输入弹窗
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CommentInputDialog({
      textInComment: $textInComment,
      imagesInComment: $imageInComment,
      videoInComment: $videoInComment,
      dialogType: $dialogType,
      publish: () => this.publishComment()
    }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    offset: {
      dx: $r('app.integer.image_comment_dialog_offset_x'),
      dy: $r('app.integer.image_comment_dialog_offset_y')
    }
  });

  aboutToAppear(): void {
    // 加载初始数据
    this.commentList = mockData();
    // 加载toolbar数据
    this.toolbarList.push({
      content: $r('app.string.toolbarList_home'),
      icon: $r('app.media.backgroundblur_main_normal'),
      action: () => {
      },
      state: ItemState.ACTIVATE
    })
    this.toolbarList.push({
      content: $r('app.string.toolbarList_discover'),
      icon: $r('app.media.backgroundblur_find_normal'),
      action: () => {
        promptAction.showToast({
          message: $r('app.string.publish_multimedia_updates_other_function'),
        });
      },
    })
    this.toolbarList.push({
      content: $r('app.string.toolbarList_Super_Group'),
      icon: $r('app.media.backgroundblur_hot_normal'),
      action: () => {
        promptAction.showToast({
          message: $r('app.string.publish_multimedia_updates_other_function'),
        });
      },
    })
    this.toolbarList.push({
      content: $r('app.string.toolbarList_Message'),
      icon: $r('sys.media.ohos_ic_public_email'),
      action: () => {
        promptAction.showToast({
          message: $r('app.string.publish_multimedia_updates_other_function'),
        });
      },
    })
    this.toolbarList.push({
      content: $r('app.string.toolbarList_more'),
      icon: $r('sys.media.ohos_ic_public_more'),
      action: () => {
        promptAction.showToast({
          message: $r('app.string.publish_multimedia_updates_other_function'),
        });
      },
    })


  }

  getCurrentDate(): string {
    const date: Date = new Date();
    return `${date.getFullYear()}-${date.getMonth()}-${date.getDay()} ${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`;
  }

  publishComment(): void {
    // 发布图片，须有选择图片
    if (this.dialogType == typeImage) {
      if (this.imageInComment !== undefined && this.imageInComment !== '') {
        const comment: FriendMoment =
          new FriendMoment(this.getCurrentDate(), '我的', $r('app.media.publish_multimedia_updates_photo0'),
            this.textInComment, this.imageInComment);
        this.commentList.addDataFirst(comment);
      } else {
        promptAction.showToast({
          message: $r('app.string.publish_multimedia_updates_input_image'),
        });
      }
    } else if (this.dialogType == typeVideo) {
      // 发布视频，须有视频
      if (this.videoInComment !== undefined && this.videoInComment !== '') {
        const comment: FriendMoment =
          new FriendMoment(this.getCurrentDate(), '我的', $r('app.media.publish_multimedia_updates_photo0'),
            this.textInComment, '', this.videoInComment);
        this.commentList.addDataFirst(comment);
      } else {
        promptAction.showToast({
          message: $r('app.string.publish_multimedia_updates_input_video'),
        });
      }
    } else if (this.dialogType == typeText) {
      if (this.textInComment) {
        const comment: FriendMoment =
          new FriendMoment(this.getCurrentDate(), '我的', $r('app.media.publish_multimedia_updates_photo0'),
            this.textInComment);
        this.commentList.addDataFirst(comment);
      } else {
        promptAction.showToast({
          message: $r('app.string.publish_multimedia_updates_input_comment'),
        });
      }
    }

    this.scroller.scrollToIndex(0, true, ScrollAlign.START);
  }

  aboutToDisappear() {
    // 将dialogController置空
    this.dialogController = null;
  }

  @Builder
  MyMenu() {
    Menu() {
      MenuItem({
        startIcon: $r('sys.media.ohos_ic_public_text'),
        content: $r('app.string.publish_multimedia_updates_post')
      })
        .onClick(() => {
          this.dialogType = typeText
          if (this.dialogController !== null) {
            // 打开评论输入弹窗
            this.dialogController.open();
          }
        })
        .id('Post')
      MenuItem({
        startIcon: $r('sys.media.save_button_picture'),
        content: $r('app.string.publish_multimedia_updates_photo')
      })
        .onClick(() => {
          this.dialogType = typeImage
          if (this.dialogController !== null) {
            // 打开评论输入弹窗
            this.dialogController.open();
          }
        })
        .id('Photo')
      MenuItem({
        startIcon: $r('sys.media.ohos_ic_public_video'),
        content: $r('app.string.publish_multimedia_updates_video')
      })
        .onClick(() => {
          this.dialogType = typeVideo
          if (this.dialogController !== null) {
            // 打开评论输入弹窗
            this.dialogController.open();
          }
        })
        .id('Video')
      MenuItem({
        startIcon: $r('app.media.camera'),
        content: $r('app.string.publish_multimedia_updates_review')
      })
        .onClick(() => {
          promptAction.showToast({
            message: $r('app.string.publish_multimedia_updates_other_function'),
          });
        })
      MenuItem({
        startIcon: $r('sys.media.ohos_ic_public_camera'),
        content: $r('app.string.publish_multimedia_updates_live')
      })
        .onClick(() => {
          promptAction.showToast({
            message: $r('app.string.publish_multimedia_updates_other_function'),
          });
        })
    }
    .width($r('app.string.publish_multimedia_updates_layout_40'))
  }

  @Builder
  MyADD() {
    Image($r('sys.media.ohos_ic_public_add'))
      .bindMenu(this.MyMenu())
      .width($r('app.string.publish_multimedia_updates_layout_40'))
      .height($r('app.string.publish_multimedia_updates_layout_40'))
      .position({ top: 20, right: 5 })
      .id('add_button')
  }

  @Builder
  Camera() {
    Image($r('sys.media.ohos_ic_public_camera'))
      .width($r('app.string.publish_multimedia_updates_layout_30'))
      .position({ top: 15, left: 10 })
  }

  build() {
    Row() {
      Tabs({ controller: this.controller1, index: 1 }) {
        TabContent() {
        }.tabBar(this.Camera())


        TabContent() {
          Column() {
            List({ space: ListConstants.LIST_SPACE, scroller: this.listScroller }) {
              // TODO：高性能知识点：列表数据较多，不需要全部渲染上屏，采用LazyForEach。
              LazyForEach(this.commentList, (moment: FriendMoment) => {
                ListItem() {
                  OneMoment({ moment: moment });

                }
              }, (moment: FriendMoment) => moment.id)
            }
            // TODO：高性能知识点：为保证滑动流畅，采用cachedCount缓存前后节点。
            .cachedCount(this.cachedCountNumber)
            .width($r('app.string.publish_multimedia_updates_layout_100'))
            .layoutWeight(1)
            .listDirection(Axis.Vertical)
            .divider({
              strokeWidth: $r('app.integer.publish_multimedia_updates_divider_width'),
              color: $r('app.color.publish_multimedia_updates_divider_color'),
              startMargin: $r('app.integer.publish_multimedia_updates_list_divider_margin'),
              endMargin: $r('app.integer.publish_multimedia_updates_list_divider_margin')
            })

            ToolBar({
              activateIndex: 0,
              toolBarList: this.toolbarList,
            })
              .height($r('app.integer.toolbar_height'))


          }
          .height($r('app.string.publish_multimedia_updates_layout_100'))
          .width($r('app.string.publish_multimedia_updates_layout_100'))
        }.tabBar($r('app.string.publish_multimedia_updates_following'))
        .height($r('app.string.publish_multimedia_updates_layout_100'))
        .width($r('app.string.publish_multimedia_updates_layout_100'))


        TabContent() {
          Column()
            .width($r('app.string.publish_multimedia_updates_layout_100'))
            .height($r('app.string.publish_multimedia_updates_layout_100'))
            .backgroundColor(Color.Blue)
        }.tabBar($r('app.string.publish_multimedia_updates_for_you'))


        TabContent() {
        }.tabBar(this.MyADD())
      }
      .onContentWillChange((currentIndex, comingIndex) => {
        if (comingIndex == 0 || comingIndex == 2 || comingIndex == 3) {
          promptAction.showToast({
            message: $r('app.string.publish_multimedia_updates_other_function'),
          });
          return false
        }
        if (comingIndex == 0) {
          return false
        }
        return true
      })
      .vertical(false)
      .barMode(BarMode.Fixed)
      .height($r('app.string.publish_multimedia_updates_layout_100'))
      .width($r('app.string.publish_multimedia_updates_layout_100'))
      .barWidth($r('app.integer.publish_multimedia_updates_list_barwidth'))
      .barHeight($r('app.integer.publish_multimedia_updates_list_barheight'))
    }
    .alignItems(VerticalAlign.Center)
    .height($r('app.string.publish_multimedia_updates_layout_100'))
    .width($r('app.string.publish_multimedia_updates_layout_100'))
  }
}