// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 private storedData;

    event DataStored(uint256 data);

    function setStoredData(uint256 data) external{
        storedData = data;
        emit DataStored(storedData);
    }
}