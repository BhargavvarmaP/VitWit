//SPDX-License-Identifier:MIT
pragma solidity >=0.4.0 <0.9.0;
import "./University.sol";
contract Admin {
    address public admin; // address of the admin
    constructor(address _admin) {
        admin=_admin;
    }
    
    struct Universities{
        address UAPaddr;
        address universityaddr;
    }
    event ModifiedUniversity(address indexed oldaddress,address indexed newaddress);
    event NewAdmin(address indexed newadmin);
    

    // Universitieslist an Array of addresses of all universities created
    Universities[] public universitieslist;
    mapping(address=>uint256) private universityIndex;
    //number of universities 
    uint256 internal _universities;
    //tracing variable for existence of university
    bool internal found;

    //function modifier  which checks the user is Admin or not
    modifier OnlyAdmin(){
        require(admin==msg.sender,"You are not an Authorized User");
         _;
    }
    
    /*AddUniversity function is to store universities into an array of containing all universities addresses named as
     universities list by entering university address, which is only authorized by Admin */
    function CreateUniversity(address _UAPaddr) public OnlyAdmin {
        require(_UAPaddr!=address(0),"Address must not be a Zero address");
        University university=new University(_UAPaddr);
        universitieslist.push(Universities(_UAPaddr,address(university)));
        _universities=universitieslist.length;
        address temp =address(university);
        universityIndex[temp]=_universities;
    }
     
     /*ModifyUniversity function is to update universities in  array of containing all universities addresses named as
     universities list by entering exixting university address and new address , which is only authorized by Admin */
    function ModifyUniversity(address _universityaddr,address _newUAPaddr) public OnlyAdmin  {
        require(_universityaddr!=address(0),"Address must not be a Zero address");
        require(_newUAPaddr!=address(0),"Address must not be a Zero address");
        DeleteUniversity(_universityaddr);
        CreateUniversity(_newUAPaddr);
        emit ModifiedUniversity(_universityaddr, _newUAPaddr);
    } 
     /* Universities function is to display the number of universities actually have */
    function getUniversities() public view returns(uint256) {
          return _universities;
    }
    /*Renounce function is to change the Admin by updating admin with new admin address, which is only authorized by Admin */
    function RenounceAdmin(address _newadmin) public OnlyAdmin {
        require(_newadmin!=address(0),"Address must not be Zero address");
        admin = _newadmin;
        emit NewAdmin(_newadmin);
    }
    /*DeleteUniversity function is to delete universities from an array of containing all universities addresses named as
     universities list by entering university address, which is only authorized by Admin */
    function DeleteUniversity(address _universityaddr) public OnlyAdmin {
    
    uint256 index = universityIndex[_universityaddr];
    Universities memory temp = universitieslist[_universities-1]; 
    universitieslist[index-1] = temp;
    _universities--;
    }
}
