import {healthcareLogsContract as health}  from "./../api/healthcareLogsContract.js";

const port = 5000
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

const app = express();

app.use(bodyParser.json());
app.use(cors());
app.use(morgan('combined'));


app.get('/', (req, res) => {
    res.send([{title: 'Welcome to blockchain api'}]);
});

app.get('/readLogs:id', async (req, res) => {
    const log = await health.readHealthcareLogs(req.params.id);

    res.send(log);
});


app.post('/addLogs:id', async (req, res) => {
    await health.createHealthcareLogs(req.params.id, req.params.acessUser, req.params.owner, req.params.documentId, req.params.documentType, req.params.timeAccess);
    res.send([{title: 'Elmenetos adicionados'}]);
});


app.listen(port, () => {
    console.log('listening on port ${port}');
  });