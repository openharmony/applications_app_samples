import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { DialogModel, PhotoModel } from '../models/PhotoModel';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { BusinessError } from '@ohos.base';
import Logger from '../common/Logger';
import { abilityAccessCtrl, common, launcherBundleManager, Permissions } from '@kit.AbilityKit';
import { Constants } from '../common/Constants';
import { inputConsumer } from '@kit.InputKit';
import { getThumbByUri } from '../manager/loader/LoadUtil';
import { PhotoDataModel } from '../models/IDataSource';
import { DirectoryEntry } from 'smbProtocol';
import nasSessionManager from '../smaba/NasSessionManager';
import { image } from '@kit.ImageKit';
import fs from '@ohos.file.fs';
import  hlgallery from '@ohos.hlgallery';

import { getAllMediaItems } from '../manager/loader/MediaTasks';
import photoManager from '../manager/PhotoManager';
import { JSON } from '@kit.ArkTS';
import { getToVideoApp, isAppInstalled } from './Index';
import hlGallery from '@ohos.hlgallery';
import deviceInfo from '@ohos.deviceInfo';

const TAG = 'PhotoWatch';
const FOCUS_DELAY = 100;
const SourceToolSeven = 7;
const SWIPE_THRESHOLD = 40;

@Entry
@Component
struct PhotoWatch {
  @State params: object = router.getParams() as Record<string, number>;
  @State @Watch("photoIndexChange") photoIndex: number = 0;
  //photoModel:存储图片信息的类
  @State photoList: PhotoDataModel[] = [];
  @State currentUri: string | undefined =
    undefined
  @StorageProp('directUri')@Watch("directUrichange") directUri: string | undefined =
    undefined
  @StorageProp('directType') directType: string | undefined =
    undefined
  controllers: VideoController = new VideoController();
  @State focusStr: string = 'watchFocus';
  @State isVideo: boolean = false;
  @State selectedIndex: number = 0;
  @State isTransfer: boolean = true;
  @State rotateValue: number = 0;
  @State rotateLandScape: boolean = true
  @State isShowMenu: boolean = false;
  @State @Watch('view_4kWatch')isFromRemote: boolean = false;
  @State menuList: DialogModel[] = [{
    uri: 'app.media.p_rotate',
    name: $r('app.string.rotate')
  }];
  @State altImage: string | undefined = undefined
  @State @Watch('view_4kWatch')selectPhotoModel?: PhotoModel = undefined
  private nasHost?: string
  @State nasImage: image.PixelMap | undefined = undefined
  @State is_4k:boolean = false
  @State isNative4KViewing: boolean = false
  private imageContainerWidth: Length = '100%'
  private imageContainerHeight: Length = '100%'
  @State transferIndex: number = -1
  @State transferPhotoList: PhotoModel[] = []
  @State photoUri: string = ''
  @State isReayToShow:boolean = false
  @State panOffsetX: number = 0;
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
      if (this.focusStr === 'watchFocus') {
        this.openRotateMenu();
      }
    }
  }
  aboutToBeDeleted() {

  }

  directUrichange(){
    console.log('directUrichange',this.directUri);
  }
  //图片下标变化，每次重新加载图片前，赋初值
  photoIndexChange() {
    Logger.info(TAG, `photoIndexChange this.nasHost =${this.nasHost} index = ${this.photoIndex}`)
    if (this.nasHost) {
      this.altImage = undefined
      this.nasImage = undefined
      nasSessionManager.readThumb(this.nasHost, this.photoList[this.photoIndex] as DirectoryEntry, this.photoIndex)
        .then((thumbResult) => {
          console.info(TAG, `load thumb success ${JSON.stringify(thumbResult)}`)
          if (thumbResult.index === this.photoIndex) {
            this.altImage = thumbResult.localPath
          }
        })

      nasSessionManager.readImage(this.nasHost, this.photoList[this.photoIndex] as DirectoryEntry, this.photoIndex)
        .then((imageResult) => {
          if (imageResult.index === this.photoIndex) {
            console.info(TAG, `load image success ${JSON.stringify(imageResult)}`)
            this.nasImage = imageResult.pixelMap
          }
        }).catch((err: BusinessError) => {
        console.error(TAG, `load image fail ${JSON.stringify(err)}`)
      })

    } else {
      this.altImage = undefined
      if (this.photoList && this.photoList.length > 0 && this.photoList.length > this.photoIndex) {
        this.selectPhotoModel = this.photoList[this.photoIndex] as PhotoModel
        getThumbByUri(getContext(), this.selectPhotoModel, 'detail').then((thumbUri) => {
          this.altImage = thumbUri
        })
      }
    }
  }

  insertAtFront(arr: PhotoModel[], newItem: PhotoModel): PhotoModel[] {
    return [newItem, ...arr];
  }

  async getPermission(): Promise<void> {
    this.transferPhotoList = await getAllMediaItems('init', getContext())
    photoManager.init(getContext() as common.UIAbilityContext)
    nasSessionManager.init(getContext() as common.UIAbilityContext)
  }

  aboutToAppear() {
    this.directUri = AppStorage.get<string>('directUri')
    this.directType = AppStorage.get<string>('directType')
    if (this.directUri) {
      this.photoUri = this.directUri
    }
    if (this.params && this.params['photoIndex'] >= 0) {
      this.photoIndex = this.params['photoIndex'];
      this.nasHost = this.params['nasHost']
      Logger.info(TAG, ' nasHost = ' + this.nasHost)
      if (this.nasHost) {
        this.photoList = nasSessionManager.getImageFiles(this.nasHost)
      } else {
        this.photoList = this.params['photoList'];
      }
      this.isFromRemote = this.params['isFromRemote'];
      this.defaultFocusBtn();
      this.photoIndexChange();
    } else {
      this.getPermission();
      this.isTransfer = false;
    }
  }
  aboutToDisappear(): void {
    // this.directUri = AppStorage.get<string>('directUri')
    // this.directType = AppStorage.get<string>('directType')
  }
  view_4kWatch() {
    this.is_4k = this.is4K(this.isFromRemote ? this.selectPhotoModel! :
      this.selectPhotoModel!)
    console.log('Photo width judge is4K --1', JSON.stringify(this.is_4k))
    if (this.is_4k && this.shouldUseNative4KViewer()) {
      this.view4K()
    } else {
      this.isNative4KViewing = false
    }
      this.recoverRotateBtn()
  }


  onPageShow() {
    if (!this.directUri){
      this.directUri=this.currentUri
    }
    this.is_4k = this.is4K(this.isFromRemote ? this.selectPhotoModel! :
      this.selectPhotoModel!)
    if (this.is_4k && this.shouldUseNative4KViewer()) {
        this.view4K()
    } else {
      this.isNative4KViewing = false
    }
    try {
      inputConsumer.on("key", this.keyOptions, this.keyCallback);
      inputConsumer.on("key", this.keyOptionsMenu, this.keyCallback);
    } catch (error) {
      Logger.error(`Subscribe failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }
    this.defaultFocusBtn();
    console.log("Pageshow路径"+this.directUri)
    console.log("pageshow类型"+this.directType)
  }

  onPageHide(): void {
    this.exitNative4KView();
    inputConsumer.off("key", this.keyOptions);
    inputConsumer.off("key", this.keyOptionsMenu);
    this.currentUri = this.directUri
    this.directUri = undefined
    console.log("PageHide路径"+this.directUri)
    console.log("pageHide类型"+this.directType)
  }

  defaultFocusBtn() {
    setTimeout(() => {
      focusControl.requestFocus(this.focusStr);
    }, 50)
  }

  clickFocusBtn(str: string) {
    this.focusStr = str;
    focusControl.requestFocus(str);
  }

  clickRotateBtn() {
    this.rotateValue += Constants.ANGLE_90;
    this.rotateLandScape = this.rotateValue % Constants.ANGLE_180 === 0
  }

  private shouldUseNative4KViewer(): boolean {
    // Native 4K viewer conflicts with ArkUI rotate menu/focus on TV.
    // Use ArkUI rendering to keep menu interaction stable.
    return false;
  }

  private canOpenRotateMenu(): boolean {
    if (!this.isTransfer) {
      return this.directType !== 'video';
    }
    return !!this.selectPhotoModel && this.selectPhotoModel.photoType === Constants.PHOTO_TYPE_IMAGE;
  }

  private exitNative4KView(): void {
    if (!this.is_4k || !this.isNative4KViewing) {
      return;
    }
    try {
      hlGallery.exitViewImage()
      this.isNative4KViewing = false
    } catch (err) {
      console.debug(TAG, "exitViewImage Err:" + JSON.stringify(err));
    }
  }

  private openRotateMenu(): void {
    if (!this.canOpenRotateMenu()) {
      return;
    }
    // 4K native view is above ArkUI. Exit native view first
    // so the ArkUI rotate menu is visible and operable.
    this.exitNative4KView();
    this.isShowMenu = true;
    setTimeout(() => {
      this.clickFocusBtn('photo_menu_0');
    }, FOCUS_DELAY);
  }

  recoverRotateBtn() {
    this.rotateValue = 0;
    this.rotateLandScape = true
  }

  onBackPress(): boolean | void {
    console.log(TAG, 'onBackPress  this.isShowMenu  border', this.isShowMenu)
    if (this.isShowMenu) {
      this.isShowMenu = false;
      this.clickFocusBtn('watchFocus');
      return true;
    }
    return false;
  }

  getImageWidth(landScape: boolean): Length {
    return landScape ? this.imageContainerWidth : this.imageContainerHeight
  }

  getImageHeight(landScape: boolean): Length {
    return landScape ? this.imageContainerHeight : this.imageContainerWidth
  }

  is4K(image: PhotoModel): boolean {
    if(deviceInfo.productModel == "gk6320v100crb_b_vb"){
      return false;
    }else {
      try {
        console.log(TAG, "is4K  image is " + JSON.stringify(image.width))
        if (image.width && image.width >= 3840) {
          return true
        }
        return false
      }catch (e) {
        console.log(TAG, "is4K image width err: " + e)
      }
      return false;
    }
  }
  async view4K() {
    console.log(TAG, "view4K  border open")
    try {
      let uri = this.isFromRemote ? this.selectPhotoModel?.remoteUri :
        this.selectPhotoModel?.uri
      if (uri) {
        let file: fs.File = fs.openSync(uri)
        let viewFd = file.fd
        try {
          hlgallery.viewImage(viewFd)
          this.isNative4KViewing = true
        } catch (e) {
          console.error(TAG, "view4K catch err: " + e)
        } finally {
          fs.closeSync(file)
        }
      }
    } catch (e) {
      console.log(TAG, "view4K catch err border: " + e)
    }

  }

  goPrev() {
    //isTransfer:布尔类型变量 遍历图片里面的内容
    if (!this.isTransfer) {
      //当前指向第一张图片，transferIndex初始值为-1
      if (this.transferIndex === 0 && this.directUri === this.photoUri || this.transferIndex === -1) {
        promptAction.showToast({
          message: $r('app.string.first_photo')
        });
        this.transferIndex = -1;
        return;
      }
      //遍历图片里面的内容
      if (this.transferPhotoList.length > 0) {
        if (this.transferIndex === 0) {
          //获取图片路径
          this.directUri = this.photoUri;
          console.log('for 获取到的图片路径' + this.directUri);
          return;
        }
        this.transferIndex--;
        this.directUri = this.transferPhotoList[this.transferIndex].uri;
        console.log('获取到的图片路径' + this.directUri);
      }
      return;
    }
    if (this.photoIndex === 0) {
      promptAction.showToast({
        message: $r('app.string.first_photo')
      });
      return;
    }
    this.isVideo = false;
    this.controllers.pause();
    this.photoIndex--;
    this.clickFocusBtn('watchFocus');
  }

  goNext() {
    if (!this.isTransfer) {
      if (this.transferPhotoList.length > 0) {
        if (this.transferIndex === this.transferPhotoList.length - 1) {
          promptAction.showToast({
            message: $r('app.string.first_photo')
          });
          return;
        }
        this.transferIndex++;
        this.directUri = this.transferPhotoList[this.transferIndex].uri;
        console.log('获取到的图片路径421' + this.directUri);
      }
      return;
    }
    //图片的张数和当前图片下标一致
    if (this.photoList.length - 1 === this.photoIndex) {
      promptAction.showToast({
        message: $r('app.string.last_photo')
      });
      return;
    }
    this.isVideo = false;
    this.controllers.pause();
    this.photoIndex++;
    this.clickFocusBtn('watchFocus');
  }

  @Builder
  nasImageContainer() {
    Image(this.nasImage ?? this.altImage)
      .objectFit(ImageFit.Contain)
      .autoResize(true)
      .width(this.getImageWidth(this.rotateLandScape))
      .height(this.getImageHeight(this.rotateLandScape))
      .rotate({ angle: this.rotateValue })
      .onError((event) => {
        promptAction.showToast({
          message: $r('app.string.cannot_open_this_image')
        });
      })
  }

  @Builder
  imageContainer() {
    if (this.selectPhotoModel && this.selectPhotoModel.photoType === Constants.PHOTO_TYPE_IMAGE) {
      if (this.is4K(this.isFromRemote ? this.selectPhotoModel :
      this.selectPhotoModel)) {
        Image(this.isFromRemote ? this.selectPhotoModel.remoteUri :
          (this.selectPhotoModel.uri || this.selectPhotoModel.thumbnail))
          .objectFit(ImageFit.Contain)
          .autoResize(true)
          .width(this.getImageWidth(this.rotateLandScape))
          .height(this.getImageHeight(this.rotateLandScape))
          .rotate({ angle: this.rotateValue })
          .alt(this.altImage)
          .onError((event) => {
            promptAction.showToast({
              message: $r('app.string.cannot_open_this_image')
            });
          })
      } else {
        Image(this.isFromRemote ? this.selectPhotoModel.remoteUri :
          (this.selectPhotoModel.uri || this.selectPhotoModel.thumbnail))
          .objectFit(ImageFit.Contain)
          .autoResize(true)
          .width(this.getImageWidth(this.rotateLandScape))
          .height(this.getImageHeight(this.rotateLandScape))
          .rotate({ angle: this.rotateValue })
          .alt(this.altImage)
          .onError((event) => {
            promptAction.showToast({
              message: $r('app.string.cannot_open_this_image')
            });
          })
      }
    } else if (this.selectPhotoModel && this.selectPhotoModel.photoType === Constants.PHOTO_TYPE_VIDEO) {
      Video({
        src: this.isFromRemote ? this.selectPhotoModel.remoteUri : this.selectPhotoModel.uri,
        controller: this.controllers,
        previewUri:this.altImage
      })
        .objectFit(ImageFit.Auto)
        .autoPlay(false)
        .controls(true)
        .onStart(() => {
          this.isVideo = true;
        })
        .onPause(() => {
          this.isVideo = false;
        })
        .onFinish(() => {
          this.isVideo = false;
        })
        .onPrepared(() => {
          this.isVideo = false;
        })
    }
  }

  build() {
    Column() {
      Stack() {
        Stack() {
          if (!this.isTransfer && this.directUri) {
            if (this.directType == 'video') {
              Video({
                src: this.directUri,
                controller: this.controllers
              })
                .objectFit(ImageFit.Auto)
                .autoPlay(false)
                .controls(true)
                .onStart(() => {
                  this.isVideo = true;
                })
                .onPause(() => {
                  this.isVideo = false;
                })
                .onFinish(() => {
                  this.isVideo = false;
                })
                .onPrepared(() => {
                  this.isVideo = false;
                });
            } else {
              Image(this.directUri)
                .autoResize(true)
                .objectFit(ImageFit.Contain)
                .width(this.getImageWidth(this.rotateLandScape))
                .height(this.getImageHeight(this.rotateLandScape))
                .rotate({ angle: this.rotateValue })
                .onError((event) => {
                  promptAction.showToast({
                    message: $r('app.string.cannot_open_this_image')
                  });
                });
            }
          } else if (this.photoList.length > 0) {
            if (this.nasHost) {
              this.nasImageContainer();
            } else {
              this.imageContainer();
            }
          } else if (!this.isTransfer && !this.directUri) {
            Column() {
              Text('加载中...') {
              }
              .fontColor(Color.White)
              .width('200px')
              .height('200px');

              // .margin("5px")
              Image($r('app.media.lading'))
                .width('100px');
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .backgroundColor(Color.Black)
            .width('100%')
            .height('100%');
          }
          Text('') {
          }
          .id('watchFocus')
          .focusable(true)
          .defaultFocus(true)
          .width('100%')
          .height('100%')
          .onKeyEvent(event => {
            //确认键值和按键类型是否对的上
            if (event.keyCode === KeyCode.KEYCODE_DPAD_LEFT && event.type === KeyType.Down) {
              this.goPrev();
            }
            //确认键值和按键类型
            if (event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT && event.type === KeyType.Down) {
              this.goNext();
            }
            //按下center或者enter按钮，按键类型为上或下
            if ((event.keyCode === KeyCode.KEYCODE_DPAD_CENTER || event.keyCode === KeyCode.KEYCODE_ENTER) &&
              event.type == KeyType.Down) {
              //nasHost为字符串类型的私有变量
              if (!this.nasHost) {
                //PhotoModel为图片参数，isFromRemote为是否为遥控器操作，初始值为false，isTransfer初始值为true
                let photoModel = this.photoList[this.photoIndex] as PhotoModel
                if (photoModel && photoModel.photoType === Constants.PHOTO_TYPE_VIDEO && this.isTransfer) {
                  //isAppInstalled:是否安装播放软件
                  if (isAppInstalled() && !this.isFromRemote) {
                    //getToVideoApp:跳转到播放软件
                    getToVideoApp(photoModel.uri, photoModel.displayName, photoModel.thumbnail);
                  } else {
                    if (this.isVideo) {
                      this.controllers.pause();
                    } else {
                      this.controllers.start();
                    }
                  }
                }
              }
              //如果为视频
              if (!this.isTransfer && this.directUri && this.directType == 'video') {
                if (this.isVideo) {
                  this.controllers.pause();
                } else {
                  this.controllers.start();
                }
              }
            }
            //菜单键
            if ((event.keyCode === KeyCode.KEYCODE_MENU || event.keyCode === KeyCode.KEYCODE_NUMPAD_1) &&
              event.type === KeyType.Down) {
              this.openRotateMenu();
            }
          })
          .onClick(() => {
            //nasHost为字符串类型的私有变量
            if (!this.nasHost) {
              //PhotoModel为图片参数，isFromRemote为是否为遥控器操作，初始值为false，isTransfer初始值为true
              let photoModel = this.photoList[this.photoIndex] as PhotoModel;
              if (photoModel && photoModel.photoType === Constants.PHOTO_TYPE_VIDEO && this.isTransfer) {
                //isAppInstalled:是否安装播放软件
                if (isAppInstalled() && !this.isFromRemote) {
                  //getToVideoApp:跳转到播放软件
                  getToVideoApp(photoModel.uri, photoModel.displayName, photoModel.thumbnail);
                } else {
                  if (this.isVideo) {
                    this.controllers.pause();
                  } else {
                    this.controllers.start();
                  }
                }
              }
            }
            //如果为视频
            if (!this.isTransfer && this.directUri && this.directType == 'video') {
              if (this.isVideo) {
                this.controllers.pause();
              } else {
                this.controllers.start();
              }
            }
          });
        }
        .width('100%')
        .height('100%')
        .backgroundColor($r('app.color.main_color'))
        .onAreaChange((_, newValue) => {
          this.imageContainerWidth = newValue.width;
          this.imageContainerHeight = newValue.height;
        })
        .gesture(
          GestureGroup(GestureMode.Parallel,
            PanGesture({
              fingers: 1,
              direction: PanDirection.Horizontal
            })
              .onActionUpdate((event: GestureEvent) => {
                this.panOffsetX = event.offsetX;
              })
              .onActionEnd((event: GestureEvent) => {
                if (this.isShowMenu) {
                  return;
                }
                if (event.offsetX > SWIPE_THRESHOLD) {
                  Logger.debug('right swipe ' + event.offsetX);
                  this.goPrev();
                } else if (event.offsetX < -SWIPE_THRESHOLD) {
                  Logger.debug('left swipe ' + event.offsetX);
                  this.goNext();
                }
                // 重置偏移量
                this.panOffsetX = 0;
              })
              .onActionCancel(() => {
                this.panOffsetX = 0;
              }),
            LongPressGesture({
              repeat: false,
              duration: 500
            })
              .onAction(() => {
                this.openRotateMenu();
              })
          )
        );

        if (this.isShowMenu && !this.isVideo) {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor(Color.Transparent)
            .onClick(() => {
              this.isShowMenu = false;
              this.clickFocusBtn('watchFocus');
            })
            .hitTestBehavior(HitTestMode.Block);
        }

        // 菜单弹窗
        if (this.isShowMenu && !this.isVideo) {
          Flex({ justifyContent: FlexAlign.Center }) {
            Row() {
              ForEach(this.menuList, (item: DialogModel, index: number) => {
                ListItem() {
                  Column() {
                    Image($r(item.uri))
                      .width('80lpx')
                      .aspectRatio(1)
                      .margin({ bottom: '12lpx' })
                      .id('photo_menu_' + index)
                      .focusable(true)
                      .defaultFocus(this.isShowMenu)
                      .borderRadius('40lpx')
                      .padding('6lpx')
                      .border({
                        width: 2,
                        color: this.focusStr == ('photo_menu_' + index) ? '#fff' : Color.Transparent, // 边框颜色
                        style: BorderStyle.Solid
                      })
                      .onKeyEvent(event => {
                        // 电脑回车键KEYCODE_ENTER
                        if ((event.keyCode === KeyCode.KEYCODE_DPAD_CENTER ||
                          event.keyCode === KeyCode.KEYCODE_ENTER) &&
                          event.type === KeyType.Down) {
                          this.clickRotateBtn();
                        }
                        //返回键
                        if (event.keyCode === KeyCode.KEYCODE_NUMPAD_2 && event.type === KeyType.Down) {
                          this.isShowMenu = false;
                          this.clickFocusBtn('watchFocus');
                        }
                      })
                      .onClick(() => {
                        this.clickRotateBtn();
                      });
                    Text(item.name)
                      .fontSize('24lpx')
                      .height('35lpx')
                      .lineHeight('35lpx')
                      .fontColor(Color.White);
                  }
                  .width('100lpx')
                  .margin({
                    left: '4lpx',
                    right: '4lpx'
                  });
                };
              });
            }
            .backgroundColor('#CC424242')
            .borderRadius('48lpx')
            .padding({
              top: '20lpx',
              right: '26lpx',
              bottom: '20lpx',
              left: '26lpx'
            })
            .justifyContent(FlexAlign.Center);
          }
          .position({ x: '0%', y: '80%' })
          .zIndex(2);
        }
      };
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.main_color'));
  }
}