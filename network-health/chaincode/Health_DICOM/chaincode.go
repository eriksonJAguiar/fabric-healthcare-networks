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
	DicomID              int       `json:"dicomId"`
	PatientFirstname     string    `json:"patient_firstname"`
	PatientLastname      string    `json:"patient_lastname"`
	PatientTelephone     string    `json:"patient_telephone"`
	PatientAddress       string    `json:"patient_address"`
	PatientAge           int       `json:"patient_age"`
	PatientBirth         string    `json:"patient_birth"`
	PatientOrganization  string    `json:"patient_lastname"`
	PatientMothername    string    `json:"patient_mothername"`
	PatientReligion      string    `json:"patient_religion"`
	PatientSex           string    `json:"patient_sex"`
	PatientGender        string    `json:"patient_gender"`
	PatientInsuranceplan string    `json:"patient_insuranceplan"`
	PatientWeigth        int       `json:"patient_weigth"`
	PatientHeigth        int       `json:"patient_heigth"`
	Machinemodel         string    `json:"machinemodel"`
	Timestamp            time.Time `json:"timestamp"`
}

type Log struct {
	LogID        int       `json:"dicomId"`
	AssetToken   string    `json:"asset_token"`
	TypeAsset    string    `json:"type_asset"`
	OwnerAsset   string    `json:"owner_asset"`
	HproviderGet string    `json:"hprovider_get"`
	Timestamp    time.Time `json:"timestamp"`
	WhoAccessed  string    `json:"who_accessed"`
	AccessLevel  int       `json:"access_level"`
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

	dicomID, err := strconv.Atoi(args[0])
	if err != nil {
		return shim.Error("1 argument must be a numeric string")
	}
	patientAge, err := strconv.Atoi(args[5])
	if err != nil {
		return shim.Error("7 argument must be a numeric string")
	}
	timestamp := time.Now()
	patientWeigth, err := strconv.Atoi(args[13])
	if err != nil {
		return shim.Error("14 argument must be a numeric string")
	}
	patientHeigth, err := strconv.Atoi(args[14])
	if err != nil {
		return shim.Error("15 argument must be a numeric string")
	}

	patientFirstname := args[1]
	patientLastname := args[2]
	patientTelephone := args[3]
	patientAddress := args[4]
	patientBirth := args[6]
	patientOrganization := args[7]
	patientMothername := args[8]
	patientReligion := args[9]
	patientSex := args[10]
	patientGender := args[11]
	patientInsuranceplan := args[12]
	machinemodel := args[15]

	dicomBytes, err := stub.GetState(args[0])
	if err != nil {
		return shim.Error("Failed to get pet: " + err.Error())
	} else if dicomBytes != nil {
		return shim.Error("This patient already exists: " + args[0])
	}

	rec := &Dicom{
		DicomID:              dicomID,
		PatientFirstname:     patientFirstname,
		PatientLastname:      patientLastname,
		PatientTelephone:     patientTelephone,
		PatientAddress:       patientAddress,
		PatientAge:           patientAge,
		PatientBirth:         patientBirth,
		PatientOrganization:  patientOrganization,
		PatientMothername:    patientMothername,
		PatientReligion:      patientReligion,
		PatientSex:           patientSex,
		PatientGender:        patientGender,
		PatientInsuranceplan: patientInsuranceplan,
		PatientWeigth:        patientWeigth,
		PatientHeigth:        patientHeigth,
		Machinemodel:         machinemodel,
		Timestamp:            timestamp,
	}

	dicomJSON, err := json.Marshal(rec)

	if err != nil {
		return shim.Error(err.Error())
	}

	err = stub.PutState(strconv.Itoa(dicomID), dicomJSON)
	if err != nil {
		return shim.Error(err.Error())
	}

	fmt.Println("- End save Dicom")
	return shim.Success(nil)

}

func (t *HealthcareChaincode) getDicom(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var dicomID, jsonResp string
	var err error

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting dicom number of the Record to query")
	}

	dicomID = args[0]

	valBytes, err := stub.GetState(dicomID)
	if err != nil {
		jsonResp = "{\"Error\":\"Failed to get state for " + dicomID + "\"}"
		return shim.Error(jsonResp)
	} else if valBytes == nil {
		jsonResp = "{\"Error\":\"Record does not exist: " + dicomID + "\"}"
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

	logID, err := strconv.Atoi(args[0])
	if err != nil {
		return shim.Error("1 argument must be a numeric string")
	}
	accessLevel, err := strconv.Atoi(args[7])
	if err != nil {
		return shim.Error("8 argument must be a numeric string")
	}

	assetToken := args[1]
	typeAsset := args[2]
	ownerAsset := args[3]
	hproviderGet := args[4]
	timestamp := time.Now()
	whoAccessed := args[6]

	dicomBytes, err := stub.GetState(args[0])
	if err != nil {
		return shim.Error("Failed to get pet: " + err.Error())
	} else if dicomBytes != nil {
		return shim.Error("This patient already exists: " + args[0])
	}

	rec := &Log{
		LogID:        logID,
		AssetToken:   assetToken,
		TypeAsset:    typeAsset,
		OwnerAsset:   ownerAsset,
		HproviderGet: hproviderGet,
		Timestamp:    timestamp,
		WhoAccessed:  whoAccessed,
		AccessLevel:  accessLevel,
	}

	logJSON, err := json.Marshal(rec)

	if err != nil {
		return shim.Error(err.Error())
	}

	err = stub.PutState(strconv.Itoa(logID), logJSON)
	if err != nil {
		return shim.Error(err.Error())
	}

	fmt.Println("- End save Dicom")
	return shim.Success(nil)

}

func (t *HealthcareChaincode) getLog(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var logID, jsonResp string
	var err error

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting Logs number of the Record to query")
	}

	logID = args[0]

	valBytes, err := stub.GetState(logID)
	if err != nil {
		jsonResp = "{\"Error\":\"Failed to get state for " + logID + "\"}"
		return shim.Error(jsonResp)
	} else if valBytes == nil {
		jsonResp = "{\"Error\":\"Record does not exist: " + logID + "\"}"
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
