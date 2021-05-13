"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const config_plugins_1 = require("@expo/config-plugins");
const pkg = require('expo-jsc-runtime/package.json');
const withJSCRuntime = config => {
    return config_plugins_1.withGradleProperties(config, config => {
        const PROP_KEY = 'JS_RUNTIME';
        const oldPropIndex = config.modResults.findIndex(prop => prop.type === 'property' && prop.key === PROP_KEY);
        const newProp = { type: 'property', key: PROP_KEY, value: 'jsc' };
        if (oldPropIndex >= 0) {
            config.modResults[oldPropIndex] = newProp;
        }
        else {
            config.modResults.push(newProp);
        }
        return config;
    });
};
exports.default = config_plugins_1.createRunOncePlugin(withJSCRuntime, pkg.name, pkg.version);
