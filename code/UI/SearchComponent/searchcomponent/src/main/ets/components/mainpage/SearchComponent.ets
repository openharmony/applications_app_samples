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

import { SceneModuleInfo } from '../model/SceneModuleInfo';
import { promptAction, ShowDialogSuccessResponse } from '@kit.ArkUI';
import { waterFlowData } from '../data/WaterFlowData';
import curves from '@ohos.curves';
import window from '@ohos.window';
import common from '@ohos.app.ability.common';
import { inputMethod } from '@kit.IMEKit';

// 持久化存储保证应用退出后再进入数据还在
PersistentStorage.persistProp('searchHistoryData', []);

/**
 * 搜索实现思路：
 * 1.在进入首页时存储一份初始数据用于查询时筛选数据。
 * 2.通过输入框onchange接口获取输入框输入的值与ListData中name字段进行对比筛选出符合条件的数据。
 * 3.将筛选获得的数据通过LazyForeach遍历渲染，点击相应的listitem时通过统一封装的接口buildRouterModel进行跳转。
 * 4.跳转后将点击的一条数据通过PersistentStorage.persistProp持久化存储下来，保证应用退出后数据依然存在并且实现搜索历史功能。
 */
/**
 * 一镜到底实现思路：
 * 1.通过bindContentCover全屏模态转场实现对搜索页面显示的控制。
 * 2.通过transition组件内转场实现搜索页面消失显示过程中的过渡效果。
 * 3.通过geometryTransition组件内隐式共享元素转场绑定两个搜索框实现传承过渡。
 * 3.在切换过程中使用animateTo显式动画配合改变搜索框大小实现转换过程中的动画和一镜到底的效果。
 */
@Component
export struct SearchComponent {
  @StorageLink('listData') searchListData: SceneModuleInfo[] | undefined = waterFlowData; // 搜索原始数据
  @StorageLink('searchHistoryData') searchHistoryData: SceneModuleInfo[] = []; // 搜索历史数组
  @State searchContext: string = ''; // 搜索输入内容
  @State isSearchPageShow: boolean = false; // 搜索页面是否显示标志位
  @State geometryId: string = ''; // 组件内隐式共享元素转场id
  @State searchNewListData: SceneModuleInfo[] = [];
  @State avoidAreaHeight: number = 0;
  @State screenWidth: number = 0;
  @StorageLink('context') uiContext: common.UIAbilityContext | undefined = AppStorage.get('context');
  @State classifyIndex: number = -1;
  @State searchInput: string = '';
  @State categoryName: string | undefined = '';
  @State searchInputWidth: number = 0;
  private searchClassifyData: String[] = ['UI布局', '动效', '三方库', 'Native', '性能示例', '其他'];
  // 从AppStorage中获取设别类别，判断是否为折叠屏
  isFoldable: boolean | undefined = AppStorage.get('isFoldable');

  aboutToAppear(): void {
    this.setSearchInputWidth();
    const type = window.AvoidAreaType.TYPE_SYSTEM;
    window.getLastWindow(this.uiContext, (err, data) => {
      if (data !== undefined) {
        let avoidArea = data.getWindowAvoidArea(type);
        this.avoidAreaHeight = avoidArea.topRect.height;
      }
    })
    let context = getContext() as common.UIAbilityContext
    window.getLastWindow(context).then((windowClass) => {
      windowClass.on('windowSizeChange', () => {
        this.setSearchInputWidth();
      })
    })
  }

  setSearchInputWidth() {
    let context = getContext() as common.UIAbilityContext;
    window.getLastWindow(context).then((windowClass) => {
      const windowsProperties = windowClass.getWindowProperties().windowRect.width;
      //32为左右边距、24为菜单图标宽度、8为搜索宽与图标之间的距离
      this.searchInputWidth = px2vp(windowsProperties) - 32 - 24 - 8;
    })
  }

  /**
   * 搜索逻辑
   * @param value:输入框输入的内容
   */
  searchFunc(value: string, category: string | undefined) {
    let newListData: SceneModuleInfo[] = [];
    if (this.searchListData !== undefined) {
      for (let i = 0; i < this.searchListData.length; i++) {
        // 通过传入的category与范例数据进行匹配，category为undefined和空时表示不进行分类查找
        const isCategoryItem: boolean =
          (category === undefined || category?.length === 0) ? true :
            this.searchListData[i].category.toString() === category;

        // 通过分类信息和includes对输入的字符进行查询
        if (this.searchListData[i].name.toLowerCase().includes(value.toLowerCase()) && isCategoryItem) {
          newListData.push(this.searchListData[i]);
        } else if (this.searchListData[i].serialNumber.toString() === value && isCategoryItem) {
          newListData.push(this.searchListData[i]);
        }
      }
    }
    if (value !== '' && newListData.length === 0) {
      promptAction.showToast({ message: $r('app.string.search_component_content_alarm') });
    }
    // 判断是否有输入的值
    if (value.length !== 0) {
      this.searchNewListData = newListData;
    } else {
      this.searchNewListData = [];
    }
  }

  /**
   * 1.搜索框进入搜索页面animateTo显式动画。
   * 2.两个搜索框同时绑定同一个geometryId。
   */
  private onSearchClicked(): void {
    this.geometryId = 'search';
    animateTo({
      duration: 100,
      // 构造插值器弹簧曲线对象，生成一条从0到1的动画曲线
      curve: curves.interpolatingSpring(0, 1, 324, 38)
    }, () => {
      this.isSearchPageShow = true;
    })
  }

  /**
   * 1.点击返回箭头，搜索框退出搜索页面animateTo显式动画。
   * 2.两个搜索框同时绑定同一个geometryId。
   */
  private onArrowClicked(): void {
    this.geometryId = 'search';
    animateTo({
      // 构造插值器弹簧曲线对象，生成一条从0到1的动画曲线
      curve: curves.interpolatingSpring(0, 1, 342, 38)
    }, () => {
      this.searchNewListData = [];
      this.isSearchPageShow = false;
      this.classifyIndex = -1;
      this.searchInput = '';
      this.categoryName = '';
    })
  }

  // 点击提示列表/历史记录进入范例页
  private onItemClicked(): void {
    this.geometryId = 'search';
    animateTo({
      curve: Curve.Ease,
      duration: 20
    }, () => {
      this.searchNewListData = [];
      this.isSearchPageShow = false;
    })
  }

  /**
   * 当开始滑动搜索列表、点击历史搜索空白部分关闭键盘
   * @param event 触屏事件
   */
  private onTouchDown(event: TouchEvent): void {
    let inputMethodController = inputMethod.getController();
    inputMethodController.stopInputSession()
  }

  /**
   * 搜索添加分类选项
   * */
  @Builder
  searchClassificationSelection() {
    Column() {
      Column() {
        Text($r('app.string.search_component_search_classify_fixed_words'))
          .fontColor($r('app.color.search_classify_fixed_words_color'))
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .margin({ bottom: $r('app.integer.search_component_classify_description_margin') })

      Grid() {
        // TODO：知识点：使用ForEach加载分类搜索列表数据
        ForEach(this.searchClassifyData, (item: string, index: number) => {
          GridItem() {
            Text(item)
              .fontColor(this.classifyIndex === index ? Color.White : Color.Black)
              .opacity(this.classifyIndex === index ? 1 : 0.8)
          }
          .height($r('app.integer.search_component_classify_category_item_height'))
          .width($r('app.integer.search_component_classify_category_item_weight'))
          .backgroundColor(this.classifyIndex === index ? $r('app.color.search_classify_category_chosen_color') :
          $r('app.color.search_classify_category_not_chosen_color'))
          .borderRadius($r('app.integer.search_component_classify_category_border_radius'))
          .onClick(() => {
            this.classifyIndex = this.classifyIndex === index ? -1 : index;
            this.categoryName = this.classifyIndex === index ? item : '';
            this.searchFunc(this.searchInput, this.categoryName);
          })
        }, (item: string) => item.toString())
      }
      .height($r('app.integer.search_component_classify_category_height'))
      .width('100%')
      .columnsTemplate('1fr 1fr 1fr')
      .rowsGap($r('app.integer.search_component_classify_category_rows_gap'))
      .columnsGap($r('app.integer.search_component_classify_category_columns_gap'))
    }
    .width('100%')
    .padding($r('app.integer.search_component_classify_category_padding'))
    .border({
      width: { bottom: $r('app.integer.search_component_classify_category_split_line') },
      color: { bottom: $r('app.color.search_classify_split_line_color') }
    })
  }

  /**
   * 增加搜索详情页第一条，显示固定文字
   */
  @Builder
  searchSampleNumber() {
    Column() {
      Text() {
        Span(this.searchNewListData.length.toString())
        Span($r('app.string.search_component_search_item_fixed_words'))
      }
      .fontSize($r('app.integer.search_component_search_number_font_size'))
      .fontColor($r('app.color.search_item_number_color'))
    }
  }

  @Builder
  searchPage() {
    Column() {
      Row() {
        Row() {
          Image($r('app.media.search_component_arrow_left'))
            .width($r('app.integer.search_component_image_left_width'))
            .onClick(() => {
              this.onArrowClicked();
            })// TODO：知识点：通过transition属性配置转场参数，在组件插入和删除时显示过渡动效
            .transition(TransitionEffect.asymmetric(
              TransitionEffect.opacity(0)
                .animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 200, delay: 150 }),
              TransitionEffect.opacity(0)
                .animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 200 }),
            ))
        }
        .justifyContent(FlexAlign.Center)
        .width($r('app.integer.search_component_image_left_background_size'))
        .height($r('app.integer.search_component_image_left_background_size'))
        .borderRadius($r('app.integer.search_component_image_left_border_radius'))
        .backgroundColor('#E5E7E9')

        // TODO：知识点：使用搜索框组件，不需要自己进行封装搜索样式
        Search({ value: this.searchContext, placeholder: $r('app.string.search_component_search_placeholder') })
          .width($r('app.integer.search_component_search_input_width'))
          .textFont({ weight: 500 })
          .searchButton('搜索', { fontSize: $r('app.integer.search_component_search_button_text_size') })
          .defaultFocus(true)// 默认获取焦点拉起键盘
          .onChange((value: string) => {
            this.searchFunc(value, this.categoryName);
            this.searchInput = value;
          })
          .borderRadius($r('app.integer.search_component_search_border_radius'))
          .geometryTransition(this.geometryId, { follow: true })
          .layoutWeight(1)
          .height($r('app.string.search_component_search_height'))
          .margin({ left: $r('app.integer.search_component_search_margin') })
          .backgroundColor($r('app.string.search_component_search_background_color'))
      }
      .padding({
        left: $r('app.integer.search_component_search_padding'),
        right: $r('app.integer.search_component_search_padding')
      })
      .alignSelf(ItemAlign.Start)

      // 搜索分类
      this.searchClassificationSelection()

      // 搜索历史
      Column() {
        // 搜索历史标题区
        Row() {
          Text($r('app.string.search_component_search_history'))
            .fontSize($r('app.string.search_component_search_history_font_size2'))
            .fontWeight(FontWeight.Bold)
          Blank()
          Image($r('app.media.search_component_ic_public_delete'))
            .width($r('app.string.search_component_search_history_delete_size'))
            .id('delete_history')
            .onClick(() => {
              // 清空历史记录-确认弹框
              promptAction.showDialog({
                message: $r('app.string.search_component_search_delete_title'),
                alignment: DialogAlignment.Center,
                buttons: [
                  {
                    text: $r('app.string.search_component_delete_back'),
                    color: $r('app.string.search_component_button_text_color')
                  },
                  {
                    text: $r('app.string.search_component_delete_ok'),
                    color: $r('app.string.search_component_button_text_color')
                  }
                ]
              }).then((data: ShowDialogSuccessResponse) => {
                // 点击删除
                if (data.index === 1) {
                  this.searchHistoryData = [];
                }
              })
            })
        }
        .visibility(this.searchHistoryData.length === 0 || this.searchContext.length !== 0 ||
          this.searchNewListData.length !== 0 ? Visibility.None : Visibility.Visible) // 没有搜索历史时隐藏
        .height($r('app.string.search_component_search_history_delete_size'))
        .width('100%')
        .margin({ top: $r('app.string.search_component_search_history_text_padding_margin1') })

        //搜索历史内容区
        Scroll() {
          Flex({ wrap: FlexWrap.Wrap }) {
            // 首次进入页面就需要全部加载不需要使用LazyForeach懒加载
            ForEach(this.searchHistoryData, (item: SceneModuleInfo) => {
              Column() {
                Text(item.name)
                  .fontSize($r('app.string.search_component_search_history_font_size3'))
                  .backgroundColor($r('app.string.search_component_search_list_text_color'))
                  .padding($r('app.string.search_component_search_history_text_padding_margin3'))
                  .borderRadius($r('app.string.search_component_main_page_top_borderRadius'))
              }
              .margin({ top: $r('app.string.search_component_search_history_text_padding_margin4') })
              .padding({ right: $r('app.string.search_component_search_history_text_padding_margin2') })
              .onClick(() => {
                this.onItemClicked();
                // 点击的项提到历史记录的最前面
                this.searchHistoryData.map((historyItem, index) => {
                  if (historyItem === item) {
                    this.searchHistoryData.unshift(this.searchHistoryData.splice(index, 1)[0]);
                  }
                })
              })
            })
          }
          .margin({ top: $r('app.string.search_component_search_history_text_padding_margin3') })
        }
        .scrollBar(BarState.Off) // 滚动条常驻不显示
        .align(Alignment.TopStart)
        .visibility(this.searchHistoryData.length === 0 || this.searchContext.length !== 0 ||
          this.searchNewListData.length !== 0 ? Visibility.None : Visibility.Visible) // 没有搜索历史时隐藏
        .height($r('app.string.search_component_scroll_height'))
        .onTouch((event) => {
          switch (event.type) {
            case TouchType.Down:
              this.onTouchDown(event);
              break;
          }
          event.stopPropagation(); // 阻止冒泡
        })
      }
      .padding({
        left: $r('app.integer.search_component_history_padding'),
        right: $r('app.integer.search_component_history_padding')
      })
      .alignItems(HorizontalAlign.Start)
      // TODO：知识点：通过transition属性配置转场参数，在组件插入和删除时显示过渡动效。非对称对称转场，第一个为出现动效有150的延迟，第二个为消失动效
      .transition(TransitionEffect.asymmetric(
        TransitionEffect.opacity(0)
          .animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 350 })
          .combine(TransitionEffect.translate({ y: 30 })),
        TransitionEffect.opacity(0)
          .animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 350 })
          .combine(TransitionEffect.translate({ y: 30 })),
      ))


      List() {
        // TODO：知识点：使用LazyForEach加载搜索结果列表，可以按需加载，解决一次性加载全部列表数据引起的卡顿问题，提高页面响应速度
        ForEach(this.searchNewListData, (item: SceneModuleInfo, index: number) => {
          ListItem() {
            Column() {
              Row() {
                Row() {
                  Image($r('app.media.search_component_search'))
                    .width($r('app.integer.search_component_list_size'))
                    .height($r('app.integer.search_component_search_icon_height'))
                  Text(item.serialNumber.toString() + '.' + item.name)
                    .maxLines(1)
                    .width($r('app.integer.search_component_search_text_width'))
                    .fontWeight(500)
                    .fontSize($r('app.string.search_component_search_history_font_size2'))
                    .opacity(0.9)
                    .margin({ left: $r('app.string.search_component_search_history_text_padding_margin2') })
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }

                Column() {
                  this.searchSampleNumber()
                }
                .visibility(index === 0 ? Visibility.Visible : Visibility.None)
              }
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.SpaceBetween)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .id('itemId')
          .width('100%')
          .margin({ top: $r('app.string.search_component_search_history_text_padding_margin1') })
          .onClick(() => {
            if (!this.searchHistoryData.includes(item)) {
              // 更新搜索历史数据,插入数组最前侧
              this.searchHistoryData.unshift(item);
            } else {
              // 搜索点击的为已有历史记录内容，该记录提到最前
              this.searchHistoryData.map((historyItem, index) => {
                if (historyItem === item) {
                  this.searchHistoryData.unshift(this.searchHistoryData.splice(index, 1)[0]);
                }
              })

            }
            this.onItemClicked();
          })
        }, (item: SceneModuleInfo) => JSON.stringify(item))
      }
      .onTouch((event) => {
        switch (event.type) {
          case TouchType.Down:
            this.onTouchDown(event);
            break;
        }
        event.stopPropagation(); // 阻止冒泡
      })
      .height($r('app.integer.search_component_list_height'))
      .margin({
        left: $r('app.integer.search_component_list_margin'),
        right: $r('app.integer.search_component_list_margin')
      })
      .edgeEffect(EdgeEffect.Spring)
      .sticky(StickyStyle.Header)
      .chainAnimation(false)
      .transition({ opacity: 0 })
      .scrollBar(BarState.Off)
      .id('search_result_list')
    }
    .transition(TransitionEffect.opacity(0))
    .backgroundColor(Color.White)
    .padding({
      top: px2vp(this.avoidAreaHeight)
    })
    .width('100%')
    .height('120%')
  }

  build() {
    // 顶部搜索框
    Search({ placeholder: $r('app.string.search_component_search_placeholder') })
      .id('searchCaseTitle')
      .backgroundColor(Color.Black)
      .focusOnTouch(false)
      .focusable(false)
      .enableKeyboardOnFocus(false)
      .backgroundColor('#E7E9E8')
      .width(this.searchInputWidth)
      .height($r('app.integer.search_component_home_search_height'))
      .onClick(() => {
        this.onSearchClicked();
      })
      .geometryTransition(this.geometryId, { follow: true })
      .transition(TransitionEffect.OPACITY.animation({
        duration: 200,
        curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1)// 搜索框转场过渡动画，cubicBezierCurve为三阶贝塞尔曲线动画
      }))
      .backgroundColor('#E7E9E8')
      .borderRadius($r('app.integer.search_component_search_border_radius'))// TODO：知识点：通过bindContentCover属性为组件绑定全屏模态页面，在组件插入和删除时可通过设置转场参数ModalTransition显示过渡动效
      .bindContentCover(this.isSearchPageShow, this.searchPage(), {
        modalTransition: ModalTransition.NONE,
        onDisappear: () => {
          this.onArrowClicked();
          this.searchContext = '';
        }
      })
  }
}
