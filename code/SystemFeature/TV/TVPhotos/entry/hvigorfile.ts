import { hapTasks, OhosPluginId } from '@ohos/hvigor-ohos-plugin';
import { hvigor } from '@ohos/hvigor'

const name = 'TVAlbum'
const artifactName = name

hvigor.afterNodeEvaluate((hvigorNode) => {
  const context = hvigorNode.getContext(OhosPluginId.OHOS_HAP_PLUGIN)
  if (context && context.getBuildProfileOpt) {
    const buildProfile = context.getBuildProfileOpt();
    const targets = buildProfile.targets
    for (const target of targets) {
      if (target.name === 'default') {
        target['output'] = {
          "artifactName": artifactName
        }
      }
    }
    context.setBuildProfileOpt(buildProfile);
  }
})

export default {
  system: hapTasks, /* Built-in plugin of Hvigor. It cannot be modified. */
  plugins: []
}