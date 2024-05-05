import scene3d from '@ohos.graphics.scene'
import router from '@ohos.router';

@Entry
@Component
struct node_base {
  scene: scene3d.Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  cam: scene3d.Camera | null = null;
  private scaled: boolean = false;
  private step: number = 0;
  @State  xAxis: number = 0;
  @State layerMaskInfo: string = '';
  private value: number = 0;
  private layerMaskIndex: number = 0x1;
  node: scene3d.Node | null | undefined = null;
  private printNode : Function = (node: scene3d.Node, tag?:string)=>{
    let msg: string = "lume_api_test " + tag;
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

  TraversalChild(node: scene3d.Node | null): void {
    if (!node) {
      return;
    }

    let container: scene3d.Container<scene3d.Node> = node.children;
    let count: number = container.count();
    console.log("lume node child count", count);

    for (let i = 0; i < count; i++) {
      this.TraversalChild(container.get(i));
    }
  }

  onPageShow(): void {
    this.Init();
  }

  onPageHide(): void {
    console.log('lume onPageHide')
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

        this.scene.environment.backgroundType = scene3d.EnvironmentBackgroundType.BACKGROUND_NONE;
        this.cam.clearColor = { r: 0, g: 0, b: 0, a: 0.0 };
        this.node = this.scene.getNodeByPath('rootNode_/Scene/node_damagedHelmet_-6514');
        if (this.node) {
          this.xAxis = this.node.position.x;
          this.value = this.xAxis;
        }
      }).catch((reason:string) => {
        console.log("lume_api_test error: " + reason) });
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
        Button('scale helmet ').onClick(()=>{
          if (!this.scene) {
            return;
          }
          let node: scene3d.Node | null | undefined = this.scene.root?.children.get(0)?.getNodeByPath('node_damagedHelmet_-6514');
          if (!node) {
            return;
          }

          if (this.scaled) {
            node.scale = { x: 1.0, y: 1.0, z: 1.0 }
            console.log("lume_api_test restore scale");
            this.scaled = false;
          } else {
            node.scale = { x: 0.5, y: 0.5, z: 0.5 }
            this.scaled = true;
            console.log("lume_api_test scale");
          }
        });
        Column() {
          Text("x axis: " + this.xAxis?.toFixed(1)).fontSize(12)
          Slider({
            value: this.value,
            min: this.value - 10,
            max: this.value + 10,
            step: 0.1,
            style: SliderStyle.OutSet
          })
            .showTips(false)
            .onChange((value: number, mode: SliderChangeMode) => {
              this.xAxis = value;
              if (mode == SliderChangeMode.End) {
                if (!this.node) {
                  return;
                }
                this.node.position.x = this.xAxis;
              }
            })
            .width("100%")
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        Button('rotate helmet ').onClick(()=>{
          if (!this.scene) {
            return;
          }
          let node: scene3d.Node | null | undefined = this.scene.getNodeByPath('rootNode_/Scene/node_damagedHelmet_-6514');
          if (!node) {
            return;
          }
          let c = Math.cos(-this.step * 0.7 * 0.1);
          let s = Math.sin(-this.step * 0.7 * 0.1);
          node.rotation = { x: s, y: 0.0, z: 0.0, w: c };
          this.step++;
        });

        Button('rotate parent ').onClick(()=>{ 
          if (!this.scene) {
            return;
          }
          let child: scene3d.Node | null | undefined = this.scene.root?.getNodeByPath('Scene/node_damagedHelmet_-6514');
          if (!child) {
            return;
          }
          let node : scene3d.Node | null = child.parent;
          if (!node) {
            return;
          }
          let c = Math.cos(-this.step * 0.7 * 0.1);
          let s = Math.sin(-this.step * 0.7 * 0.1);
          node.rotation = { x: 0.0, y: s, z: 0.0, w: c };
          this.step++;
        });
        Button('root visibl').onClick(()=>{
          if (this.scene?.root) {
            this.scene.root.visible =!this.scene.root?.visible
          }
        })
        Button('layer mask').onClick(()=>{
          if (!this.scene) {
            return;
          }
          let node: scene3d.Node | null | undefined = this.scene.getNodeByPath('rootNode_/Scene/node_damagedHelmet_-6514');
          if (!node) {
            return;
          }
          let enabled:Boolean = node.layerMask.getEnabled(this.layerMaskIndex);
          node.layerMask.setEnabled(1, !enabled);
          this.layerMaskInfo = node.name + ':\n' + 'layer mask index : ' + this.layerMaskIndex + '\n' +
            'enabled: ' + enabled;
        })
        Text("layer mask info: \n" + this.layerMaskInfo)
        Button('back').onClick(()=>{
          if (this.scene) {
            this.scene.destroy();
          }
          router.back()}
        )
      }
      .width('100%')
    }
    .height('100%')
  }
}