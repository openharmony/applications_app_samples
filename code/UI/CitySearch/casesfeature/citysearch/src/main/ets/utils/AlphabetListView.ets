/*
* Copyright (c) 2024 Huawei Device Co., Ltd.
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

/**
 * 功能描述:
 * 1. 在搜索框中可以根据城市拼音模糊搜索出相近的城市，例如输入"a"，会出现"阿尔山"、"阿勒泰地区"、"安庆"、"安阳"。
 * 2. 下方城市列表通过AlphabetIndexer组件实现拼音索引条，通过滑动选择城市首拼，快速定位相关首拼城市。
 *
 * 实现原理:
 * 1. 当用户滑动List组件，list组件onScrollIndex监听到firstIndex的改变，绑定赋值给AlphabetIndexer的selected属性，从而定位到字母索引。
 * 2. 当点击AlphabetIndexer的字母索引时，通过scrollToIndex触发list组件滑动并指定firstIndex，从而实现List列表与AlphabetIndexer组件首字母联动吸顶展示。
 *
 * @param hotSelectList - 热门选择列表
 * @param alphabetSelectList - 字母选择数据列表
 * @param hotSelectListTitle - 热门选择列表标题
 * @param hotSelectHandle - 点击热门选择列表项处理逻辑
 * @param alphabetSelectHandle - 点击字母列表项处理逻辑
 *
 */
import { AlphabetListItemView, HotListItemView } from '../model/DetailData';
import { CommonConstants } from '../common/CommonConstants';

@Component
export struct AlphabetListView {
  // -------------------对外暴露变量-----------------------
  // 热门选择列表
  hotSelectList: HotListItemView[] = [];
  // 字母选择数据列表
  alphabetSelectList: AlphabetListItemView[] = [];
  // 热门列表标题
  hotSelectListTitle: ResourceStr = '';
  // 点击热门选择列表项处理逻辑
  hotSelectHandle: (hotSelectValue: string) => void = (hotSelectValue: string = CommonConstants.INIT_VALUE) => {
  };
  // 点击字母列表项处理逻辑
  alphabetSelectHandle: (alphabetSelectValue: string ) => void = (alphabetSelectValue: string =
  CommonConstants.INIT_VALUE) => {
  };
  // --------------------私有属性----------------------------
  // 初始化列表index
  @State stabIndex: number = 0;
  // 字母索引数据
  @State alphabetIndexer: string[] = [];
  // 滑动控制器
  private scroller: Scroller = new Scroller();
  // 搜索控制器
  controller: SearchController = new SearchController();

  build() {
    Stack({ alignContent: Alignment.End }) {
      Column() {
        Text(this.hotSelectListTitle)
          .fontSize($r('app.integer.citysearch_text_font'))
          .fontColor($r('app.color.citysearch_text_font_color'))
          .opacity(CommonConstants.OPACITY)
          .margin({
            left: $r('app.integer.citysearch_txt_margin_left'),
            bottom: $r('app.integer.citysearch_row_margin_bottom')
          })

        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center, wrap: FlexWrap.Wrap }) {
          ForEach(this.hotSelectList, (hotCityItem: HotListItemView) => {
            // 这里规定每行占四个城市
            Column() {
              hotCityItem.contentBuilder.builder(hotCityItem.hotListItem)
            }.onClick(() => {
              this.hotSelectHandle(hotCityItem.hotListItem);
            })
          })
        }
        .width(CommonConstants.VIEW_FULL)

        List({
          space: CommonConstants.LIST_SPACE,
          initialIndex: CommonConstants.INITIAL_INDEX,
          scroller: this.scroller
        }) {
          ForEach(this.alphabetSelectList, (alphabetListItem: AlphabetListItemView) => {
            ListItem() {
              Column() {
                Text(`${alphabetListItem.alphabetListItem.name}`)
                  .height($r('app.integer.citysearch_list_item_height'))
                  .fontSize($r('app.integer.citysearch_font_size'))
                  .fontColor($r('app.color.citysearch_text_font_color'))
                  .width(CommonConstants.VIEW_FULL)
                ForEach(alphabetListItem.alphabetListItem.dataList, (item: string) => {
                  Column() {
                    alphabetListItem.contentBuilder.builder(item)
                  }.onClick(() => {
                    this.alphabetSelectHandle(item);
                  })
                })
              }
            }
          })
        }
        .width(CommonConstants.VIEW_FULL)
        .margin({
          left: $r('app.integer.citysearch_txt_margin_left'),
          bottom: $r('app.integer.citysearch_txt_margin_bottom')
        })
        .layoutWeight(1)
        .edgeEffect(EdgeEffect.None)
        .divider({
          strokeWidth: $r('app.integer.citysearch_divider_strokeWidth'),
          color: $r('app.color.citysearch_divider_color'),
          startMargin: $r('app.integer.citysearch_divider_start'),
          endMargin: $r('app.integer.citysearch_divider_end')
        })
        .listDirection(Axis.Vertical)
        .scrollBar(BarState.Off)
        .onScrollIndex((firstIndex: number, lastIndex: number) => {
          this.stabIndex = firstIndex;
        })
      }
      .alignItems(HorizontalAlign.Start)

      /* TODO：知识点：可以与容器组件联动用于按逻辑结构快速定位容器显示区域的组件，arrayValue为字母索引字符串数组，selected为初始选中项索引值。
       * 1. 当用户滑动List组件，list组件onScrollIndex监听到firstIndex的改变，绑定赋值给AlphabetIndexer的selected属性，从而定位到字母索引。
       * 2. 当点击AlphabetIndexer的字母索引时，通过scrollToIndex触发list组件滑动并指定firstIndex，从而实现List列表与AlphabetIndexer组件
       * 首字母联动吸顶展示。
       */
      AlphabetIndexer({ arrayValue: this.alphabetIndexer, selected: this.stabIndex })
        .height(CommonConstants.VIEW_FULL)
        .selectedColor($r('app.color.citysearch_alphabet_select_color'))// 选中项文本颜色
        .popupColor($r('app.color.citysearch_alphabet_pop_color'))// 弹出框文本颜色
        .selectedBackgroundColor($r('app.color.citysearch_alphabet_selected_bgc'))// 选中项背景颜色
        .popupBackground($r('app.color.citysearch_alphabet_pop_bgc'))// 弹出框背景颜色
        .popupPosition({
          x: $r('app.integer.citysearch_pop_position_x'),
          y: $r('app.integer.citysearch_pop_position_y')
        })
        .usingPopup(true) // 是否显示弹出框
        .selectedFont({ size: $r('app.integer.citysearch_select_font'), weight: FontWeight.Bolder })// 选中项字体样式
        .popupFont({ size: $r('app.integer.citysearch_pop_font'), weight: FontWeight.Bolder })// 弹出框内容的字体样式
        .alignStyle(IndexerAlign.Right)// 弹出框在索引条左侧弹出
        .itemSize(CommonConstants.ALPHABET_SIZE)// 每一项的尺寸大小
        .margin({ right: CommonConstants.ALPHABET_MARGIN_RIGHT_SIZE })
        .onSelect((tabIndex: number) => {
          this.scroller.scrollToIndex(tabIndex);
        })
    }
    .flexShrink(1)
    .flexGrow(1)
    .padding({ bottom: $r('app.integer.citysearch_padding_bottom') })
  }

  aboutToAppear(): void {
    if (this.alphabetSelectList.length) {
      this.alphabetSelectList.forEach((item: AlphabetListItemView) => {
        this.alphabetIndexer.push(item.alphabetListItem.name);
      })
    }
  }
}