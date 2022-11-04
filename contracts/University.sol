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
    //tracing variable for courseID/studentID
    bool internal found;
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
    /*UpdateCourseStatus function is to update Course status by entering CourseID and number representing
     status where CREATED=0,RUNNING=1,SUSPENDED=2, which is only authorized by University Authorized Person */
    function updateCourseStatus(uint256 _courseID,STATUS _status) public OnlyUAP {
        uint256 _id = findCourse(_courseID);
        if(found){
            courseslist[_id].status=_status;
        }
    }
    /*createStudent function is to create Students by entering StudentID and CourseID, which is only
     authorized by University Authorized Person */
    function CreateStudent(uint256 _studentID,uint256 _courseID) public OnlyUAP {
         uint256 _id=findCourse(_courseID);
         require(courseslist[_id].status==STATUS.RUNNING,"This is not Running Course");
         if(found){
         studentlist[_studentID]=Student(_studentID,_courseID);
         students++;
         }
    }
    /*ViewStudent function is to display StudentID and CourseID by entering StudentID */
    function ViewStudent(uint256 _studentID) public view returns(Student memory) {
         Student memory student=studentlist[_studentID];
         return student;
    }
    /*DeleteStudent function is to delete Students by entering StudentID, which is only
     authorized by University Authorized Person */
    function DeleteStudent(uint256 _studentID) public OnlyUAP {
        uint256  _id = findStudent(_studentID);
        if(found){
        delete studentlist[_id];
        students--;
        }
    }
    /*RenounceUAP function is to change the University Authorized Person  by entering new UAP address, which is only
     authorized by University Authorized Person */
    function RenounceUAP(address _newUAP) public OnlyUAP{
          require(_newUAP!=address(0),"Address must not be Zero Address");
          UAP=_newUAP;
    }
    /*findCourse function is to find CourseID by traversing courseslist */
    function findCourse(uint256 _ID) internal returns(uint256) {
        for(uint256 i=0;i<courses;i++){
           if(courseslist[i].courseID==_ID){
               return i;
               found=true;
               break;
           }
           else{
               found=false;
           }
        }
    }
    /*findStudent function is to find StudentID by traversing Studentlist */
    function findStudent(uint256 _ID) internal returns(uint256) {
          for(uint256 i=0;i<students;i++){
           if(studentlist[i].studentID==_ID){
               return i;
               found=true;
               break;
           }
           else{
               found=false;
           }
        }
    }
}