var express = require('express');
var bodyParser = require('body-parser');

var app = express();
app.use(bodyParser.json());

// Setting for Hyperledger Fabric
const { FileSystemWallet, Gateway } = require('fabric-network');
const path = require('path');
const ccpPath = path.resolve(__dirname, '.', 'Config', 'connection-profile.json');
const { exec } = require('child_process');


// app.get('/api/queryallcars', async function (req, res) {
//     try {

//         // Create a new file system based wallet for managing identities.
//         const walletPath = path.join(process.cwd(), 'wallet');
//         const wallet = new FileSystemWallet(walletPath);
//         console.log(`Wallet path: ${walletPath}`);

//         // Check to see if we've already enrolled the user.
//         const userExists = await wallet.exists('user1');
//         if (!userExists) {
//             console.log('An identity for the user "user1" does not exist in the wallet');
//             console.log('Run the registerUser.js application before retrying');
//             return;
//         }

//         // Create a new gateway for connecting to our peer node.
//         const gateway = new Gateway();
//         await gateway.connect(ccpPath, { wallet, identity: 'user1', discovery: { enabled: true, asLocalhost: false } });

//         // Get the network (channel) our contract is deployed to.
//         const network = await gateway.getNetwork('healthchannel');

//         // Get the contract from the network.
//         const contract = network.getContract('fabcar');

//         // Evaluate the specified transaction.
//         // queryCar transaction - requires 1 argument, ex: ('queryCar', 'CAR4')
//         // queryAllCars transaction - requires no arguments, ex: ('queryAllCars')
//         const result = await contract.evaluateTransaction('queryAllCars');
//         console.log(`Transaction has been evaluated, result is: ${result.toString()}`);
//         res.status(200).json({response: result.toString()});

//     } catch (error) {
//         console.error(`Failed to evaluate transaction: ${error}`);
//         res.status(500).json({error: error});
//         process.exit(1);
//     }
// });


app.get('/api/readHealthcareLabs/:index', async function (req, res) {
    try {

        //req.params.index

        const cmd = 'docker exec -it cli peer chaincode query -n HRecords-contract -c '; 
	    
	const cmd2 = `'{"Args":["readHealthcareLabs","${req.params.index}"]}'`;
	
	const cmd3 = ' -C healthchannel';

	const fullcmd = cmd + cmd2.toString() + cmd3;

        exec('ls', (err, stdout, stderr) => {
            if (err) {
                console.error(err)
            } else {
            console.log(`stdout: ${stdout}`);
            console.log(`stderr: ${stderr}`);
            }
        });

    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        res.status(500).json({error: error});
        process.exit(1);
    }
});

app.post('/api/createHealthcareLabs/', async function (req, res) {
    try {

        //await contract.submitTransaction('createHealthcareLabs', req.body.labsId, req.body.refDocument, req.body.refIFPS, req.body.owner, req.body.documentType, Date.now().toString());
        //console.log('Transaction has been submitted');
        //res.send('Transaction has been submitted');

        // Disconnect from the gateway.
        // await gateway.disconnect();

        const args = `{"Args":["createHealthcareLabs","${req.body.labsId}", "${req.body.refDocument}", "${req.body.refIFPS}", "${req.body.owner}", "${req.body.documentType}", "${Date.now().toString()}"]}`;

        exec(`docker exec -it cli peer chaincode invoke -n HRecords-contract -c ${args} -C healthchannel`, (err, stdout, stderr) => {
            if (err) {
                console.error(err)
            } else {
            console.log(`stdout: ${stdout}`);
            console.log(`stderr: ${stderr}`);
            }
        });

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        process.exit(1);
    }
})

// app.put('/api/changeowner/:car_index', async function (req, res) {
//     try {

//         // Create a new file system based wallet for managing identities.
//         const walletPath = path.join(process.cwd(), 'wallet');
//         const wallet = new FileSystemWallet(walletPath);
//         console.log(`Wallet path: ${walletPath}`);

//         // Check to see if we've already enrolled the user.
//         const userExists = await wallet.exists('user1');
//         if (!userExists) {
//             console.log('An identity for the user "user1" does not exist in the wallet');
//             console.log('Run the registerUser.js application before retrying');
//             return;
//         }

//         // Create a new gateway for connecting to our peer node.
//         const gateway = new Gateway();
//         await gateway.connect(ccpPath, { wallet, identity: 'user1', discovery: { enabled: true, asLocalhost: false } });

//         // Get the network (channel) our contract is deployed to.
//         const network = await gateway.getNetwork('healthchannel');

//         // Get the contract from the network.
//         const contract = network.getContract('fabcar');

//         // Submit the specified transaction.
//         // createCar transaction - requires 5 argument, ex: ('createCar', 'CAR12', 'Honda', 'Accord', 'Black', 'Tom')
//         // changeCarOwner transaction - requires 2 args , ex: ('changeCarOwner', 'CAR10', 'Dave')
//         await contract.submitTransaction('changeCarOwner', req.params.car_index, req.body.owner);
//         console.log('Transaction has been submitted');
//         res.send('Transaction has been submitted');

//         // Disconnect from the gateway.
//         await gateway.disconnect();

//     } catch (error) {
//         console.error(`Failed to submit transaction: ${error}`);
//         process.exit(1);
//     }	
// })
process.env.PORT = 8080
app.listen(process.env.PORT, () =>
  console.log(`App listening on port ${process.env.PORT}!`),
);
