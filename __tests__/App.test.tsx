/**
 * @format
 */

import React from 'react';
import ReactTestRenderer from 'react-test-renderer';
import App from '../App';

jest.mock('react-native-safe-area-context', () => {
  const { View } = require('react-native');

  return {
    SafeAreaProvider: View,
    SafeAreaView: View,
  };
});

test('renders correctly', async () => {
  let renderer: ReactTestRenderer.ReactTestRenderer;

  await ReactTestRenderer.act(async () => {
    renderer = ReactTestRenderer.create(<App />);
  });

  const rendered = JSON.stringify(renderer!.toJSON());
  expect(rendered).toContain('WarpBuild iOS CI');
  expect(rendered).toContain('BUILD & RUN OK');
});
