// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract FlipkarEhr {
    struct Patient {
        address patientAddr;
        string aadhaarNum;
        // mapping(address=>bool)
        // mapping(address => bool) allowedDoctor;
        // address[] doctors;
        // string [] appointments;
        // string cid;
    }
    struct HIP {
        address hipAddr;
        string name;
        string email;
    }
    // Mappings Related to Patients
    mapping(string => address) aadharToAddress;
    mapping(address => bool) patientsMap;
    mapping(address => Patient) patients;
    //Mappings Related to HIPs
    mapping(address => bool) HIPsMap;
    mapping(address => HIP) hips;

    //Functions related to Patients
    function getIsPatient(address patientAddr) public view returns (bool) {
        if (patientsMap[patientAddr] == true) {
            return true;
        }
        return false;
    }

    function checkPatientAgainstAadhar(
        string memory aadhaarNum
    ) public view returns (bool) {
        address checkAddr = aadharToAddress[aadhaarNum];
        if (checkAddr == address(0)) {
            return false;
        } else {
            return true;
        }
    }

    function addNewPatient(
        address patientAddr,
        string calldata aadhaarNum
    ) public {
        // require(
        //     getIsDoctor(patientAddr) == false,
        //     "This address is registered for a doctor."
        // );
        require(
            getIsPatient(patientAddr) == false,
            "A patient is already registered with other role using this account address."
        );
        // isPatient[patientAddr] = true;
        // patients[patientAddr] = cid;
        aadharToAddress[aadhaarNum] = patientAddr;
        Patient storage patient = patients[patientAddr];
        patient.patientAddr = patientAddr;
        patient.aadhaarNum = aadhaarNum;
        // patient.cid = cid;
        // return true;
    }

    //Functions related to HIPs
    function getIsHIP(address hipAddr) public view returns (bool) {
        if (HIPsMap[hipAddr] == true) {
            return true;
        }
        return false;
    }

    function addNewHIP(
        address hipAddr,
        string memory name,
        string memory email
    ) public {
        require(
            getIsPatient(hipAddr) == false,
            "This account is already registered with Patient role"
        );
        require(
            getIsHIP(hipAddr) == false,
            "A HIP is already registered using this account address."
        );
        HIP storage hip = hips[hipAddr];
        hip.hipAddr = hipAddr;
        hip.name = name;
        hip.email = email;
    }
}
