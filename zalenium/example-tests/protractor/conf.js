exports.config = {
  seleniumAddress: 'http://zalenium-zalenium.apps.example.com/wd/hub',
  specs: ['simple-test.js'],
  allScriptsTimeout: 11000,
  multiCapabilities: [{
    browserName: 'firefox'
  }, {
    browserName: 'chrome'
  }]
};
