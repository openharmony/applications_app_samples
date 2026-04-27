import lazy { RESOLVER_REGISTRY as ResolverRegistry } from '../sta/ResolverRegistry';
import lazy { ResolverRegistryStaDummy } from './ResolverRegistryStaDummy';

import deviceInfo from '@ohos.deviceInfo';

let ResolverRegistrySta = undefined;
if (deviceInfo.sdkApiVersion >= 20) {
    ResolverRegistrySta = ResolverRegistry;
} else {
    ResolverRegistrySta = ResolverRegistryStaDummy;
}

export { ResolverRegistrySta };
