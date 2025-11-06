/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

// [Start article_list_view_one]
class ArticleChangeSource {
  public id: string;
  public title: string;
  public brief: string;

  constructor(id: string, title: string, brief: string) {
    this.id = id;
    this.title = title;
    this.brief = brief;
  }
}

@Entry
@Component
struct ArticleListViewChangeSource {
  @State isListReachEnd: boolean = false;
  @State articleList: Array<ArticleChangeSource> = [
    new ArticleChangeSource('001', 'Article 1', 'Abstract'),
    new ArticleChangeSource('002', 'Article 2', 'Abstract'),
    new ArticleChangeSource('003', 'Article 3', 'Abstract'),
    new ArticleChangeSource('004', 'Article 4', 'Abstract'),
    new ArticleChangeSource('005', 'Article 5', 'Abstract'),
    new ArticleChangeSource('006', 'Article 6', 'Abstract')
  ];

  loadMoreArticles() {
    this.articleList.push(new ArticleChangeSource('007', 'New Article', 'Abstract'));
  }

  build() {
    Column({ space: 5 }) {
      List() {
        ForEach(this.articleList, (item: ArticleChangeSource) => {
          ListItem() {
            ArticleCardChangeSource({ article: item })
              .margin({ top: 20 })
          }
        }, (item: ArticleChangeSource) => item.id)
      }
      .onReachEnd(() => {
        this.isListReachEnd = true;
      })
      .parallelGesture(
        PanGesture({ direction: PanDirection.Up, distance: 80 })
          .onActionStart(() => {
            if (this.isListReachEnd) {
              this.loadMoreArticles();
              this.isListReachEnd = false;
            }
          })
      )
      .padding(20)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0xF1F3F5)
  }
}

@Component
struct ArticleCardChangeSource {
  @Prop article: ArticleChangeSource;

  build() {
    Row() {
      // 此处'app.media.startIcon'仅作示例，请开发者自行替换，否则imageSource创建失败会导致后续无法正常执行。
      Image($r('app.media.startIcon'))
        .width(80)
        .height(80)
        .margin({ right: 20 })

      Column() {
        Text(this.article.title)
          .fontSize(20)
          .margin({ bottom: 8 })
        Text(this.article.brief)
          .fontSize(16)
          .fontColor(Color.Gray)
          .margin({ bottom: 8 })
      }
      .alignItems(HorizontalAlign.Start)
      .width('80%')
      .height('100%')
    }
    .padding(20)
    .borderRadius(12)
    .backgroundColor('#FFECECEC')
    .height(120)
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }
}
// [End article_list_view_one]