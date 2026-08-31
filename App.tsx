import React from 'react';
import { StatusBar, StyleSheet, Text, View } from 'react-native';
import { SafeAreaProvider, SafeAreaView } from 'react-native-safe-area-context';

function App() {
  return (
    <SafeAreaProvider>
      <StatusBar barStyle="light-content" backgroundColor="#101827" />
      <SafeAreaView style={styles.safeArea}>
        <View style={styles.card}>
          <Text style={styles.eyebrow}>REACT NATIVE · iOS</Text>
          <Text style={styles.title}>WarpBuild iOS CI</Text>
          <Text style={styles.description}>
            GitHub Actions에서 빌드한 앱이 iOS Simulator에서 실행 중입니다.
          </Text>
          <View style={styles.statusRow}>
            <View style={styles.statusDot} />
            <Text style={styles.statusText}>BUILD &amp; RUN OK</Text>
          </View>
        </View>
      </SafeAreaView>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: '#101827',
    justifyContent: 'center',
    padding: 24,
  },
  card: {
    backgroundColor: '#17233A',
    borderColor: '#2D4163',
    borderRadius: 24,
    borderWidth: 1,
    padding: 28,
  },
  eyebrow: {
    color: '#7DD3FC',
    fontSize: 13,
    fontWeight: '700',
    letterSpacing: 1.8,
    marginBottom: 12,
  },
  title: {
    color: '#FFFFFF',
    fontSize: 34,
    fontWeight: '800',
    letterSpacing: -0.8,
  },
  description: {
    color: '#C7D2E5',
    fontSize: 17,
    lineHeight: 26,
    marginTop: 16,
  },
  statusRow: {
    alignItems: 'center',
    alignSelf: 'flex-start',
    backgroundColor: '#123C32',
    borderRadius: 999,
    flexDirection: 'row',
    marginTop: 28,
    paddingHorizontal: 15,
    paddingVertical: 10,
  },
  statusDot: {
    backgroundColor: '#4ADE80',
    borderRadius: 5,
    height: 10,
    marginRight: 9,
    width: 10,
  },
  statusText: {
    color: '#BBF7D0',
    fontSize: 13,
    fontWeight: '800',
    letterSpacing: 0.8,
  },
});

export default App;
