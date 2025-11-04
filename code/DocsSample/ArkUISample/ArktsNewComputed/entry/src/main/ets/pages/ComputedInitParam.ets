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

// [Start Computed_Init_Param]
@ObservedV2
class Article {
  @Trace public quantity: number = 0;
  public unitPrice: number = 0;

  constructor(quantity: number, unitPrice: number) {
    this.quantity = quantity;
    this.unitPrice = unitPrice;
  }
}

@Entry
@ComponentV2
export struct ComputedInitParam {
  @Local shoppingBasket: Article[] = [new Article(1, 20), new Article(5, 2)];

  @Computed
  get total(): number {
    return this.shoppingBasket.reduce((acc: number, item: Article) => acc + (item.quantity * item.unitPrice), 0);
  }

  @Computed
  get qualifiesForDiscount(): boolean {
    return this.total >= 100;
  }

  build() {
    // [StartExclude Computed_Init_Param]
    NavDestination() {
      // [EndExclude  Computed_Init_Param]
      Column() {
        Text(`Shopping List: `)
          .fontSize(30)
        ForEach(this.shoppingBasket, (item: Article) => {
          Row() {
            Text(`unitPrice: ${item.unitPrice}`)
            Button('-')
              .onClick(() => {
                if (item.quantity > 0) {
                  item.quantity--;
                }
              })
            Text(`quantity: ${item.quantity}`)
            Button('+')
              .onClick(() => {
                item.quantity++;
              })
          }

          Divider()
        })
        Child({ total: this.total, qualifiesForDiscount: this.qualifiesForDiscount })
      }.alignItems(HorizontalAlign.Start)
      // [StartExclude Computed_Init_Param]
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.computed_title_3'))
    // [EndExclude  Computed_Init_Param]
  }
}

@ComponentV2
struct Child {
  @Param total: number = 0;
  @Param qualifiesForDiscount: boolean = false;

  build() {
    Row() {
      Text(`Total: ${this.total} `)
        .fontSize(30)
      Text(`Discount: ${this.qualifiesForDiscount} `)
        .fontSize(30)
    }
  }
}
// [End Computed_Init_Param]
