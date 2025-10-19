// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract QuizRunContract is Ownable{
    struct User{
        address userAddress;
        string userName;
        uint256 points;
        uint256 balance;
        uint32 level;
        uint32 completedQuizes;
    }

    struct Quiz{
        uint256 id;
        uint32 level;
        uint256 reward;
        uint32 noOfQuestions;
    }

    mapping(address => User) public users;
    mapping(uint256 => Quiz) public quizes;
    address[] public userAddresses;
    uint256[] public quizIds;

    constructor() Ownable(msg.sender){}

    function create_user(string memory _userName) public {
        require(users[msg.sender].userAddress == address(0), "User already exists");
        users[msg.sender] = User(msg.sender, _userName, 0, 0, 0, 0);
        userAddresses.push(msg.sender);
    }

    function store_quiz_data(
        uint256 _id,
        uint32 _level,
        uint256 _reward,
        uint32 _noOfQuestions
    ) public onlyOwner{
        require(quizes[_id].id == 0, "Quiz already exists");
        quizes[_id] = Quiz(_id, _level, _reward, _noOfQuestions);
        quizIds.push(_id);
    }

    function get_quiz_info(uint256 _id) public view returns(Quiz memory){
        return quizes[_id];
    }

    function submit_quiz(
        uint256 _id,
        uint32 _score,
        uint32 _level
    ) public {
        require(_score <= quizes[_id].noOfQuestions, "Invalid score");
        require(quizes[_id].id != 0, "Quiz does not exist");
        require(users[msg.sender].userAddress != address(0), "User does not exist");
        require(quizes[_id].level == users[msg.sender].level, "Invalid level");
        
        users[msg.sender].points += _score;
        
        if(users[msg.sender].level < _level){
            users[msg.sender].level = _level;
        }
        
        if(_score == quizes[_id].noOfQuestions){
            users[msg.sender].points += quizes[_id].reward;
        }
    }

    function get_user_info() public view returns(User memory){
        return users[msg.sender];
    }

    function get_all_user_addresses() public view returns (address[] memory){
        return userAddresses;
    }

    function get_all_quiz_ids() public view returns (uint256[] memory){
        return quizIds;
    }
}