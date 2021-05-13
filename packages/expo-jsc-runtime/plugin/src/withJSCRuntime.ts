import { ConfigPlugin, createRunOncePlugin, withGradleProperties } from '@expo/config-plugins';

const pkg = require('expo-jsc-runtime/package.json');

const withJSCRuntime: ConfigPlugin = config => {
  return withGradleProperties(config, config => {
    const PROP_KEY = 'JS_RUNTIME';

    const oldPropIndex = config.modResults.findIndex(
      prop => prop.type === 'property' && prop.key === PROP_KEY
    );
    const newProp: typeof config.modResults[0] = { type: 'property', key: PROP_KEY, value: 'jsc' };

    if (oldPropIndex >= 0) {
      config.modResults[oldPropIndex] = newProp;
    } else {
      config.modResults.push(newProp);
    }
    return config;
  });
};

export default createRunOncePlugin(withJSCRuntime, pkg.name, pkg.version);
