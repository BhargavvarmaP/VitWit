//SPDX-License-Identifier:MIT
pragma solidity >=0.4.0 <0.9.0;
contract Admin {
    address public admin; // address of the admin
    constructor(address _admin) {
        admin=_admin;
    }
    // Universitieslist an Array of addresses of all universities created
    address[] public universitieslist;
    //number of universities 
    uint256 internal universities;
    //tracing variable for existence of university
    bool internal found;

    //function modifier  which checks the user is Admin or not
    modifier OnlyAdmin(){
        require(admin==msg.sender,"You are not an Authorized User");
         _;
    }
    
    /*AddUniversity function is to store universities into an array of containing all universities addresses named as
     universities list by entering university address, which is only authorized by Admin */
    function AddUniversity(address _universityaddr) public OnlyAdmin {
        require(_universityaddr!=address(0),"Address must not be a Zero address");
        universitieslist.push(_universityaddr);
        universities=universitieslist.length;
    }
     
     /*ModifyUniversity function is to update universities in  array of containing all universities addresses named as
     universities list by entering exixting university address and new address , which is only authorized by Admin */
    function ModifyUniversity(address _universityaddr,address _newaddr) public OnlyAdmin  {
        require(_universityaddr!=address(0),"Address must not be a Zero address");
        require(_newaddr!=address(0),"Address must not be a Zero address");
        uint256 _id = find(_universityaddr);
        if(found) {
        universitieslist[_id] = _newaddr;
        }
    }
    /*DeleteUniversity function is to delete universities from an array of containing all universities addresses named as
     universities list by entering university address, which is only authorized by Admin */
    function DeleteUniversity(address _universityaddr) public OnlyAdmin {
        require(_universityaddr!=address(0),"Address must not be a Zero address");
        uint256 _id = find(_universityaddr);
        if(found==true){
         address temp = universitieslist[_id];
         universitieslist[_id]=universitieslist[universities-1];
         universitieslist[universities-1]=temp;
         universitieslist.pop();
        }
    }
     
     /* Universities function is to display the number of universities actually have */
    function Universities() public view returns(uint256) {
          return universities;
    }
    /*Renounce function is to change the Admin by updating admin with new admin address, which is only authorized by Admin */
    function RenounceAdmin(address _newadmin) public OnlyAdmin {
        require(_newadmin!=address(0),"Address must not be Zero address");
        admin = _newadmin;
    }
     
     function find(address _addr) internal returns(uint256) {
        for(uint256 i=0;i<universities;i++){
            if(universitieslist[i]==_addr){
                found=true;
                return i;
            }
            else{
            found = false; 
            }
        }
    }
}