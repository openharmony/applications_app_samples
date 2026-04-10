import router from '@ohos.router';
import { AlbumModel, AlbumType, DialogModel, PhotoModel } from '../models/PhotoModel';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import { PhotoDataSource } from '../models/IDataSource';
import { inputConsumer } from '@kit.InputKit';
import Logger from '../common/Logger';
import { Constants } from '../common/Constants';
import { Util } from '../common/Util';
import photoManager from '../manager/PhotoManager';
import { promptAction } from '@kit.ArkUI';
import { EventUtil } from '../common/EventUtil';
import { getToVideoApp, isAppInstalled } from './Index';

const TAG = 'PhotoDeleteList';

const PRIMARY_MENU_LIST: DialogModel[] = [{
  uri: 'app.media.p_check_default',
  name: $r('app.string.choose')
}, {
  uri: 'app.media.p_clear_all',
  name: $r('app.string.clear_all'),
}]

const SECONDARY_MENU_LIST_DEFAULT: DialogModel[] = [{
  uri: 'app.media.p_restore',
  name: $r('app.string.restore'),
}, {
  uri: 'app.media.p_del_default',
  name: $r('app.string.delete'),
}, {
  uri: 'app.media.p_check_no_default',
  name: $r('app.string.select_all'),
}];

const SECONDARY_MENU_LIST_CANCEL: DialogModel[] = [{
  uri: 'app.media.p_restore',
  name: $r('app.string.restore'),
}, {
  uri: 'app.media.p_del_default',
  name: $r('app.string.delete'),
}, {
  uri: 'app.media.p_check_all_default',
  name: $r('app.string.cancel_all_select'),
}];

const FOCUS_CHANGE_DELAY = 500;

@Entry
@Component
struct PhotoDeleteList {
  @State title: ResourceStr = $r('app.string.album_name_trash');
  @State photoList: PhotoDataSource = new PhotoDataSource();
  @State photoListSize: number = 0
  @State isPhotoData: boolean = false;
  @State pictureIndex: number = 0;
  @State focusPhotoStr: string = 'picture0';
  @State focusDialogStr: string = '';
  @State isPhotoSelecting: boolean = false;
  @State isCheckAll: boolean = false;
  @State isShowMenu: boolean = false;
  @State pictureChooseFlags: boolean[] = [];
  @State menuIndex: number = 0;
  @State menuList: DialogModel[] = PRIMARY_MENU_LIST;
  //删除
  @State isShowDeleteDialog: boolean = false;
  @State deleteIndex: number = 1;
  private deleteList: Resource[] = [$r('app.string.cancel'), $r('app.string.delete')];
  private gridRowCount: number = 6;
  private scroller: Scroller = new Scroller();
  private photoObserver = (photos: PhotoModel[], albumModel: AlbumModel) => {
    this.photoList.setData(photos)
    this.photoListSize = photos.length
  }
  private keyOptions: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: Constants.TAB_KEY,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };
  private keyOptionsMenu: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: Constants.MENU_KEY,
    isFinalKeyDown: false,
    finalKeyDownDuration: Constants.KEY_DOWN_DURATION
  };
  private keyCallback = (keyOptions: inputConsumer.KeyOptions) => {
    if (!this.isShowMenu) {
      if (this.isPhotoSelecting && this.isCheckAll) {
        this.menuList = SECONDARY_MENU_LIST_CANCEL;
      } else if (this.isPhotoSelecting && !this.isCheckAll) {
        this.menuList = SECONDARY_MENU_LIST_DEFAULT;
      } else {
        this.menuList = PRIMARY_MENU_LIST;
      }
      this.isShowMenu = true;
      setTimeout(() => {
        this.clickFocusBtn('photo_menu0', true); //默认在选择焦点
        this.menuIndex = 0;
      }, FOCUS_CHANGE_DELAY)
    }
  }

  onPageShow(): void {
    try {
      inputConsumer.on('key', this.keyOptions, this.keyCallback);
      inputConsumer.on('key', this.keyOptionsMenu, this.keyCallback);
    } catch (error) {
      Logger.error(`Subscribe failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }
    photoManager.getLoader(AlbumType.TRASH)?.registerChangeCallback(this.photoObserver)
    this.defaultFocusBtn()
  }

  onPageHide(): void {
    inputConsumer.off('key', this.keyOptions, this.keyCallback);
    inputConsumer.off('key', this.keyOptionsMenu, this.keyCallback);
    photoManager.getLoader(AlbumType.TRASH)?.unRegisterChangeCallback(this.photoObserver)
  }

  defaultFocusBtn() {
    setTimeout(() => {
      this.clickFocusBtn(this.focusPhotoStr, false)
    }, FOCUS_CHANGE_DELAY)
  }

  clickFocusBtn(str: string, inDialog: boolean) {
    const isSuccess = focusControl.requestFocus(str);
    if (isSuccess) {
      if (inDialog) {
        this.focusDialogStr = str;
      } else {
        this.focusPhotoStr = str;
      }
    } else {
      Logger.error(TAG, `requestFocus is failed , focusStr = ${str}`);
    }
    return isSuccess;
  }

  onBackPress(): boolean | void {
    if (this.isShowDeleteDialog) {
      this.dismissDeleteDialog();
      return true;
    }
    if (this.isShowMenu) {
      this.dismissMenu();
      return true;
    }
    if (this.isPhotoSelecting) {
      this.cancelPhotoSelect();
      return true;
    }
  }

  //编辑状态的照片返回
  cancelPhotoSelect() {
    this.isPhotoSelecting = false;
    this.pictureChooseFlags = new Array(this.photoList.totalCount()).fill(false)
    this.isCheckAll = false;
  }

  dismissMenu() {
    this.isShowMenu = false;
    setTimeout(() => {
      this.clickFocusBtn(this.focusPhotoStr, false)
    }, FOCUS_CHANGE_DELAY)
  }

  dismissDeleteDialog() {
    this.isShowDeleteDialog = false;
    this.deleteIndex = 1;
    setTimeout(() => {
      this.menuIndex = 0;
      this.clickFocusBtn('photo_menu0', true);
    }, FOCUS_CHANGE_DELAY)
  }

  async clearAllPhotos() {
    photoManager.delete(AlbumType.TRASH, this.photoList.getAllData() as PhotoModel[])
    this.isShowMenu = false;
  }

  selectPhoto(index: number) {
    this.pictureChooseFlags[index] = !this.pictureChooseFlags[index];
    const count = this.pictureChooseFlags.filter(item => item).length;
    this.isCheckAll = count === this.photoList.totalCount() ? true : false;
  }

  getSelectedPhotos(): PhotoModel[] {
    let picUris: PhotoModel[] = [];
    this.pictureChooseFlags.forEach((item, index) => {
      if (item) {
        picUris.push(this.photoList.getData(index) as PhotoModel);
      }
    })
    Logger.error(TAG, `getSelectedPhotoUri length = ${picUris.length}`);
    return picUris;
  }

  async restorePhotos() {
    let photos = this.getSelectedPhotos();
    if (photos.length > 0) {
      try {
        await photoManager.recoverTrash(photos)
        this.cancelPhotoSelect();
        this.dismissMenu();
      } catch (e) {
        Logger.error(TAG, 'restorePhotos fail ' + JSON.stringify(e))
      }
    } else {
      promptAction.showToast({
        message: $r('app.string.please_choose_photo')
      });
    }
  }

  async deletePhotos() {
    let photos = this.getSelectedPhotos();
    if (photos.length > 0) {
      try {
        await photoManager.delete(AlbumType.TRASH, photos);
        this.cancelPhotoSelect();
        this.isShowMenu = false;
        this.isShowDeleteDialog = false;
        this.deleteIndex = 1;
        setTimeout(() => {
          this.pictureIndex = 0;
          this.clickFocusBtn('picture0', false);
        }, FOCUS_CHANGE_DELAY)
      } catch (e) {
        Logger.error(TAG, 'deletePhotos error ' + JSON.stringify(e))
      }
    }
  }

  build() {
    Column() {
      Row() {
        Row() {
          Text(this.title)
            .fontFamily('HarmonyOS Sans')
            .fontColor(Color.White)
            .fontSize('64lpx')
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: '33lpx',
        right: '33lpx',
        top: '48lpx',
        bottom: '36lpx'
      })

      Row() {
        Text($r('app.string.album_trash_secondary_title'))
          .fontFamily('HarmonyOS Sans')
          .fontColor(Color.White)
          .fontSize('28lpx')
          .margin({
            left: '33lpx',
            bottom: '24lpx'
          })
      }.width('100%').justifyContent(FlexAlign.Start)


      Row() {
        if (this.photoListSize === 0 && this.isPhotoData) {
          Text($r('app.string.no_data'))
            .fontColor(Color.White)
            .fontSize('34lpx')
            .size({ height: `calc(100% - 520lpx)` })
        } else {
          Grid(this.scroller) {
            LazyForEach(this.photoList, (item: PhotoModel, index: number) => {
              GridItem() {
                Column() {
                  Stack() {
                    Image(item.photoType === photoAccessHelper.PhotoType.VIDEO ?
                      (item.thumbnail || $r('app.media.p_video')) : item.uri)
                      .borderRadius('18lpx')
                      .id('picture' + index)
                      .focusable(true)
                      .defaultFocus(index === 0)
                      .width('100%')
                      .aspectRatio(1)
                      .autoResize(false)
                      .interpolation(ImageInterpolation.Medium)
                      .shadow({ radius: 1, color: Color.Gray })
                      .onKeyEvent((event: KeyEvent) => {
                        if (event.keyCode === KeyCode.KEYCODE_DPAD_LEFT && event.type === KeyType.Down) {
                          if (this.pictureIndex !== 0) {
                            this.pictureIndex--;
                            this.scroller.scrollToIndex(this.pictureIndex, true, ScrollAlign.AUTO);
                            this.clickFocusBtn('picture' + this.pictureIndex, false);
                          }
                        }
                        if (event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT && event.type === KeyType.Down) {
                          if (this.pictureIndex === this.photoList.totalCount() - 1) {
                            return;
                          }
                          this.pictureIndex++;
                          this.scroller.scrollToIndex(this.pictureIndex, true, ScrollAlign.AUTO);
                          this.clickFocusBtn('picture' + this.pictureIndex, false);
                        }
                        if (event.keyCode === KeyCode.KEYCODE_DPAD_DOWN && event.type === KeyType.Down) {
                          if (this.pictureIndex + this.gridRowCount > this.photoList.totalCount() - 1) {
                            return;
                          }
                          this.pictureIndex += this.gridRowCount;
                          this.scroller.scrollToIndex(this.pictureIndex, true, ScrollAlign.AUTO);
                          this.clickFocusBtn('picture' + this.pictureIndex, false);
                        }
                        if (event.keyCode === KeyCode.KEYCODE_DPAD_UP && event.type === KeyType.Down) {
                          if (this.pictureIndex >= this.gridRowCount) {
                            this.pictureIndex -= this.gridRowCount;
                            this.scroller.scrollToIndex(this.pictureIndex, true, ScrollAlign.AUTO);
                            this.clickFocusBtn('picture' + this.pictureIndex, false);
                          }
                        }
                        if ((event.keyCode === KeyCode.KEYCODE_DPAD_CENTER ||
                          event.keyCode === KeyCode.KEYCODE_ENTER) &&
                          event.type === KeyType.Down) {
                          if (this.isPhotoSelecting) {
                            this.selectPhoto(index)
                          } else if (item && item.photoType === Constants.PHOTO_TYPE_VIDEO) {
                            if (isAppInstalled()) {
                              getToVideoApp(item.uri, item.displayName, item.thumbnail);
                            }
                          } else {
                            router.pushUrl({
                              url: 'pages/PhotoWatch',
                              params: {
                                photoIndex: index,
                                photoList: this.photoList.getAllData()
                              }
                            })
                          }
                        }
                        // 数字1KEYCODE_NUMPAD_1
                        if ((event.keyCode === KeyCode.KEYCODE_MENU || event.keyCode === KeyCode.KEYCODE_NUMPAD_1) &&
                          event.type === KeyType.Down) {
                          if (this.isPhotoSelecting && this.isCheckAll) {
                            this.menuList = SECONDARY_MENU_LIST_CANCEL;
                          } else if (this.isPhotoSelecting && !this.isCheckAll) {
                            this.menuList = SECONDARY_MENU_LIST_DEFAULT;
                          } else {
                            this.menuList = PRIMARY_MENU_LIST;
                          }
                          this.isShowMenu = true;
                          setTimeout(() => {
                            this.clickFocusBtn('photo_menu0', true);
                            this.menuIndex = 0;
                          }, 50)
                        }
                        //返回键KEYCODE_BACK
                        if (event.keyCode === KeyCode.KEYCODE_NUMPAD_2 && event.type === KeyType.Down &&
                        this.isPhotoSelecting) {
                          this.cancelPhotoSelect();
                        }
                      })
                      .onClick(()=>{
                        this.pictureIndex = index
                        this.clickFocusBtn('picture' + this.pictureIndex, false)
                        if (this.isPhotoSelecting) {
                          this.selectPhoto(index)
                        } else {
                          if (item && item.photoType === Constants.PHOTO_TYPE_VIDEO) {
                            if (isAppInstalled()) {
                              getToVideoApp(item.uri, item.displayName, item.thumbnail);
                            }
                          } else {
                            router.pushUrl({
                              url: 'pages/PhotoWatch',
                              params: {
                                photoIndex: index,
                                photoList: this.photoList.getAllData()
                              }
                            })
                          }
                        }
                      })
                      .onHover(() => {
                        this.pictureIndex = index
                        this.scroller.scrollToIndex(this.pictureIndex, true, ScrollAlign.AUTO);
                        this.clickFocusBtn('picture' + this.pictureIndex, false);
                      })
                      .onTouch(event => {
                        if (!EventUtil.isTouchEvent(event)) {
                          return
                        }
                        if (event.sourceTool !== SourceTool.Pen &&
                          event.sourceTool !== Constants.SOURCE_TOOL_MOUSE_CLICK) {
                          return;
                        }
                        if (event.type == TouchType.Up) {
                          if (this.isPhotoSelecting) {
                            this.selectPhoto(index)
                          } else {
                            if (item && item.photoType === Constants.PHOTO_TYPE_VIDEO) {
                              if (isAppInstalled()) {
                                getToVideoApp(item.uri, item.displayName, item.thumbnail);
                              }
                            } else {
                              router.pushUrl({
                                url: 'pages/PhotoWatch',
                                params: {
                                  photoIndex: index,
                                  photoList: this.photoList.getAllData()
                                }
                              })
                            }
                          }
                        }
                      })
                    Row() {
                      // 缩略图左下角视频时长
                      Text(item != null && item.photoType == Constants.PHOTO_TYPE_VIDEO ?
                      Util.getFormattedDuration(Number(item.duration)) : '')
                        .fontSize('24lpx')
                        .fontFamily('HarmonyOS Sans')
                        .fontColor('#DBFFFFFF')
                        .lineHeight('28lpx')
                        .margin({ left: '8%', bottom: '4%' })
                      // 照片编辑状态
                      if (this.isPhotoSelecting) {
                        Image(this.pictureChooseFlags[index] ? $r('app.media.p_yes') : $r('app.media.p_no'))
                          .width('24lpx')
                          .aspectRatio(1)
                          .margin({ right: '5%', bottom: '5%' })
                      } else {
                        Text(Util.getRemainingDays(getContext(), Number((item.dateTrashed ?? 0))))
                          .fontSize('24lpx')
                          .fontFamily('HarmonyOS Sans')
                          .fontColor('#DBFFFFFF')
                          .lineHeight('28lpx')
                          .margin({ left: '8%', bottom: '4%' })
                      }
                    }
                    .width('100%')
                    .justifyContent(FlexAlign.SpaceBetween)
                    .align(Alignment.BottomStart)
                  }.align(Alignment.BottomEnd)
                }
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .borderRadius('22lpx')
                .margin('24lpx')
                .padding('6lpx')
                .border({
                  width: 2,
                  color: this.focusPhotoStr === ('picture' + index) ? '#fff' : Color.Transparent,
                  style: BorderStyle.Solid
                })
              }
            }, (item: string, index: number) => (JSON.stringify(item) + index))
          }
          .columnsTemplate('1fr '.repeat(this.gridRowCount))
          .width('100%')
          .scrollBar(BarState.Off)
          .padding({ left: '4lpx', right: '4lpx' })
          .size({ height: `calc(100% - 210lpx)` })
        }
      }

      if (this.isShowMenu) {
        Flex({ justifyContent: FlexAlign.Center }) {
          Row() {
            ForEach(this.menuList, (item: DialogModel, index: number) => {
              ListItem() {
                Column() {
                  Image($r(item.uri))
                    .width('80lpx')
                    .aspectRatio(1)
                    .margin({ bottom: '12lpx' })
                    .id('photo_menu' + index)
                    .focusable(true)
                    .defaultFocus(this.isShowMenu && index === 0)
                    .borderRadius('40lpx')
                    .padding('6lpx')
                    .border({
                      width: 2,
                      color: this.focusDialogStr === ('photo_menu' + index) ? '#fff' : Color.Transparent, // 边框颜色
                      style: BorderStyle.Solid
                    })
                    .onKeyEvent(e => {
                      if (e.keyCode === KeyCode.KEYCODE_DPAD_LEFT && e.type === KeyType.Down) {
                        if (this.menuIndex !== 0) {
                          this.clickFocusBtn('photo_menu' + (this.menuIndex - 1), true);
                          this.menuIndex--;
                        }
                      }
                      if (e.keyCode === KeyCode.KEYCODE_DPAD_RIGHT && e.type === KeyType.Down) {
                        if (this.menuIndex < this.menuList.length - 1) {
                          this.clickFocusBtn('photo_menu' + (this.menuIndex + 1), true);
                          this.menuIndex++;
                        }
                      }
                      // 电脑回车键KEYCODE_ENTER
                      if ((e.keyCode === KeyCode.KEYCODE_DPAD_CENTER || e.keyCode === KeyCode.KEYCODE_ENTER) &&
                        e.type === KeyType.Down) {
                        if (this.isPhotoSelecting) {
                          if (this.focusDialogStr === 'photo_menu0') {
                            // 恢复
                            this.restorePhotos();
                          } else if (this.focusDialogStr === 'photo_menu1') {
                            // 删除
                            if (this.getSelectedPhotos().length > 0) {
                              this.isShowDeleteDialog = true;
                              setTimeout(() => {
                                this.clickFocusBtn('delete1', true)
                              }, FOCUS_CHANGE_DELAY)
                            } else {
                              promptAction.showToast({
                                message: $r('app.string.please_choose_photo')
                              });
                            }
                          } else {
                            // 全选/取消全选
                            this.pictureChooseFlags =
                              this.isCheckAll ? new Array(this.photoList.totalCount()).fill(false) :
                              new Array(this.photoList.totalCount()).fill(true)
                            this.isCheckAll = !this.isCheckAll;
                            this.menuList = this.isCheckAll ? SECONDARY_MENU_LIST_CANCEL : SECONDARY_MENU_LIST_DEFAULT;
                          }
                        } else {
                          if (this.focusDialogStr === 'photo_menu0') {
                            this.isPhotoSelecting = true;
                            this.pictureChooseFlags = new Array(this.photoList.totalCount()).fill(false);
                            this.scroller.scrollToIndex(this.pictureIndex, true, ScrollAlign.AUTO)
                            this.clickFocusBtn(this.focusPhotoStr, false);
                            this.selectPhoto(this.pictureIndex)
                            this.isShowMenu = false;
                          } else if (this.focusDialogStr === 'photo_menu1') {
                            this.clearAllPhotos();
                          }
                        }
                      }
                      //返回键
                      if (e.keyCode === KeyCode.KEYCODE_NUMPAD_2 && e.type === KeyType.Down) {
                        this.dismissMenu();
                      }
                    })
                    .onHover(() => {
                      this.menuIndex = index;
                      this.clickFocusBtn('photo_menu' + (this.menuIndex), true);
                    })
                    .onClick(()=>{
                      this.menuIndex = index
                      this.clickFocusBtn('photo_menu' + this.menuIndex, true);
                      if (this.isPhotoSelecting) {
                        if (this.focusDialogStr === 'photo_menu0') {
                          // 恢复
                          this.restorePhotos();
                        } else if (this.focusDialogStr === 'photo_menu1') {
                          // 删除
                          if (this.getSelectedPhotos().length > 0) {
                            this.isShowDeleteDialog = true;
                            setTimeout(() => {
                              this.clickFocusBtn('delete1', true)
                            }, FOCUS_CHANGE_DELAY)
                          } else {
                            promptAction.showToast({
                              message: $r('app.string.please_choose_photo')
                            });
                          }
                        } else {
                          // 全选/取消全选
                          this.pictureChooseFlags =
                            this.isCheckAll ? new Array(this.photoList.totalCount()).fill(false) :
                              new Array(this.photoList.totalCount()).fill(true)
                          this.isCheckAll = !this.isCheckAll;
                          this.menuList = this.isCheckAll ? SECONDARY_MENU_LIST_CANCEL : SECONDARY_MENU_LIST_DEFAULT;
                        }
                      } else {
                        if (this.focusDialogStr === 'photo_menu0') {
                          this.isPhotoSelecting = true;
                          this.pictureChooseFlags = new Array(this.photoList.totalCount()).fill(false);
                          this.scroller.scrollToIndex(this.pictureIndex, true, ScrollAlign.AUTO)
                          this.clickFocusBtn(this.focusPhotoStr, false);
                          this.selectPhoto(this.pictureIndex)
                          this.isShowMenu = false;
                        } else if (this.focusDialogStr === 'photo_menu1') {
                          this.clearAllPhotos();
                        }
                      }
                    })
                    .onTouch(event => {
                      if (!EventUtil.isTouchEvent(event)) {
                        return
                      }
                      if (event.sourceTool !== SourceTool.Pen &&
                        event.sourceTool !== Constants.SOURCE_TOOL_MOUSE_CLICK) {
                        return;
                      }
                      this.menuIndex = index;
                      this.clickFocusBtn('photo_menu' + this.menuIndex, true);
                    })
                  Text(item.name)
                    .fontSize('24lpx')
                    .height('35lpx')
                    .lineHeight('35lpx')
                    .fontColor(Color.White)
                }
                .width('100lpx')
                .margin({
                  left: '4lpx',
                  right: '4lpx'
                })
              }
            })
          }
          .backgroundColor('#CC424242')
          .borderRadius('48lpx')
          .padding({
            top: '20lpx',
            right: '26lpx',
            bottom: '20lpx',
            left: '26lpx'
          })
          .justifyContent(FlexAlign.Center)
        }
        .position({ x: '0%', y: '75%' })
      }

      if (this.isShowDeleteDialog) {
        Flex({ justifyContent: FlexAlign.Center }) {
          Column() {
            Column() {
              Text($r('app.string.to_delete_the_file'))
                .fontSize('40lpx')
                .fontColor(Color.White)
                .width('100%')
                .fontWeight(FontWeight.Bold)
                .textAlign(TextAlign.Center)
            }.margin({ bottom: '40lpx' })

            Row() {
              ForEach(this.deleteList, (item: string, index: number) => {
                Column() {
                  Text(item)
                    .width('230lpx')
                    .height('72lpx')
                    .id('delete' + index)
                    .focusable(true)
                    .backgroundColor(index === 1 ? this.deleteIndex === 0 ? '#99E52424' : '#FFE52424' : '#33FFFFFF')
                    .borderRadius('200lpx')
                    .fontFamily('HarmonyOS Sans')
                    .fontSize('36lpx')
                    .textAlign(TextAlign.Center)
                    .fontColor('#DBFFFFFF')
                    .fontWeight(FontWeight.Bold)
                    .onKeyEvent(e => {
                      if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Down) {
                        if (this.deleteIndex !== 0) {
                          this.clickFocusBtn('delete' + (this.deleteIndex - 1), true)
                          this.deleteIndex--;
                        }
                      }
                      if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down) {
                        if (this.deleteIndex < this.deleteList.length - 1) {
                          this.clickFocusBtn('delete' + (this.deleteIndex + 1), true)
                          this.deleteIndex++
                        }
                      }
                      // 电脑回车键KEYCODE_ENTER
                      if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                        e.type == KeyType.Down) {
                      }
                    })
                    .onClick(()=>{
                      this.deleteIndex = index
                      this.clickFocusBtn('delete' + this.deleteIndex, true)
                      if (this.deleteIndex === 0) {
                        setTimeout(() => {
                          this.dismissDeleteDialog();
                        }, 100)
                      } else {
                        this.deletePhotos();
                      }
                    })
                }
                .borderRadius('200lpx')
                .padding('6lpx')
                .border({
                  width: 2,
                  color: this.focusDialogStr == ('delete' + index) ? '#fff' : Color.Transparent,
                  style: BorderStyle.Solid
                })
              })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('640lpx')
          .height('260lpx')
          .backgroundColor('rgba(64, 64, 64, 1.0)')
          .shadow({ radius: 4, color: 'rgba(255, 255, 255, 0.25)' })
          .borderRadius('24lpx')
          .padding('48lpx')
        }
        .position({ x: '0%', y: '39%' })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.main_color'))
    .padding({ left: '63lpx', right: '63lpx' })
  }
}
