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
import Napi from 'libentry.so';
import { NodeContent } from '@kit.ArkUI';

function getNodeType(type: string): number {
  let ret = -1;
  switch(type) {
    case 'TOGGLE':
      ret = 5;
      break;
    case 'BUTTON':
      ret = 9;
      break;
    case 'CHECKBOX':
      ret = 11;
      break;
    case 'SLIDER':
      ret = 17;
      break;
    case 'RADIO':
      ret = 18;
      break;
    case 'CHECKBOX_GROUP':
      ret = 21;
      break;
    default:
      break;
  }
  return ret;
}

const SUCC_TAG = 'success';
const FAIL_TAG = 'failed';

@Extend(Text)
function style(textAlign: TextAlign) {
  .textAlign(textAlign)
  .fontSize(12)
  .border({ width: 1 })
  .padding(10)
  .width('100%')
}

@Entry
@Component
struct Index {
  @State status: number = Visibility.Visible;
  @State nodeId: number = -1;
  @State nodeStatus: string = '';
  @State curNodeType: string = '';
  @State attributeType: string = '';
  @State attributeTypeId: number = -1;
  @State attributeValue: string = '-1';
  @State resultValue: string = '-1';
  @State curAttrStatus: number = 0;
  @State result: string = '...';
  private nodeContent = new NodeContent();

  nativeCallback = (data: string) => {
    this.result = data;
  }

  aboutToAppear() {
    // 通过C-API创建节点，并添加到管理器nodeContent上
    Napi.createFormPage(this.nodeContent);
  }

  @Builder
  SubMenuNodeType() {
    Menu() {
      MenuItem({ content: 'TOGGLE' }).width('50%').onChange(() => { this.curNodeType = 'TOGGLE'; })
      MenuItem({ content: 'BUTTON' }).width('50%').onChange(() => { this.curNodeType = 'BUTTON'; })
      MenuItem({ content: 'CHECKBOX' }).width('50%').onChange(() => { this.curNodeType = 'CHECKBOX'; })
      MenuItem({ content: 'SLIDER' }).width('50%').onChange(() => { this.curNodeType = 'SLIDER'; })
      MenuItem({ content: 'RADIO' }).width('50%').onChange(() => { this.curNodeType = 'RADIO'; })
      MenuItem({ content: 'CHECKBOX_GROUP' }).width('50%').onChange(() => { this.curNodeType = 'CHECKBOX_GROUP'; })
    }
  }

  @Builder
  SubMenuAttributeType() {
    Menu() {
      MenuItem({ content: 'TOGGLE', builder: (): void => this.SubMenu_TOGGLE() }).width('50%')
        .onChange(()=> { this.status = Visibility.None })
      MenuItem({ content: 'BUTTON', builder: (): void => this.SubMenu_BUTTON() }).width('50%')
        .onChange(()=> { this.status = Visibility.None })
      MenuItem({ content: 'CHECKBOX', builder: (): void => this.SubMenu_CHECKBOX() }).width('50%')
        .onChange(()=> { this.status = Visibility.None })
      MenuItem({ content: 'SLIDER', builder: (): void => this.SubMenu_SLIDER() }).width('50%')
        .onChange(()=> { this.status = Visibility.None })
      MenuItem({ content: 'RADIO', builder: (): void => this.SubMenu_RADIO() }).width('50%')
        .onChange(()=> { this.status = Visibility.None })
      MenuItem({ content: 'CHECKBOX_GROUP', builder: (): void => this.SubMenu_CHECKBOX_GROUP() }).width('50%')
        .onChange(()=> { this.status = Visibility.None })
    }.visibility(this.status)
  }

  @Builder
  SubMenu_TOGGLE() {
    Menu() {
      MenuItem({ content: 'SELECTED_COLOR' }).width('50%').onChange(() => {
        this.attributeType = 'SELECTED_COLOR';
        this.attributeTypeId = 5000;
      })
      MenuItem({ content: 'SWITCH_POINT_COLOR' }).width('50%').onChange(() => {
        this.attributeType = 'SWITCH_POINT_COLOR';
        this.attributeTypeId = 5001;
      })
      MenuItem({ content: 'VALUE' }).width('50%').onChange(() => {
        this.attributeType = 'VALUE';
        this.attributeTypeId = 5002;
      })
      MenuItem({ content: 'UNSELECTED_COLOR' }).width('50%').onChange(() => {
        this.attributeType = 'UNSELECTED_COLOR';
        this.attributeTypeId = 5003;
      })
    }
  }

  @Builder
  SubMenu_BUTTON() {
    Menu() {
      MenuItem({ content: 'LABEL' }).width('50%').onChange(() => {
        this.attributeType = 'LABEL';
        this.attributeTypeId = 9000;
      })
      MenuItem({ content: 'TYPE' }).width('50%').onChange(() => {
        this.attributeType = 'TYPE';
        this.attributeTypeId = 9001;
      })
      MenuItem({ content: 'MIN_FONT_SCALE' }).width('50%').onChange(() => {
        this.attributeType = 'MIN_FONT_SCALE';
        this.attributeTypeId = 9002;
      })
      MenuItem({ content: 'MAX_FONT_SCALE' }).width('50%').onChange(() => {
        this.attributeType = 'MAX_FONT_SCALE';
        this.attributeTypeId = 9003;
      })
    }
  }

  @Builder
  SubMenu_CHECKBOX() {
    Menu() {
      MenuItem({ content: 'SELECT' }).width('50%').onChange(() => {
        this.attributeType = 'SELECT';
        this.attributeTypeId = 11000;
      })
      MenuItem({ content: 'SELECT_COLOR' }).width('50%').onChange(() => {
        this.attributeType = 'SELECT_COLOR';
        this.attributeTypeId = 11001;
      })
      MenuItem({ content: 'UNSELECT_COLOR' }).width('50%').onChange(() => {
        this.attributeType = 'UNSELECT_COLOR';
        this.attributeTypeId = 11002;
      })
      MenuItem({ content: 'MARK' }).width('50%').onChange(() => {
        this.attributeType = 'MARK';
        this.attributeTypeId = 11003;
      })
      MenuItem({ content: 'SHAPE' }).width('50%').onChange(() => {
        this.attributeType = 'SHAPE';
        this.attributeTypeId = 11004;
      })
      MenuItem({ content: 'NAME' }).width('50%').onChange(() => {
        this.attributeType = 'NAME';
        this.attributeTypeId = 11005;
      })
      MenuItem({ content: 'GROUP' }).width('50%').onChange(() => {
        this.attributeType = 'GROUP';
        this.attributeTypeId = 11006;
      })
    }
  }

  @Builder
  SubMenu_SLIDER() {
    Menu() {
      MenuItem({ content: 'BLOCK_COLOR' }).width('50%').onChange(() => {
        this.attributeType = 'BLOCK_COLOR';
        this.attributeTypeId = 17000;
      })
      MenuItem({ content: 'TRACK_COLOR' }).width('50%').onChange(() => {
        this.attributeType = 'TRACK_COLOR';
        this.attributeTypeId = 17001;
      })
      MenuItem({ content: 'SELECTED_COLOR' }).width('50%').onChange(() => {
        this.attributeType = 'SELECTED_COLOR';
        this.attributeTypeId = 17002;
      })
      MenuItem({ content: 'SHOW_STEPS' }).width('50%').onChange(() => {
        this.attributeType = 'SHOW_STEPS';
        this.attributeTypeId = 17003;
      })
      MenuItem({ content: 'BLOCK_STYLE' }).width('50%').onChange(() => {
        this.attributeType = 'BLOCK_STYLE';
        this.attributeTypeId = 17004;
      })
      MenuItem({ content: 'VALUE' }).width('50%').onChange(() => {
        this.attributeType = 'VALUE';
        this.attributeTypeId = 17005;
      })
      MenuItem({ content: 'MIN_VALUE' }).width('50%').onChange(() => {
        this.attributeType = 'MIN_VALUE';
        this.attributeTypeId = 17006;
      })
      MenuItem({ content: 'MAX_VALUE' }).width('50%').onChange(() => {
        this.attributeType = 'MAX_VALUE';
        this.attributeTypeId = 17007;
      })
      MenuItem({ content: 'STEP' }).width('50%').onChange(() => {
        this.attributeType = 'STEP';
        this.attributeTypeId = 17008;
      })
      MenuItem({ content: 'DIRECTION' }).width('50%').onChange(() => {
        this.attributeType = 'DIRECTION';
        this.attributeTypeId = 17009;
      })
      MenuItem({ content: 'REVERSE' }).width('50%').onChange(() => {
        this.attributeType = 'REVERSE';
        this.attributeTypeId = 17010;
      })
      MenuItem({ content: 'STYLE' }).width('50%').onChange(() => {
        this.attributeType = 'STYLE';
        this.attributeTypeId = 17011;
      })
      MenuItem({ content: 'TRACK_THICKNESS' }).width('50%').onChange(() => {
        this.attributeType = 'TRACK_THICKNESS';
        this.attributeTypeId = 17012;
      })
      MenuItem({ content: 'ENABLE_HAPTIC_FEEDBACK' }).width('50%').onChange(() => {
        this.attributeType = 'ENABLE_HAPTIC_FEEDBACK';
        this.attributeTypeId = 17013;
      })
      MenuItem({ content: 'PREFIX' }).width('50%').onChange(() => {
        this.attributeType = 'PREFIX';
        this.attributeTypeId = 17014;
      })
      MenuItem({ content: 'SUFFIX' }).width('50%').onChange(() => {
        this.attributeType = 'SUFFIX';
        this.attributeTypeId = 17015;
      })
    }
  }

  @Builder
  SubMenu_RADIO() {
    Menu() {
      MenuItem({ content: 'CHECKED' }).width('50%').onChange(() => {
        this.attributeType = 'CHECKED';
        this.attributeTypeId = 18000;
      })
      MenuItem({ content: 'STYLE' }).width('50%').onChange(() => {
        this.attributeType = 'STYLE';
        this.attributeTypeId = 18001;
      })
      MenuItem({ content: 'VALUE' }).width('50%').onChange(() => {
        this.attributeType = 'VALUE';
        this.attributeTypeId = 18002;
      })
      MenuItem({ content: 'GROUP' }).width('50%').onChange(() => {
        this.attributeType = 'GROUP';
        this.attributeTypeId = 18003;
      })
    }
  }

  @Builder
  SubMenu_CHECKBOX_GROUP() {
    Menu() {
      MenuItem({ content: 'NAME' }).width('50%').onChange(() => {
        this.attributeType = 'NAME';
        this.attributeTypeId = 21000;
      })
      MenuItem({ content: 'SELECT_ALL' }).width('50%').onChange(() => {
        this.attributeType = 'SELECT_ALL';
        this.attributeTypeId = 21001;
      })
      MenuItem({ content: 'SELECTED_COLOR' }).width('50%').onChange(() => {
        this.attributeType = 'SELECTED_COLOR';
        this.attributeTypeId = 21002;
      })
      MenuItem({ content: 'UNSELECTED_COLOR' }).width('50%').onChange(() => {
        this.attributeType = 'UNSELECTED_COLOR';
        this.attributeTypeId = 21003;
      })
      MenuItem({ content: 'MARK' }).width('50%').onChange(() => {
        this.attributeType = 'MARK';
        this.attributeTypeId = 21004;
      })
      MenuItem({ content: 'SHAPE' }).width('50%').onChange(() => {
        this.attributeType = 'SHAPE';
        this.attributeTypeId = 21005;
      })
    }
  }

  build() {
    Column() {
        Row() {
            Button($r('app.string.return_node'))
              .height(25)
              .width('10%')
              .onClick(() => {
                this.getUIContext().getRouter().back();
              })
            Text($r('app.string.native_node_example'))
              .fontSize(24)
              .margin(10)
              .fontWeight(FontWeight.Bold)
              .height('10%')
        }
        Row() {
          Button($r('app.string.select_node_type'))
            .width('30%')
            .margin(10)
            .bindMenu(this.SubMenuNodeType)
          Button($r('app.string.create'))
            .width('25%')
            .margin(10)
            .onClick(() => {
              Napi.removeFormNode(this.nodeId);
              this.nodeId = -1;

              this.nodeId = Napi.createFormNode(getNodeType(this.curNodeType), this.nativeCallback);
              this.nodeStatus = (this.nodeId == -1) ? FAIL_TAG : SUCC_TAG;
            })
          Button($r('app.string.remove'))
            .width('25%')
            .margin(10)
            .onClick(() => {
              Napi.removeFormNode(this.nodeId);
              this.nodeId = -1;
              this.nodeStatus = FAIL_TAG;
            })
        }

        Row() {
          Text($r('app.string.current_type', `${this.curNodeType}`))
            .style(TextAlign.Start)
            .fontSize(10)
            .margin(5)
            .width('48%')
          Text($r('app.string.current_status', `${this.nodeStatus}`))
            .style(TextAlign.Start)
            .fontSize(11)
            .margin(5)
            .width('48%')
        }

        Row() {
          Button($r('app.string.select_node_attribute'))
            .bindMenu(this.SubMenuAttributeType)
            .fontSize(10)
            .onClick(() => {
              this.status = Visibility.Visible
            })
          Button($r('app.string.set_attribute_value'))
            .alignSelf(ItemAlign.End)
            .fontSize(10)
            .onClick(
              () => {
                this.curAttrStatus = -1;
                this.curAttrStatus = Napi.setFormAttribute(this.nodeId, getNodeType(this.curNodeType),
                  this.attributeTypeId, this.attributeValue);
              }
            )
          Button($r('app.string.get_attribute_value'))
            .alignSelf(ItemAlign.End)
            .fontSize(10)
            .onClick(
              () => {
                this.resultValue = Napi.getFormAttribute(this.nodeId, getNodeType(this.curNodeType),
                  this.attributeTypeId);
              }
            )
          Button($r('app.string.reset_attribute_value'))
            .fontSize(11)
            .alignSelf(ItemAlign.End)
            .onClick(() => {
              this.curAttrStatus = -1;
              this.curAttrStatus = Napi.resetFormAttribute(this.nodeId, getNodeType(this.curNodeType),
                this.attributeTypeId);
            })
        }
        Row() {
          Text($r('app.string.current_attribute_type', `${this.attributeType}`))
            .style(TextAlign.Start)
            .fontSize(11)
            .margin(5)
            .width('95%')
        }
      Row() {
        Text($r('app.string.response', `${this.resultValue}`))
          .style(TextAlign.Start)
          .fontSize(11)
          .margin(5)
          .width('95%')
      }
      Row() {
        Text(`event: ${this.result}`)
          .style(TextAlign.Start)
          .width('95%')
          .fontSize(15)
          .margin(5)
      }

      Row() {
        Text($r('app.string.attribute_value'))
          .alignSelf(ItemAlign.Center)
          .fontSize(15)
          .height(20)
        TextInput({ placeholder: $r('app.string.please_input_attribute_value'), text: this.attributeValue })
          .width('85%')
          .height(35)
          .borderRadius(0)
          .onChange((value: string) => {
            this.attributeValue = value;
          })

      }
      .margin(10)

      Column() {
        ContentSlot(this.nodeContent)
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .width('95%')
      .height('42%')
      .margin({ left: 0 })
      .border({ width: 1 })
      .position({x:'3%',y:'58%'})
    }
  }
}
