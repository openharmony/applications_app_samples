import scene3d from '@ohos.graphics.scene'
import router from '@ohos.router';
import animator, { AnimatorResult } from '@ohos.animator'
let logTag: string = 'lume_api_test';

@Entry
@Component
struct container {
  scene: scene3d.Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  cam: scene3d.Camera | null = null;
  private scaled: boolean = false;
  private step: number = 0;
  private node: scene3d.Node | null | undefined = undefined;
  private sceneNode: scene3d.Node | null = null;
  @State hierarchy: string = '';
  backAnimator: AnimatorResult | undefined = undefined;
  needAddCam: Boolean = false;

  private printNode : Function = (node: scene3d.Node, tag?:string)=>{
    let msg: string = logTag + tag;
    if (!node) {
      console.log(msg + ' error node null');
      return;
    }
    console.log(msg + ' name', node.name);
    console.log(msg + ' path', node.path);
    console.log(msg + ' nodeType', node.nodeType);
    console.log(msg + ' node resource type', node.resourceType);
    console.log(msg + ' parent name', node.parent?.name);
  }

  Traversal(node: scene3d.Node | null): void {
    if (!node) {
      return;
    }
    this.printNode(node, " node print");
    this.hierarchy += node.path + '/' + node.name + '\n';
    let container: scene3d.Container<scene3d.Node> = node.children;
    let count: number = container.count();
    console.log(logTag + " node child count", count);
    this.hierarchy += '  ';
    for (let i = 0; i < count; i++) {
      this.Traversal(container.get(i));
    }
  }

  onPageShow(): void {
    this.Init();
  }

  onPageHide(): void {
    console.log(logTag + ' onPageHide')
    if (this.scene) {
      this.scene.destroy();
    }

    this.cam = null;
    this.scene = null;
  }

  Init(): void {
    if (this.scene == null) {
      scene3d.Scene.load($rawfile("gltf/DamagedHelmet/glTF/DamagedHelmet.gltf")).then(async (result:scene3d.Scene) => {
        this.scene = result;
        this.sceneOpt = { scene: this.scene, modelType: ModelType.SURFACE } as SceneOptions;
        let rf:scene3d.SceneResourceFactory = this.scene.getResourceFactory();
        this.cam = await rf.createCamera({ "name": "Camera1" });
        this.cam.enabled = true;
        this.cam.position.z = 5;

        this.node = this.scene.getNodeByPath('rootNode_/Scene/node_damagedHelmet_-6514');
        this.printNode(this.node, 'node_damagedHelmet_-6514');
        this.printNode(this.cam, 'camera');
        this.Traversal(this.scene.root);
        this.sceneNode = this.scene.getNodeByPath('rootNode_/Scene');
      }).catch((reason:string) => {
        console.log(logTag + " error: " + reason )});
    }
  }

  build() {
    Row() {
      Column() {
        Column() {
          if (this.sceneOpt) {
            Component3D(this.sceneOpt)
              .renderWidth('60%')
              .renderHeight('60%')
          }
          else {
            Text("loading 1...");
          }
        }
        .height('30%')

        Button('remove node').onClick(()=>{
          this.scene?.root?.children.remove(this.node);
        })
        Button('appen node').onClick(()=>{
          this.scene?.root?.children.get(0)?.children.append(this.node);
        })
        Button('insert node').onClick(()=>{
          this.scene?.root?.children.get(0)?.children.insertAfter(this.node, null);
        })
        Button('clear').onClick(()=>{
          this.scene?.root?.children.clear();
          this.needAddCam = true;
        })
        Text(this.hierarchy)
        Button('back').onClick(()=>{ router.back()})
      }
      .width('100%')
    }
    .height('100%')
  }
}