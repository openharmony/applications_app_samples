import { hilog } from '@kit.PerformanceAnalysisKit';
import nativeNode from 'libentry.so';
import { NodeContent } from '@ohos.arkui.node'

class Params {
  public insert: boolean = false
  public nodeContent: NodeContent;

  constructor(insert: boolean, nodeContent: NodeContent) {
    this.insert = insert;
    this.nodeContent = nodeContent;
  }
}

class MyNodeContent extends NodeContent {
  onAttachToWindow(): void {
    // TODO
  }

  onDetachFromWindow(): void {
    // TODO
  }

  constructor() {
    super()
  }
}

@Builder
function buildNodeContent(params: Params) {
  ContentSlot(params.insert ? params.nodeContent : undefined)
}

@Entry
@Component
struct Parent {
  @State insert: boolean = true
  public nodeContent = new MyNodeContent()
  public nodeContent2 = new MyNodeContent()
  @State xcWidth: number = 200
  aboutToAppear(): void {
    nativeNode.createNativeNodexc(this.nodeContent, 'nodeContent1234');
  }

  build() {

    Row() {
      Column() {
        buildNodeContent(new Params(this.insert, this.nodeContent))
      }
      .width(this.xcWidth)
    }
    .width('100%')
    .height('100%')
  }
}
