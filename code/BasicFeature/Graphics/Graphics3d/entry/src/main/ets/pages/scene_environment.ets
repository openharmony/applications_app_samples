import scene3d from '@ohos.graphics.scene'
import router from '@ohos.router';

let logTag: string = "lume_api_test ";
let typeFlag: number = 0;
let DiffuseFactorFlag: number = 0;
let SpecularFactorFlag: number = 0;
let MapFactorFlag: number = 0;
let radianceImageFlag: number = 0;
let irradianceFlag: number = 0;

function GenRandom(): number {
  return Math.random() * 2 - 1;
}

@Entry
@Component
struct node_geometry {
  scene: scene3d.Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  cam: scene3d.Camera | null = null;
  env: scene3d.Environment | null = null;
  envImg1: scene3d.Image | null = null;
  envImg2: scene3d.Image | null = null;
  envImg3: scene3d.Image | null = null;
  radianceImg1: scene3d.Image | null = null;

  //  scene:Nullable<scene3D.Scene>;
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
      scene3d.Scene.load($rawfile("gltf/DamagedHelmet/glTF/DamagedHelmet.gltf"))
        .then(async (result: scene3d.Scene) => {
          this.scene = result;
          this.sceneOpt = { scene: this.scene, modelType: ModelType.SURFACE } as SceneOptions;
          let rf: scene3d.SceneResourceFactory = this.scene.getResourceFactory();
          this.cam = await rf.createCamera({ "name": "Camera1" });
          this.cam.enabled = true;
          this.cam.position.z = 5;
          this.env = await rf.createEnvironment({ "name": "Env" });

          // this.envImg1 = await rf.createImage({ name: "envImg1", uri: $rawfile("bricks.jpg") });
          // this.envImg2 = await rf.createImage({ name: "envImg2", uri: $rawfile("charging_env.ktx") });
          // this.envImg3 = await rf.createImage({ name: "envImg3", uri: $rawfile("bricks.jpg") });
          // this.radianceImg1 = await rf.createImage ({
          //   name: "radianceImg1",
          //   uri: $rawfile("quarry_02_2k_radiance(spec).ktx")
          // });
          this.envImg1 = await rf.createImage({ name: "envImg1", uri: $rawfile("gltf/Cube/glTF/Cube_BaseColor.png") });
          this.envImg2 = await rf.createImage({ name: "envImg2", uri: $rawfile("gltf/Environment/glTF/images/quarry_02_2k_skybox.ktx") });
          this.envImg3 = await rf.createImage({ name: "envImg3", uri: $rawfile("gltf/DamagedHelmet/glTF/Default_albedo.jpg") });
          this.radianceImg1 = await rf.createImage ({
            name: "radianceImg1",
            uri: $rawfile("gltf/Environment/glTF/images/quarry_02_2k_radiance(spec).ktx")
          });
        })
        .catch((reason: string) => {
          console.log("lume_api_test error: " + reason)
        });
    }
  }

  build() {
    Row() {
      Column() {
        Stack() {
          Column() {}.height('100%').width('100%').backgroundColor(Color.Green)

          if (this.sceneOpt) {
            Component3D(this.sceneOpt)
              .renderWidth('60%')
              .renderHeight('60%')
              .backgroundColor(Color.Transparent)
              .width("90%")
              .height('100%')
          }
          else {
            Text("loading 1...");
          }
        }
        .height('30%')

        Button('change env Img Type').onClick(() => {
          if (!this.scene || !this.env || !this.cam) {
            return;
          }
          typeFlag = (typeFlag + 1) % 4;
          if (typeFlag == 0) {
            this.scene.environment.backgroundType = scene3d.EnvironmentBackgroundType.BACKGROUND_NONE;
            this.cam.clearColor = { r: 0, g: 0, b: 0, a: 0.0 };
            console.log(logTag + "Environment environmentImage set NONE");
          }
          else if (this.envImg1 && typeFlag == 1) {
            this.scene.environment.backgroundType = scene3d.EnvironmentBackgroundType.BACKGROUND_IMAGE;
            this.scene.environment.environmentImage = this.envImg1;
            console.log(logTag + "Environment environmentImage set envImg1 IMAGE");
          }
          else if (this.envImg2 && typeFlag == 2) {
            this.scene.environment.backgroundType = scene3d.EnvironmentBackgroundType.BACKGROUND_CUBEMAP;
            this.scene.environment.environmentImage = this.envImg2;
            console.log(logTag + "Environment environmentImage set envImg2 CUBEMAP");
          }
          else if (this.envImg3 && typeFlag == 3) {
            this.scene.environment.backgroundType = scene3d.EnvironmentBackgroundType.BACKGROUND_EQUIRECTANGULAR;
            this.scene.environment.environmentImage = this.envImg3;
            console.log(logTag + "Environment environmentImage set envImg3 EQUIRECTANGULAR");
          }
        });

        Button('change radiance Img').onClick(() => {
          if (!this.scene || !this.env) {
            return;
          }
          radianceImageFlag = (radianceImageFlag + 1) % 2;
          if (radianceImageFlag == 0) {
            this.scene.environment.radianceImage = null;
            console.log(logTag + "Environment radianceImage set null");
          }
          else if (this.radianceImg1 && radianceImageFlag == 1) {
            this.scene.environment.radianceImage = this.radianceImg1;
            console.log(logTag + "Environment radianceImage set radianceImg1");
          }
        });

        Button('change indirectDiffuseFactor').onClick(() => {
          if (!this.scene || !this.env) {
            return;
          }
          DiffuseFactorFlag = (DiffuseFactorFlag + 1) % 4;
          if (DiffuseFactorFlag == 0) {
            this.scene.environment.indirectDiffuseFactor.x = 1;
            this.scene.environment.indirectDiffuseFactor.y = 1;
            this.scene.environment.indirectDiffuseFactor.z = 1;
            this.scene.environment.indirectDiffuseFactor.w = 1;
            console.log(logTag + "Environment indirectDiffuseFactor: ["
              + this.scene.environment.indirectDiffuseFactor.x + ", "
              + this.scene.environment.indirectDiffuseFactor.y + ", "
              + this.scene.environment.indirectDiffuseFactor.z + ", "
              + this.scene.environment.indirectDiffuseFactor.w + "]");
          }
          else if (DiffuseFactorFlag == 1) {
            this.scene.environment.indirectDiffuseFactor.x = 40;
            this.scene.environment.indirectDiffuseFactor.y = 1;
            this.scene.environment.indirectDiffuseFactor.z = 1;
            this.scene.environment.indirectDiffuseFactor.w = 1;
            console.log(logTag + "Environment indirectDiffuseFactor: ["
              + this.scene.environment.indirectDiffuseFactor.x + ", "
              + this.scene.environment.indirectDiffuseFactor.y + ", "
              + this.scene.environment.indirectDiffuseFactor.z + ", "
              + this.scene.environment.indirectDiffuseFactor.w + "]");
          }
          else if (DiffuseFactorFlag == 2) {
            this.scene.environment.indirectDiffuseFactor.x = 1;
            this.scene.environment.indirectDiffuseFactor.y = 40;
            this.scene.environment.indirectDiffuseFactor.z = 1;
            this.scene.environment.indirectDiffuseFactor.w = 1;
            console.log(logTag + "Environment indirectDiffuseFactor: ["
              + this.scene.environment.indirectDiffuseFactor.x + ", "
              + this.scene.environment.indirectDiffuseFactor.y + ", "
              + this.scene.environment.indirectDiffuseFactor.z + ", "
              + this.scene.environment.indirectDiffuseFactor.w + "]");
          }
          else if (DiffuseFactorFlag == 3) {
            this.scene.environment.indirectDiffuseFactor.x = 1;
            this.scene.environment.indirectDiffuseFactor.y = 1;
            this.scene.environment.indirectDiffuseFactor.z = 40;
            this.scene.environment.indirectDiffuseFactor.w = 1;
            console.log(logTag + "Environment indirectDiffuseFactor: ["
              + this.scene.environment.indirectDiffuseFactor.x + ", "
              + this.scene.environment.indirectDiffuseFactor.y + ", "
              + this.scene.environment.indirectDiffuseFactor.z + ", "
              + this.scene.environment.indirectDiffuseFactor.w + "]");
          }
        });

        Button('change indirectSpecularFactor').onClick(() => {
          if (!this.scene || !this.env) {
            return;
          }
          SpecularFactorFlag = (SpecularFactorFlag + 1) % 4;
          if (SpecularFactorFlag == 0) {
            this.scene.environment.indirectSpecularFactor.x = 1;
            this.scene.environment.indirectSpecularFactor.y = 1;
            this.scene.environment.indirectSpecularFactor.z = 1;
            this.scene.environment.indirectSpecularFactor.w = 1;
            console.log(logTag + "Environment indirectSpecularFactor: ["
              + this.scene.environment.indirectSpecularFactor.x + ", "
              + this.scene.environment.indirectSpecularFactor.y + ", "
              + this.scene.environment.indirectSpecularFactor.z + ", "
              + this.scene.environment.indirectSpecularFactor.w + "]");
          }
          else if (SpecularFactorFlag == 1) {
            this.scene.environment.indirectSpecularFactor.x = 40;
            this.scene.environment.indirectSpecularFactor.y = 1;
            this.scene.environment.indirectSpecularFactor.z = 1;
            this.scene.environment.indirectSpecularFactor.w = 1;
            console.log(logTag + "Environment indirectSpecularFactor: ["
              + this.scene.environment.indirectSpecularFactor.x + ", "
              + this.scene.environment.indirectSpecularFactor.y + ", "
              + this.scene.environment.indirectSpecularFactor.z + ", "
              + this.scene.environment.indirectSpecularFactor.w + "]");
          }
          else if (SpecularFactorFlag == 2) {
            this.scene.environment.indirectSpecularFactor.x = 1;
            this.scene.environment.indirectSpecularFactor.y = 40;
            this.scene.environment.indirectSpecularFactor.z = 1;
            this.scene.environment.indirectSpecularFactor.w = 1;
            console.log(logTag + "Environment indirectSpecularFactor: ["
              + this.scene.environment.indirectSpecularFactor.x + ", "
              + this.scene.environment.indirectSpecularFactor.y + ", "
              + this.scene.environment.indirectSpecularFactor.z + ", "
              + this.scene.environment.indirectSpecularFactor.w + "]");
          }
          else if (SpecularFactorFlag == 3) {
            this.scene.environment.indirectSpecularFactor.x = 1;
            this.scene.environment.indirectSpecularFactor.y = 1;
            this.scene.environment.indirectSpecularFactor.z = 40;
            this.scene.environment.indirectSpecularFactor.w = 1;
            console.log(logTag + "Environment indirectSpecularFactor: ["
              + this.scene.environment.indirectSpecularFactor.x + ", "
              + this.scene.environment.indirectSpecularFactor.y + ", "
              + this.scene.environment.indirectSpecularFactor.z + ", "
              + this.scene.environment.indirectSpecularFactor.w + "]");
          }
        });

        Button('change environmentMapFactor').onClick(() => {
          if (!this.scene || !this.env) {
            return;
          }
          MapFactorFlag = (MapFactorFlag + 1) % 4;
          if (MapFactorFlag == 0) {
            this.scene.environment.environmentMapFactor.x = 1;
            this.scene.environment.environmentMapFactor.y = 1;
            this.scene.environment.environmentMapFactor.z = 1;
            this.scene.environment.environmentMapFactor.w = 1;
            console.log(logTag + "Environment environmentMapFactor: ["
              + this.scene.environment.environmentMapFactor.x + ", "
              + this.scene.environment.environmentMapFactor.y + ", "
              + this.scene.environment.environmentMapFactor.z + ", "
              + this.scene.environment.environmentMapFactor.w + "]");
          }
          else if (MapFactorFlag == 1) {
            this.scene.environment.environmentMapFactor.x = 40;
            this.scene.environment.environmentMapFactor.y = 1;
            this.scene.environment.environmentMapFactor.z = 1;
            this.scene.environment.environmentMapFactor.w = 1;
            console.log(logTag + "Environment environmentMapFactor: ["
              + this.scene.environment.environmentMapFactor.x + ", "
              + this.scene.environment.environmentMapFactor.y + ", "
              + this.scene.environment.environmentMapFactor.z + ", "
              + this.scene.environment.environmentMapFactor.w + "]");
          }
          else if (MapFactorFlag == 2) {
            this.scene.environment.environmentMapFactor.x = 1;
            this.scene.environment.environmentMapFactor.y = 40;
            this.scene.environment.environmentMapFactor.z = 1;
            this.scene.environment.environmentMapFactor.w = 1;
            console.log(logTag + "Environment environmentMapFactor: ["
              + this.scene.environment.environmentMapFactor.x + ", "
              + this.scene.environment.environmentMapFactor.y + ", "
              + this.scene.environment.environmentMapFactor.z + ", "
              + this.scene.environment.environmentMapFactor.w + "]");
          }
          else if (MapFactorFlag == 3) {
            this.scene.environment.environmentMapFactor.x = 1;
            this.scene.environment.environmentMapFactor.y = 1;
            this.scene.environment.environmentMapFactor.z = 40;
            this.scene.environment.environmentMapFactor.w = 1;
            console.log(logTag + "Environment environmentMapFactor: ["
              + this.scene.environment.environmentMapFactor.x + ", "
              + this.scene.environment.environmentMapFactor.y + ", "
              + this.scene.environment.environmentMapFactor.z + ", "
              + this.scene.environment.environmentMapFactor.w + "]");
          }
        });

        Button('change irradianceCoefficients').onClick(() => {
          if (!this.scene || !this.env) {
            return;
          }
          MapFactorFlag = (MapFactorFlag + 1) % 4;
          this.scene.environment.irradianceCoefficients =
            [{ x: GenRandom(), y: GenRandom(), z: GenRandom() },
              { x: GenRandom(), y: GenRandom(), z: GenRandom() },
              { x: GenRandom(), y: GenRandom(), z: GenRandom() },
              { x: GenRandom(), y: GenRandom(), z: GenRandom() },
              { x: GenRandom(), y: GenRandom(), z: GenRandom() },
              { x: GenRandom(), y: GenRandom(), z: GenRandom() },
              { x: GenRandom(), y: GenRandom(), z: GenRandom() },
              { x: GenRandom(), y: GenRandom(), z: GenRandom() },
              { x: GenRandom(), y: GenRandom(), z: GenRandom() }];
          console.log(logTag + "Environment irradianceCoefficients[0]: ["
            + this.scene.environment.irradianceCoefficients[0].x + ", "
            + this.scene.environment.irradianceCoefficients[0].y + ", "
            + this.scene.environment.irradianceCoefficients[0].z + "]");
        });

        Button('back').onClick(() => {
          router.back()
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}