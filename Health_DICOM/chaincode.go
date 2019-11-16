package main

import (
	"encoding/json"
	"fmt"
	"strconv"
	"time"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

type Dicom struct {
	DicomId               int       `json:"dicomId"`
	Patient_firstname     string    `json:"patient_firstname"`
	Patient_lastname      string    `json:"patient_lastname"`
	Patient_telephone     string    `json:"patient_telephone"`
	Patient_address       string    `json:"patient_address"`
	Patient_age           int       `json:"patient_age"`
	Patient_birth         string    `json:"patient_birth"`
	Patient_organization  string    `json:"patient_lastname"`
	Patient_mothername    string    `json:"patient_mothername"`
	Patient_religion      string    `json:"patient_religion"`
	Patient_sex           string    `json:"patient_sex"`
	Patient_gender        string    `json:"patient_gender"`
	Patient_insuranceplan string    `json:"patient_insuranceplan"`
	Patient_weigth        int       `json:"patient_weigth"`
	Patient_heigth        int       `json:"patient_heigth"`
	Machinemodel          string    `json:"machinemodel"`
	Timestamp             time.Time `json:"timestamp"`
}

type Log struct {
	LogId         int       `json:"dicomId"`
	Asset_token   string    `json:"asset_token"`
	Type_asset    string    `json:"type_asset"`
	Owner_asset   string    `json:"owner_asset"`
	Hprovider_get string    `json:"hprovider_get"`
	Timestamp     time.Time `json:"timestamp"`
	Who_accessed  string    `json:"who_accessed"`
	Access_level  int       `json:"access_level"`
}

type HealthcareChaincode struct {
}

func (t *HealthcareChaincode) Init(stub shim.ChaincodeStubInterface) pb.Response {
	return shim.Success(nil)
}

func (t *HealthcareChaincode) saveDicom(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var err error

	fmt.Println("Parameter number" + strconv.Itoa(len(args)))
	if len(args) < 18 || len(args) > 18 {
		return shim.Error("Incorrect number of arguments. Expecting 5")
	}

	/*fmt.Println("- start init Records")
	if len(args[0]) <= 0 {
		return shim.Error("1st argument must be a non-empty string")
	} else if len(args[1]) <= 0 {
		return shim.Error("2st argument must be a non-empty string")
	} else if len(args[2]) <= 0 {
		return shim.Error("3st argument must be a non-empty string")
	} else if len(args[3]) <= 0 {
		return shim.Error("4st argument must be a non-empty string")
	} else if len(args[4]) <= 0 {
		return shim.Error("5st argument must be a non-empty string")
	} else if len(args[5]) <= 0 {
		return shim.Error("6st argument must be a non-empty string")
	} else if len(args[6]) <= 0 {
		return shim.Error("7st argument must be a non-empty string")
	} else if len(args[7]) <= 0 {
		return shim.Error("8st argument must be a non-empty string")
	} else if len(args[8]) <= 0 {
		return shim.Error("9st argument must be a non-empty string")
	} else if len(args[9]) <= 0 {
		return shim.Error("10st argument must be a non-empty string")
	} else if len(args[10]) <= 0 {
		return shim.Error("11st argument must be a non-empty string")
	} else if len(args[11]) <= 0 {
		return shim.Error("4st argument must be a non-empty string")
	} else if len(args[4]) <= 0 {
		return shim.Error("5st argument must be a non-empty string")
	}*/

	recordId, err := strconv.Atoi(args[0])
	if err != nil {
		return shim.Error("1 argument must be a numeric string")
	}
	patient, err := strconv.Atoi(args[1])
	if err != nil {
		return shim.Error("2 argument must be a numeric string")
	}
	timestamp := time.Now()
	activity := args[2]
	cardiacFrequency, err := strconv.Atoi(args[3])
	if err != nil {
		return shim.Error("4 argument must be a numeric string")
	}
	location := args[4]

	recordBytes, err := stub.GetState(args[0])
	if err != nil {
		return shim.Error("Failed to get pet: " + err.Error())
	} else if recordBytes != nil {
		return shim.Error("This patient already exists: " + args[0])
	}

	rec := &Record{RecordId: recordId, Patient: patient, Timestamp: timestamp, Activity: activity, CardiacFrequency: cardiacFrequency, Location: location}

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

func (t *HealthcareChaincode) createIndex(stub shim.ChaincodeStubInterface, indexName string, attributes []string) error {
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

func (t *HealthcareChaincode) deleteIndex(stub shim.ChaincodeStubInterface, indexName string, attributes []string) error {
	fmt.Println("- start delete index")

	indexKey, err := stub.CreateCompositeKey(indexName, attributes)
	if err != nil {
		return err
	}

	stub.DelState(indexKey)

	fmt.Println("- End delete index")
	return nil
}

func (t *HealthcareChaincode) deleteRecord(stub shim.ChaincodeStubInterface, args []string) pb.Response {
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
	} else if valBytes == nil {
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

func (t *HealthcareChaincode) readRecord(stub shim.ChaincodeStubInterface, args []string) pb.Response {
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
	} else if valBytes == nil {
		jsonResp = "{\"Error\":\"Record does not exist: " + recordId + "\"}"
		return shim.Error(jsonResp)
	}

	return shim.Success(valBytes)
}

func (t *HealthcareChaincode) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	fun, args := stub.GetFunctionAndParameters()
	fmt.Println("Invoke is runing " + fun)

	if fun == "initChaicode" {
		return t.saveDicom(stub, args)
	} else if fun == "readDicom" {
		return t.readRecord(stub, args)
	} else if fun == "deleteRecord" {
		return t.deleteRecord(stub, args)
	}

	fmt.Println("invoke did not find func: " + fun) //error
	return shim.Error("Received unknown function invocation")
}
