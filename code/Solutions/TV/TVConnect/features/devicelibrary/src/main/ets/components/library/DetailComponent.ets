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
import { CommonConstants } from '../../constants/CommonConstants';
import { DetailListsComponent } from './DetailListsComponent';
import { SideListComponent } from './SideListComponent';

@Component
export struct DetailSingComponent {
  @Prop currentTab: number = 0;
  @State sideListIndex: number = 0;

  build() {
    Column() {
      DetailListsComponent({
        currentTab: this.currentTab,
        deviceColumns: 6,
        sideListIndex: this.sideListIndex,
      });
    }.height('100%').width('100%').alignItems(HorizontalAlign.Start).justifyContent(FlexAlign.Start);
  }
}

@Component
export struct DetailMultipleComponent {
  @Prop currentTab: number = 0;
  @State sideListIndex: number = 0;
  private listScroller: Scroller = new Scroller();

  build() {
    GridRow({
      columns: { sm: CommonConstants.COLUMN_SM, md: CommonConstants.COLUMN_MD, lg: CommonConstants.COLUMN_LG },
      breakpoints: { value: CommonConstants.BREAK_POINTS_VALUE, reference: BreakpointsReference.WindowSize }
    }) {
      GridCol({
        span: {
          sm: CommonConstants.SIDE_LIST_SPAN_SM,
          md: CommonConstants.SIDE_LIST_SPAN_MD,
          lg: CommonConstants.SIDE_LIST_SPAN_LG
        }
      }) {
        SideListComponent({
          sideListIndex: this.sideListIndex,
          currentTab: this.currentTab,
        });
      };

      GridCol({
        span: {
          sm: CommonConstants.DETAIL_LIST_SPAN_SM,
          md: CommonConstants.DETAIL_LIST_SPAN_MD,
          lg: CommonConstants.DETAIL_LIST_SPAN_LG
        }
      }) {
        DetailListsComponent({
          currentTab: this.currentTab,
          deviceColumns: 5,
          sideListIndex: this.sideListIndex,
          scroller: this.listScroller,
        });
      };
    }
    .width('100%')
    .height('100%');
  }
}