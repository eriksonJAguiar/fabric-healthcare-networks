import { HealthcareLogsContract } from "../lib/healthcare-logs-contract.js";

const port = 5000
const express = require('express');

const app = express();



app.get('/', (req, res) => {
    res.send([{title: 'Welcome to blockchain api'}]);
});

app.get('/readLogs:id', async (req, res) => {
    const log = await healthcareLogsContract.readHealthcareLogs(req.params.id);

    res.send(log);
});


app.post('/addLogs:id', async (req, res) => {
    await healthcareLogsContract.createHealthcareLogs(req.params.id, req.params.acessUser, req.params.owner, req.params.documentId, req.params.documentType, req.params.timeAccess);
    res.send([{title: 'Elementos adicionados'}]); 
});


app.listen(port, () => {
    console.log('listening on port ${port}');
  });