// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SchoolGradingSystem {
    // Struct to represent a student
    struct Student {
        string name;    // Name of the student
        uint grade;     // Grade of the student (0-100)
        bool isEnrolled; // Flag indicating whether the student is enrolled
    }

    // Mapping to store students by their Ethereum address
    mapping(address => Student) private students;
    
    // Array to maintain a list of enrolled student addresses
    address[] private studentList;

    // Address of the contract owner
    address public owner;

    // Constructor to set the owner to the deployer of the contract
    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict access to only the owner of the contract
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Function to enroll a student
    function enrollStudent(address _studentAddress, string memory _name) public onlyOwner {
        // Check if the student is not already enrolled
        require(!students[_studentAddress].isEnrolled, "Student is already enrolled");

        // Create a new Student struct and store in the mapping
        students[_studentAddress] = Student(_name, 0, true);

        // Add the student address to the studentList
        studentList.push(_studentAddress);
    }

    // Function to update a student's name
    function updateStudentName(address _studentAddress, string memory _newName) public onlyOwner {
        // Check if the student is enrolled
        require(students[_studentAddress].isEnrolled, "Student is not enrolled");

        // Update the student's name
        students[_studentAddress].name = _newName;
    }

    // Function to assign a grade to a student
    function assignGrade(address _studentAddress, uint _grade) public onlyOwner {
        // Check if the student is enrolled
        require(students[_studentAddress].isEnrolled, "Student is not enrolled");

        // Check if the grade is within valid range (0-100)
        require(_grade <= 100, "Grade must be between 0 and 100");

        // Assign the grade to the student
        students[_studentAddress].grade = _grade;

        // Assert to ensure the grade is set correctly
        assert(students[_studentAddress].grade == _grade);
    }

    // Function to get a student's grade
    function getGrade(address _studentAddress) public view returns (string memory name, uint grade) {
        // Check if the student is enrolled
        require(students[_studentAddress].isEnrolled, "Student is not enrolled");

        // Retrieve the student from the mapping
        Student memory student = students[_studentAddress];

        // Return the student's name and grade
        return (student.name, student.grade);
    }

    // Function to unenroll a student
    function unenrollStudent(address _studentAddress) public onlyOwner {
        // Check if the student is enrolled
        require(students[_studentAddress].isEnrolled, "Student is not enrolled");

        // Remove the student from the mapping
        delete students[_studentAddress];

        // Remove the student address from the studentList
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
        // Return the length of the studentList array
        return studentList.length;
    }

    // Function to retrieve the address of a student by index
    function getStudentAddress(uint _index) public view returns (address) {
        // Check if the index is within bounds of the studentList array
        require(_index < studentList.length, "Index out of bounds");

        // Return the student address at the specified index
        return studentList[_index];
    }
}
