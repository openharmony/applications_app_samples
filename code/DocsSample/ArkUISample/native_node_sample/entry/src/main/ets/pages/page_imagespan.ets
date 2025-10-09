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
import napiAgent from 'libentry.so';
import { NodeContent } from '@kit.ArkUI';

function getNodeType(type: string) : number {
  let ret = -1;
  switch (type) {
    case 'IMAGE_SPAN':
      ret = 3;
      break;
    case 'IMAGE':
      ret = 4;
      break;
    case 'LOADING_PROGRESS':
      ret = 6;
      break;
    case 'PROGRESS':
      ret = 10;
      break;
    case 'DATE_PICKER':
      ret = 13;
      break;
    case 'TIME_PICKER':
      ret = 14;
      break;
    case 'TEXT_PICKER':
      ret = 15;
      break;
    case 'CALENDAR_PICKER':
      ret = 16;
      break;
    case 'IMAGE_ANIMATOR':
      ret = 19;
      break;
    default:
      break;
  }
  return ret;
}

const SUCC_TAG = '创建成功';
const FAIL_TAG = '创建失败';

@Entry
@Component
struct Index {
  @State nodeId: number = -1;
  @State nodeStatus: string = FAIL_TAG;
  @State curNodeType: string = '未设置';
  @State attributeType: string = '未设置';
  @State attributeTypeId: number = -1;
  @State attributeValue: string = '-1';
  @State resultValue: string = '-1';
  @State curAttrStatus: number = -1;
  private nodeContent = new NodeContent();

  aboutToAppear() {
    // 通过C-API创建节点，并添加到管理器nodeContent上
    napiAgent.createImageSpanPage(this.nodeContent);
  }

  @Builder
  SubMenuNodeType() {
    Menu() {
      MenuItem({ content: 'IMAGE_SPAN' }).width('50%').onChange(()=> { this.curNodeType = 'IMAGE_SPAN'})
      MenuItem({ content: 'IMAGE'}).width('50%').onChange(()=> { this.curNodeType = 'IMAGE' })
      MenuItem({ content: 'LOADING_PROGRESS'}).width('50%').onChange(()=> { this.curNodeType = 'LOADING_PROGRESS' })
      MenuItem({ content: 'PROGRESS'}).width('50%').onChange(()=> { this.curNodeType = 'PROGRESS' })
      MenuItem({ content: 'DATE_PICKER'}).width('50%').onChange(()=> { this.curNodeType = 'DATE_PICKER' })
      MenuItem({ content: 'TIME_PICKER' }).width('50%').onChange(()=> { this.curNodeType = 'TIME_PICKER'})
      MenuItem({ content: 'TEXT_PICKER'}).width('50%').onChange(()=> { this.curNodeType = 'TEXT_PICKER' })
      MenuItem({ content: 'CALENDAR_PICKER'}).width('50%').onChange(()=> { this.curNodeType = 'CALENDAR_PICKER' })
      MenuItem({ content: 'IMAGE_ANIMATOR'}).width('50%').onChange(()=> { this.curNodeType = 'IMAGE_ANIMATOR' })
    }
  }

  @Builder
  SubMenuAttributeType() {
    Menu() {
      MenuItem({ content: 'IMAGE_SPAN', builder: ():void=>this.SubMenu_IMAGE_SPAN() }).width('50%')
      MenuItem({ content: 'IMAGE', builder: ():void=>this.SubMenu_IMAGE() }).width('50%')
      MenuItem({ content: 'LOADING_PROGRESS', builder: ():void=>this.SubMenu_LOADING_PROGRESS() }).width('50%')
      MenuItem({ content: 'PROGRESS', builder: ():void=>this.SubMenu_PROGRESS() }).width('50%')
      MenuItem({ content: 'DATE_PICKER', builder: ():void=>this.SubMenu_DATE_PICKER() }).width('50%')
      MenuItem({ content: 'TIME_PICKER', builder: ():void=>this.SubMenu_TIME_PICKER() }).width('50%')
      MenuItem({ content: 'TEXT_PICKER', builder: ():void=>this.SubMenu_TEXT_PICKER() }).width('50%')
      MenuItem({ content: 'CALENDAR_PICKER', builder: ():void=>this.SubMenu_CALENDAR_PICKER() }).width('50%')
      MenuItem({ content: 'IMAGE_ANIMATOR', builder: ():void=>this.SubMenu_IMAGE_ANIMATOR() }).width('50%')
    }
  }

  @Builder
  SubMenu_IMAGE_SPAN() {
    Menu() {
      MenuItem({ content: 'SRC' }).width('50%').onChange(()=> {
        this.attributeType = 'SRC'
        this.attributeTypeId = 3000
      })
      MenuItem({ content: 'VERTICAL_ALIGNMENT' }).width('50%').onChange(()=> {
        this.attributeType = 'VERTICAL_ALIGNMENT'
        this.attributeTypeId = 3001
      })
      MenuItem({ content: 'ALT' }).width('50%').onChange(()=> {
        this.attributeType = 'ALT'
        this.attributeTypeId = 3002
      })
      MenuItem({ content: 'BASELINE_OFFSET' }).width('50%').onChange(()=> {
        this.attributeType = 'BASELINE_OFFSET'
        this.attributeTypeId = 3003
      })
    }
  }
  // add image attributeType
  @Builder
  SubMenu_IMAGE() {
    Menu() {
      MenuItem({ content: 'BACKGROUND_IMAGE' }).width('50%').onChange(()=> {
        this.attributeType = 'BACKGROUND_IMAGE'
        this.attributeTypeId = 3
      })
      MenuItem({ content: 'BACKGROUND_IMAGE_SIZE' }).width('50%').onChange(()=> {
        this.attributeType = 'BACKGROUND_IMAGE_SIZE'
        this.attributeTypeId = 30
      })
      MenuItem({ content: 'BACKGROUND_IMAGE_SIZE_WITH_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'BACKGROUND_IMAGE_SIZE_WITH_STYLE'
        this.attributeTypeId = 31
      })
      MenuItem({ content: 'BACKGROUND_IMAGE_POSITION' }).width('50%').onChange(()=> {
        this.attributeType = 'BACKGROUND_IMAGE_POSITION'
        this.attributeTypeId = 56
      })
      MenuItem({ content: 'BACKGROUND_IMAGE_RESIZABLE_WITH_SLICE' }).width('50%').onChange(()=> {
        this.attributeType = 'BACKGROUND_IMAGE_RESIZABLE_WITH_SLICE'
        this.attributeTypeId = 100
      })
      MenuItem({ content: 'SRC' }).width('50%').onChange(()=> {
        this.attributeType = 'SRC'
        this.attributeTypeId = 4000
      })
      MenuItem({ content: 'OBJECT_FIT' }).width('50%').onChange(()=> {
        this.attributeType = 'OBJECT_FIT'
        this.attributeTypeId = 4001
      })
      MenuItem({ content: 'INTERPOLATION' }).width('50%').onChange(()=> {
        this.attributeType = 'INTERPOLATION'
        this.attributeTypeId = 4002
      })
      MenuItem({ content: 'OBJECT_REPEAT' }).width('50%').onChange(()=> {
        this.attributeType = 'OBJECT_REPEAT'
        this.attributeTypeId = 4003
      })
      MenuItem({ content: 'COLOR_FILTER' }).width('50%').onChange(()=> {
        this.attributeType = 'COLOR_FILTER'
        this.attributeTypeId = 4004
      })
      MenuItem({ content: 'AUTO_RESIZE' }).width('50%').onChange(()=> {
        this.attributeType = 'AUTO_RESIZE'
        this.attributeTypeId = 4005
      })
      MenuItem({ content: 'ALT' }).width('50%').onChange(()=> {
        this.attributeType = 'ALT'
        this.attributeTypeId = 4006
      })
      MenuItem({ content: 'DRAGGABLE' }).width('50%').onChange(()=> {
        this.attributeType = 'DRAGGABLE'
        this.attributeTypeId = 4007
      })
      MenuItem({ content: 'RENDER_MODE' }).width('50%').onChange(()=> {
        this.attributeType = 'RENDER_MODE'
        this.attributeTypeId = 4008
      })
      MenuItem({ content: 'FIT_ORIGINAL_SIZE' }).width('50%').onChange(()=> {
        this.attributeType = 'FIT_ORIGINAL_SIZE'
        this.attributeTypeId = 4009
      })
      MenuItem({ content: 'FILL_COLOR' }).width('50%').onChange(()=> {
        this.attributeType = 'FILL_COLOR'
        this.attributeTypeId = 4010
      })
      MenuItem({ content: 'RESIZABLE' }).width('50%').onChange(()=> {
        this.attributeType = 'RESIZABLE'
        this.attributeTypeId = 4011
      })
      MenuItem({ content: 'SYNC_LOAD' }).width('50%').onChange(()=> {
        this.attributeType = 'SYNC_LOAD'
        this.attributeTypeId = 4012
      })
      MenuItem({ content: 'SOURCE_SIZE' }).width('50%').onChange(()=> {
        this.attributeType = 'SOURCE_SIZE'
        this.attributeTypeId = 4013
      })
      MenuItem({ content: 'IMAGE_MATRIX' }).width('50%').onChange(()=> {
        this.attributeType = 'IMAGE_MATRIX'
        this.attributeTypeId = 4014
      })
      MenuItem({ content: 'MATCH_TEXT_DIRECTION' }).width('50%').onChange(()=> {
        this.attributeType = 'MATCH_TEXT_DIRECTION'
        this.attributeTypeId = 4015
      })
      MenuItem({ content: 'COPY_OPTION' }).width('50%').onChange(()=> {
        this.attributeType = 'COPY_OPTION'
        this.attributeTypeId = 4016
      })
      MenuItem({ content: 'ENABLE_ANALYZER' }).width('50%').onChange(()=> {
        this.attributeType = 'ENABLE_ANALYZER'
        this.attributeTypeId = 4017
      })
      MenuItem({ content: 'DYNAMIC_RANGE_MODE' }).width('50%').onChange(()=> {
        this.attributeType = 'DYNAMIC_RANGE_MODE'
        this.attributeTypeId = 4018
      })
      MenuItem({ content: 'HDR_BRIGHTNESS' }).width('50%').onChange(()=> {
        this.attributeType = 'HDR_BRIGHTNESS'
        this.attributeTypeId = 4019
      })
      MenuItem({ content: 'ORIENTATION' }).width('50%').onChange(()=> {
        this.attributeType = 'ORIENTATION'
        this.attributeTypeId = 4020
      })
    }
  }

  @Builder
  SubMenu_LOADING_PROGRESS() {
    Menu() {
      MenuItem({ content: 'COLOR' }).width('50%').onChange(()=> {
        this.attributeType = 'COLOR'
        this.attributeTypeId = 6000
      })
      MenuItem({ content: 'ENABLE_LOADING' }).width('50%').onChange(()=> {
        this.attributeType = 'ENABLE_LOADING'
        this.attributeTypeId = 6001
      })
    }
  }

  @Builder
  SubMenu_PROGRESS() {
    Menu() {
      MenuItem({ content: 'VALUE' }).width('50%').onChange(()=> {
        this.attributeType = 'VALUE'
        this.attributeTypeId = 10000
      })
      MenuItem({ content: 'TOTAL' }).width('50%').onChange(()=> {
        this.attributeType = 'TOTAL'
        this.attributeTypeId = 10001
      })
      MenuItem({ content: 'COLOR' }).width('50%').onChange(()=> {
        this.attributeType = 'COLOR'
        this.attributeTypeId = 10002
      })
      MenuItem({ content: 'TYPE' }).width('50%').onChange(()=> {
        this.attributeType = 'TYPE'
        this.attributeTypeId = 10003
      })
      MenuItem({ content: 'LINEAR_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'LINEAR_STYLE'
        this.attributeTypeId = 10004
      })
    }
  }

  @Builder
  SubMenu_DATE_PICKER() {
    Menu() {
      MenuItem({ content: 'LUNAR' }).width('50%').onChange(()=> {
        this.attributeType = 'LUNAR'
        this.attributeTypeId = 13000
      })
      MenuItem({ content: 'START' }).width('50%').onChange(()=> {
        this.attributeType = 'START'
        this.attributeTypeId = 13001
      })
      MenuItem({ content: 'END' }).width('50%').onChange(()=> {
        this.attributeType = 'END'
        this.attributeTypeId = 13002
      })
      MenuItem({ content: 'SELECTED' }).width('50%').onChange(()=> {
        this.attributeType = 'SELECTED'
        this.attributeTypeId = 13003
      })
      MenuItem({ content: 'DISAPPEAR_TEXT_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'DISAPPEAR_TEXT_STYLE'
        this.attributeTypeId = 13004
      })
      MenuItem({ content: 'TEXT_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'TEXT_STYLE'
        this.attributeTypeId = 13005
      })
      MenuItem({ content: 'SELECTED_TEXT_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'SELECTED_TEXT_STYLE'
        this.attributeTypeId = 13006
      })
      MenuItem({ content: 'MODE' }).width('50%').onChange(()=> {
        this.attributeType = 'MODE'
        this.attributeTypeId = 13007
      })
      MenuItem({ content: 'ENABLE_HAPTIC_FEEDBACK' }).width('50%').onChange(()=> {
        this.attributeType = 'ENABLE_HAPTIC_FEEDBACK'
        this.attributeTypeId = 13008
      })
      MenuItem({ content: 'CAN_LOOP' }).width('50%').onChange(()=> {
        this.attributeType = 'CAN_LOOP'
        this.attributeTypeId = 13009
      })
    }
  }

  @Builder
  SubMenu_TIME_PICKER() {
    Menu() {
      MenuItem({ content: 'SELECTED' }).width('50%').onChange(()=> {
        this.attributeType = 'SELECTED'
        this.attributeTypeId = 14000
      })
      MenuItem({ content: 'USE_MILITARY_TIME' }).width('50%').onChange(()=> {
        this.attributeType = 'USE_MILITARY_TIME'
        this.attributeTypeId = 14001
      })
      MenuItem({ content: 'DISAPPEAR_TEXT_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'DISAPPEAR_TEXT_STYLE'
        this.attributeTypeId = 14002
      })
      MenuItem({ content: 'TEXT_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'TEXT_STYLE'
        this.attributeTypeId = 14003
      })
      MenuItem({ content: 'SELECTED_TEXT_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'SELECTED_TEXT_STYLE'
        this.attributeTypeId = 14004
      })
      MenuItem({ content: 'START' }).width('50%').onChange(()=> {
        this.attributeType = 'START'
        this.attributeTypeId = 14005
      })
      MenuItem({ content: 'END' }).width('50%').onChange(()=> {
        this.attributeType = 'END'
        this.attributeTypeId = 14006
      })
      MenuItem({ content: 'ENABLE_CASCADE' }).width('50%').onChange(()=> {
        this.attributeType = 'ENABLE_CASCADE'
        this.attributeTypeId = 14007
      })
    }
  }

  @Builder
  SubMenu_TEXT_PICKER() {
    Menu() {
      MenuItem({ content: 'OPTION_RANGE' }).width('50%').onChange(()=> {
        this.attributeType = 'OPTION_RANGE'
        this.attributeTypeId = 15000
      })
      MenuItem({ content: 'OPTION_SELECTED' }).width('50%').onChange(()=> {
        this.attributeType = 'OPTION_SELECTED'
        this.attributeTypeId = 15001
      })
      MenuItem({ content: 'OPTION_VALUE' }).width('50%').onChange(()=> {
        this.attributeType = 'OPTION_VALUE'
        this.attributeTypeId = 15002
      })
      MenuItem({ content: 'DISAPPEAR_TEXT_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'DISAPPEAR_TEXT_STYLE'
        this.attributeTypeId = 15003
      })
      MenuItem({ content: 'TEXT_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'TEXT_STYLE'
        this.attributeTypeId = 15004
      })
      MenuItem({ content: 'SELECTED_TEXT_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'SELECTED_TEXT_STYLE'
        this.attributeTypeId = 15005
      })
      MenuItem({ content: 'SELECTED_INDEX' }).width('50%').onChange(()=> {
        this.attributeType = 'SELECTED_INDEX'
        this.attributeTypeId = 15006
      })
      MenuItem({ content: 'CAN_LOOP' }).width('50%').onChange(()=> {
        this.attributeType = 'CAN_LOOP'
        this.attributeTypeId = 15007
      })
      MenuItem({ content: 'DEFAULT_PICKER_ITEM_HEIGHT' }).width('50%').onChange(()=> {
        this.attributeType = 'DEFAULT_PICKER_ITEM_HEIGHT'
        this.attributeTypeId = 15008
      })
      MenuItem({ content: 'COLUMN_WIDTHS' }).width('50%').onChange(()=> {
        this.attributeType = 'COLUMN_WIDTHS'
        this.attributeTypeId = 15009
      })
      MenuItem({ content: 'ENABLE_HAPTIC_FEEDBACK' }).width('50%').onChange(()=> {
        this.attributeType = 'ENABLE_HAPTIC_FEEDBACK'
        this.attributeTypeId = 15010
      })
      MenuItem({ content: 'SELECTED_BACKGROUND_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'SELECTED_BACKGROUND_STYLE'
        this.attributeTypeId = 15011
      })
    }
  }

  @Builder
  SubMenu_CALENDAR_PICKER() {
    Menu() {
      MenuItem({ content: 'HINT_RADIUS' }).width('50%').onChange(()=> {
        this.attributeType = 'HINT_RADIUS'
        this.attributeTypeId = 16000
      })
      MenuItem({ content: 'SELECTED_DATE' }).width('50%').onChange(()=> {
        this.attributeType = 'SELECTED_DATE'
        this.attributeTypeId = 16001
      })
      MenuItem({ content: 'EDGE_ALIGNMENT' }).width('50%').onChange(()=> {
        this.attributeType = 'EDGE_ALIGNMENT'
        this.attributeTypeId = 16002
      })
      MenuItem({ content: 'TEXT_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'TEXT_STYLE'
        this.attributeTypeId = 16003
      })
      MenuItem({ content: 'START' }).width('50%').onChange(()=> {
        this.attributeType = 'START'
        this.attributeTypeId = 16004
      })
      MenuItem({ content: 'END' }).width('50%').onChange(()=> {
        this.attributeType = 'END'
        this.attributeTypeId = 16005
      })
      MenuItem({ content: 'DISABLED_DATE_RANGE' }).width('50%').onChange(()=> {
        this.attributeType = 'DISABLED_DATE_RANGE'
        this.attributeTypeId = 16006
      })
      MenuItem({ content: 'MARK_TODAY' }).width('50%').onChange(()=> {
        this.attributeType = 'MARK_TODAY'
        this.attributeTypeId = 16007
      })
    }
  }

  @Builder
  SubMenu_IMAGE_ANIMATOR() {
    Menu() {
      MenuItem({ content: 'IMAGES' }).width('50%').onChange(()=> {
        this.attributeType = 'IMAGES'
        this.attributeTypeId = 19000
      })
      MenuItem({ content: 'STATE' }).width('50%').onChange(()=> {
        this.attributeType = 'STATE'
        this.attributeTypeId = 19001
      })
      MenuItem({ content: 'DURATION' }).width('50%').onChange(()=> {
        this.attributeType = 'DURATION'
        this.attributeTypeId = 19002
      })
      MenuItem({ content: 'REVERSE' }).width('50%').onChange(()=> {
        this.attributeType = 'REVERSE'
        this.attributeTypeId = 19003
      })
      MenuItem({ content: 'FIXED_SIZE' }).width('50%').onChange(()=> {
        this.attributeType = 'FIXED_SIZE'
        this.attributeTypeId = 19004
      })
      MenuItem({ content: 'FILL_MODE' }).width('50%').onChange(()=> {
        this.attributeType = 'FILL_MODE'
        this.attributeTypeId = 19005
      })
      MenuItem({ content: 'ITERATION' }).width('50%').onChange(()=> {
        this.attributeType = 'ITERATION'
        this.attributeTypeId = 19006
      })
    }
  }


  build() {
    Column() {
      Text('native_node功能示例')
        .fontSize(24)
        .margin(10)
        .fontWeight(FontWeight.Bold)
        .height('10%')
      Row() {
        Column() {
          Button('选择节点类型:')
            .width('50%')
            .margin({ left: 10 })
            .bindMenu(this.SubMenuNodeType)
          Text(`current type: ${this.curNodeType}`)
            .fontSize(14)
            .margin(10)
          Text(`current status: ${this.nodeStatus}`)
            .fontSize(14)
            .margin(10)

          Row() {
            Button('创建')
              .width('30%')
              .margin(10)
              .onClick(() => {
                // 先将之前创建的节点清理
                napiAgent.removeImageSpanNode(this.nodeId);
                this.nodeId = -1;
                // 创建新节点
                this.nodeId = napiAgent.createImageSpanNode(getNodeType(this.curNodeType))
                this.nodeStatus = (this.nodeId == -1) ? FAIL_TAG : SUCC_TAG;
              })
            Button('清理')
              .width('30%')
              .margin(10)
              .onClick(() => {
                napiAgent.removeImageSpanNode(this.nodeId);
                this.nodeId = -1;
                this.nodeStatus = FAIL_TAG;
              })
          }

        }
        .width('50%')

        Column() {
          Button('选择节点属性:')
            .width('50%')
            .margin({ left: 10 })
            .bindMenu(this.SubMenuAttributeType)
          Text(`当前属性类型: ${this.attributeType}`)
            .fontSize(14)
            .margin(10)
          Text(`返回属性值: ${this.resultValue}`)
            .fontSize(14)
            .margin(5)
          Row() {
            Text('属性值:')
              .alignSelf(ItemAlign.End)
              .fontSize(14)
            TextInput({ placeholder: '请输入属性值', text: this.attributeValue })
              .width('60%')
              .height(40)
              .onChange((value: string) => {
                this.attributeValue = value;
              })
          }
          .width('100%')
          .margin(20)
          .justifyContent(FlexAlign.End)

          Button('设置属性值')
            .width('50%')
            .margin(5)
            .alignSelf(ItemAlign.End)
            .onClick(
              () => {
                this.curAttrStatus = -1;
                this.curAttrStatus = napiAgent.setImageSpanAttribute(this.nodeId, getNodeType(this.curNodeType),
                  this.attributeTypeId, this.attributeValue);
                console.log('-----setNativeNodeAttribute,attributeTypeId:' + this.attributeTypeId +
                  ' ,curAttrStatus:' + this.curAttrStatus);
              }
            )
          Button('获取属性值')
            .width('50%')
            .margin(5)
            .alignSelf(ItemAlign.End)
            .onClick(
              () => {
                this.resultValue = napiAgent.getImageSpanAttribute(this.nodeId, getNodeType(this.curNodeType),
                  this.attributeTypeId);
                console.log('-----getNativeNodeAttribute,attributeTypeId:' + this.attributeTypeId +
                  ' ,attributeValue:' + this.resultValue);
              }
            )
          Button('重置属性值')
            .width('50%')
            .margin(5)
            .alignSelf(ItemAlign.End)
            .onClick(() => {
              // 重置新节点
              this.curAttrStatus = napiAgent.resetImageSpanAttribute(this.nodeId, getNodeType(this.curNodeType),
                this.attributeTypeId)
            })
        }
        .width('50%')
      }
      .height('30%')

      // 组件显示在界面下半部分
      Column() {
        ContentSlot(this.nodeContent)
      }
      .margin(10)
      .width('60%')
      .height('60%')
    }
  }
}
