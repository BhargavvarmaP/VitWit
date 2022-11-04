//SPDX-License-Identifier:MIT
pragma solidity >=0.4.0 <0.9.0;
contract University {
    address public UAP; //address of University Authorized person
    constructor(address _UAP) {
        UAP=_UAP;
    } 
    //Course contains courseID, Coursename and status of course
    //Student contains studentID,CourseID 
    struct Course {
        uint256 courseID; //represents courseID
        string  coursename; //represents name of the Course
        STATUS  status; //represents status of course
    }
    struct Student {
        uint256 studentID; // represents ID of the student
        uint256 courseID; // represents ID of the course
    }
    //studentlist mapping comprising studentID => Student 
    mapping(uint256=>Student) public studentlist;
    //courseslist mapping comprising courseID => Course
    mapping(uint256=>Course) public courseslist;
    //courses represents total number of courses
    uint256 internal courses;
    //students represents total number of students
    uint256 internal students;
    //enumeration list of status comprising values called CREATED,RUNNING,SUSPENDED
    enum STATUS{CREATED,RUNNING,SUSPENDED}
    
    //function modifier  which checks the user is University Authorized person or not
    modifier OnlyUAP() {
        require(UAP==msg.sender,"Not an Authorized User");
        _;
    }

    /*createCourse function is to create Courses by entering CourseID and name, which is only
     authorized by University Authorized Person */
    function createCourse(uint256 _courseID,string calldata _coursename) public OnlyUAP {
     courseslist[_courseID]=Course(_courseID,_coursename,STATUS.CREATED);
     courses++;
    }
    /*SuspendCourse function is to update Course status by entering CourseID which is only authorized
     by University Authorized Person */
    function SuspendCourse(uint256 _courseID) public OnlyUAP {
            courseslist[_courseID].status=STATUS.SUSPENDED;
    }
    /*RunCourse function is to update Course status by entering CourseID which is only authorized
     by University Authorized Person */
    function RunCourse(uint256 _courseID) public OnlyUAP {
            courseslist[_courseID].status=STATUS.RUNNING;
    }
    /*createStudent function is to create Students by entering StudentID and CourseID, which is only
     authorized by University Authorized Person */
    function CreateStudent(uint256 _studentID,uint256 _courseID) public OnlyUAP {
         require(courseslist[_courseID].status==STATUS.RUNNING,"This is not Running Course");
         studentlist[_studentID]=Student(_studentID,_courseID);
         students++;
    }
    /*ViewStudent function is to display StudentID and CourseID by entering StudentID */
    function ViewStudent(uint256 _studentID) public view returns(Student memory) {
         Student memory student=studentlist[_studentID];
         return student;
    }
    /*DeleteStudent function is to delete Students by entering StudentID, which is only
     authorized by University Authorized Person */
    function DeleteStudent(uint256 _studentID) public OnlyUAP {
        delete studentlist[_studentID];
        students--;
        
    }
    /*RenounceUAP function is to change the University Authorized Person  by entering new UAP address, which is only
     authorized by University Authorized Person */
    function RenounceUAP(address _newUAP) public OnlyUAP{
          require(_newUAP!=address(0),"Address must not be Zero Address");
          UAP=_newUAP;
    }
}