package main

import (
	"encoding/json"
	"fmt"
	"strconv"
	"time"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

type Record struct {
	RecordId     int       	   `json:"recordId"`
	Timestamp    time.Time 	   `json:"Time"`
	Parameter    string	       `json:"Parameter"`
	Value    	 float32 	   `json:"Value"`
}

/*type Owner struct {
	Id                     int
	name, lastname, gender string
}*/

type RecordsChaincode struct {
}

/*func (r *Record) chageOwner(owner Owner) {
	r.Patient = owner
}*/

func (t *RecordsChaincode) Init(stub shim.ChaincodeStubInterface) pb.Response {
	return shim.Success(nil)
}

func (t *RecordsChaincode) initRecord(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var err error

	fmt.Println("Total de parametros" + strconv.Itoa(len(args)))

	if len(args) != 3 {
		return shim.Error("Incorrect number of arguments. Expecting 3")
	}

	fmt.Println("- start init Records")

	if len(args[0]) <= 0 {
		return shim.Error("1st argument must be a non-empty string")
	} 
	
	else if len(args[1]) <= 0 {
		return shim.Error("2st argument must be a non-empty string")
	} 
	
	else if len(args[2]) <= 0 {
		return shim.Error("3st argument must be a non-empty string")

	recordId, err := strconv.Atoi(args[0])

	if err != nil {
		return shim.Error("First argument must be a numeric string")
	}

	timestamp := time.Now()

	paramter := args[1]
	
	value, err := strconv.Atoi(args[2])

	if err != nil {
		return shim.Error("Third argument must be a numeric string")
	}
	

	recordBytes, err := stub.GetState(args[0])

	if err != nil {
		return shim.Error("Failed to get pet: " + err.Error())
	} 
	
	else if recordBytes != nil {
		return shim.Error("This record already exists: " + args[0])
	}

	rec := &Record{RecordId: recordId, Timestamp: timestamp, Parameter: parameter, Value: value}

	// Generate JSON object from Go object
	recordJson, err := json.Marshal(rec)

	if err != nil {
		return shim.Error(err.Error())
	}

	err = stub.PutState(strconv.Itoa(recordId), recordJson)
	if err != nil {
		return shim.Error(err.Error())
	}

	fmt.Println("- End init Record")
	return shim.Success(nil)

}

func (t *RecordsChaincode) createIndex(stub shim.ChaincodeStubInterface, indexName string, attributes []string) error {
	fmt.Println("- Start create index")

	var err error

	indexKey, err := stub.CreateCompositeKey(indexName, attributes)
	if err != nil {
		return err
	}

	value := []byte{0x00}
	stub.PutState(indexKey, value)

	fmt.Println("- End create index")
	return nil
}

func (t *RecordsChaincode) deleteIndex(stub shim.ChaincodeStubInterface, indexName string, attributes []string) error {
	fmt.Println("- start delete index")

	indexKey, err := stub.CreateCompositeKey(indexName, attributes)
	if err != nil {
		return err
	}

	stub.DelState(indexKey)

	fmt.Println("- End delete index")
	return nil
}

func (t *RecordsChaincode) deleteRecord(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var jsonResp string
	var recordJson Record

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	recordId := args[0]

	valBytes, err := stub.GetState(recordId)

	if err != nil {
		jsonResp = "{\"Error\":\"Failed to get state for " + recordId + "\"}"
		return shim.Error(jsonResp)
	} 
	
	else if valBytes == nil {
		jsonResp = "{\"Error\":\"Record does not exist: " + recordId + "\"}"
		return shim.Error(jsonResp)
	}

	err = json.Unmarshal([]byte(valBytes), &recordJson)

	if err != nil {
		jsonResp = "{\"Error\":\"Failed to decode JSON of: " + recordId + "\"}"
		return shim.Error(jsonResp)
	}

	err = stub.DelState(recordId)

	if err != nil {
		return shim.Error("Failed to delete state:" + err.Error())
	}

	return shim.Success(nil)

}

func (t *RecordsChaincode) readRecord(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var recordId, jsonResp string
	var err error

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting record number of the Record to query")
	}

	recordId = args[0]

	valBytes, err := stub.GetState(recordId)

	if err != nil {
		jsonResp = "{\"Error\":\"Failed to get state for " + recordId + "\"}"
		return shim.Error(jsonResp)
	} 
	
	else if valBytes == nil {
		jsonResp = "{\"Error\":\"Record does not exist: " + recordId + "\"}"
		return shim.Error(jsonResp)
	}

	return shim.Success(valBytes)
}

func (t *RecordsChaincode) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	fun, args := stub.GetFunctionAndParameters()
	
	fmt.Println("Invoke is runing " + fun)

	if fun == "initRecord" {
		return t.initRecord(stub, args)
	} 
	
	else if fun == "readRecord" {
		return t.readRecord(stub, args)
	} 
	
	else if fun == "deleteRecord" {
		return t.deleteRecord(stub, args)
	}

	fmt.Println("invoke did not find func: " + fun) // Invoke error logging
	return shim.Error("Received unknown function invocation")
}
