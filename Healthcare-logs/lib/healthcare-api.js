const { HealthcareLogsContract } = require("healthcare-logs-contract.js");
const { ChaincodeStub, ClientIdentity } = require('fabric-shim');
//const { HealthcareLogsContract } = require('../lib/healthcare-logs-contract');
const port = 5000
const express = require('express');
const winston = require('winston');
const chai = require('chai');
const chaiAsPromised = require('chai-as-promised');
const sinon = require('sinon');
const sinonChai = require('sinon-chai');
/*const bodyParser = require('body-parser');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');*/

const app = express();
chai.should();
chai.use(chaiAsPromised);
chai.use(sinonChai);

/*app.use(bodyParser.json());
app.use(cors());
app.use(morgan('combined'));*/

class ApiContext {

    constructor() {
        this.stub = sinon.createStubInstance(ChaincodeStub);
        this.clientIdentity = sinon.createStubInstance(ClientIdentity);
        this.logging = {
            getLogger: sinon.stub().returns(sinon.createStubInstance(winston.createLogger().constructor)),
            setLevel: sinon.stub(),
        };
    }

}

const ctx = new ApiContext();
const contract = new HealthcareLogsContract();


app.get('/', (req, res) => {
    res.send([{title: 'Welcome to blockchain api'}]);
});

app.get('/readLogs:id', async (req, res) => {
    const log = await contract.readHealthcareLogs(ctx,req.params.id);

    res.send(log);
});


app.post('/addLogs:id', async (req, res) => {
    await contract.createHealthcareLogs(ctx,req.params.id, req.params.acessUser, req.params.owner, req.params.documentId, req.params.documentType, req.params.timeAccess);
    res.send([{title: 'Elmenetos adicionados'}]);
});


app.listen(port, () => {
    console.log('listening on port ${port}');
  });