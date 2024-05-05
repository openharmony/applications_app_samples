import scene3d from '@ohos.graphics.scene'
import router from '@ohos.router';

@Entry
@Component
struct node_geometry {
  scene: scene3d.Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  cam: scene3d.Camera | null = null;
  private scaled: boolean = false;
  private step: number = 0;

  private printMesh : Function = (geometry: scene3d.Geometry, tag?:string)=>{
    let msg: string = "lume_api_test " + tag;
    if (!geometry) {
      console.log(msg + ' error geometry null ');
      return;
    }
    console.log(msg + ' name', geometry.mesh.name);
    let aabb: scene3d.Aabb = geometry.mesh.aabb;
    console.log(msg + ' aabb min ', aabb.aabbMin.x, aabb.aabbMin.y, aabb.aabbMin.z);
    console.log(msg + ' aabb max ', aabb.aabbMax.x, aabb.aabbMax.y, aabb.aabbMax.z);
    let submeshes: scene3d.SubMesh[] = geometry.mesh.subMeshes;
    let submeshCount = submeshes.length;
    let materialOverride: scene3d.Material | undefined = geometry.mesh.materialOverride;
    if (materialOverride) {
      console.log(msg + ' material overrid name', materialOverride.name);
      console.log(msg + ' material overrid type', materialOverride.materialType);
    } else {
      console.log(msg +'  material overrid empty');
    }

    console.log(msg + "submesh count", submeshCount);
    for (let i = 0; i < submeshCount; i++) {
      let submesh: scene3d.SubMesh = submeshes[i];
      console.log(msg + 'submesh name', submesh.name);
      console.log(msg + 'submesh material name', submesh.material.name);
      console.log(msg + 'submesh material type', submesh.material.materialType);
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
        let node: scene3d.Node | null | undefined = undefined;
        node = this.scene.getNodeByPath('rootNode_/Scene/node_damagedHelmet_-6514');
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
        Button('print geometry ').onClick(()=>{
          if (!this.scene) {
            return;
          }
          let geometry: scene3d.Geometry | null | undefined =
            this.scene.getNodeByPath('rootNode_/Scene/node_damagedHelmet_-6514') as scene3d.Geometry;
          if (!geometry) {
            return;
          }
          this.printMesh(geometry, 'geometry')
        });

        Button('material override').onClick(async ()=>{
          if (!this.scene) {
            return;
          }
          let geometry: scene3d.Geometry | null | undefined =
            this.scene.getNodeByPath('rootNode_/Scene/node_damagedHelmet_-6514') as scene3d.Geometry;
          if (!geometry) {
            return;
          }
          let material: scene3d.Material = 
            await this.scene.getResourceFactory().createMaterial({name: "materialOverride"}, scene3d.MaterialType.SHADER);
          console.log('lume_api_test assign material overrial');
          geometry.mesh.materialOverride = material;
          this.printMesh(geometry, 'after material override');
        });

        Button('replace submesh material').onClick(async ()=>{
          if (!this.scene) {
            return;
          }
          let geometry: scene3d.Geometry | null | undefined =
            this.scene.getNodeByPath('rootNode_/Scene/node_damagedHelmet_-6514') as scene3d.Geometry;
          if (!geometry) {
            return;
          }
          let material: scene3d.Material = 
            await this.scene.getResourceFactory().createMaterial({name: "subMeshMaterial"}, scene3d.MaterialType.SHADER);
          console.log('lume_api_test assign submesh material overrial');
          for (let m of geometry.mesh.subMeshes) {
            m.material = material;
            this.printMesh(geometry, 'after replace submesh material');
          }
        });

        Button('back').onClick(()=>{ router.back()})
      }
      .width('100%')
    }
    .height('100%')
  }
}