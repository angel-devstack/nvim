-- Solidity snippets - Option 3: Complete + Advanced Patterns
-- Covers: contract structure, events, modifiers, functions, mappings
-- Plus: ERC20, Ownable, ReentrancyGuard, Pausable
-- Plus: Factory, Proxy, Upgradeable, Multisig, Timelock

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Basic Contract Structure
  s("sol", fmt(
    "// SPDX-License-Identifier: {}\npragma solidity ^0.8.0;\n\n{}\ncontract {} {\n    {}\n}\n",
    {c(1, {t"MIT", t"Apache-2.0"}), t"", i(2, "ContractName"), i(0)}
  )),

  -- Events
  s("evt", fmt("event {}($1);", {i(1, "EventName")})),
  s("tx", t"event Transfer(address indexed from, address indexed to, uint256 value);"),
  s("ap", t"event Approval(address indexed owner, address indexed spender, uint256 value);"),
  s("mi", t"event Mint(address indexed to, uint256 amount);"),
  s("bu", t"event Burn(address indexed from, uint256 amount);"),

  -- Modifiers
  s("own", t"address public owner;\n\nmodifier onlyOwner() {\n    require(msg.sender == owner, \"Not owner\");\n    _;\n}\n"),
  s("nr", t"uint256 private _status;\n\nmodifier nonReentrant() {\n    require(_status == 1, \"ReentrancyGuard: reentrant call\");\n    _status = 2;\n    _;\n    _status = 1;\n}\n"),
  s("va", t"modifier validAddress(address _addr) {\n    require(_addr != address(0), \"Invalid address\");\n    _;\n}\n"),
  s("au", t"mapping(address => bool) public auth;\n\nmodifier auth_check() {\n    require(auth[msg.sender], \"Unauthorized\");\n    _;\n}\n"),
  s("pa", t"bool public paused;\n\nmodifier whenNotPaused() {\n    require(!paused, \"Contract is paused\");\n    _;\n}\n\nmodifier whenPaused() {\n    require(paused, \"Contract is not paused\");\n    _;\n}\n"),

  -- Functions
  s("tr", t"function transfer(address _to, uint256 _value) external returns (bool) {\n    require(balanceOf[msg.sender] >= _value, \"Insufficient balance\");\n    require(_to != address(0), \"Invalid address\");\n\n    balanceOf[msg.sender] -= _value;\n    balanceOf[_to] += _value;\n\n    emit Transfer(msg.sender, _to, _value);\n    return true;\n}\n"),
  s("ap", t"function approve(address _spender, uint256 _value) external returns (bool) {\n    require(_spender != address(0), \"Invalid spender\");\n\n    allowance[msg.sender][_spender] = _value;\n    emit Approval(msg.sender, _spender, _value);\n    return true;\n}\n"),
  s("tf", t"function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {\n    require(balanceOf[_from] >= _value, \"Insufficient balance\");\n    require(allowance[_from][msg.sender] >= _value, \"Insufficient allowance\");\n    require(_to != address(0), \"Invalid address\");\n\n    balanceOf[_from] -= _value;\n    balanceOf[_to] += _value;\n    allowance[_from][msg.sender] -= _value;\n\n    emit Transfer(_from, _to, _value);\n    return true;\n}\n"),
  s("mi", t"function mint(address _to, uint256 _amount) external {\n    require(_to != address(0), \"Invalid address\");\n    balanceOf[_to] += _amount;\n    totalSupply += _amount;\n    emit Mint(_to, _amount);\n}\n"),
  s("bu", t"function burn(uint256 _amount) external {\n    require(balanceOf[msg.sender] >= _amount, \"Insufficient balance\");\n    balanceOf[msg.sender] -= _amount;\n    totalSupply -= _amount;\n    emit Burn(msg.sender, _amount);\n}\n"),

  -- Mappings & Vars
  s("bal", t"mapping(address => uint256) public balanceOf;\n"),
  s("alw", t"mapping(address => mapping(address => uint256)) public allowance;\n"),
  s("aut", t"mapping(address => bool) public auth;\n"),
  s("ts", t"uint256 public totalSupply;\n"),
  s("su", t"uint256 public decimals = 18;\n"),
  s("nm", t"string public name;\n"),
  s("sy", t"string public symbol;\n"),

  -- Require
  s("req", fmt'require({i(1, "condition")}, "$2");', {i(2, "error message")}),

  -- ERC20 Template (simplificada porque la completa es demasiado larga para snippets)
  s("erc20", t"// ERC20 contract structure - ver example-contract.sol para template completo\ninterface IERC20 {\n    function transfer(address to, uint256 value) external returns (bool);\n    function approve(address spender, uint256 value) external returns (bool);\n}\n\ncontract MyToken {\n    string public name = \"My Token\";\n    string public symbol = \"MTK\";\n    uint8 public decimals = 18;\n    uint256 public totalSupply;\n\n    mapping(address => uint256) public balanceOf;\n    mapping(address => mapping(address => uint256)) public allowance;\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    constructor(uint256 _initialSupply) {\n        totalSupply = _initialSupply;\n        balanceOf[msg.sender] = _initialSupply;\n        emit Transfer(address(0), msg.sender, _initialSupply);\n    }\n\n    function transfer(address _to, uint256 _value) public returns (bool) {\n        require(balanceOf[msg.sender] >= _value, \"Insufficient balance\");\n        balanceOf[msg.sender] -= _value;\n        balanceOf[_to] += _value;\n        emit Transfer(msg.sender, _to, _value);\n        return true;\n    }\n}\n"),

  -- Ownable Pattern
  s("owncont", t"// Ownable pattern\naddress public owner;\naddress public pendingOwner;\n\nevent OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\nconstructor() {\n    owner = msg.sender;\n    emit OwnershipTransferred(address(0), msg.sender);\n}\n\nmodifier onlyOwner() {\n    require(msg.sender == owner, \"Ownable: caller is not the owner\");\n    _;\n}\n\nfunction transferOwnership(address newOwner) external onlyOwner {\n    require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n    owner = newOwner;\n    emit OwnershipTransferred(owner, newOwner);\n}\n"),

  -- ReentrancyGuard
  s("reent", t"// ReentrancyGuard\nuint256 private _status;\n\nmodifier nonReentrant() {\n    require(_status == 1, \"ReentrancyGuard: reentrant call\");\n    _status = 2;\n    _;\n    _status = 1;\n}\n"),

  -- Pausable
  s("pausec", t"// Pausable\nbool public paused;\n\nevent Paused(address account);\nevent Unpaused(address account);\n\nmodifier whenNotPaused() {\n    require(!paused, \"Pausable: paused\");\n    _;\n}\n\nmodifier whenPaused() {\n    require(paused, \"Pausable: not paused\");\n    _;\n}\n\nfunction _pause() internal {\n    require(!paused, \"Pausable: already paused\");\n    paused = true;\n    emit Paused(msg.sender);\n}\n\nfunction _unpause() internal {\n    require(paused, \"Pausable: not paused\");\n    paused = false;\n    emit Unpaused(msg.sender);\n}\n"),

  -- Factory Pattern
  s("factory", t"// Factory pattern\naddress[] public deployed;\nmapping(address => bool) public isDeployed;\naddress public owner;\n\nevent Deployed(address child, uint256 index);\n\nmodifier onlyOwner() {\n    require(msg.sender == owner, \"Not owner\");\n    _;\n}\n\nconstructor() {\n    owner = msg.sender;\n}\n\nfunction deployContract(bytes memory initCode) external returns (address) {\n    address child;\n    assembly {\n        child := create(0, add(initCode, 0x20), mload(initCode))\n    }\n    require(child != address(0), \"Deployment failed\");\n    deployed.push(child);\n    isDeployed[child] = true;\n    emit Deployed(child, deployed.length - 1);\n    return child;\n}\n"),

  -- Proxy Pattern
  s("proxy", t"// Proxy pattern\naddress public implementation;\naddress public owner;\n\nevent Upgraded(address indexed implementation);\n\nconstructor(address _implementation) {\n    implementation = _implementation;\n    owner = msg.sender;\n}\n\nfunction upgradeTo(address newImplementation) external {\n    require(msg.sender == owner, \"Not owner\");\n    require(newImplementation != address(0), \"Invalid implementation\");\n    implementation = newImplementation;\n    emit Upgraded(newImplementation);\n}\n\nfallback() external payable {\n    address impl = implementation;\n    assembly {\n        calldatacopy(0, 0, calldatasize())\n        let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)\n        returndatacopy(0, 0, returndatasize())\n        switch result\n        case 0 { revert(0, returndatasize()) }\n        default { return(0, returndatasize()) }\n    }\n}\n\nreceive() external payable {}\n"),

  -- Upgradeable Implementation
  s("impl", t"// Upgradeable implementation\nuint256 public version;\n\nconstructor(uint256 _version) {\n    version = _version;\n}\n\nfunction getImplementation() external view returns (address) {\n    return address(this);\n}\n"),

  -- Beacon
  s("beacon", t"// Beacon pattern\naddress public implementation;\naddress public owner;\n\nevent Upgraded(address indexed implementation);\n\nconstructor(address _implementation) {\n    implementation = _implementation;\n    owner = msg.sender;\n}\n\nfunction upgradeTo(address newImplementation) external {\n    require(msg.sender == owner, \"Not owner\");\n    require(newImplementation != address(0), \"Invalid implementation\");\n    implementation = newImplementation;\n    emit Upgraded(newImplementation);\n}\n"),

  -- Multisig Pattern
  s("multi", t"// Multisig wallet\nmapping(address => bool) public isOwner;\nuint256 public threshold;\nuint256 public nonce;\naddress[] public owners;\n\nevent ExecutionSuccess(uint256 indexed nonce);\nevent ExecutionFailure(uint256 indexed nonce);\n\nmodifier onlyWallet() {\n    require(isOwner[msg.sender], \"Not owner\");\n    _;\n}\n\nconstructor(address[] memory _owners, uint256 _threshold) {\n    require(_owners.length >= _threshold, \"Invalid threshold\");\n    threshold = _threshold;\n    for (uint256 i = 0; i < _owners.length; i++) {\n        require(_owners[i] != address(0), \"Invalid owner\");\n        require(!isOwner[_owners[i]], \"Duplicate owner\");\n        isOwner[_owners[i]] = true;\n        owners.push(_owners[i]);\n    }\n}\n\nfunction executeTransaction(address to, uint256 value, bytes memory data, uint256 nonce_) external onlyWallet returns (bool) {\n    require(nonce == nonce_, \"Invalid nonce\");\n    nonce++;\n    (bool success, ) = to.call{value: value, data: data};\n    if (success) {\n        emit ExecutionSuccess(nonce_);\n    } else {\n        emit ExecutionFailure(nonce_);\n    }\n    return success;\n}\n"),

  -- Timelock Pattern
  s("time", t"// Timelock\naddress public owner;\nuint256 public timelockDuration;\nuint256 public timeLockEnd;\n\nevent QueuedTransaction(bytes32 indexed txHash, uint256 executionTime);\n\nmodifier onlyOwner() {\n    require(msg.sender == owner, \"Not owner\");\n    _;\n}\n\nconstructor(uint256 _timelockDuration) {\n    owner = msg.sender;\n    timelockDuration = _timelockDuration;\n    timeLockEnd = block.timestamp + _timelockDuration;\n}\n\nfunction executeTransaction(address to, uint256 value, bytes memory data) external onlyWallet returns (bool) {\n    require(block.timestamp >= timeLockEnd, \"Timelock not expired\");\n    (bool success, ) = to.call{value: value, data: data};\n    return success;\n}\n"),

  -- SafeERC20
  s("safeerc20", t"// SafeERC20\ninterface IERC20 {\n    function transfer(address to, uint256 value) external returns (bool);\n    function transferFrom(address from, address to, uint256 value) external returns (bool);\n}\n\nabstract contract SafeERC20 {\n    function safeTransfer(address token, address to, uint256 amount) internal {\n        (bool success, bytes memory data) = token.call(abi.encodeWithSignature(\"transfer(address,uint256)\", to, amount));\n        require(success && (data.length == 0 || abi.decode(data, (bool))), \"SafeERC20: transfer failed\");\n    }\n\n    function safeTransferFrom(address token, address from, address to, uint256 amount) internal {\n        (bool success, bytes memory data) = token.call(abi.encodeWithSignature(\"transferFrom(address,address,uint256)\", from, to, amount));\n        require(success && (data.length == 0 || abi.decode(data, (bool))), \"SafeERC20: transfer failed\");\n    }\n}\n"),
}