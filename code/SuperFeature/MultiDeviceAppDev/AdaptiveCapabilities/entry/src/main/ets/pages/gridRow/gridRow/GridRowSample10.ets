/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

// Radio group
const OVERALL_LEFT_CENTER_RIGHT = '1';
const OVERALL_TOP_MIDDLE_BOTTOM = '2';
const SINGLE_LEFT_CENTER_RIGHT = '3';
const SINGLE_TOP_MIDDLE_BOTTOM = '4';

@Entry
@Component
struct GridRowSample10 {
  @State col1Offset: number = 0;
  @State col2Offset: number = 0;
  @State col1Order: number = 0;
  @State col2Order: number = 1;
  @State col1Align: ItemAlign = ItemAlign.Start;
  @State col2Align: ItemAlign = ItemAlign.Start;
  private gridController: GridColController = new GridColController();
  private layoutColumns: number = 6;
  private radioHeight: Length = '80%';
  private radioValue: string = 'RadioValue';

  build() {
    Column({ space: 5 }) {

      Column() {
        GridRow({ columns: this.layoutColumns, direction: GridRowDirection.Row }) {

          // The non-rendering component support the Height attribute of GridRow
          GridCol({ span: 0 })
            .height('100%')
            .backgroundColor('#ccc');

          GridCol({ span: 1, offset: this.col1Offset, order: this.col1Order }) {
            Text('1')
              .height('100%')
              .fontSize(24);
          }.height('33.3%')
          .backgroundColor('#ff00ff94')
          .alignSelf(this.col1Align);

          GridCol({ span: 1, offset: this.col2Offset, order: this.col2Order }) {
            Text('2')
              .height('100%')
              .fontSize(24);
          }.height('33.3%')
          .backgroundColor('#ff53e8ff')
          .alignSelf(this.col2Align);
        }.width('100%')
        .height('100%');
      }.width('100%')
      .height('50%')
      .border({ width: 1, color: '#ff00ffe9' });

      Column() {

        // Radio Groups
        Row() {
          Text($r('app.string.Radio_GridRow_All_LCR'))
            .fontSize(24)
            .layoutWeight(1);

          Row() {
            Radio({ value: this.radioValue, group: OVERALL_LEFT_CENTER_RIGHT })
              .height(this.radioHeight)
              .id('rdo11')
              .onClick(() => {
                this.gridController.moveAllInHor(HorDirection.LEFT, this);
              });
            Radio({ value: this.radioValue, group: OVERALL_LEFT_CENTER_RIGHT })
              .height(this.radioHeight)
              .id('rdo12')
              .onClick(() => {
                this.gridController.moveAllInHor(HorDirection.MEDIUM, this);
              });
            Radio({ value: this.radioValue, group: OVERALL_LEFT_CENTER_RIGHT })
              .height(this.radioHeight)
              .id('rdo13')
              .onClick(() => {
                this.gridController.moveAllInHor(HorDirection.RIGHT, this)
              });
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.End);
        }.width('100%')
        .height('25%')
        .justifyContent(FlexAlign.SpaceAround)
        .margin({ top: '1%' });

        Row() {
          Text($r('app.string.Radio_GridRow_All_TMB'))
            .fontSize(24)
            .layoutWeight(1);

          Row() {
            Radio({ value: this.radioValue, group: OVERALL_TOP_MIDDLE_BOTTOM })
              .height(this.radioHeight)
              .id('rdo21')
              .onClick(() => {
                this.gridController.moveAllInVer(VerDirection.TOP, this);
              });
            Radio({ value: this.radioValue, group: OVERALL_TOP_MIDDLE_BOTTOM })
              .height(this.radioHeight)
              .id('rdo22')
              .onClick(() => {
                this.gridController.moveAllInVer(VerDirection.MEDIUM, this);
              });
            Radio({ value: this.radioValue, group: OVERALL_TOP_MIDDLE_BOTTOM })
              .height(this.radioHeight)
              .id('rdo23')
              .onClick(() => {
                this.gridController.moveAllInVer(VerDirection.BOTTOM, this);
              });
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.End);
        }.width('100%')
        .height('25%')
        .justifyContent(FlexAlign.SpaceAround)
        .margin({ top: '1%' });

        Row() {
          Text($r('app.string.Radio_GridRow_Sg_LCR'))
            .fontSize(24)
            .layoutWeight(1);

          Row() {
            Radio({ value: this.radioValue, group: SINGLE_LEFT_CENTER_RIGHT })
              .height(this.radioHeight)
              .id('rdo31')
              .onClick(() => {
                this.gridController.moveSecInHor(HorDirection.LEFT, this);
              });
            Radio({ value: this.radioValue, group: SINGLE_LEFT_CENTER_RIGHT })
              .height(this.radioHeight)
              .id('rdo32')
              .onClick(() => {
                this.gridController.moveSecInHor(HorDirection.MEDIUM, this);
              });
            Radio({ value: this.radioValue, group: SINGLE_LEFT_CENTER_RIGHT })
              .height(this.radioHeight)
              .id('rdo33')
              .onClick(() => {
                this.gridController.moveSecInHor(HorDirection.RIGHT, this);
              });
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.End);
        }.width('100%')
        .height('25%')
        .justifyContent(FlexAlign.SpaceAround)
        .margin({ top: '1%' });

        Row() {
          Text($r('app.string.Radio_GridRow_Sg_TMB'))
            .fontSize(24)
            .layoutWeight(1);

          Row() {
            Radio({ value: this.radioValue, group: SINGLE_TOP_MIDDLE_BOTTOM })
              .height(this.radioHeight)
              .id('rdo41')
              .onClick(() => {
                this.gridController.moveSecInVer(VerDirection.TOP, this);
              });
            Radio({ value: this.radioValue, group: SINGLE_TOP_MIDDLE_BOTTOM })
              .height(this.radioHeight)
              .id('rdo42')
              .onClick(() => {
                this.gridController.moveSecInVer(VerDirection.MEDIUM, this);
              });
            Radio({ value: this.radioValue, group: SINGLE_TOP_MIDDLE_BOTTOM })
              .height(this.radioHeight)
              .id('rdo43')
              .onClick(() => {
                this.gridController.moveSecInVer(VerDirection.BOTTOM, this);
              });
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.End);
        }
        .width('100%')
        .height('25%')
        .justifyContent(FlexAlign.SpaceAround)
        .margin({ top: '1%' });
      }
      .width('100%')
      .height('30%')
      .padding({left: 10, right: 10});
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center);
  }
}

enum HorDirection {
  LEFT,
  MEDIUM,
  RIGHT
}

enum VerDirection {
  TOP,
  MEDIUM,
  BOTTOM
}

const COL1_POSITIONS = [0, 2, 4]; // The values of the first component

class GridColController {

  moveAllInHor(pos: HorDirection, inst: GridRowSample10) {
    switch (pos) {
      case HorDirection.LEFT:
        inst.col1Offset = COL1_POSITIONS[HorDirection.LEFT];
        break;
      case HorDirection.MEDIUM:
        inst.col1Offset = COL1_POSITIONS[HorDirection.MEDIUM];
        break;
      default:
        inst.col1Offset = COL1_POSITIONS[HorDirection.RIGHT];
        break;
    }
    inst.col2Offset = 0;
    this.orderReset(inst);
  }

  moveAllInVer(pos: VerDirection, inst: GridRowSample10) {
    switch (pos) {
      case VerDirection.TOP:
        inst.col1Align = ItemAlign.Start;
        break;
      case VerDirection.MEDIUM:
        inst.col1Align = ItemAlign.Center;
        break;
      default:
        inst.col1Align = ItemAlign.End;
        break;
    }
    inst.col2Align = inst.col1Align;
  }

  moveSecInHor(pos: HorDirection, inst: GridRowSample10) {
    switch (pos) {
      case HorDirection.LEFT:
        this.moveSecToLeft(inst);
        break;
      case HorDirection.MEDIUM:
        this.moveSecToMedium(inst);
        break;
      default: // col1 in RIGHT
        this.moveSecToRight(inst);
        break;
    }
  }

  moveSecInVer(pos: VerDirection, inst: GridRowSample10) {
    switch (pos) {
      case VerDirection.TOP:
        inst.col2Align = ItemAlign.Start;
        break;
      case VerDirection.MEDIUM:
        inst.col2Align = ItemAlign.Center;
        break;
      default:
        inst.col2Align = ItemAlign.End;
        break;
    }
  }

  private orderReset(inst: GridRowSample10) {
    inst.col1Order = 0;
    inst.col2Order = 1;
  }

  private orderRevert(inst: GridRowSample10) {
    inst.col1Order = 1;
    inst.col2Order = 0;
  }

  private col1OffsetReset(inst: GridRowSample10) {
    if (inst.col1Order > inst.col2Order) {
      inst.col1Offset += inst.col2Offset + 1;
    }
  }

  private moveSecToLeft(inst: GridRowSample10) {
    this.col1OffsetReset(inst);
    switch (inst.col1Offset) {
      case COL1_POSITIONS[HorDirection.LEFT]:
        this.orderReset(inst);
        inst.col2Offset = COL1_POSITIONS[HorDirection.LEFT] - COL1_POSITIONS[HorDirection.LEFT];
        break;
      case COL1_POSITIONS[HorDirection.MEDIUM]:
        this.orderRevert(inst);
        inst.col2Offset = COL1_POSITIONS[HorDirection.LEFT] + 1;
        inst.col1Offset = 0;
        break;
      default: // RIGHT
        this.orderRevert(inst);
        inst.col2Offset = COL1_POSITIONS[HorDirection.LEFT] + 1;
        inst.col1Offset = 2;
        break;
    }
  }

  private moveSecToMedium(inst: GridRowSample10) {
    this.col1OffsetReset(inst);
    switch (inst.col1Offset) {
      case COL1_POSITIONS[HorDirection.LEFT]:
        this.orderReset(inst);
        inst.col2Offset = COL1_POSITIONS[HorDirection.MEDIUM] - COL1_POSITIONS[HorDirection.LEFT];
        break;
      case COL1_POSITIONS[HorDirection.MEDIUM]:
        this.orderReset(inst);
        inst.col2Offset = COL1_POSITIONS[HorDirection.MEDIUM] - COL1_POSITIONS[HorDirection.MEDIUM];
        break;
      default: // RIGHT
        this.orderRevert(inst);
        inst.col2Offset = COL1_POSITIONS[HorDirection.MEDIUM] + 1;
        inst.col1Offset = 0;
        break;
    }
  }

  private moveSecToRight(inst: GridRowSample10) {
    this.col1OffsetReset(inst);
    switch (inst.col1Offset) {
      case COL1_POSITIONS[HorDirection.LEFT]:
        this.orderReset(inst);
        inst.col2Offset = COL1_POSITIONS[HorDirection.RIGHT] - COL1_POSITIONS[HorDirection.LEFT];
        break;
      case COL1_POSITIONS[HorDirection.MEDIUM]:
        this.orderReset(inst);
        inst.col2Offset = COL1_POSITIONS[HorDirection.RIGHT] - COL1_POSITIONS[HorDirection.MEDIUM];
        break;
      default: // RIGHT
        this.orderReset(inst);
        inst.col2Offset = COL1_POSITIONS[HorDirection.RIGHT] - COL1_POSITIONS[HorDirection.RIGHT];
        break;
    }
  }
}