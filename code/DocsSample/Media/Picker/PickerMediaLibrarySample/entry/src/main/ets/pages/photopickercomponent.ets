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

// [Start PhotoPickerComponent_drawer]
import { display } from '@kit.ArkUI';
import { PhotoPickerComponent, PickerController, PickerOptions } from '@kit.MediaLibraryKit';
const enum DrawerState {
  Expanding,
  Collapsing,
  Sliding
}

@Entry
@Component
struct Drawer {
  @State pickerController: PickerController = new PickerController();
  private pickerOptions: PickerOptions = new PickerOptions();
  // 屏幕高度。
  @State screenHeight: number = 0;
  // 抽屉高度。
  @State drawerHeight: number = 0;
  // 抽屉的偏移量。
  @State offsetY: number = 0;
  // 抽屉状态。
  @State isExpanded: boolean = false;
  // 拖拽起始位置。
  private startY: number = 0;
  // 当前拖拽的偏移量。
  private currentOffset: number = 0;
  // 自定义抽屉高度在整个屏幕的占比。
  private drawerRation: number = 0.8;
  // 初始化为收缩态。
  private drawerState: DrawerState = DrawerState.Collapsing;
  // 手势响应阈值，判断手势是否是向下。
  private pulligDownThreshold: number = -5;

  aboutToAppear(): void {
    // 获取屏幕高度。
    this.screenHeight = px2vp(display.getDefaultDisplaySync().height);
    // 获取抽屉高度。
    this.drawerHeight = this.screenHeight * this.drawerRation;
    // 初始时抽屉在底部（隐藏高度）。
    this.offsetY = this.drawerHeight * 0.8;
    // 初始化时picker不支持滚动。
    this.pickerOptions.isSlidingSupported = false;
    // 无边缘回弹。
    this.pickerOptions.edgeEffect = EdgeEffect.None;
    // 不展示搜索框。
    this.pickerOptions.isSearchSupported = false;
  }

  private scrollStopAtStart() {
    // 状态变更为展开态，同时设置宫格不能滚动。
    this.drawerState = DrawerState.Expanding;
    this.pickerController.updatePickerOptions({
    isSlidingSupported: false
  })
  }

  private toggleDrawer() {
    if (this.isExpanded) {
      this.hideDrawer();
    } else {
      this.showDrawer();
    }
  }

  private hideDrawer() {
    animateTo({
      duration: 300,
      curve: Curve.EaseOut,
      onFinish: () => {
        this.isExpanded = false;
      }
    }, () => {
      this.drawerState = DrawerState.Collapsing;
      this.offsetY = this.drawerHeight * 0.8;
    })
  }

  private showDrawer() {
    animateTo({
      duration: 300,
      curve: Curve.EaseOut,
      onFinish: () => {
        this.isExpanded = true;
      }
    }, () => {
      this.drawerState = DrawerState.Expanding;
      this.offsetY = 0;
    })
  }

  build() {
    RelativeContainer() {
      // 主内容区域。
      Column() {
        Text('主页面内容')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 20 })

        Text('这是一个使用RelativeContainer实现的底部抽屉效果')
          .fontSize(16)
          .fontColor('#666')
          .margin({ bottom: 30 })
          .textAlign(TextAlign.Center)
          .width('80%')

        Button(this.isExpanded ? '收起抽屉' : '展开抽屉')
          .onClick(() => {
            this.toggleDrawer();
          })
      }
      .width('100%')
      .padding(20)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor('#f5f5f5')
      .borderRadius(10)
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      })
      .height('100%')

      if (this.isExpanded) {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('#80000000')
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            left: { anchor: '__container__', align: HorizontalAlign.Start },
            right: { anchor: '__container__', align: HorizontalAlign.End },
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          })
          .onClick(() => {
            this.hideDrawer();
          })
      }

      Column() {
        Row()
          .width(50)
          .height(5)
          .backgroundColor('#CCC')
          .borderRadius(3)
          .margin({ top: 12, bottom: 8 })

        Text('抽屉菜单')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 10 })

        Divider()
          .width('90%')
          .margin({ bottom: 10 })

        PhotoPickerComponent({
          pickerOptions: this.pickerOptions,
          pickerController: this.pickerController,
          onScrollStopAtStart: this.scrollStopAtStart
        })
          .layoutWeight(1)
          .width('100%')
      }
      .width('100%')
      .height(this.drawerHeight)
      .backgroundColor(Color.White)
      .borderRadius({ topLeft: 20, topRight: 20 })
      .shadow({ radius: 10, color: '#33000000' })
      .alignRules({
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End },
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      })
      .translate({ y: this.offsetY })
      .gesture(
        PanGesture({ direction: PanDirection.Vertical })
          // 记录开始拖拽的位置。
          .onActionStart((event: GestureEvent) => {
            this.startY = event.fingerList[0].globalY || 0;
            this.currentOffset = this.offsetY;
          })
          .onActionUpdate((event: GestureEvent) => {
            // 如果是picker滑动状态，不改变抽屉的高度，直接返回。
            if (this.drawerState === DrawerState.Sliding) {
              return;
            }
            // 如果是展开态或者收缩态则需要通过手势来改变状态。
            // 计算移动距离。
            const deltaY = event.fingerList[0].globalY - this.startY || 0;
            // 展开态且向下滑动，那么屏蔽宫格的滑动且状态置为滚动态。
            if (this.drawerState === DrawerState.Expanding && deltaY < this.pulligDownThreshold) {
              this.pickerController.updatePickerOptions({
                isSlidingSupported: true
              })
              this.drawerState = DrawerState.Sliding
            }
            let newOffset = this.currentOffset + deltaY;
            if (newOffset < 0) {
              newOffset = 0;
            }
            this.offsetY = newOffset;
          })
          .onActionEnd(()=>{
            // 手势结束，根据位置自动展开或收起。
            if (this.offsetY > this.drawerHeight / 2) {
              // 滑动超过抽屉一半，收缩态。
              this.hideDrawer();
            } else {
              // 滑动不到抽屉一半，展开态。
              this.showDrawer();
            }
          })
      )
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#E0E0E0')
  }
}
// [End PhotoPickerComponent_drawer]

// [Start PhotoPickerComponent_import]
import {
  PhotoPickerComponent, PickerController, PickerOptions,
  DataType, BaseItemInfo, ItemInfo, PhotoBrowserInfo, ItemType, ClickType,
  MaxCountType, PhotoBrowserRange, PhotoBrowserUIElement,
  ItemsDeletedCallback, ExceedMaxSelectedCallback, CurrentAlbumDeletedCallback, SingleLineConfig,
  BadgeConfig, PreselectedInfo, SaveMode, BadgeType, ItemDisplayRatio,VideoPlayerState
} from '@ohos.file.PhotoPickerComponent';
// [End PhotoPickerComponent_import]

// [Start PhotoPickerComponent_demo_import]
// xxx.ets
import {
  PhotoPickerComponent,
  PickerController,
  PickerOptions,
  DataType,
  BaseItemInfo,
  ItemInfo,
  PhotoBrowserInfo,
  ItemType,
  ClickType,
  MaxCountType,
  PhotoBrowserRange,
  PhotoBrowserUIElement,
  ItemsDeletedCallback,
  ExceedMaxSelectedCallback,
  CurrentAlbumDeletedCallback,
  videoPlayStateChangedCallback,
  VideoPlayerState,
  photoAccessHelper
} from '@kit.MediaLibraryKit';
import { dataSharePredicates } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
// [End PhotoPickerComponent_demo_import]

// [Start PhotoPickerComponent_demo_import_1117]
// xxx.ets
import {
  PhotoPickerComponent,
  PickerController,
  PickerOptions,
  DataType,
  BaseItemInfo,
  ItemInfo,
  PhotoBrowserInfo,
  ItemType,
  ClickType,
  MaxCountType,
  PhotoBrowserRange,
  PhotoBrowserUIElement,
  ItemsDeletedCallback,
  ExceedMaxSelectedCallback,
  CurrentAlbumDeletedCallback,
  videoPlayStateChangedCallback,
  VideoPlayerState
} from '@ohos.file.PhotoPickerComponent';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { dataSharePredicates } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
// [Start PhotoPickerComponent_demo_import_1117]

// [Start PhotoPickerComponent_demo_body]
@Entry
@Component
struct PickerDemo {
  pickerOptions: PickerOptions = new PickerOptions();
  @State pickerController: PickerController = new PickerController();
  @State selectUris: string[] = [];
  @State currentUri: string = '';
  @State isBrowserShow: boolean = false;
  private selectedItemsDeletedCallback: ItemsDeletedCallback =
    (baseItemInfos: Array<BaseItemInfo>) => this.onSelectedItemsDeleted(baseItemInfos);
  private exceedMaxSelectedCallback: ExceedMaxSelectedCallback =
    (exceedMaxCountType: MaxCountType) => this.onExceedMaxSelected(exceedMaxCountType);
  private currentAlbumDeletedCallback: CurrentAlbumDeletedCallback = () => this.onCurrentAlbumDeleted();
  private videoPlayStateChangedCallback: videoPlayStateChangedCallback =
    (state: VideoPlayerState) => this.videoPlayStateChanged(state);
  private thumbnail: PixelMap[] = [];
  private assets: photoAccessHelper.PhotoAsset[] = [];

  aboutToAppear() {
    this.pickerOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
    this.pickerOptions.maxSelectNumber = 5;
    this.pickerOptions.isSearchSupported = false;
    this.pickerOptions.isPhotoTakingSupported = false;
    this.pickerOptions.photoBrowserCheckboxPosition = [0.5, 0.5];
    // 其他属性.....
  }

  private onSelect(uri: string): void {
    // 添加。
    if (uri) {
      this.selectUris.push(uri);
    }
  }

  private onDeselect(uri: string): void {
    // 移除。
    if (uri) {
      this.selectUris = this.selectUris.filter((item: string) => {
        return item != uri;
      })
    }
  }

  private onItemClicked(itemInfo: ItemInfo, clickType: ClickType): boolean {
    if (!itemInfo) {
      return false;
    }
    let type: ItemType | undefined = itemInfo.itemType;
    let uri: string | undefined = itemInfo.uri;
    if (type === ItemType.CAMERA) {
      // 点击相机item。
      return true; // 返回true则拉起系统相机，若应用需要自行处理则返回false。
    } else {
      if (clickType === ClickType.SELECTED) {
        // 应用做自己的业务处理（注：非长耗时操作，例如opensync大文件）。
        if (uri) {
          this.selectUris.push(uri);
          this.pickerOptions.preselectedUris = [...this.selectUris];
        }
        return true; // 返回true则勾选，否则不响应勾选。
      } else {
        if (uri) {
          this.selectUris = this.selectUris.filter((item: string) => {
            return item != uri;
          });
          this.pickerOptions.preselectedUris = [...this.selectUris];
        }
      }
      return true;
    }
  }

  private onEnterPhotoBrowser(photoBrowserInfo: PhotoBrowserInfo): boolean {
    // 进入大图的回调。
    this.isBrowserShow = true;
    return true;
  }

  private onExitPhotoBrowser(photoBrowserInfo: PhotoBrowserInfo): boolean {
    // 退出大图的回调。
    this.isBrowserShow = false;
    return true;
  }

  private onPickerControllerReady(): void {
    // 接收到该回调后，便可通过pickerController相关接口向picker发送数据，在此之前不生效。
    let elements: number[] = [PhotoBrowserUIElement.BACK_BUTTON];
    this.pickerController.setPhotoBrowserUIElementVisibility(elements, false); // 设置大图页不显示返回按钮。
  }

  private onPhotoBrowserChanged(browserItemInfo: BaseItemInfo): boolean {
    // 大图左右滑动的回调。
    this.currentUri = browserItemInfo.uri ?? '';
    return true;
  }

  private onSelectedItemsDeleted(baseItemInfos: Array<BaseItemInfo>): void {
    // 已勾选图片被删除时的回调。
  }

  private onExceedMaxSelected(exceedMaxCountType: MaxCountType): void {
    // 超过最大选择数量再次点击时的回调。
  }

  private onCurrentAlbumDeleted(): void {
    // 当前相册被删除时的回调。
  }

  private videoPlayStateChanged(state: VideoPlayerState): void {
    // 当视频播放状态变化时回调。
  }
  build() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center
    }) {
      Column() {
        if (this.isBrowserShow) {
          // 这里模拟应用自己的大图返回按钮。
          Row() {
            Button('退出大图').width('33%').height('8%').onClick(() => {
              this.pickerController.exitPhotoBrowser();
            })
          }.margin({ bottom: 20 })
        }

        PhotoPickerComponent({
          pickerOptions: this.pickerOptions,
          onSelect: (uri: string): void => this.onSelect(uri),
          onDeselect: (uri: string): void => this.onDeselect(uri),
          onItemClicked: (itemInfo: ItemInfo, clickType: ClickType): boolean =>
            this.onItemClicked(itemInfo,
            clickType), // 该接口可替代上面两个接口。
          onEnterPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
            this.onEnterPhotoBrowser(photoBrowserInfo),
          onExitPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
            this.onExitPhotoBrowser(photoBrowserInfo),
          onPickerControllerReady: (): void => this.onPickerControllerReady(),
          onPhotoBrowserChanged: (browserItemInfo: BaseItemInfo): boolean =>
            this.onPhotoBrowserChanged(browserItemInfo),
          onSelectedItemsDeleted: this.selectedItemsDeletedCallback,
          onExceedMaxSelected: this.exceedMaxSelectedCallback,
          onCurrentAlbumDeleted: this.currentAlbumDeletedCallback,
          onVideoPlayStateChanged: this.videoPlayStateChangedCallback,
          pickerController: this.pickerController,
        }).height('60%').width('100%')

        // 这里模拟应用侧底部的选择栏。
        if (this.isBrowserShow) {
          Row() {
            ForEach(this.assets, async (asset: photoAccessHelper.PhotoAsset, index) => {
              if (asset.uri === this.currentUri) {
                Image(this.thumbnail[index])
                  .height('10%')
                  .width('10%')
                  .onClick(() => {
                  })
                  .borderWidth(1)
                  .borderColor('red')
              } else {
                Image(this.thumbnail[index]).height('10%').width('10%').onClick(() => {
                  this.pickerController.setData(DataType.SET_SELECTED_URIS, this.selectUris);
                  this.pickerController.setPhotoBrowserItem(asset.uri, PhotoBrowserRange.ALL);
                })
              }
            }, (uri: string) => JSON.stringify(uri))
          }
        } else {
          Button('预览').width('33%').height('5%').onClick(async () => {
            if (this.selectUris.length > 0) {
              this.thumbnail = [];
              this.assets = [];
              for (let selectUri of this.selectUris) {
                let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
                predicates.equalTo(photoAccessHelper.PhotoKeys.URI, selectUri);
                let fetchOptions: photoAccessHelper.FetchOptions = {
                  fetchColumns: [],
                  predicates: predicates
                };
                let context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
                let photoHelper = photoAccessHelper.getPhotoAccessHelper(context);
                let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> =
                  await photoHelper.getAssets(fetchOptions);
                let asset = await fetchResult.getFirstObject()
                this.assets.push(asset);
                this.thumbnail.push(await asset.getThumbnail())
              }
              this.pickerController.setPhotoBrowserItem(this.selectUris[0], PhotoBrowserRange.SELECTED_ONLY);
            }
          })
        }
      }
    }
  }
}
// [End PhotoPickerComponent_demo_body]