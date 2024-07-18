import { NodeController, FrameNode, RenderNode, DrawContext, Size } from '@ohos.arkui.node';
import { UIContext } from '@ohos.arkui.UIContext';

const TAG = '[Test_API]';

const defaultDrawFunction = (context: DrawContext) => {};
type DrawFunction = (context: DrawContext) => void;

class NativeRenderNode extends RenderNode {
  private drawFunction: DrawFunction;

  constructor(drawFunction: DrawFunction) {
    super();
    this.drawFunction = drawFunction;
  }

  draw(context: DrawContext) {
    this.drawFunction(context);
  }
}

class NativeNodeController extends  NodeController {
  private rootNode: FrameNode | null = null;
  private renderNode: NativeRenderNode | null = null;
  private drawFunction: DrawFunction;

  constructor(drawFunction: DrawFunction) {
    super();
    this.drawFunction = drawFunction;
  }

  makeNode(uiContext: UIContext): FrameNode {
    this.renderNode = new NativeRenderNode(this.drawFunction);
    this.rootNode = new FrameNode(uiContext);
    const renderNode = this.rootNode?.getRenderNode();
    if (renderNode) {
      renderNode.frame = { x: 0, y:0, width: 1000, height: 1000 };
      this.renderNode.frame = { x: 0, y:0, width: 1000, height: 1000 };
      renderNode.appendChild(this.renderNode);
    }
    return this.rootNode;
  }

  aboutToResize(size: Size): void{
    const renderNode = this.rootNode?.getRenderNode();
    if (renderNode) {
      renderNode.frame = { x: 0, y: 0, width: size.width, height: size.height };
      if (this.renderNode) {
        this.renderNode.frame =  { x: 0, y: 0, width: size.width, height: size.height };
      }
    }
    this.invalidate();
  }

  invalidate(): void {
      this.renderNode?.invalidate();
  }
}

@Component
struct NativeRenderComponent {
  drawFunction: DrawFunction  = defaultDrawFunction;
  @State controller: NativeNodeController | null = null;

  aboutToAppear(): void {
      this.controller = new NativeNodeController(this.drawFunction);
  }

  build() {
    NodeContainer(this.controller)
      .onTouch((event: TouchEvent) => {
        if (event.type === TouchType.Up) {
          this.controller?.invalidate();
        }
      })
  }
}

export default NativeRenderComponent;

