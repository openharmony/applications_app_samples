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

import { AlphabetListItemView, AlphabetListItemType, CITY_DATA, HotListItemView, HOT_CITY } from '../model/DetailData';
import { SearchView } from './SearchView';
import { AlphabetListView } from '../utils/AlphabetListView';
import { promptAction } from '@kit.ArkUI';
import { CommonConstants } from '../common/CommonConstants';

const SEARCH_BUTTON_TEXT = '搜索';

/**
 * 功能说明: 本示例介绍城市选择场景的使用：通过AlphabetIndexer实现首字母快速定位城市的索引条导航
 *
 * 推荐场景: 首字母快速定位的列表场景
 *
 * 核心组件:
 * 1. AlphabetListView: 列表视图
 *
 * 实现步骤:
 * 1. 数据准备。初始化城市列表和热门城市列表数组。
 * @example
 * // 热门城市列表
   hotCityList: HotCityListItemView[] = [];
   // 城市列表
   cityList: CityListItemView[] = [];

   aboutToAppear(): void {
     CITY_DATA.forEach((cityItem: CityType) => {
       this.cityList.push(new CityListItemView(cityItem, wrapBuilder(cityListItemSection)))
     })
     HOT_CITY.forEach((hotCityItem: string) => {
       this.hotCityList.push(new HotCityListItemView(hotCityItem, wrapBuilder(hotCitySection)))
     })
   }
 * 以上代码中，HotCityListItemView为热门城市列表项的类，CityListItemView为城市列表项的类。两者都包含列表项、
 * 列表项视图，开发者可以自行配置，也可以使用默认的属性配置。
 *
 * 2. 构建自定义城市视图。
   AlphabetListView({
     hotSelectList: this.hotCityList,
     hotSelectListTitle: $r('app.string.citysearch_hotCity'),
     alphabetSelectList: this.cityList,
     hotSelectHandle: (hotSelectValue: string) => {
       this.hotSelectHandle(hotSelectValue);
     },
     alphabetSelectHandle: (alphabetSelectValue: string) => {
       this.alphabetSelectHandle(alphabetSelectValue);
     }
   })
 *
 */
@Component
export struct CitySearch {
  // 搜索值
  @State changeValue: string = '';
  // 热门城市列表
  hotCityList: HotListItemView[] = [];
  // 城市列表
  cityList: AlphabetListItemView[] = [];
  // 占位
  placeholder: string = CommonConstants.PLACE_HOLDER_TEXT;
  // 搜索控制器
  controller: SearchController = new SearchController();
  // 是否展示搜索结果列表
  @State isSearchState: boolean = false;
  // 搜索结果
  @State searchList: string[] = [];

  /**
   * 弹窗函数
   */
  showToast() {
    promptAction.showToast({
      message: $r('app.string.citysearch_only_show_for_ux')
    })
  }

  aboutToAppear(): void {
    CITY_DATA.forEach((cityItem: AlphabetListItemType) => {
      this.cityList.push(new AlphabetListItemView(cityItem, wrapBuilder(cityListItemSection)))
    })
    HOT_CITY.forEach((hotCityItem: string) => {
      this.hotCityList.push(new HotListItemView(hotCityItem, wrapBuilder(hotCitySection)))
    })
  }

  build() {
    Column() {
      // 搜索框
      Search({ value: this.changeValue, placeholder: this.placeholder, controller: this.controller })
        .searchButton(SEARCH_BUTTON_TEXT)
        .width(CommonConstants.VIEW_FULL)
        .height($r('app.integer.citysearch_search_height'))
        .margin({ left: $r('app.integer.citysearch_search_margin_left') })
        .backgroundColor($r('app.color.citysearch_search_bgc'))
        .placeholderColor(Color.Grey)
        .placeholderFont({ size: $r('app.integer.citysearch_placeholderFont_size'), weight: CommonConstants.WEIGHT })
        .textFont({ size: $r('app.integer.citysearch_placeholderFont_size'), weight: CommonConstants.WEIGHT })
        .onSubmit((value: string) => {
          // 如果没有输入数据，就使用占位符作为默认数据
          if (value.length === 0) {
            value = this.placeholder;
          }
          // 将值赋值给changeValue
          this.changeValue = value;
          this.isSearchState = true;
          this.searchCityList(value);
          if (this.searchList.length === 0) {
            this.showToast();
          }
        })
        .onChange((value: string) => {
          this.changeValue = value;
          // 搜索
          this.searchCityList(value);
          if (value.length === 0) {
            // 关闭搜索列表
            this.isSearchState = false;
            // 清空数据
            this.searchList.splice(0, this.searchList.length);
          } else {
            this.changeValue = value;
            // 搜索
            this.searchCityList(value);
            this.isSearchState = true;
            if (this.searchList.length === 0) {
              this.showToast();
            }
          }
        })

      /**
       * 城市列表组件
       * @param hotSelectList - 热门选择列表
       * @param alphabetSelectList - 字母选择数据列表
       * @param hotSelectListTitle - 热门选择列表标题
       * @param hotSelectHandle - 点击热门选择列表项处理逻辑
       * @param alphabetSelectHandle - 点击字母列表项处理逻辑
       */
      AlphabetListView({
        hotSelectList: this.hotCityList,
        hotSelectListTitle: $r('app.string.citysearch_hotCity'),
        alphabetSelectList: this.cityList,
        hotSelectHandle: (hotSelectValue: string) => {
          this.hotCityHandle(hotSelectValue);
        },
        alphabetSelectHandle: (alphabetSelectValue: string) => {
          this.cityHandle(alphabetSelectValue);
        }
      })
        .margin({ top: $r('app.integer.citysearch_list_margin_top') })/**
         * 性能知识点：由于需要通过搜索按钮频繁的控制自定义组件的显隐状态，因此推荐使用显隐控制替代条件渲染，
         * 参考合理选择条件渲染和显隐控制文章：
         * https://docs.openharmony.cn/pages/v4.1/zh-cn/application-dev/performance/proper-choice-between-if-and-visibility.md
         */
        .visibility(this.isSearchState ? Visibility.None : Visibility.Visible)

      /**
       * 搜索组件，将数据传递到搜索列表
       * @param searchList: 搜索列表数据
       * @param changeValue: 选定的城市
       */
      SearchView({ searchList: $searchList, changeValue: $changeValue })
        .width(CommonConstants.VIEW_FULL)
        .layoutWeight(1)
        .visibility(this.isSearchState ? Visibility.Visible : Visibility.None)
    }
    .width(CommonConstants.VIEW_FULL)
    .height(CommonConstants.VIEW_FULL)
    .padding({ left: $r('app.integer.citysearch_padding_left'), right: $r('app.integer.citysearch_padding_right') })
    .backgroundColor($r('app.color.citysearch_bgc'))
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
  }

  // 搜索城市展示逻辑
  searchCityList(value: string) {
    let cityNames: string[] = [];
    CITY_DATA.forEach(item => {
      if (item.name.includes(value.toUpperCase())) {
        // 当搜索城市拼音首字母，将相关城市信息展示。例如输入"a"，会出现"阿尔山"、"阿勒泰地区"、"安庆"、"安阳"。
        // 输入"b"，会出现"北京"、"亳州"、"包头"、"宝鸡"。
        cityNames = item.dataList;
        return;
      }
      item.dataList.forEach(cityName => {
        // 当搜索汉字，会进行模糊搜索，将相关城市信息展示。例如搜索"长"：展示"长沙"，"长春"。
        if (cityName.includes(value)) {
          cityNames.push(cityName);
        }
      })
    })
    // 判断是否有输入的值
    if (value.length !== 0) {
      this.searchList = cityNames;
    } else {
      this.searchList = [];
    }
  }

  cityHandle(alphabetSelectValue: string) {
    // TODO:待开发者根据选定列表的城市名称时执行的逻辑操作，比如说筛选等
    // 当前调用Toast显示提示:此样式仅为案例展示
    promptAction.showToast({ message: $r('app.string.citysearch_only_show_ui') });
  }

  hotCityHandle(hotSelectValue: string) {
    this.changeValue = hotSelectValue;
  }
}

@Builder
function hotCitySection(hotCity: string) {
  Text(`${hotCity}`)
    .margin({
      bottom: $r('app.integer.citysearch_text_margin_bottom'),
      left: $r('app.integer.citysearch_text_margin_left2')
    })
    .width(CommonConstants.HOT_CITY_TEXT_WIDTH)
    .height($r('app.integer.citysearch_text_height'))
    .textAlign(TextAlign.Center)
    .fontSize($r('app.integer.citysearch_text_font'))
    .maxLines(CommonConstants.MAX_LINES)
    .fontColor($r('app.color.citysearch_text_font_color2'))
    .backgroundColor($r('app.color.citysearch_text_bgc'))
    .borderRadius($r('app.integer.citysearch_text_border_radius'))
}

@Builder
function cityListItemSection(cityItem: string) {
  Text(cityItem)
    .height($r('app.integer.citysearch_list_item_height'))
    .fontSize($r('app.integer.citysearch_text_font'))
    .width(CommonConstants.VIEW_FULL)
}