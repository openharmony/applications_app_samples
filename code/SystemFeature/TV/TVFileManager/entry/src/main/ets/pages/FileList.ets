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
import ListPageAdapter from '../component/adapter/ListPageAdapter';
import { FileBean } from '../component/bean/FileBean';
import { Tools } from '../common/utils/Tools';
import { MediaType } from '../model/MediaType';
import { MLog } from '../common/utils/MLog';
import { image } from '@kit.ImageKit';
import { focusIdTag, NavStack } from '../common/manager/NavPathStackManager';
import { FileAccessManager, RootData } from '../common/manager/FileAccessManager';
import { common } from '@kit.AbilityKit';
import { Want } from '@kit.AbilityKit';
import { DeleteDialog } from '../component/dialog/DeleteDialog';
import { RenameDialog } from '../component/dialog/RenameDialog';
import { promptAction } from '@kit.ArkUI';
import { KeyCode } from '@kit.InputKit';
import { ProgressDialog } from '../component/dialog/ProgressDialog';
import AbilityManager from '../common/manager/AbilityManager';
import { FileJumpTools, PlaylistItem } from '../common/FileJumpTools';
import { BusinessError } from '@kit.BasicServicesKit';
import { PageType } from '../model/PageType';
import { FileInfo } from '../common/data/FileInfo';
import { FileOperationItem } from '../component/FileOperationItem';
import { Operation, OperationAction, OperationActionID } from '../model/Operation';
import { OverrideDialog } from '../component/dialog/OverrideDialog';
import { ColorMetrics, LengthMetrics, router } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';

import { FileTaskPool } from '../common/manager/FileTaskPool';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import StorageSpaceComponent from '../component/StorageSpaceComponent';
import { appManager } from '@kit.AbilityKit';
import fileUtil from '../common/utils/FileUtil';
import { DEFAULT_THUMB_HEIGHT, DEFAULT_THUMB_WIDTH, LIST_CACHE_COUNT } from '../common/Constants';
import { InputKeyEventUtils } from '../common/utils/InputKeyEventUtils';
import { Units } from '../common/utils/PixelUnitConversion';
import lpx from '../common/utils/Lpx';

const TAG = 'FileList';

const IS_SHOW_IMAGE = getParamValue() !== 'Hi3751V352';

const DEFAULT_INDEX = 4;

const ALBUM_BUNDLE_NAME = 'com.samples.album';

const VIDEO_BUNDLE_NAME = 'com.ohos.demandplayer';

function getParamValue(): string {
  try {
    let value = systemParameterEnhance.getSync('const.product.name');
    MLog.info(TAG, ` getParamValue const.product.name: ${value}`);
    return value;
  } catch (err) {
    MLog.printError(TAG, `getParamValue const.product.name error`, err);
    return 'unknown';
  }
}

@Component
export struct FileList {
  @Link isFocusable: boolean;
  scroller: Scroller = new Scroller();
  @Prop @Watch('changePage') name: string = '';
  private pageType: PageType = PageType.NORMAL_PAGE;
  private mediaType?: MediaType;
  private checkOverrideFile: string = '';
  private overrideFileType: boolean = false;
  private rootInfo?: FileInfo;
  private data: ListPageAdapter = new ListPageAdapter(getContext(this));
  @State imageMap: Set<string> = new Set();
  // 视频缩略图
  @State videoThumbCache: Map<string, string> = new Map();
  @State loadingVideos: Set<string> = new Set();
  @State menuList: Operation[] = [];
  @State specialSelectMod: boolean = false; //  1-全选 0-取消全选
  @State selectedIndex: string = '';
  @State isRootUsbPage: boolean = false;
  @LocalStorageLink('backPageBeanId') backPageBeanId: string = '';
  @StorageLink('showFileOperation') showFileOperation: boolean = false;
  @StorageLink(focusIdTag) @Watch('changeFocus') focusId: string = '';
  @State isCopying: boolean = false;
  @State isMoving: boolean = false;
  //选择需要操作的文件列表
  @StorageLink('operationFiles') operationFiles: FileBean[] = [];
  //是否进入多选模式
  @LocalStorageLink('isSelect') isSelect: boolean = false;
  @LocalStorageLink('progressOne') progressOne: string = '';
  @LocalStorageLink('progressValue') progressValue: number = 0;
  @LocalStorageLink('progressSize') progressSize: number = 0;
  @State dataLength: number = 1;
  private overrideController: CustomDialogController = new CustomDialogController({
    builder: OverrideDialog({
      filename: this.checkOverrideFile,
      cancel: () => {
        this.closeCopyMode();
      },
      confirm: () => {
        this.confirmCopyOrMove(this.overrideFileType, true);
      }
    }),
    customStyle: true,
    autoCancel: true,
    alignment: DialogAlignment.Center
  });
  private deleteController: CustomDialogController = new CustomDialogController({
    builder: DeleteDialog({
      cancel: () => {
        MLog.info(TAG, `DeleteDialog cancel`);
        this.deleteController.close();
        this.closeCopyMode();
        this.requestFocus();
      },
      confirm: () => {
        if (this.operationFiles.length == 0) {
          return;
        }
        let files = [...this.operationFiles];
        let hasRootFile = files.some((file): boolean => file.isDevice());
        FileAccessManager.getIns(getContext(this)).delete(files).then((num: number) => {
          MLog.info(TAG, `delete result num:${num}`);
          if (num > 0) {
            this.data?.splice(files);
          } else {
            if (!hasRootFile) {
              this.showWarning($r('app.string.delete_failed_warning'));
            }
          }
          this.hideFileOperation();
          emitter.emit('REFRESH_SPACE_SIZE');
          emitter.emit(`REFRESH_LIST`);
        });
      }
    }),
    customStyle: true,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
      MLog.info(TAG, 'dialog onWillDismiss reason' + JSON.stringify(dismissDialogAction.reason));
      if (dismissDialogAction.reason == DismissReason.PRESS_BACK ||
        dismissDialogAction.reason == DismissReason.TOUCH_OUTSIDE) {
        dismissDialogAction.dismiss();
        this.closeCopyMode();
        this.requestFocus();
      }
    }
  });
  private renameController: CustomDialogController = new CustomDialogController({
    builder: RenameDialog({
      text: this.operationFiles && this.operationFiles.length > 0 ?
        this.operationFiles[0].name.substring(0, this.operationFiles[0].name.lastIndexOf('.')) : '',
      confirm: (text: string) => {
        MLog.info(TAG, `RenameDialog confirm text:${text} -- ${this.operationFiles[0].name}`);
        if (this.operationFiles[0] && text !== this.operationFiles[0].name) {
          FileAccessManager.getIns(getContext(this)).rename(this.operationFiles, text).then(() => {
            this.data!.rename(this.operationFiles, text);
            this.hideFileOperation();
            emitter.emit(`REFRESH_LIST`);
          });
        } else {
          this.hideFileOperation();
        }
      }
    }),
    cancel: () => {
      MLog.info(TAG, `RenameDialog cancel`);
      this.hideFileOperation();
      this.requestFocus();
    },
    customStyle: true,
    autoCancel: true,
    maskColor: $r('app.color.rename_input_text'),
    alignment: DialogAlignment.Center,
    onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
      MLog.info(TAG, 'dialog onWillDismiss reason' + JSON.stringify(dismissDialogAction.reason));
      if (dismissDialogAction.reason == DismissReason.PRESS_BACK) {
        dismissDialogAction.dismiss();
        this.hideFileOperation();
        this.requestFocus();
      }
    }
  });
  private taskPool?: FileTaskPool;
  private progressIsOpen: boolean = false;
  private progressController: CustomDialogController = new CustomDialogController({
    builder: ProgressDialog({
      cancel: () => {
        MLog.print(TAG, `ProgressDialog cancel `);
        if (this.taskPool) {
          this.taskPool.cancel();
          this.closeCopyMode();
          emitter.emit('REFRESH_SPACE_SIZE');
          emitter.emit(`REFRESH_LIST`);
        }
      }
    }),
    customStyle: true,
    autoCancel: false,
    maskColor: $r('app.color.rename_input_text'),
    alignment: DialogAlignment.Center
  });
  backPressCB = (): boolean | void => {
    return this.onBackPress();
  };
  statusCB = (isSelect: boolean) => {
    MLog.print(TAG, `refresh: ${this.name}`);
    if (isSelect) {
      this.isCopying = NavStack.getIns().isCopy();
      this.isMoving = NavStack.getIns().isMove();
    } else {
      this.isCopying = false;
      this.isMoving = false;
    }
    this.setMenu();
  };

  aboutToAppear() {
    FileAccessManager.getIns(getContext(this));
    this.isCopying = NavStack.getIns().isCopy();
    this.isMoving = NavStack.getIns().isMove();
    NavStack.getIns().regBackPressFun(this.backPressCB);
    NavStack.getIns().addStatusLis(this.statusCB);
    emitter.on(`REFRESH_LIST`, this.onRefreshData);
  }

  aboutToDisappear(): void {
    emitter.off(`REFRESH_LIST`, this.onRefreshData);
    NavStack.getIns().unregBackPressFun(this.backPressCB);
    NavStack.getIns().removeStatusLis(this.statusCB);
  }

  requestFocus() {
    // backPageBeanId
    if (this.name && this.data && this.data.totalCount() > 0) {
      MLog.print(TAG, `load backPageBeanId:${this.backPageBeanId}`);
      let id = this.data.getData(0).id;
      if (this.backPageBeanId && this.data.find(this.backPageBeanId)) {
        id = this.backPageBeanId;
      }
      MLog.print(TAG, `request first item:${this.name}-fileItem-${id}`);
      this.focusId = `${this.name}-fileItem-${id}`;
      this.changeFocus(this.focusId);
    } else if (this.showFileOperation) {
      MLog.print(TAG, `request showFileOperation first`);
      this.focusId = this.menuList[0].action;
    }
  }

  changeFocus(focus: string, times?: number) {
    if (!this.focusId) {
      MLog.warn(TAG, `changeFocus is empty!`);
      return;
    }
    let time = times || 1;
    let ret = focusControl.requestFocus(this.focusId);
    MLog.print(TAG, `changeFocus(${time}) ${this.focusId}->${ret}`);
    if (!ret && time < 10) {
      let timerId = setTimeout(() => {
        clearTimeout(timerId);
        this.changeFocus(focus, ++time);
      }, 30);
    }
  }

  changePage() {
    MLog.print(TAG, `changePage:${this.name}`);
    emitter.emit(`REFRESH_LIST`);
  }

  onRefreshData = () => {
    let info = NavStack.getIns().curPageInfo;
    this.pageType = info.pageType;
    MLog.print(TAG, `onRefreshData REFRESH_LIST ${this.name} pageType:${this.pageType} info:${JSON.stringify(info)}`);

    this.data.clear();
    this.imageMap.clear();
    this.videoThumbCache.clear();
    this.loadingVideos.clear();
    this.isRootUsbPage = false;
    let ins = FileAccessManager.getIns(getContext(this));
    switch (this.pageType) {
      case PageType.ROOT_PAGE:
        try {
          MLog.print(TAG, `onRefreshData ROOT_PAGE`);
          ins.getRootDataAsFile().then((root: RootData) => {
            if (root.root) {
              MLog.print(TAG, `onRefreshData ${root.root.uri} ${root.list.length}`);
              this.rootInfo = root.root;
            }
            if (root.list && this.data) {
              this.data.clear();
              this.pushData(root.list);
            }
          });
        } catch (err) {
          MLog.printError(TAG, `onRefreshData ${this.pageType} error!`, err);
        }
        break;
      case PageType.EXTERNAL_USB_PAGE:
        try {
          emitter.emit('REFRESH_SPACE_SIZE', { data: { isShowSpaceSize: false, name: this.name } });
          ins.getUsbDataAsFile().then((root: RootData) => {
            if (root.list && this.data) {
              this.data.clear();
              this.data.pushRoot(root.list);
              this.data.totalCount();
              this.isRootUsbPage = true;
            }
          });
        } catch (err) {
          MLog.printError(TAG, `onRefreshData ${this.pageType} error!`, err);
        }
        break;
      case PageType.DOC_PAGE:
        try {
          this.data.clear();
          ins.getRootLocal().then(roots => {
            if (roots) {
              ins.getDocs(roots).then(fileArr => {
                let arr: FileBean[] = fileArr.map(it => new FileBean(it.uri, it).updateDirType());
                arr.sort();
                this.pushData(arr);
              });
            }
          });
        } catch (err) {
          MLog.printError(TAG, `onRefreshData ${this.pageType} error!`, err);
        }
        break;
      case PageType.VIDEO_PAGE:
      case PageType.IMAGE_PAGE:
      case PageType.AUDIO_PAGE:
        try {
          let mediaType = this.pageType == PageType.VIDEO_PAGE ? MediaType.VIDEO
            : this.pageType == PageType.IMAGE_PAGE ? MediaType.IMAGE : MediaType.AUDIO;
          this.data.clear();
          ins.getMediaFileAsset(mediaType).then(arr => {
            this.pushData(arr);
          });
          ins.getFileAsset(mediaType).then(arr => {
            this.pushData(arr);
          });
          // 进入媒体页时提前预热分享服务：用户浏览选图期间服务即可完成初始化，
          // 使点击分享时直接走热启动路径，弹窗近乎即时出现。
          AbilityManager.preloadShareService(getContext(this) as common.UIAbilityContext);
        } catch (err) {
          MLog.printError(TAG, `onRefreshData ${this.pageType} error!`, err);
        }
        break;
      default:
        if (info.uri) {
          if (info.rootRelativePath) {
            MLog.print(TAG, `REFRESH_SPACE_SIZE name:${info.name} info.rootRelativePath:${info.rootRelativePath}`);
            emitter.emit('REFRESH_SPACE_SIZE', { data: { relativePath: info.rootRelativePath, name: info.name } });
          }
          MLog.print(TAG, `getDataByFile id:${info.uri}`);
          ins.getListFormUri(info.uri).then((files: Array<FileInfo>) => {
            MLog.print(TAG, `getDataByFile files:${files.length}`);
            let arr: FileBean[] = files.map(it => new FileBean(it.uri, it).updateDirType());
            arr.sort();
            this.pushData(arr);
          });
        }
        break;
    }

  };

  pushData(beans: FileBean[]) {
    // 为所有图片预设默认尺寸 96x96
    beans.forEach(bean => {
      if (bean.isImage() && !bean.hasImageDimensions()) {
        bean.setImageDimensions(96, 96);
      }
    });
    this.data.push(beans);
    this.dataLength = this.data.totalCount();
    let index = this.data.getIndexById(this.backPageBeanId);
    if (index > 0) {
      //  延迟请求焦点，等待列表数据渲染完成
      setTimeout(() => {
        if (index > DEFAULT_INDEX) {
          this.scroller.scrollToIndex(index - 2);
        }
        this.requestFocus();
      });
    } else {
      // 当数据为空时，焦点在tab上
      if (this.dataLength === 0) {
        this.isFocusable = true;
        setTimeout(() => {
        }, 200);
      }
    }
  }

  onPageShow(): void {
    this.isCopying = NavStack.getIns().isCopy();
    this.isMoving = NavStack.getIns().isMove();
    NavStack.getIns().isShowHomePage = false;
  }

  setMenu() {
    switch (this.name) {
      case PageType.VIDEO_PAGE:
      case PageType.IMAGE_PAGE:
      case PageType.AUDIO_PAGE:
      case PageType.DOC_PAGE:
        this.menuList = [OperationAction.del, OperationAction.share, OperationAction.rename];
        break;
      default:
        this.menuList = [OperationAction.del, OperationAction.move, OperationAction.copy, OperationAction.selectAll,
          OperationAction.share, OperationAction.rename];
        break;
    }
    if (this.isCopying) {
      this.menuList = [OperationAction.copyCancel, OperationAction.copyConfirm];
    } else if (this.isMoving) {
      this.menuList = [OperationAction.moveCancel, OperationAction.moveConfirm];
    }
  }

  onClickMenu(action: OperationActionID) {
    MLog.print(TAG, `onClickMenu:${action}`);
    switch (action) {
      case OperationActionID.Del:
        if (this.operationFiles.length < 1) {
          this.showWarning($r('app.string.at_last_one'));
          return;
        }
        this.backPageBeanId = this.operationFiles[0].id;
        this.showFileOperation = false;
        this.deleteController.open();
        break;
      case OperationActionID.Move:
        this.startCopyMode(true);
        break;
      case OperationActionID.MoveConfirm:
        if (this.checkOverride()) {
          this.overrideFileType = true;
          this.overrideController.open();
        } else {
          this.confirmCopyOrMove(true);
        }
        break;
      case OperationActionID.Copy:
        this.startCopyMode(false);
        break;
      case OperationActionID.CopyConfirm:
        if (this.checkOverride()) {
          this.overrideFileType = false;
          this.overrideController.open();
        } else {
          this.confirmCopyOrMove(false);
        }
        break;
      case OperationActionID.MoveCancel:
        MLog.print(TAG, ` cancel move`);
        this.closeCopyMode();
        break;
      case OperationActionID.CopyCancel:
        MLog.print(TAG, ` cancel move`);
        this.closeCopyMode();
        break;
      case OperationActionID.SelectAll: {
        if (this.operationFiles.length < this.data!.totalCount()) {
          if (this.data!.totalCount() <= 20) {
            this.operationFiles = [];
            for (let i = 0; i < this.data!.totalCount(); i++) {
              this.operationFiles.push(this.data!.getData(i));
            }
            this.specialSelectMod = true;
            MLog.print(TAG, `click select all operationFiles:${this.operationFiles.length}`);
          } else {
            this.showWarning('最多可处理20个文件');
          }
        } else {
          this.specialSelectMod = false;
          this.operationFiles = [];
        }

      }
        break;
      case OperationActionID.Share: {
        if (this.operationFiles.length != 1) {
          this.showWarning($r('app.string.support_one_item'));
          return;
        }
        if (!this.operationFiles[0].isFile()) {
          this.showWarning($r('app.string.no_support_dir'));
          return;
        }
        const shareFile = this.operationFiles[0];
        MLog.info(TAG, `Share action triggered: file=${shareFile.name}, path=${shareFile.getPath()}`);
        const shareContext = getContext(this) as common.UIAbilityContext;
        // hideFileOperation 移至 then() 内：菜单保持显示直到弹窗真正触发，
        // 避免冷启动时菜单立刻消失、800ms 后弹窗才出现导致的焦点跳动问题。
        AbilityManager.startShareAbility(shareFile, shareContext).then((success: boolean) => {
          MLog.info(TAG, `Share result: success=${success}, file=${shareFile.name}`);
          this.hideFileOperation();
          if (!success) {
            MLog.error(TAG, `Share failed after retry: file=${shareFile.name}`);
            this.showWarning($r('app.string.share_failed'));
          }
        });
        break;
      }
      case OperationActionID.Rename:
        if (this.operationFiles.length < 1) {
          this.showWarning($r('app.string.at_last_one'));
          return;
        }
        if (this.operationFiles.length > 1) {
          this.showWarning($r('app.string.at_more_one'));
          return;
        }
        this.backPageBeanId = this.operationFiles[0].id;
        this.showFileOperation = false;
        this.renameController.open();
        NavStack.setFocusId('renameInput');
        break;
    }
  }

  checkOperationFile(item: FileBean): boolean {
    let find = this.operationFiles.find(it => it.id === item.id);
    return find != undefined;
  }

  build() {
    Stack() {
      List({ scroller: this.scroller }) {
        if (this.dataLength > 0) {
          LazyForEach(this.data, (item: FileBean, index: number) => {
            ListItem() {
              Row() {
                Image(this.getFileIcon(item))
                  .sourceSize({
                    width: Units.px2vp(item.imageWidth),
                    height: Units.px2vp(item.imageHeight)
                  })
                  .objectFit(ImageFit.Contain)
                  .width(lpx(Units.px2vp(75)))
                  .height(lpx(Units.px2vp(75)))
                  .onError(err => {
                    MLog.warn(TAG, `Image onError message:${err?.message ?? ''} index:${index} item.id:${item.id}`);
                    const path = item.getPath();
                    if (!path) {
                      return;
                    }

                    this.getUIContext().runScopedTask(() => {
                      if (item.isVideo() && this.videoThumbCache.has(path)) {
                        MLog.info(TAG, `Video thumbnail failed to load, path:${path}`);
                        this.videoThumbCache.delete(path);
                        this.videoThumbCache = new Map(this.videoThumbCache);
                      }
                      if (item.isImage() && this.imageMap.has(path)) {
                        this.imageMap.delete(path);
                      }
                    });
                  })
                Text(item.name)
                  .fontSize(lpx(Units.px2fp(18)))
                  .fontColor(
                    this.selectedIndex == item.id ? $r('app.color.file_list_text_sel') : $r('app.color.file_list_text'))
                  .margin({ left: lpx(Units.px2vp(22)) })
                  .layoutWeight(1)
                Text(this.isFile(item) ? Tools.byte2Str(item.size) : '')
                  .fontSize(lpx(Units.px2vp(18)))
                  .fontColor(
                    this.selectedIndex == item.id ? $r('app.color.file_list_text_sel') : $r('app.color.file_list_text'))
                  .margin({ left: lpx(Units.px2vp(10)) })
                if (this.isRootUsbPage) {
                  Row() {
                    StorageSpaceComponent({ storagePath: item.relativePath })
                  }.size({ width: lpx(Units.px2vp(180)), height: lpx(Units.px2vp(50)) })
                }

                if (this.isSelect) {
                  Image(this.checkOperationFile(item) ? $r('app.media.ic_public_selected') :
                    $r('app.media.ic_public_no_select'))
                    .width(lpx(Units.px2vp(18)))
                    .height(lpx(Units.px2vp(18)))
                    .margin({ left: lpx(Units.px2vp(32)) })
                } else {
                  if (item.isDir()) {
                    Blank().width(lpx(Units.px2vp(18)))
                    Image(this.selectedIndex == item.id ? $r('app.media.ic_right') : $r('app.media.right'))
                      .size({ width: '8lpx', height: '16lpx' })
                  } else {
                    Blank().width(lpx(Units.px2vp(55)))
                  }
                }
              }
              .alignItems(VerticalAlign.Center)
              .padding({
                left: lpx(Units.px2vp(24)),
                top: lpx(Units.px2vp(9)),
                bottom: lpx(Units.px2vp(9)),
                right: lpx(Units.px2vp(20))
              })
              .backgroundColor(this.selectedIndex == item.id ? $r('app.color.file_list_item_bg_sel') :
                $r('app.color.file_list_item_bg'))
              .borderRadius(lpx(Units.px2vp(18)))
            }
            .id(`${this.name}-fileItem-${item.id}`)
            .margin({ bottom: lpx(Units.px2vp(10)), top: lpx(Units.px2vp(12)) })
            .width('100%')
            .height(lpx(Units.px2vp(80)))
            .focusBox({
              strokeColor: ColorMetrics.numeric(Color.Transparent),
              strokeWidth: LengthMetrics.px(0)
            })
            .onFocus(() => {
              animateTo({
                duration: 0
              }, () => {
                this.selectedIndex = item.id;
                MLog.print(TAG, `onFocus selectedIndex:${this.selectedIndex}`);
              });
            })
            .onHover((isHover) => {
              if (isHover) {
                focusControl.requestFocus(`${this.name}-fileItem-${item.id}`);
              }
            })
            .onTouch((event: TouchEvent) => {
              if (event.type === TouchType.Down) {
                this.backPageBeanId = item.id;
                focusControl.requestFocus(`${this.name}-fileItem-${item.id}`);
              }
            })
            .onClick(() => {
              this.isFocusable = false;
              this.backPageBeanId = item.id;
              setTimeout(() => {
                this.onClickItem(item);
              }, 100);
            })
            .onAppear(() => {
              MLog.print(TAG, `onAppear ListItem index:${index} item.id:${item.id}`);
              if (item.isImage()) {
                console.log(TAG,
                  `传入sourceSize的[${index}] ${item.name} - 宽:${item.imageWidth}, 高:${item.imageHeight}`);
              }
              if (IS_SHOW_IMAGE) {
                if (item.isImage() || item.isVideo()) {
                  this.imageMap.add(item.getPath());
                  if (item.isVideo()) {
                    this.loadVideoThumb(item);
                  }
                  if (item.isImage()) {
                    this.loadImageDimensions(item);
                  }
                }
              }

              if (index == 0) {
                MLog.print(TAG, `set focusId index:${index} totalCount:${this.data.totalCount()} item.id:${item.id}`);
                this.requestFocus();

              }

            })
            .onDisAppear(() => {
              setTimeout(() => {
                const path = item.getPath();
                if (this.imageMap.has(path)) {
                  this.imageMap.delete(path);
                }
                if (this.videoThumbCache.has(path)) {
                  this.videoThumbCache.delete(path);
                }
              });
            })
            .gesture(LongPressGesture({ repeat: false })
              .onAction((event: GestureEvent) => {
                this.showFileOperation = true;
                this.isSelect = true;
                this.operationFiles.push(item);
              })
            )
          }, (item: FileBean) => `${item.id}-${item.size}-${this.operationFiles.includes(item) ? 's' : '-'}`)
        } else {
          ListItem() {
            Text($r('app.string.no_files'))
              .fontColor($r('app.color.file_list_text'))
              .fontSize(lpx(Units.px2vp(36)))
          }.width('100%')
          .height('100%')
          .alignSelf(ItemAlign.Center)
        }
      }
      .width('100%')
      .height('100%')
      .cachedCount(LIST_CACHE_COUNT)
      .padding({ right: lpx(Units.px2vp(20)) })
      .id('list_def')
      .focusBox({
        strokeColor: ColorMetrics.numeric(Color.Transparent),
        strokeWidth: LengthMetrics.px(0)
      })
      .onBlur(() => {
        this.isFocusable = true;
        this.selectedIndex = '';
        this.focusId = '';
        MLog.print(TAG, `onBlur list selectedIndex:${this.selectedIndex}`);
      })
      .onAppear(() => {
        MLog.print(TAG, `onAppear list selectedIndex:${this.selectedIndex}`);
        MLog.print(TAG, `onAppear backPageBeanId:${this.backPageBeanId}`);
        emitter.emit(`REFRESH_LIST`);
        AppStorage.setOrCreate('REFRESH_PAGE', `REFRESH_LIST`);
        this.setMenu();
        this.onPageShow();
      })
      .onDisAppear(() => {
        MLog.print(TAG, `onDisAppear pageName:${this.name}`);
        this.focusId = '';
        this.data.clear();
        this.imageMap.clear();
        this.videoThumbCache.clear();
        this.loadingVideos.clear();
      })


      Row() {
        ForEach(this.menuList, (it: Operation, index: number) => {
          FileOperationItem({
            focusId: it.action,
            image: it.image,
            imageFocus: it.imageFocus,
            text: it.text,
            specialSelectMod: $specialSelectMod,
            visible: true,
            itemClick: () => {
              this.onClickMenu(it.action);
            },
          })
        })

      }
      .borderRadius(lpx(Units.px2vp(48)))
      .padding({
        top: lpx(Units.px2vp(20)),
        bottom: lpx(Units.px2vp(25)),
        left: lpx(Units.px2vp(24)),
        right: lpx(Units.px2vp(24))
      })
      .backgroundColor($r('app.color.dialog_bg'))
      .margin({ bottom: lpx(Units.px2vp(96)) })
      .visibility(this.showFileOperation ? Visibility.Visible : Visibility.None)
    }
    .alignContent(Alignment.Bottom)
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Transparent)
    .focusBox({
      strokeColor: ColorMetrics.numeric(Color.Transparent),
      strokeWidth: LengthMetrics.px(0)
    })
    .onKeyEvent((event: KeyEvent) => {
      if (event.keyCode === KeyCode.KEYCODE_DPAD_UP && event.type == KeyType.Down) {
        this.isFocusable = true;
      }
      MLog.print(TAG, `NavDestination onKeyEvent event:${JSON.stringify(event)}`);

      if (event.keyCode === KeyCode.KEYCODE_MENU && event.type == KeyType.Up) {
        if (this.showFileOperation) {
          this.hideFileOperation();
        } else {
          this.showFileOperation = true;
          this.isSelect = true;
          this.setMenu();
          AbilityManager.preloadShareService(getContext(this) as common.UIAbilityContext);
        }
      }
    })
  }

  onBackPress(): boolean | void {
    this.isFocusable = false;
    MLog.print(TAG,
      `onBackPress isCopying:${this.isCopying} isMoving:${this.isMoving} showFileOperation:${this.showFileOperation}`);
    if (!this.isCopying && !this.isMoving && this.showFileOperation) {
      MLog.info(TAG, 'onBackPressed hide file operation');
      this.hideFileOperation();
      return true;
    }
    if (this.progressIsOpen) {
      return true;
    }
    if (NavStack.getIns().checkBackPress()) {
      this.data.clear();
      this.data.notifyDataReload();
      this.imageMap.clear();
      let info = NavStack.getIns().curPageInfo;
      if (info && info.uri) {
        this.backPageBeanId = info.uri;
        MLog.print(TAG, `save backPageBeanId:${this.backPageBeanId}`);
      }
      NavStack.getIns().popPath();
      return true;
    } else {
      MLog.warn(TAG, `onBackPress checkBackPress false isSelectMod:${NavStack.getIns().isSelectMod()}`);

    }
  }

  private async loadVideoThumb(item: FileBean) {
    const videoPath = item.getPath();
    if (this.videoThumbCache.has(videoPath) || this.loadingVideos.has(videoPath)) {
      return;
    }
    this.loadingVideos.add(videoPath);
    try {
      const cacheDir = await fileUtil.getCacheDir(getContext());
      const thumbPath = await fileUtil.getThumbNail(cacheDir, videoPath, DEFAULT_THUMB_WIDTH, DEFAULT_THUMB_HEIGHT);
      // 重新赋值触发UI刷新
      this.videoThumbCache = new Map(this.videoThumbCache.set(videoPath, thumbPath));
    } catch (error) {
      console.error(`Failed to load thumbnail path = ${videoPath}, err = ${JSON.stringify(error)}`);
    } finally {
      this.loadingVideos.delete(videoPath);
    }
  }

  private async loadImageDimensions(item: FileBean): Promise<void> {
    console.log(TAG, `加载图片路径 path:${item.getPath()}`);
    const imagePath = item.getPath();
    if (!imagePath) {
      return;
    }
    try {
      // 获取原始尺寸
      const dimensions = await fileUtil.getImageOriginalDimensions(imagePath);
      let w: number = dimensions.width;
      let h: number = dimensions.height;

      console.log(TAG, `图片原始尺寸:${w}x${h}`);
      let pxTarget = 96; // 系统性能差，降低解析分辨率

      // 设置到 FileBean
      const index = this.data.getIndexById(item.id);
      if (w == 0 || h == 0) {
        item.setImageDimensions(0, 0);
      } else if (w >= h) {
        const newHeight = pxTarget * h / w;
        item.setImageDimensions(pxTarget, newHeight);
        MLog.info(TAG, `更宽的 Image [${item.name}] ,原来的:${w}x${h} `);
        MLog.info(TAG, `更宽的 Image [${item.name}] ,更改后:${pxTarget}x${newHeight} `);
      } else {
        const newWidth = pxTarget * w / h;
        item.setImageDimensions(newWidth, pxTarget);
        MLog.info(TAG, `更长的 Image [${item.name}] ,原来的:${w}x${h} `);
        MLog.info(TAG, `更长的 Image [${item.name}] ,更改后:${newWidth}x${pxTarget} `);
      }

      this.getUIContext().runScopedTask(() => {
        if (index >= 0) {
          this.data.notifyDataChange(index);
          console.log(TAG, `通知数据变化 index:${index}, size:${item.imageWidth}x${item.imageHeight}`);
        }
      });
    } catch (error) {
      console.error(`Failed to load image dimensions: ${imagePath}, err = ${JSON.stringify(error)}`);
    }
  }

  private getFileIcon(bean: FileBean) {
    let icon: Resource | image.PixelMap | string;
    if (bean.isVideo()) {
      if (this.videoThumbCache.has(bean.getPath())) {
        icon = this.videoThumbCache.get(bean.getPath()) || $r('app.media.ic_file_video');
      } else {
        icon = $r('app.media.ic_file_video');
      }
    } else if (bean.isImage()) {
      if (this.imageMap.has(bean.getPath())) {
        icon = bean.getPath();
      } else {
        icon = $r('app.media.ic_file_image');
      }
    } else if (bean.isAudio()) {
      icon = $r('app.media.ic_file_audio');
    } else if (bean.isDoc()) {
      icon = $r('app.media.ic_file_doc');
    } else if (bean.isFile()) {
      icon = $r('app.media.ic_file');
    } else {
      icon = $r('app.media.ic_dir');
    }
    return icon;
  }

  private isFile(item: FileBean): boolean {
    return !item.isDevice() && item.isFile();
  }

  async onClickItem(item: FileBean) {
    MLog.print(TAG, `onclick item:${(item.toString())}`);
    if (this.isSelect) {
      if (this.operationFiles.includes(item)) {
        //如果操作列表已添加该item，去掉
        this.operationFiles.splice(this.operationFiles.indexOf(item), 1);
      } else {
        if (this.operationFiles.length > 19) {
          this.showWarning('最多可处理20个文件');
        } else {
          this.operationFiles.push(item);
        }
      }
      this.specialSelectMod = this.operationFiles.length == this.data!.totalCount();
      MLog.info(TAG,
        `operationFile totalCount:${this.data!.totalCount()} operationFiles length: ${this.operationFiles.length}`);
      this.setMenu();
      return;
    }

    MLog.print(TAG, `mediaType:${this.mediaType} isDir:${item.isDir()} `);

    if (item.isDir()) {
      // 在进入目录前先检查是否为空目录
      let currentDeviceType = NavStack.getIns().getDevice();
      NavStack.getIns().pushBean(item);

      // 进入新目录后，确保设备类型不变
      NavStack.getIns().setDevice(currentDeviceType);
    } else {
      if (item.isImage() || item.isVideo() || item.isAudio()) {
        let ctx = getContext(this) as common.UIAbilityContext;
        let params: Want;
        if (item.isImage()) {
          params = FileJumpTools.getImageWant(item.name, item.getPath());
          this.terminateAbility(ALBUM_BUNDLE_NAME);
        } else if (item.isAudio()) {
          const currentIndex = this.data.getIndexById(item.id);
          const playList = this.buildMusicPlayList();

          params = FileJumpTools.getAudioWant(item.name, item.getPath(), currentIndex, playList);
        } else {
          params = await FileJumpTools.getVideoWant(item.name, item.getPath());
          this.terminateAbility(VIDEO_BUNDLE_NAME);
        }
        MLog.print(TAG, `params:${JSON.stringify(params)}`);
        setTimeout(() => {
          ctx.startAbility(params).catch((err: BusinessError) => {
            MLog.printError(TAG, 'onClickItem startAbility error', err);
          });
        }, 500);
      } else {
        MLog.info(TAG, 'Open file not supported');
        promptAction.showToast({ message: $r('app.string.open_file_no_support_tip') });
      }
    }
  }

  private buildMusicPlayList(): PlaylistItem[] {
    const playList: PlaylistItem[] = [];

    for (let i = 0; i < this.data.totalCount(); i++) {
      const fileBean = this.data.getData(i);
      if (fileBean.isAudio()) {
        playList.push({
          name: fileBean.name,
          uri: fileBean.getPath(),
          time: 0
        });
      }
    }
    return playList;
  }

  // 终止指定的 Ability
  terminateAbility(bundleName: string) {
    try {
      appManager.killProcessesByBundleName(bundleName).then(() => {
        console.log(`Kill process of ${bundleName} successfully.`);
      }).catch((err: BusinessError) => {
        console.error(`Failed to kill process of ${bundleName}. Error: ${err}`);
      });
    } catch (error) {
      console.error(`Failed to kill process. Error: ${error}`);
    }
  }

  private hideFileOperation() {
    this.requestFocus();
    //隐藏下方操作菜单的时候，退出多选模式，操作列表置空
    this.showFileOperation = false;
    this.isSelect = false;
    this.specialSelectMod = false;
    this.operationFiles = [];
  }

  private showWarning(msg: ResourceStr) {
    promptAction.showToast({
      message: msg,
      duration: 2000
    });
  }

  private checkOverride(): boolean {
    for (let k = 0; k < this.data.totalCount(); k++) {
      let cur = this.data.getData(k);
      let find = this.operationFiles.find(it => it.name === cur.name);
      if (find) {
        this.checkOverrideFile = find.name;
        return true;
      }
    }
    return false;
  }

  private confirmCopyOrMove(isMove: boolean, force?: boolean) {
    let target = NavStack.getIns().curPageInfo.uri || this.rootInfo?.uri;
    if (!target) {
      this.showWarning($r('app.string.no_support_root'));
      return;
    }
    let destUri = target;
    this.progressValue = 0;
    this.progressSize = this.operationFiles.length;
    MLog.print(TAG, `confirmCopyOrMove destUri:${destUri} isMove:${isMove} size:${this.progressSize}`);
    MLog.print(TAG, `confirmCopyOrMove curPageInfo.uri:${NavStack.getIns().curPageInfo.uri}`);
    this.progressController.open();
    this.progressIsOpen = true;
    NavStack.setFocusId('progressCancel');

    let context = getContext() as common.UIAbilityContext;
    this.taskPool = new FileTaskPool(context, this.operationFiles, destUri, isMove);
    this.taskPool.setProgressFun((progress: number, progressOne?: string, result?: string) => {
      this.progressValue = progress;
      this.progressOne = progressOne ?? '';
      MLog.print(TAG, `progress:${this.progressOne} ${this.progressValue}/${this.progressSize}`);
      if (result && result !== 'success') {
        this.showWarning($r('app.string.file_operation_failed', result));
      }
    });
    this.taskPool.setFinishCall(result => {
      MLog.print(TAG, `Finish call result:${result}`);

      this.closeCopyMode();

      emitter.emit('REFRESH_SPACE_SIZE');
      emitter.emit(`REFRESH_LIST`);
    });
    this.taskPool.run();

  }

  private startCopyMode(isMove: boolean) {
    if (this.operationFiles.length < 1) {
      this.showWarning($r('app.string.at_last_one'));
      return;
    }
    // 记录操作文件ID，用于取消时恢复焦点
    this.backPageBeanId = this.operationFiles[0].id;
    //当前不是拷贝或移动状态
    if (!this.isCopying && !this.isMoving) {
      if (isMove) {
        NavStack.getIns().setMoveMode();
        this.focusId = OperationActionID.MoveConfirm;
      } else {
        NavStack.getIns().setCopyMode();
        this.focusId = OperationActionID.CopyConfirm;
      }
    }
    MLog.print(TAG, `startCopyMode  isMoving:${this.isMoving} isCopying:${this.isCopying}`);
    this.isSelect = false;
  }

  private closeCopyMode() {
    NavStack.getIns().closeSelectMode();
    this.isCopying = false;
    this.isMoving = false;
    this.specialSelectMod = false;
    MLog.print(TAG, `closeCopyMode  isMoving:${this.isMoving} isCopying:${this.isCopying}`);
    this.hideFileOperation();
    if (this.taskPool) {
      this.taskPool.release();
      this.taskPool = undefined;
    }
    this.progressIsOpen = false;
    this.progressController.close();
    this.setMenu();
  }
}

