// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract FlipkarEhr {
    struct Patient {
        address patientAddr;
        string aadhaarNum;
        // mapping(address=>bool)
        mapping(address => bool) allowedHIUs;
        mapping(address => bool) HIPsAddedMap;
        address[] HIPsAdded;
        // address[] doctors;
        // string [] appointments;
        // string cid;
    }
    struct HIP {
        address hipAddr;
        string name;
        string email;
    }
    struct HIU {
        address hiuAddr;
        string name;
        string email;
        mapping(address => bool) consent;
    }
    // Mappings Related to Patients
    mapping(string => address) aadharToAddress;
    mapping(address => bool) patientsMap;
    mapping(address => Patient) patients;
    //Mappings Related to HIPs
    mapping(address => bool) HIPsMap;
    mapping(address => HIP) hips;
    //Mappings Related to HIUs
    mapping(address => bool) HIUsMap;
    mapping(address => HIU) hius;

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
        require(
            getIsHIP(patientAddr) == false,
            "This address is registered as a HIP facility."
        );
        require(
            getIsPatient(patientAddr) == false,
            "A patient is already registered with other role using this account address."
        );
        // isPatient[patientAddr] = true;
        // patients[patientAddr] = cid;
        patientsMap[patientAddr] = true;
        aadharToAddress[aadhaarNum] = patientAddr;
        Patient storage patient = patients[patientAddr];
        patient.patientAddr = patientAddr;
        patient.aadhaarNum = aadhaarNum;
        // patient.cid = cid;
        // return true;
    }

    function giveConsent(address patientAddr, address hiuAddr) public {
        require(
            patientsMap[patientAddr] == true,
            "Given address is not of a registered patient"
        );
        Patient storage patient = patients[patientAddr];
        patient.allowedHIUs[hiuAddr] = true;
    }

    function revokeConsent(address patientAddr, address hiuAddr) public {
        require(
            patientsMap[patientAddr] == true,
            "Given address is not of a registered patient"
        );
        Patient storage patient = patients[patientAddr];
        patient.allowedHIUs[patientAddr] = false;
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
        HIPsMap[hipAddr] = true;
        HIP storage hip = hips[hipAddr];
        hip.hipAddr = hipAddr;
        hip.name = name;
        hip.email = email;
    }

    function getHIP(
        address hipAddr
    ) public view returns (string memory, string memory) {
        require(
            HIPsMap[hipAddr] == true,
            "The associated address is not of a registered HIP."
        );
        return (hips[hipAddr].name, hips[hipAddr].email);
    }

    //Functions related to HIUs
    function getIsHIU(address hiuAddr) public view returns (bool) {
        if (HIUsMap[hiuAddr] == true) {
            return true;
        }
        return false;
    }

    function addNewHIU(
        address hiuAddr,
        string memory name,
        string memory email
    ) public {
        require(
            getIsPatient(hiuAddr) == false,
            "This account is already registered with Patient role"
        );
        require(
            getIsHIU(hiuAddr) == false,
            "A HIU is already registered using this account address."
        );
        HIUsMap[hiuAddr] = true;
        HIU storage hiu = hius[hiuAddr];
        hiu.hiuAddr = hiuAddr;
        hiu.name = name;
        hiu.email = email;
    }

    function getHIU(
        address hiuAddr
    ) public view returns (string memory, string memory) {
        require(
            HIUsMap[hiuAddr] == true,
            "The associated address is not of a registered HIU."
        );
        return (hius[hiuAddr].name, hius[hiuAddr].email);
    }

    function hasConsent(
        address hiuAddr,
        address patientAddr
    ) public view returns (bool) {
        require(
            HIUsMap[hiuAddr] == true,
            "The given address is not of a registered HIU"
        );
        require(
            patientsMap[patientAddr] == true,
            "Given address is not of a registered patient"
        );
        Patient storage patient = patients[patientAddr];
        if (patient.allowedHIUs[hiuAddr]) {
            return true;
        }
        return false;
    }

    function addRecord(address patientAddr, address hipAddr) public {
        Patient storage patient = patients[patientAddr];
        patient.HIPsAddedMap[hipAddr] = true;
        patient.HIPsAdded.push(hipAddr);
    }

    function requestRecords(
        address hiuAddr,
        address patientAddr
    ) public view returns (address[] memory) {
        require(
            hasConsent(hiuAddr, patientAddr) == true,
            "Does not have the consent of the patient"
        );
        Patient storage patient = patients[patientAddr];
        uint count = 0;
        for (uint256 i = 0; i < patient.HIPsAdded.length; i++) {
            if (patient.HIPsAddedMap[patient.HIPsAdded[i]] == true) {
                // result.push(patient.HIPsAdded[i]);
                count++;
            }
        }
        address[] memory result = new address[](count);
        count = 0;
        for (uint256 i = 0; i < patient.HIPsAdded.length; i++) {
            if (patient.HIPsAddedMap[patient.HIPsAdded[i]] == true) {
                result[count] = patient.HIPsAdded[i];
                count++;
            }
        }
        return result;
    }
}
