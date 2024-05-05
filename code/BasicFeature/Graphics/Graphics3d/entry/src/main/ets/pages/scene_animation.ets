import scene3d from '@ohos.graphics.scene'
import router from '@ohos.router';
import animator, { AnimatorResult } from '@ohos.animator';


let logTag: string = "lume_api_test ";

let enableFlag: number = 0;


@Entry
@Component
struct node_geometry {
  scene: scene3d.Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  cam: scene3d.Camera | null = null;
  @State progressValue: number = 0;
  @State animationOnstart: Boolean = false;
  @State animationOnFinished: Boolean = false;
  //
  @State animationEnabled: Boolean = false;
  @State animationDuration: number = 0;
  @State animationIsRunning: Boolean = false;
  @State animationCallbackInvoked: string = 'no invoked callback'
  // @State animationProgress: number = 0;


  backAnimator: AnimatorResult | undefined = undefined;
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
    this.backAnimator = animator.create({
      duration: 2000,
      easing: "ease",
      delay: 0,
      fill: "none",
      direction: "normal",
      iterations: -1,
      begin: 100,
      end: 200
    })
    this.backAnimator.onframe = value => {
      if (this.scene?.animations[0]) {
        this.animationEnabled = this.scene.animations[0].enabled;
        this.animationDuration = this.scene.animations[0].duration;
        this.animationIsRunning = this.scene.animations[0].running;
        this.progressValue = this.scene.animations[0].progress;
      }
    }
    if (this.scene == null) {
      scene3d.Scene.load($rawfile("gltf/BrainStem/glTF/BrainStem.gltf"))
        .then(async (result: scene3d.Scene) => {
          this.scene = result;
          this.sceneOpt = { scene: this.scene, modelType: ModelType.SURFACE } as SceneOptions;
          let rf = this.scene.getResourceFactory();
          this.cam = await rf.createCamera({ "name": "Camera1" });
          this.cam.enabled = true;
          this.cam.position.z = 5;

          let env = await rf.createEnvironment({ "name": "Env" });
          this.scene.environment.backgroundType = scene3d.EnvironmentBackgroundType.BACKGROUND_IMAGE;
          this.scene.environment.environmentImage = await rf.createImage({ name: "envImg1", uri: $rawfile("bricks.jpg") });
        })
        .catch((reason: string) => {
          console.log("lume_api_test error: " + reason)
        });
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
              .onAppear(()=>{
                if (!this.scene || !this.scene.animations[0]) {
                  return;
                }
                let count = this.scene.animations.length;
                console.log(logTag + "animation count", count)
                for (let i = 0; i < count; i++) {
                  console.log(logTag + "animation index name", i, this.scene.animations[i].name);
                }
                let anim: scene3d.Animation = this.scene.animations[0];
                console.log(logTag + "animation count", anim.name)
                anim.onStarted(()=>{
                  console.log(logTag + 'animation onStart');
                  // this.animationOnstart = true;
                  // this.animationOnFinished = false;
                  this.animationCallbackInvoked = 'animation on start'
                });
                anim.onFinished(() => {
                  console.log(logTag + 'animation onFinish');
                  this.animationCallbackInvoked = 'animation on finish'
                });
                this.backAnimator?.play();
              })
          }
          else {
            Text("loading 1...");
          }
        }
        .height('30%')

        Row() {
          Text ("progress: " + (this.progressValue * 100).toFixed(2) + '%')
         // Progress({value:0, total:100, type:ProgressType.Capsule}).width("70%").height(50).value(this.progressValue)
        }
        Text("Duration: " + this.animationDuration.toFixed(2) + "S");
        Text("Running: " + this.animationIsRunning);
        Text("enabled: " + this.animationEnabled);
        // if (this.animationOnstart) {
        //   Text('animation on start')
        // }
        // if (this.animationOnFinished) {
        //   Text('animation on finished')
        // }
        Text("animation invoked callback:" + this.animationCallbackInvoked);

        Button('enable animation').onClick(() => {
          if (!this.scene || !this.scene.animations[0]) {
            return;
          }

          this.scene.animations[0].enabled = !this.scene.animations[0].enabled;
          console.log(logTag + "enable animation: " + this.scene.animations[0].enabled);
        });

        // Button('get duration').onClick(async () => {
        //   if (!this.scene || !this.scene.animations[0]) {
        //     return;
        //   }
        //   let anim: scene3d.Animation = this.scene.animations[0];
        //
        //   console.log(logTag + "animation duration: " + anim.duration);
        // });

        // Button('is running?').onClick(async () => {
        //   if (!this.scene || !this.scene.animations[0]) {
        //     return;
        //   }
        //   let anim: scene3d.Animation = this.scene.animations[0];
        //
        //   console.log(logTag + "animation is running: " + anim.running);
        // });

        Button('start').onClick(async () => {
          if (!this.scene || !this.scene.animations[0]) {
            return;
          }
          let anim: scene3d.Animation = this.scene.animations[0];
          anim.start();
          console.log(logTag + "animation start");
        });

        Button('pause').onClick(async () => {
          if (!this.scene || !this.scene.animations[0]) {
            return;
          }
          let anim: scene3d.Animation = this.scene.animations[0];
          anim.pause();
          console.log(logTag + "animation pause");
        });

        Button('stop').onClick(async () => {
          if (!this.scene || !this.scene.animations[0]) {
            return;
          }
          let anim: scene3d.Animation = this.scene.animations[0];
          anim.stop();
          console.log(logTag + "animation stop");
        });

        Button('finish').onClick(async () => {
          if (!this.scene || !this.scene.animations[0]) {
            return;
          }
          let anim: scene3d.Animation = this.scene.animations[0];
          anim.finish();
          console.log(logTag + "animation finish");
        });

        Button('restart').onClick(async () => {
          if (!this.scene || !this.scene.animations[0]) {
            return;
          }
          let anim: scene3d.Animation = this.scene.animations[0];
          anim.restart();
          console.log(logTag + "animation restart");
        });

        Button('seek to 30% progress').onClick(async () => {
          if (!this.scene || !this.scene.animations[0]) {
            return;
          }
          let anim: scene3d.Animation = this.scene.animations[0];
          anim.seek(0.3);
          console.log(logTag + "animation seek 0.3");
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