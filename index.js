/**
 * @format
 */

import Constants from 'expo-constants';
console.log(Constants.systemFonts);

import {AppRegistry} from 'react-native';
import App from './App';
import {name as appName} from './app.json';

AppRegistry.registerComponent(appName, () => App);
