import router from '@ohos.router';

@Entry
@Component
struct Index {
  onJumpClick(target_url: string, target_id: number): void {
    router.pushUrl({ url: target_url }, router.RouterMode.Single, (err) => {
      if (err) {
        console.error('Invoke pushUrl failed, code is ${err.code}, message is ${err.message}');
        return;
      }
    });
  }

  build() {
    List() {
      ListItem() {
        Button("container")
          .onClick(() => {
            this.onJumpClick('graphics3d/container', 0);
          })
      }
      ListItem() {
        Button("node_base")
          .onClick(() => {
            this.onJumpClick('graphics3d/node_base', 0);
          })
      }
      ListItem() {
        Button("node_camera")
        .onClick(() => {
          this.onJumpClick('graphics3d/node_camera', 0);
        })
      }
      ListItem() {
        Button("node_geometry")
          .onClick(() => {
            this.onJumpClick('graphics3d/node_geometry', 0);
          })
      }
      ListItem() {
        Button("node_light")
          .onClick(() => {
            this.onJumpClick('graphics3d/node_light', 0);
          })
      }

      ListItem() {
        Button("scene_environment")
          .onClick(() => {
            this.onJumpClick('graphics3d/scene_environment', 0);
          })
      }
      ListItem() {
        Button("scene_animation")
          .onClick(() => {
            this.onJumpClick('graphics3d/scene_animation', 0);
          })
      }
      ListItem() {
        Button("scene_shader")
          .onClick(() => {
            this.onJumpClick('graphics3d/scene_shader', 0);
          })
      }
    }.alignListItem(ListItemAlign.Center)
    .width('100%')
    .height('100%')
  }
}
