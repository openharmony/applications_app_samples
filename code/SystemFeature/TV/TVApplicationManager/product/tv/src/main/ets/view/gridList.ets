import StoreAppList from '../common/utils/storage'
import { Throttle } from '../common/utils/throttle';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { cursorImage } from './cursorImage'
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { application } from '@kit.AbilityKit';
import FilterAppList from '../components/filterApp';
import { EventUtil } from '../common/utils/EventUtil';
import { ColorMetrics, DrawableDescriptor, LengthMetrics } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { AppIconCacheManager } from '../Utils/AppIconCacheManager';
import { AppNameCacheManager } from '../Utils/AppNameCacheManager';
import json from '@ohos.util.json';

const TAG: string = 'gridList';
const sourceToolMouseClick: number = 7
const MAX_NUM: number = 6;

interface AppList {
  icon: ResourceStr;
  label: string;
  element: Element
  labelId?: number;
  iconId?: number;
  moduleName?: string;
  installSource?: string;
  installTime?: number;
}

class Element {
  public bundleName: string = ''
  public abilityName: string = ''
}


@Component
export struct gridList {
  @Link @Watch('onAllListChange') allList: Array<AppList>;
  @State appList: Array<AppList> = [];
  private readonly VISIBLE_ROWS = 3;
  private readonly COLS = 6;
  private readonly TOTAL_VISIBLE = this.VISIBLE_ROWS * this.COLS; // 3×6
  private readonly BATCH_SIZE = 6; // 每批加载6个应用
  private readonly BATCH_DELAY = 200; // 批次间延迟200ms
  private isRemainingLoading: boolean = false;
  private currentBatch: number = 0;
  private initialLoadTimer: number = -1;
  private batchLoadTimer: number = -1;
  private loadVersion: number = 0;

  @Link ifMove: string;
  @Link focusIndex: number;
  @Link arrowXPos: number;
  @Link bigScreen: boolean;
  private scroller: Scroller = new Scroller();
  @State temp: number = 0;
  @State originIndex: number = 0;
  // @State arrowXPos: number = 0
  @State translateX: number = 0;
  @State translateY: number = 0
  @State nextIndex: number = 0
  @State showAmit: boolean = false
  @State focusControl: boolean = true
  @State duration: number = 1000
  // 上一次按键时间
  preEventClickTime: number = 0;
  @Link startAbilityBundle: boolean;
  @State isPanMove: boolean = false//是否滑动
  @State isLongPressed : boolean = false//是否长按
  longPressAction=()=>{}//长按操作

  aboutToAppear(): void {
    this.startAbilityBundle = true
    emitter.on('exitMoveMode', () => {
      this.ifMove = 'false'
      this.localStorageApp()
    })
  }

  aboutToDisappear(): void {
    this.resetLoadingState()
  }

  onAllListChange(){
    this.loadVersion++
    this.loadInitialData(this.loadVersion)
  }

  resetLoadingState() {
    if (this.initialLoadTimer !== -1) {
      clearTimeout(this.initialLoadTimer)
      this.initialLoadTimer = -1
    }
    if (this.batchLoadTimer !== -1) {
      clearTimeout(this.batchLoadTimer)
      this.batchLoadTimer = -1
    }
    this.isRemainingLoading = false
    this.currentBatch = 0
  }

  // 加载初始数据
  loadInitialData(version: number) {
    this.resetLoadingState()
    if (!this.allList || this.allList.length === 0) {
      this.appList = []
      return;
    }
    const initialData = this.allList.slice(0, this.TOTAL_VISIBLE);
    this.appList = [...initialData];


    // 分批加载剩余应用
    this.initialLoadTimer = setTimeout(()=>{
      if (version !== this.loadVersion) {
        return
      }
      this.startBatchLoading(version);
    },3000)
  }

  startBatchLoading(version: number) {
    if (version !== this.loadVersion) {
      return;
    }
    if (this.isRemainingLoading) {
      return;
    }

    const remainingCount = this.allList.length - this.TOTAL_VISIBLE;
    if (remainingCount <= 0) {
      return;
    }

    this.isRemainingLoading = true;
    this.currentBatch = 0;

    // 开始加载第一个批次
    this.loadNextBatch(version);
  }

  async loadNextBatch(version: number) {
    if (version !== this.loadVersion) {
      this.isRemainingLoading = false;
      return;
    }
    const remainingApps = this.allList.slice(this.TOTAL_VISIBLE);
    const startIndex = this.currentBatch * this.BATCH_SIZE;

    // 检查是否还有剩余应用
    if (startIndex >= remainingApps.length) {
      this.isRemainingLoading = false;
      return;
    }

    this.currentBatch++;
    const endIndex = Math.min(startIndex + this.BATCH_SIZE, remainingApps.length);
    const batchApps = remainingApps.slice(startIndex, endIndex);

    // 1. 将这批应用添加到显示列表
    this.appList = [...this.appList, ...batchApps];
    // 2. 如果不是最后一批，继续加载下一批
    if (endIndex < remainingApps.length) {
      this.batchLoadTimer = setTimeout(() => {
        this.loadNextBatch(version);
      }, this.BATCH_DELAY);
    } else {
      // 所有批次完成
      this.isRemainingLoading = false;
    }
  }

  // 交换两个AppList对象的所有属性（包括嵌套对象）
  swapAppListItems(item1: AppList, item2: AppList): void {
    // 1. 交换基本类型属性
    this.swapIcon(item1, item2);
    this.swapLabel(item1, item2);
    this.swapLabelId(item1, item2);
    this.swapIconId(item1, item2);
    this.swapModuleName(item1, item2);
    this.swapInstallSource(item1, item2);
    this.swapInstallTime(item1, item2);
    // 2. 交换嵌套的Element对象
    this.swapElement(item1.element, item2.element);
  }

  // 为每个属性创建专门的交换方法
  swapIcon(item1: AppList, item2: AppList): void {
    const temp = item1.icon;
    item1.icon = item2.icon;
    item2.icon = temp;
  }

  swapLabel(item1: AppList, item2: AppList): void {
    const temp = item1.label;
    item1.label = item2.label;
    item2.label = temp;
  }

  swapLabelId(item1: AppList, item2: AppList): void {
    const temp = item1.labelId;
    item1.labelId = item2.labelId;
    item2.labelId = temp;
  }

  swapIconId(item1: AppList, item2: AppList): void {
    const temp = item1.iconId;
    item1.iconId = item2.iconId;
    item2.iconId = temp;
  }

  swapModuleName(item1: AppList, item2: AppList): void {
    const temp = item1.moduleName;
    item1.moduleName = item2.moduleName;
    item2.moduleName = temp;
  }

  swapInstallSource(item1: AppList, item2: AppList): void {
    const temp = item1.installSource;
    item1.installSource = item2.installSource;
    item2.installSource = temp;
  }

  swapInstallTime(item1: AppList, item2: AppList): void {
    const temp = item1.installTime;
    item1.installTime = item2.installTime;
    item2.installTime = temp;
  }

  // 交换Element对象的属性
  swapElement(elem1: Element, elem2: Element): void {
    // 交换bundleName
    const tempBundle = elem1.bundleName;
    elem1.bundleName = elem2.bundleName;
    elem2.bundleName = tempBundle;

    // 交换abilityName
    const tempAbility = elem1.abilityName;
    elem1.abilityName = elem2.abilityName;
    elem2.abilityName = tempAbility;
  }

  //移动逻辑
  // @Throttle(230)
  async moveItem(focusIndex: number, temp: Object, translateX: number, translateY: number) {
    const originalIndex = this.focusIndex;
    const originalItem = this.appList[originalIndex];
    const targetItem = this.appList[focusIndex];
    // 设置移动方向
    this.translateX = translateX;
    this.translateY = translateY;
    this.arrowXPos = 0;
    this.showAmit = true;
    // 动画结束后交换数据并重置状态
    setTimeout(() => {
      this.swapAppListItems(originalItem, targetItem)
      this.translateX = 0;
      this.translateY = 0;
      this.showAmit = false;
      this.focusIndex = focusIndex;
      focusControl.requestFocus('itemid_' + this.focusIndex);
    }, 230);
  }

  //进入移动应用模式
  removeApp() {
    this.ifMove = 'true'
  }

  //判断是否移动应用
  moveAble(focusIndex: number, temp: Object, translateX: number, translateY: number) {

    this.nextIndex = focusIndex


    this.ifMove == 'true' ? this.moveItem(focusIndex, temp, translateX, translateY) : this.focusIndex = focusIndex
    focusControl.requestFocus('itemid_' + this.focusIndex);
  }

  //上下左右键移动逻辑
  commonOperation(focusIndex: number, temp: object, judge: boolean, translateX: number, translateY: number) {
    this.moveAble(focusIndex, temp, translateX, translateY)
  }

  // 判断是否翻页
  ifChangePage(focusIndex: number, direction?: string) {
    // 只有在跨行移动时才翻页
    if (direction === 'up' || direction === 'down') {
      this.scroller.scrollToIndex(focusIndex, false, ScrollAlign.CENTER)
    }
  }

  //判断移动时是否存在方位图标
  ifShowIcon(index: number, appList: Array<AppList>, action: string) {
    let target: boolean = false
    if (action == 'left') {
      if (index % 6 == 0) {
        target = false
      } else {
        target = true
      }
    }
    if (action == 'right') {
      if (index % 6 == 5 || index == (appList.length - 1)) {
        target = false
      } else {
        target = true
      }
    }
    if (action == 'up') {
      if (index / 6 >= 1) {
        target = true
      } else {
        target = false
      }
    }
    if (action == 'down') {
      if (index <= (appList.length - 7)) {
        target = true
      } else {
        target = false
      }
    }
    return target
  }

  //移动卸载后对应用列表做持久化存储
  localStorageApp() {
    let appList = this.appList.map(item => item.element)
    let storageList = new StoreAppList(getContext())
    storageList.setAppList(JSON.stringify(appList))
  }

  // 判断
  judgeDirection(index: number, appList: Array<AppList>, action1: string, action2: string) {
    let target = ''
    if (this.ifShowIcon(index, appList, action1) && this.ifShowIcon(index, appList, action2)) {
      target = 'SpaceBetween'
    }
    if (this.ifShowIcon(index, appList, action1) && !this.ifShowIcon(index, appList, action2)) {
      target = 'Start'
    }
    if (this.ifShowIcon(index, appList, action2) && !this.ifShowIcon(index, appList, action1)) {
      target = 'End'
    }
    return target

  }
  // 拖拽过程样式
  @Builder
  appBuilder(info: AppList,index:number) {
      itemGrid({
        info: info,
        focusIndex:index,
        index: index,
      })
  }


  changeIndex(fromIndex: number, toIndex: number) {
    if (fromIndex === toIndex){
      return;
    }

     let item= this.appList.splice(fromIndex, 1); // 移除拖拽项
    this.appList.splice(toIndex, 0, item[0]); // 插入到新位置
    console.log('=====changeIndex',toIndex)
    this.allList=this.appList//同步
    this.focusIndex=toIndex
    this.localStorageApp()

  }
onDidBuild(): void {
  try {
    focusControl.requestFocus('itemid_' + this.focusIndex)
  }catch (e) {
    console.log('====err')
  }
}
  build() {
    if (this.appList.length > 0) {
      Grid(this.scroller) {
        ForEach(this.appList, (info: AppList, index) => {
          GridItem() {
            itemGrid({
              info: info,
              focusIndex: this.focusIndex,
              index: index,
              ifMove: this.ifMove,
              focusControl: this.focusControl,
              showAmit: this.showAmit,
              arrowXPos: this.arrowXPos,
              bigScreen: this.bigScreen,
              appList: this.appList,
              ifShowIcon: this.ifShowIcon.bind(this)
            })
          }
          .padding({ bottom: '40lpx' })
          .id('itemid_' + index)
          .focusable(true)
          .focusBox({
            strokeWidth: LengthMetrics.px(0)
          })
          .onAppear(() => {
            if(index === 0) {
              focusControl.requestFocus('itemid_0')
            }
          })
          .onFocus(() => {
            this.focusControl = true
            emitter.emit('closeDialog')
          })
          .onBlur(() => {
            this.focusControl = false
          })
          .onTouch((event) => {
            if (event.type==TouchType.Down) {
              this.isPanMove=false
              this.focusIndex = index
              focusControl.requestFocus('itemid_' + this.focusIndex);
            }
          })
          .onHover((isHover: boolean, event: HoverEvent) => {
            event.stopPropagation();
            if (this.ifMove == 'true') {
              return;
            }
            if (event.sourceTool === 0 || event.sourceTool === 1) {
              return;
            }
            if (isHover) {
              this.focusIndex = index;
              focusControl.requestFocus('itemid_' + this.focusIndex);
            }
          })
          .onKeyEvent((event) => {
            if (event == undefined) {
              return
            }
            if (event.type === KeyType.Up) {
              return
            }
            // 按键延迟200毫秒 解决按太快时跳焦问题 #IBPH7B #IBPGT9
            if (new Date().getTime() - this.preEventClickTime < 200) {
              return
            }
            this.preEventClickTime = new Date().getTime()

            if (event.keyCode === 2054 && event.type === KeyType.Down) {
              if (this.ifMove == 'false') {
                this.startAbilityBundle = true
                this.localStorageApp()
                emitter.emit('menuEvent', { data: true });
                globalThis.context.startAbility({
                  bundleName: this.appList[this.focusIndex].element.bundleName as string,
                  abilityName: this.appList[this.focusIndex].element.abilityName as string
                });
              } else {
                this.ifMove = 'false'
                this.localStorageApp()
                return
              }
            }
            this.ifChangePage(this.focusIndex)

            if (this.ifMove == 'true') {
              event.stopPropagation()
            }
            if (event.type === KeyType.Down) {
              let temp = this.appList[this.focusIndex]
              let focusIndex = this.focusIndex
              if (event.keyCode === KeyCode.KEYCODE_DPAD_UP) {
                if (!this.ifShowIcon(this.focusIndex, this.appList, 'up')) {
                  return
                }
                focusIndex = (this.focusIndex - 6) < 0 ? 0 : this.focusIndex - 6
                this.commonOperation(focusIndex, temp, false, 0, this.bigScreen ? -624 : -311)
                this.ifChangePage(this.focusIndex, 'up')  // 只有上下移动才翻页
              }
              if (event.keyCode === KeyCode.KEYCODE_DPAD_DOWN) {
                const newIndex = this.focusIndex + MAX_NUM;
                if (newIndex >= this.appList.length) {
                  return;
                }
                if (!this.ifShowIcon(this.focusIndex, this.appList, 'down') && this.ifMove == 'true') {
                  return
                }
                focusIndex = newIndex;
                this.commonOperation(focusIndex, temp, true, 0, this.bigScreen ? 624 : 311)
                this.ifChangePage(this.focusIndex, 'down')  // 只有上下移动才翻页
              }
              if (event.keyCode === KeyCode.KEYCODE_DPAD_LEFT) {
                if (!this.ifShowIcon(this.focusIndex, this.appList, 'left')) {
                  return
                }
                temp = this.appList[this.focusIndex]
                focusIndex = this.focusIndex - 1
                if (focusIndex >= 0) {
                  this.moveAble(focusIndex, temp, this.bigScreen ? -576 : -288, 0)

                } else {
                  return
                }
              }
              if (event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT) {
                focusIndex = this.focusIndex + 1
                if (focusIndex % 6 === 0) {
                  return
                }
                let num = this.appList.length
                if (focusIndex < num) {
                  this.moveAble(focusIndex, temp, this.bigScreen ? 576 : 288, 0)
                } else {
                  return
                }
              }
              if (event.keyCode === 2033) {
                this.ifMove = 'false'
                this.localStorageApp()
                return
              }
            }
          })
          .onClick(()=>{
            this.focusIndex = index
            if (this.ifMove == 'false'&&!this.isLongPressed) {
              this.startAbilityBundle = true
              this.localStorageApp()
              emitter.emit('menuEvent', { data: true });
              globalThis.context.startAbility({
                bundleName: this.appList[this.focusIndex].element.bundleName as string,
                abilityName: this.appList[this.focusIndex].element.abilityName as string
              });
            } else {
              this.ifMove = 'false'
              this.localStorageApp()
              return
            }
          })
        }, (info: AppList) => {
          return JSON.stringify(info)
        })
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr')
      .focusable(true)
      .rowsGap('20lpx')
      .width('100%')
      .height('85%')
      .padding({
        left: '96lpx',
        right: '96lpx'
      })

      .parallelGesture(GestureGroup(GestureMode.Parallel,
        LongPressGesture({ duration: 1000, repeat: false })
          .onAction(() => {
            this.isLongPressed = true
          })
          .onActionEnd((e) => {
            this.isLongPressed = false
            console.log('=====22222', this.isPanMove)
            if (!this.isPanMove) {
              this.longPressAction()
            }
          }),
        PanGesture().onActionUpdate((e) => {
          console.log('=====33333', e.offsetX, e.offsetY, this.isPanMove)
          // if (Math.abs(e.offsetX) > 30 || Math.abs(e.offsetY) > 30) {
            //滑动不执行长按操作
            this.isPanMove = true
          // }
        })))
      .editMode(true) // 进入编辑模式
      .supportAnimation(true)
      .onItemDragStart((event: ItemDragInfo, itemIndex: number) => {
        // 设置拖拽过程中显示的图片
        return this.appBuilder(this.appList[itemIndex],itemIndex);
      })
      .onItemDrop((event: ItemDragInfo, itemIndex: number, insertIndex: number, isSuccess: boolean) => {
        // 当在本组件范围内停止拖拽行为时，触发回调。
        // isSuccess=false时，说明drop的位置在grid外部  insertIndex > length时，说明有新增元素的事件发生
        if (!isSuccess || insertIndex >= this.appList.length) {
          return;
        }
        this.changeIndex(itemIndex, insertIndex);
      })
    }
  }
}

@Component
struct itemGrid {
  @Prop @Watch('infoChange') info: AppList = { icon: '', label: '', element: { bundleName: '', abilityName: '' } }
  lastInfoSting: string = ''
  @Prop
  focusIndex: number
  @Prop
  index: number
  @Prop
  ifMove: string
  @Prop
  focusControl: boolean = true
  @Prop
  showAmit: boolean = false
  @Prop
  arrowXPos: number;
  @Prop
  bigScreen: boolean;
  appList: Array<AppList> = [];
  ifShowIcon: (index: number, appList: Array<AppList>, action: string) => boolean = () => {
    return false
  }

  @State appIcon: ResourceStr | DrawableDescriptor| image.PixelMap | null = ''
  @State appName: string = ' '

  infoChange() {
    if (this.ifMove === 'true') {
      const infoString = JSON.stringify(this.info)
      if (this.lastInfoSting !== infoString) {
        this.lastInfoSting = infoString
        this.infoChangelist()
      }
    }
  }

  infoChangelist() {
    // 从缓存管理器获取图标、名称
    AppIconCacheManager.getInstance().getAppIcon(
      this.info.element.bundleName,
      this.info.moduleName || '',
      this.info.element.abilityName,
      this.info.iconId || 0
    ).then(pixelMap => {
      if(pixelMap){
        this.appIcon = pixelMap
      }
    });

    AppNameCacheManager.getInstance().get(
      this.info.element.bundleName,
      this.info.moduleName || '',
      this.info.element.abilityName,
      this.info.labelId || 0
    ).then(res => {
      this.appName = res
      console.log('熊appName', this.info.element.bundleName,(new Date().getTime())-(AppStorage.get('time') as number))
    })
  }

  aboutToAppear() {
    this.infoChangelist();
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        Stack({ alignContent: Alignment.Center }) {
          Row(){}
            .backgroundColor(this.focusIndex == this.index ? '#e6ffffff' : (this.ifMove === 'true' ? '#ccffffff' : '#e6ffffff'))
            .zIndex(5)
            .borderRadius('18lpx')
            .width(this.focusIndex == this.index ? '266lpx' : '248lpx')
            .height(this.focusIndex == this.index ? '158lpx' : '140lpx')

          Image(this.appIcon)
            .height(this.focusIndex == this.index ? '108lpx' : '96lpx')
            .aspectRatio(1)
            .objectFit(ImageFit.Contain)
            .interpolation(ImageInterpolation.High)
            .syncLoad(true)
            .zIndex(5)
            .focusable(true)
            .focusBox({
              strokeColor: ColorMetrics.numeric(Color.Transparent),
              strokeWidth: LengthMetrics.px(0)
            })
        }
        .padding('5lpx')
        .focusable(true)
        .border({
          radius: '24lpx',
          color: 'rgba(255, 255, 255, 0.86)',
          width: this.focusIndex === this.index && this.focusControl ? '2lpx' : 0,
        })

        if (this.focusIndex === this.index && this.ifMove == 'true' && !this.showAmit) {
          Row() {
            cursorImage({
              arrowXPos: this.arrowXPos,
              ifOpacity: this.ifShowIcon(this.focusIndex, this.appList, 'left'),
              image: 'app.media.left',
              rowOrColumn: true,
              ifForward: true,
            })
            cursorImage({
              arrowXPos: this.arrowXPos,
              ifOpacity: this.ifShowIcon(this.focusIndex, this.appList, 'right'),
              image: 'app.media.right',
              rowOrColumn: true,
              ifForward: false,
            })
          }
          .width(this.bigScreen ? '360lpx' : '360lpx')
          .justifyContent(FlexAlign.SpaceBetween)
          .renderGroup(true)
          .visibility(this.focusIndex === this.index && this.ifMove == 'true' ? Visibility.Visible : Visibility.Hidden)

          Column() {
            cursorImage({
              arrowXPos: this.arrowXPos,
              ifOpacity: this.ifShowIcon(this.focusIndex, this.appList, 'up'),
              image: 'app.media.up',
              rowOrColumn: false,
              ifForward: true,
            })
            cursorImage({
              arrowXPos: this.arrowXPos,
              ifOpacity: this.ifShowIcon(this.focusIndex, this.appList, 'down'),
              image: 'app.media.down',
              rowOrColumn: false,
              ifForward: false,
            })
          }
          .height(this.bigScreen ? '270lpx' : '270lpx')
          .renderGroup(true)
          .visibility(this.focusIndex === this.index && this.ifMove == 'true' ? Visibility.Visible : Visibility.Hidden)
          .justifyContent(FlexAlign.SpaceBetween)
        }
      }
      .margin({ top: this.focusIndex === this.index && this.ifMove == 'true' && !this.showAmit ? '-42lpx' : '0' })
      .id(this.info.element.bundleName)
      .focusable(true)

      Text(this.appName)
      //  .defaultFocus(this.index === 0)
        .fontSize(this.focusIndex === this.index ? '36lpx' : '28lpx')
        .fontColor('rgba(255, 255, 255, 0.6)')
        .textAlign(TextAlign.Center)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({
          top: '24lpx'
        })
        .visibility(this.focusIndex === this.index && this.ifMove == 'true' ? Visibility.Hidden : Visibility.Visible)
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width('284lpx')
    .height('252lpx')
    .focusable(true)
  }
}