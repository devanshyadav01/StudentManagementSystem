# School Grading System Smart Contract
# Overview

The SchoolGradingSystem contract manages a simple school grading system on the Ethereum blockchain. It allows the owner to enroll students, assign grades, update student information, and retrieve student grades.

## Contract Details
Contract Name: SchoolGradingSystem
Solidity Version: ^0.8.0
License: MIT License
## Features

### Enroll Student
Function: enrollStudent(address _studentAddress, string memory _name)
Description: Enrolls a new student with their Ethereum address and name.

### Update Student Name

Function: updateStudentName(address _studentAddress, string memory _newName)
Description: Updates the name of an enrolled student.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SchoolGradingSystem {
    struct Student {
        string name;
        uint grade;
        bool isEnrolled;
    }

    mapping(address => Student) private students;
    address[] private studentList;  // Maintain a list of enrolled students
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Function to enroll a student
    function enrollStudent(address _studentAddress, string memory _name) public onlyOwner {
        require(!students[_studentAddress].isEnrolled, "Student is already enrolled");
        students[_studentAddress] = Student(_name, 0, true);
        studentList.push(_studentAddress);
    }

    // Function to update a student's name
    function updateStudentName(address _studentAddress, string memory _newName) public onlyOwner {
        require(students[_studentAddress].isEnrolled, "Student is not enrolled");
        students[_studentAddress].name = _newName;
    }

    // Function to assign a grade to a student
    function assignGrade(address _studentAddress, uint _grade) public onlyOwner {
        require(students[_studentAddress].isEnrolled, "Student is not enrolled");
        require(_grade <= 100, "Grade must be between 0 and 100");

        students[_studentAddress].grade = _grade;

        // Assert to ensure the grade is set correctly
        assert(students[_studentAddress].grade == _grade);
    }

    // Function to get a student's grade
    function getGrade(address _studentAddress) public view returns (string memory name, uint grade) {
        require(students[_studentAddress].isEnrolled, "Student is not enrolled");

        Student memory student = students[_studentAddress];
        return (student.name, student.grade);
    }

    // Function to unenroll a student
    function unenrollStudent(address _studentAddress) public onlyOwner {
        require(students[_studentAddress].isEnrolled, "Student is not enrolled");

        // Remove from mapping and studentList
        delete students[_studentAddress];
        for (uint i = 0; i < studentList.length; i++) {
            if (studentList[i] == _studentAddress) {
                studentList[i] = studentList[studentList.length - 1];
                studentList.pop();
                break;
            }
        }
    }

    // Function to retrieve the total number of enrolled students
    function getTotalStudents() public view returns (uint) {
        return studentList.length;
    }

    // Function to retrieve the address of a student by index
    function getStudentAddress(uint _index) public view returns (address) {
        require(_index < studentList.length, "Index out of bounds");
        return studentList[_index];
    }
}




## Help

For common issues, consider the following:

1.Compilation Errors: Ensure you are using the correct Solidity version (0.8.0 or higher).

2.Deployment Issues: Check your network configuration and ensure you have sufficient funds in your MetaMask account for gas fees.

3.Function Errors: Review the function requirements and error messages. For example, division by zero will trigger a revert() with a custom message.

## Authors

Contributors names and contact info

Devansh Satsangi
[devanshyadav566@gmail.com]


## License

This project is licensed under the MIT License - see the LICENSE.md file for details
