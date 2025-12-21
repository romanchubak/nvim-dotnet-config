const vsdaLocation = 'user directory\\AppData\\Local\\Programs\\Microsoft VS Code\\resources\\app\\node_modules.asar.unpacked\\vsda\\build\\Release\\vsda.node';
const vsda = require(vsdaLocation);

const signer = new vsda.signer();

process.argv.slice(2).forEach(arg => {
  const signature = signer.sign(arg);
  console.log(signature);
});
