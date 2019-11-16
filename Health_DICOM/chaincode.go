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
	if len(args) < 17 || len(args) > 17 {
		return shim.Error("Incorrect number of arguments. Expecting 18")
	}

	fmt.Println("- start init Dicom")
	if len(args[0]) <= 0 {
		return shim.Error("1st argument must be a non-empty string")
	} else if len(args[1]) <= 0 {
		return shim.Error("2nd argument must be a non-empty string")
	} else if len(args[2]) <= 0 {
		return shim.Error("3rd argument must be a non-empty string")
	} else if len(args[3]) <= 0 {
		return shim.Error("4th argument must be a non-empty string")
	} else if len(args[4]) <= 0 {
		return shim.Error("5th argument must be a non-empty string")
	} else if len(args[5]) <= 0 {
		return shim.Error("6th argument must be a non-empty string")
	} else if len(args[6]) <= 0 {
		return shim.Error("7th argument must be a non-empty string")
	} else if len(args[7]) <= 0 {
		return shim.Error("8th argument must be a non-empty string")
	} else if len(args[8]) <= 0 {
		return shim.Error("9th argument must be a non-empty string")
	} else if len(args[9]) <= 0 {
		return shim.Error("10th argument must be a non-empty string")
	} else if len(args[10]) <= 0 {
		return shim.Error("11th argument must be a non-empty string")
	} else if len(args[11]) <= 0 {
		return shim.Error("12th argument must be a non-empty string")
	} else if len(args[12]) <= 0 {
		return shim.Error("13th argument must be a non-empty string")
	} else if len(args[13]) <= 0 {
		return shim.Error("14th argument must be a non-empty string")
	} else if len(args[14]) <= 0 {
		return shim.Error("15th argument must be a non-empty string")
	} else if len(args[15]) <= 0 {
		return shim.Error("16th argument must be a non-empty string")
	} else if len(args[16]) <= 0 {
		return shim.Error("17th argument must be a non-empty string")
	}

	dicomId, err := strconv.Atoi(args[0])
	if err != nil {
		return shim.Error("1 argument must be a numeric string")
	}
	patient_age, err := strconv.Atoi(args[5])
	if err != nil {
		return shim.Error("7 argument must be a numeric string")
	}
	timestamp := time.Now()
	patient_weigth, err := strconv.Atoi(args[13])
	if err != nil {
		return shim.Error("14 argument must be a numeric string")
	}
	patient_heigth, err := strconv.Atoi(args[14])
	if err != nil {
		return shim.Error("15 argument must be a numeric string")
	}

	patient_firstname := args[1]
	patient_lastname := args[2]
	patient_telephone := args[3]
	patient_address := args[4]
	patient_birth := args[6]
	patient_organization := args[7]
	patient_mothername := args[8]
	patient_religion := args[9]
	patient_sex := args[10]
	patient_gender := args[11]
	patient_insuranceplan := args[12]
	machinemodel := args[15]

	dicomBytes, err := stub.GetState(args[0])
	if err != nil {
		return shim.Error("Failed to get pet: " + err.Error())
	} else if dicomBytes != nil {
		return shim.Error("This patient already exists: " + args[0])
	}

	rec := &Dicom{
		DicomId:               dicomId,
		Patient_firstname:     patient_firstname,
		Patient_lastname:      patient_lastname,
		Patient_telephone:     patient_telephone,
		Patient_address:       patient_address,
		Patient_age:           patient_age,
		Patient_birth:         patient_birth,
		Patient_organization:  patient_organization,
		Patient_mothername:    patient_mothername,
		Patient_religion:      patient_religion,
		Patient_sex:           patient_sex,
		Patient_gender:        patient_gender,
		Patient_insuranceplan: patient_insuranceplan,
		Patient_weigth:        patient_weigth,
		Patient_heigth:        patient_heigth,
		Machinemodel:          machinemodel,
		Timestamp:             timestamp,
	}

	dicomJson, err := json.Marshal(rec)

	if err != nil {
		return shim.Error(err.Error())
	}

	err = stub.PutState(strconv.Itoa(dicomId), dicomJson)
	if err != nil {
		return shim.Error(err.Error())
	}

	fmt.Println("- End save Dicom")
	return shim.Success(nil)

}

func (t *HealthcareChaincode) getDicom(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var dicomId, jsonResp string
	var err error

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting dicom number of the Record to query")
	}

	dicomId = args[0]

	valBytes, err := stub.GetState(dicomId)
	if err != nil {
		jsonResp = "{\"Error\":\"Failed to get state for " + dicomId + "\"}"
		return shim.Error(jsonResp)
	} else if valBytes == nil {
		jsonResp = "{\"Error\":\"Record does not exist: " + dicomId + "\"}"
		return shim.Error(jsonResp)
	}

	return shim.Success(valBytes)
}

func (t *HealthcareChaincode) saveLog(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var err error

	fmt.Println("Parameter number" + strconv.Itoa(len(args)))
	if len(args) < 8 || len(args) > 8 {
		return shim.Error("Incorrect number of arguments. Expecting 18")
	}

	fmt.Println("- start save Logs")
	if len(args[0]) <= 0 {
		return shim.Error("1st argument must be a non-empty string")
	} else if len(args[1]) <= 0 {
		return shim.Error("2nd argument must be a non-empty string")
	} else if len(args[2]) <= 0 {
		return shim.Error("3rd argument must be a non-empty string")
	} else if len(args[3]) <= 0 {
		return shim.Error("4th argument must be a non-empty string")
	} else if len(args[4]) <= 0 {
		return shim.Error("5th argument must be a non-empty string")
	} else if len(args[5]) <= 0 {
		return shim.Error("6th argument must be a non-empty string")
	} else if len(args[6]) <= 0 {
		return shim.Error("7th argument must be a non-empty string")
	} else if len(args[7]) <= 0 {
		return shim.Error("8th argument must be a non-empty string")
	}

	logId, err := strconv.Atoi(args[0])
	if err != nil {
		return shim.Error("1 argument must be a numeric string")
	}
	access_level, err := strconv.Atoi(args[7])
	if err != nil {
		return shim.Error("8 argument must be a numeric string")
	}

	asset_token := args[1]
	type_asset := args[2]
	owner_asset := args[3]
	hprovider_get := args[4]
	timestamp := time.Now()
	who_accessed := args[6]

	dicomBytes, err := stub.GetState(args[0])
	if err != nil {
		return shim.Error("Failed to get pet: " + err.Error())
	} else if dicomBytes != nil {
		return shim.Error("This patient already exists: " + args[0])
	}

	rec := &Log{
		LogId:         logId,
		Asset_token:   asset_token,
		Type_asset:    type_asset,
		Owner_asset:   owner_asset,
		Hprovider_get: hprovider_get,
		Timestamp:     timestamp,
		Who_accessed:  who_accessed,
		Access_level:  access_level,
	}

	logJson, err := json.Marshal(rec)

	if err != nil {
		return shim.Error(err.Error())
	}

	err = stub.PutState(strconv.Itoa(logId), logJson)
	if err != nil {
		return shim.Error(err.Error())
	}

	fmt.Println("- End save Dicom")
	return shim.Success(nil)

}

func (t *HealthcareChaincode) getLog(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var logId, jsonResp string
	var err error

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting Logs number of the Record to query")
	}

	logId = args[0]

	valBytes, err := stub.GetState(logId)
	if err != nil {
		jsonResp = "{\"Error\":\"Failed to get state for " + logId + "\"}"
		return shim.Error(jsonResp)
	} else if valBytes == nil {
		jsonResp = "{\"Error\":\"Record does not exist: " + logId + "\"}"
		return shim.Error(jsonResp)
	}

	return shim.Success(valBytes)
}

func (t *HealthcareChaincode) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	fun, args := stub.GetFunctionAndParameters()
	fmt.Println("Invoke is runing " + fun)

	if fun == "saveDicom" {
		return t.saveDicom(stub, args)
	} else if fun == "getDicom" {
		return t.getDicom(stub, args)
	} else if fun == "saveLog" {
		return t.saveLog(stub, args)
	} else if fun == "getLog" {
		return t.getLog(stub, args)
	}

	fmt.Println("invoke did not find func: " + fun) //error
	return shim.Error("Received unknown function invocation")
}
