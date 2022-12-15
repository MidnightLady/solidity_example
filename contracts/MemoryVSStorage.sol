// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract MemoryVSStorage
{
    // Initialising array numbers
    int[] public number_array;


    function getMemory() public view returns (int[] memory){
        return number_array;
    }


    function Memory() public
    {
        number_array.push(1);

        //Creating a new instance
        int[] memory myArray = number_array;

        // Adding value to the
        // first index of the new Instance
        myArray[0] = 0;
    }

    function Storage() public
    {
        //creating a new instance
        int[] storage myArray = number_array;

        // Adding value to the first
        // index of the array myArray
        myArray[0] = 22;
    }
}