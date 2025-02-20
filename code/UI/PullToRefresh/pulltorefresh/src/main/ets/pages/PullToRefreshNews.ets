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

/**
 * 使用pullToRefresh组件样例
 *
 * 核心组件:
 * 1. pullToRefresh
 *
 * 实现步骤:
 * 1. 使用一个@Builder修饰的方法实现LazyForEach列表懒加载。
 * 2. 使用pullToRefresh组件实现上拉下滑加载数据，将UI方法传入组件中。
 */

import util from '@ohos.util';
import { PullToRefresh, PullToRefreshConfigurator } from '@ohos/pulltorefresh/index';
import { BasicDataSource } from '../viewModel/BasicDataSource';

const NEWS_TITLE_MAX_LINES: number = 1;
const NEWS_TITLE_TEXT_FONT_WEIGHT: number = 500;
const NEWS_CONTENT_MAX_LINES: number = 2;
const NEWS_TIME_MAX_LINES: number = 1;
const NEWS_PAGE_TEXT_FONT_WEIGHT: number = 600;
const NEWS_RESOLVE_SUCCESS: string = '刷新成功';
const NEWS_MOCK_DATA_COUNT: number = 8; // 每份模拟数据所含的新闻个数为8
const MOCK_DATA_FILE_ONE_DIR: string = 'mockDataOne.json'; // 模拟数据路径
const MOCK_DATA_FILE_TWO_DIR: string = 'mockDataTwo.json'; // 模拟数据路径
const NEWS_REFRESH_TIME: number = 1500; // 数据刷新时间
const LOAD_DEFAULT_TEXT: string = '正在玩命加载中...'; // 上拉加载默认文本
const LOAD_STOP_TEXT: string = '已经到底啦'; // 上拉加载到底提示文本
const LOAD_TEXT_PULL_UP_1: string = '正在上拉刷新...'; // 上拉1阶段文本
const LOAD_TEXT_PULL_UP_2: string = '放开刷新'; // 上拉2阶段文本
const NEWS_MAX_LIST: number = 4; // 数据列表总页数
const LOAD_PULL_STATE_CHANGE: number = 0.75; // 根据组件动画配置的上拉阶段改变临界值
const PAGE_LIST_ID: string = 'pageList'; // 列表ID

@Component
export struct PullToRefreshNewsComponent {
  // 创建用于懒加载的数据对象
  @State newsData: NewsDataSource = new NewsDataSource();
  private mockFlag: boolean = true;
  // 需绑定列表或宫格组件
  private scroller: Scroller = new Scroller();
  // 模拟数据列表页
  @State newsDataListIndex: number = 1;
  private refreshConfigurator: PullToRefreshConfigurator = new PullToRefreshConfigurator();
  @State isPullUp: boolean = true;
  @State isLoading: boolean = false;
  @State private angle1?: number | string = 0;
  @State private angle2?: number | string = 0;
  @State loadText: string = '';

  aboutToAppear() {
    const newsModelMockData: NewsData[] = getNews(MOCK_DATA_FILE_ONE_DIR);
    for (let j = 0; j < NEWS_MOCK_DATA_COUNT; j++) {
      this.newsData.pushData(newsModelMockData[j]);
    }
  }

  build() {
    Column() {
      Text($r('app.string.pull_refresh_page_title'))
        .fontSize($r('app.integer.pull_refresh_page_text_font_size'))
        .fontWeight(NEWS_PAGE_TEXT_FONT_WEIGHT)
        .textAlign(TextAlign.Start)
        .lineHeight($r('app.integer.pull_refresh_page_text_line_height'))
        .padding({ left: $r('app.string.pull_refresh_page_text_padding_left') })
        .width($r('app.string.pull_refresh_page_text_width'))
        .height($r('app.string.pull_refresh_page_text_height'))
        .backgroundColor($r('app.color.pull_refresh_listColor'))

      Column() {
        PullToRefresh({
          // TODO: 知识点：使用PullToRefresh组件时需要先绑定数据与主体布局。若使用LazyForEach组件渲染列表时，需将UI方法使用@Builder修饰并传入customList属性中。
          // 必传项，列表组件所绑定的数据
          data: $newsData,
          // 必传项，需绑定传入主体布局内的列表或宫格组件
          scroller: this.scroller,
          // 必传项，自定义主体布局，内部有列表或宫格组件
          customList: () => {
            // 一个用@Builder修饰过的UI方法
            this.getListView();
          },
          // 组件属性配置，具有默认值
          refreshConfigurator: this.refreshConfigurator,
          // TODO: 知识点：设置onRefresh下拉刷新回调方法，该方法必须返回一个Promise类型。
          onRefresh: () => {
            return new Promise<string>((resolve, reject) => {
              // 模拟网络请求操作，请求网络1.5秒后得到数据，通知组件，变更列表数据
              setTimeout(() => {
                this.newsData.clear();
                let newsModelMockData: NewsData[] = [];
                // 根据mockFlag切换获取的数据文件
                if (this.mockFlag) {
                  newsModelMockData = getNews(MOCK_DATA_FILE_TWO_DIR);
                } else {
                  newsModelMockData = getNews(MOCK_DATA_FILE_ONE_DIR);
                }
                this.mockFlag = !this.mockFlag;
                for (let j = 0; j < NEWS_MOCK_DATA_COUNT; j++) {
                  this.newsData.pushData(newsModelMockData[j]);
                }
                resolve(NEWS_RESOLVE_SUCCESS);
                // 页码归零
                this.newsDataListIndex = 1;
              }, NEWS_REFRESH_TIME);
            });
          },
          // TODO: 知识点：设置onLoadMore上滑加载更多数据回调方法，该方法必须返回一个Promise类型。
          onLoadMore: () => {
            return new Promise<string>((resolve, reject) => {
              // 模拟数据列表页超过4页后已到达底部，无法继续加载
              if (this.newsDataListIndex < NEWS_MAX_LIST) {
                // 模拟网络请求操作，请求网络1.5秒后得到数据，通知组件变更列表数据
                setTimeout(() => {
                  let newsModelMockData: NewsData[] = getNews(MOCK_DATA_FILE_ONE_DIR);
                  for (let j = 0; j < NEWS_MOCK_DATA_COUNT; j++) {
                    this.newsData.pushData(newsModelMockData[j]);
                  }
                  this.newsDataListIndex++;
                  resolve('');
                }, NEWS_REFRESH_TIME);
              } else {
                // 如果已满4页，更改上拉提示信息提示已经加载完所有数据
                setTimeout(() => {
                  resolve('');
                }, NEWS_REFRESH_TIME);
              }
            });
          },
          customLoad: () => this.customLoad(),
          customRefresh: null,
          onAnimPullUp: (value, width, height) => {
            if (value !== undefined && width !== undefined && height !== undefined) {
              if (value) {
                this.isLoading = false;
                this.isPullUp = true;
                // 判断上拉拖拽过程中高度是否超过阶段临界值
                if (value < LOAD_PULL_STATE_CHANGE) {
                  // 归零角度，保持箭头朝上
                  this.angle1 = 0;
                  // 改变提示文本为上拉1阶段
                  this.loadText = LOAD_TEXT_PULL_UP_1;
                } else {
                  // 翻转角度，保持箭头朝下
                  this.angle1 = 180;
                  // 改变提示文本为上拉2阶段
                  this.loadText = LOAD_TEXT_PULL_UP_2;
                }
              }
            }
          },
          onAnimLoading: (value, width, height) => {
            if (value !== undefined && width !== undefined && height !== undefined) {
              if (value) {
                this.isPullUp = false;
                this.isLoading = true;
                // 更改角度使加载图片保持旋转
                this.angle2 = value * 360;
                // 判读页码是否为最后一页
                if (this.newsDataListIndex !== NEWS_MAX_LIST) {
                  this.loadText = LOAD_DEFAULT_TEXT;
                } else {
                  // 最后一页更换文本提示已经到底了
                  this.loadText = LOAD_STOP_TEXT;
                }
              }
            }
          }
        })
      }
      .backgroundColor($r('app.color.pull_refresh_listColor'))
    }
    .height($r('app.string.pull_refresh_page_height'))
  }

  @Builder
  private customLoad() {
    Row() {
      Stack() {
        // 上拉1阶段箭头图片
        Image($r('app.media.pull_icon_up'))
          .width($r('app.string.pull_refresh_load_width'))
          .height($r('app.string.pull_refresh_load_height'))
          .objectFit(ImageFit.Contain)
          .visibility(this.isPullUp ? Visibility.Visible : Visibility.Hidden)
          .rotate({
            z: 1,
            angle: this.angle1 !== undefined ? this.angle1 : 0
          })
        // 加载时图片
        Image($r('app.media.pull_icon_load'))
          .width($r('app.string.pull_refresh_load_width'))
          .height($r('app.string.pull_refresh_load_height'))
          .objectFit(ImageFit.Contain)
          .visibility(this.isLoading ? Visibility.Visible : Visibility.Hidden)
          .rotate({
            z: 1,
            angle: this.angle2 !== undefined ? this.angle2 : 0
          })
      }
      // 最后一页加载时隐藏加载图片
      .width(this.newsDataListIndex === NEWS_MAX_LIST && this.isLoading ? 0 :
      this.refreshConfigurator.getLoadImgHeight())
      .height(this.newsDataListIndex === NEWS_MAX_LIST && this.isLoading ? 0 :
      this.refreshConfigurator.getLoadImgHeight())

      // 上拉过程与加载时提示文本
      Text(this.loadText)
        .height($r('app.string.pull_refresh_load_height'))
        .textAlign(TextAlign.Center)
        .margin({ left: this.newsDataListIndex === NEWS_MAX_LIST && this.isLoading ? 0 : 8 })
        .fontColor(this.refreshConfigurator !== undefined ? this.refreshConfigurator.getLoadTextColor() : 0)
        .fontSize(this.refreshConfigurator !== undefined ? this.refreshConfigurator.getLoadTextSize() : 0)
    }
    .height($r('app.string.pull_refresh_load_height'))
  }

  // 必须使用@Builder修饰方法
  @Builder
  private getListView() {
    List({
      space: 3, scroller: this.scroller
    }) {
      // TODO: 性能知识点：使用懒加载组件渲染数据
      LazyForEach(this.newsData, (item: NewsData) => {
        ListItem() {
          newsItem({
            newsTitle: item.newsTitle,
            newsContent: item.newsContent,
            newsTime: item.newsTime
          })
        }
        .backgroundColor($r('app.color.pull_refresh_white'))
        .margin({
          bottom: $r('app.string.pull_refresh_list_margin_bottom'),
          left: $r('app.string.pull_refresh_list_item_margin_left')
        })
        .borderRadius($r('app.integer.pull_refresh_list_border_radius'))
      }, (item: NewsData, index?: number) => JSON.stringify(item) + index);
    }
    .id(PAGE_LIST_ID)
    .width($r('app.string.pull_refresh_List_width'))
    .backgroundColor($r('app.color.pull_refresh_listColor'))
    // TODO: 知识点：必须设置列表为滑动到边缘无效果，否则无法触发pullToRefresh组件的上滑下拉方法。
    .edgeEffect(EdgeEffect.None)
  }

  aboutToDisappear() {
    this.newsData.clear();
  }
}

// 单一列表样式组件
@Component
struct newsItem {
  private newsTitle: string | Resource = '';
  private newsContent: string | Resource = '';
  private newsTime: string | Resource = '';

  build() {
    Column() {
      Row() {
        Image($r('app.media.pull_refresh_news'))
          .width($r('app.string.pull_refresh_title_image_width'))
          .height($r('app.string.pull_refresh_title_image_height'))
          .objectFit(ImageFit.Contain)
        Text(this.newsTitle)
          .fontSize($r('app.integer.pull_refresh_title_text_font_size'))
          .fontColor($r('app.color.pull_refresh_title_fontColor'))
          .width($r('app.string.pull_refresh_title_text_width'))
          .maxLines(NEWS_TITLE_MAX_LINES)
          .margin({ left: $r('app.string.pull_refresh_title_text_margin_left') })
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontWeight(NEWS_TITLE_TEXT_FONT_WEIGHT)
      }
      .alignItems(VerticalAlign.Center)
      .height($r('app.string.pull_refresh_title_row_height'))
      .margin({
        top: $r('app.string.pull_refresh_title_row_margin_top'),
        left: $r('app.string.pull_refresh_title_image_margin_left')
      })

      Text(this.newsContent)
        .fontSize($r('app.integer.pull_refresh_content_font_size'))
        .lineHeight($r('app.integer.pull_refresh_content_font_line_height'))
        .fontColor($r('app.color.pull_refresh_content_fontColor'))
        .height($r('app.string.pull_refresh_content_height'))
        .width($r('app.string.pull_refresh_content_width'))
        .maxLines(NEWS_CONTENT_MAX_LINES)
        .margin({
          left: $r('app.string.pull_refresh_content_margin_left'),
          top: $r('app.string.pull_refresh_content_margin_top')
        })
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(this.newsTime)
        .fontSize($r('app.integer.pull_refresh_time_font_size'))
        .fontColor($r('app.color.pull_refresh_time_fontColor'))
        .height($r('app.string.pull_refresh_time_height'))
        .width($r('app.string.pull_refresh_time_width'))
        .maxLines(NEWS_TIME_MAX_LINES)
        .margin({
          left: $r('app.string.pull_refresh_time_margin_left'),
          top: $r('app.string.pull_refresh_time_margin_top')
        })
        .textOverflow({ overflow: TextOverflow.None })
    }
    .alignItems(HorizontalAlign.Start)
  }
}

// 新闻数据对象
class NewsData {
  newsId: string
  newsTitle: string | Resource
  newsContent: string | Resource
  newsTime: string | Resource

  toString(): string {
    return this.newsId + ' ' + this.newsTitle + ' ' + this.newsContent + ' ' + this.newsTime;
  }

  constructor(id: string, title: string | Resource, content: string | Resource, time: string | Resource) {
    this.newsId = id;
    this.newsTitle = title;
    this.newsContent = content;
    this.newsTime = time;
  }
}

// 懒加载列表对象
class NewsDataSource extends BasicDataSource {
  dataArray: Array<NewsData> = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): Object {
    return this.dataArray[index];
  }

  public addData(index: number, data: NewsData): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: NewsData): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public clear(): void {
    this.dataArray = [];
  }
}

class JsonObjType {
  public newsList: NewsData[] = [];
}

class JsonObject {
  private jsonFileDir: string = '';

  constructor(jsonFileDir: string) {
    this.jsonFileDir = jsonFileDir;
  }

  // 获取数据
  getNewsData(): Array<NewsData> {
    // 从本地文件中获取数据
    const value = getContext().resourceManager.getRawFileContentSync(this.jsonFileDir);
    // 解码为utf-8格式
    const textDecoder = util.TextDecoder.create('utf-8', {
      ignoreBOM: true
    });
    const textDecoderResult = textDecoder.decodeWithStream(new Uint8Array(value.buffer));
    const jsonObj: JsonObjType = JSON.parse(textDecoderResult) as JsonObjType;
    const newsModelBuckets: NewsData[] = [];
    // 映射json数据为NewsModel对象
    const newsModelObj = jsonObj.newsList;
    for (let i = 0; i < newsModelObj.length; i++) {
      const contactTemp = new NewsData(newsModelObj[i].newsId, newsModelObj[i].newsTitle,
        newsModelObj[i].newsContent, newsModelObj[i].newsTime);
      newsModelBuckets.push(contactTemp);
    }
    return newsModelBuckets;
  }
}

function getNews(mockFileDir: string): Array<NewsData> {
  const jsonObj: JsonObject = new JsonObject(mockFileDir);
  const newsModelMockData: NewsData[] = jsonObj.getNewsData();
  return newsModelMockData;
}
