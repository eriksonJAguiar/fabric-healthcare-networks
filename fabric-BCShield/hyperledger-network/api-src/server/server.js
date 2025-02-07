var express = require('express');
var bodyParser = require('body-parser');
var app = express();
const fabricNetwork = require('./fabricNetwork')
app.set('view engine', 'ejs');
app.use(bodyParser.json());
urlencoder = bodyParser.urlencoded({ extended: true});
const args = process.argv.slice(2);
const org = args[0];


app.post('/api/createLabs', urlencoder, async function (req, res) {

  try {
    const contract = await fabricNetwork.connectNetwork(`connection-${org}.json`, `../../wallet/wallet-${org}`);
    console.log(req.body);  
    // let records = {
    //         labsId: req.body.labsId, 
    //         refDocument: req.body.refDocument,
    //         refIFPS: req.body.refIFPS,
    //         owner: req.body.owner,
    //         documentType: req.body.documentType,
    //         timestamp:Date.now().toString()
    // };
    let tx = await contract.submitTransaction('createHealthcareLabs', req.body.labsId, req.body.refDocument, req.body.refIFPS, req.body.documentType, req.body.documentType, Date.now().toString());
    res.json({
      status: 'OK - Transaction has been submitted',
      txid: tx.toString()
    });
    console.log('OK - Transaction has been submitted');
  } catch (error) {
    console.error(`Failed to evaluate transaction: ${error}`);
    res.status(500).json({
      error: error
    });
  }

});

app.get('/api/readLabs/:id', async function (req, res) {
  try {
    const contract = await fabricNetwork.connectNetwork(`connection-${org}.json`, `../../wallet/wallet-${org}`);
    const result = await contract.evaluateTransaction('readHealthcareLabs', req.params.id.toString());
    let response = JSON.parse(result.toString());
    res.json({result:response});
    console.log('OK - Query Successful');
  } catch (error) {
    console.error(`Failed to evaluate transaction: ${error}`);
    res.status(500).json({
      error: error
    });
  }
})


// app.post('/api/setPosition', async function (req, res) {

//   try {
//     const contract = await fabricNetwork.connectNetwork('connection-deliverer.json', 'wallet/wallet-deliverer');
//     let tx = await contract.submitTransaction('setPosition', req.body.id.toString(), req.body.latitude.toString(), req.body.longitude.toString());
//     res.json({
//       status: 'OK - Transaction has been submitted',
//       txid: tx.toString()
//     });
//   } catch (error) {
//     console.error(`Failed to evaluate transaction: ${error}`);
//     res.status(500).json({
//       error: error
//     });
//   }

// });


// app.get('/api/getHistorySushi/:id', async function (req, res) {
//   try {
//     const contract = await fabricNetwork.connectNetwork(`connection-${org}.json`, 'wallet/wallet-${org}');
//     const historySushi = JSON.parse((await contract.evaluateTransaction('getHistory', req.params.id.toString())).toString());
//     const actualSushi = JSON.parse((await contract.evaluateTransaction('querySushi', req.params.id.toString())).toString());
//     historySushi.unshift(actualSushi);
//     const historyTuna = JSON.parse((await contract.evaluateTransaction('getHistory', actualSushi.tunaId.toString())).toString());
//     const actualTuna = JSON.parse((await contract.evaluateTransaction('queryTuna', actualSushi.tunaId.toString())).toString());
//     historyTuna.unshift(actualTuna);
//     res.json({
//       historySushi: historySushi,
//       historyTuna: historyTuna
//     });
//   } catch (error) {
//     console.error(`Failed to evaluate transaction: ${error}`);
//     res.status(500).json({
//       error: error
//     });
//   }
// })

// app.get('/api/getShushi/:id', async function (req, res) {
//   try {
//     const contract = await fabricNetwork.connectNetwork('connection-retailer.json', 'wallet/wallet-retailer');
//     const result = await contract.evaluateTransaction('queryAsset', req.params.id.toString());
//     let response = JSON.parse(result.toString());
//     res.json(response);
//   } catch (error) {
//     console.error(`Failed to evaluate transaction: ${error}`);
//     res.status(500).json({
//       error: error
//     });
//   }
// })


// app.post('/api/addShushi', async function (req, res) {
//   try {
//     const contract = await fabricNetwork.connectNetwork('connection-manufacturer.json', 'wallet/wallet-manufacturer');
//     let sushi = {
//       id: req.body.id,
//       latitude: req.body.latitude,
//       longitude: req.body.longitude,
//       type: req.body.type,
//       tunaId: req.body.tunaId
//     }
//     let tx = await contract.submitTransaction('addAsset', JSON.stringify(sushi));
//     res.json({
//       status: 'OK - Transaction has been submitted',
//       txid: tx.toString()
//     });
//   } catch (error) {
//     console.error(`Failed to evaluate transaction: ${error}`);
//     res.status(500).json({
//       error: error
//     });
//   }

// })


app.listen(3000, ()=>{
  console.log("***********************************");
  console.log("API server listening at localhost:3000");
  console.log("***********************************");
});