// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ToDoListContract {
    struct Task {
        uint256 id;
        string content;
        bool completed;
        uint256 createdAt;
    }
    
    mapping(address => Task[]) private userTasks;
    mapping(address => uint256) private taskCounter;
    
    event TaskCreated(address indexed user, uint256 taskId, string content);
    event TaskCompleted(address indexed user, uint256 taskId);
    event TaskDeleted(address indexed user, uint256 taskId);
    
    // Core Function 1: Add a new task
    function addTask(string memory _content) public {
        require(bytes(_content).length > 0, "Task content cannot be empty");
        
        uint256 taskId = taskCounter[msg.sender];
        Task memory newTask = Task({
            id: taskId,
            content: _content,
            completed: false,
            createdAt: block.timestamp
        });
        
        userTasks[msg.sender].push(newTask);
        taskCounter[msg.sender]++;
        
        emit TaskCreated(msg.sender, taskId, _content);
    }
    
    // Core Function 2: Mark task as completed
    function completeTask(uint256 _taskIndex) public {
        require(_taskIndex < userTasks[msg.sender].length, "Task does not exist");
        require(!userTasks[msg.sender][_taskIndex].completed, "Task already completed");
        
        userTasks[msg.sender][_taskIndex].completed = true;
        
        emit TaskCompleted(msg.sender, userTasks[msg.sender][_taskIndex].id);
    }
    
    // Core Function 3: Delete a task
    function deleteTask(uint256 _taskIndex) public {
        require(_taskIndex < userTasks[msg.sender].length, "Task does not exist");
        
        uint256 taskId = userTasks[msg.sender][_taskIndex].id;
        
        // Move the last task to the deleted task's position and remove the last task
        userTasks[msg.sender][_taskIndex] = userTasks[msg.sender][userTasks[msg.sender].length - 1];
        userTasks[msg.sender].pop();
        
        emit TaskDeleted(msg.sender, taskId);
    }
    
    // View function to get user's tasks
    function getTasks() public view returns (Task[] memory) {
        return userTasks[msg.sender];
    }
    
    // View function to get task count
    function getTaskCount() public view returns (uint256) {
        return userTasks[msg.sender].length;
    }
    
    // View function to get specific task
    function getTask(uint256 _taskIndex) public view returns (Task memory) {
        require(_taskIndex < userTasks[msg.sender].length, "Task does not exist");
        return userTasks[msg.sender][_taskIndex];
    }
}
