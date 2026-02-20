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
local rep = require("luasnip.extras").rep

return {
  -- =========================================================================
  -- Basic Contract Structure
  -- =========================================================================
  s("sol", fmt(
    "// SPDX-License-Identifier: {}\npragma solidity ^0.8.0;\n\n{}\ncontract {} {{\n    {}\n}}",
    { c(1, { t"MIT", t"Apache-2.0", t"BSD-3-Clause" }),
      t"", i(2, "ContractName"), i(0) }
  )),

  -- =========================================================================
  -- Events
  -- =========================================================================
  s("evt", fmt("event {}({});", { i(1, "EventName"), i(2, "address indexed from, uint256 value") })),

  s("tx", fmt(
    "event Transfer(address indexed from, address indexed to, uint256 value);",
    {}
  )),

  s("ap", fmt(
    "event Approval(address indexed owner, address indexed spender, uint256 value);",
    {}
  )),

  s("mi", fmt(
    "event Mint(address indexed to, uint256 amount);",
    {}
  )),

  s("bu", fmt(
    "event Burn(address indexed from, uint256 amount);",
    {}
  )),

  -- =========================================================================
  -- Modifiers
  -- =========================================================================
  s("own", fmt(
    "address public owner;\n\nmodifier onlyOwner() {\n    require(msg.sender == owner, \"Not owner\");\n    _;\n}",
    {}
  )),

  s("nr", fmt(
    "uint256 private _counter;\n\nmodifier nonReentrant() {\n    require(_counter == 0, \"ReentrancyGuard: reentrant call\");\n    _counter = 1;\n    _;\n    _counter = 0;\n}",
    {}
  )),

  s("va", fmt(
    "modifier validAddress(address _addr) {\n    require(_addr != address(0), \"Invalid address\");\n    _;\n}",
    {}
  )),

  s("au", fmt(
    "modifier auth() {\n    require(auth[msg.sender], \"Unauthorized\");\n    _;\n}",
    {}
  )),

  s("pa", fmt(
    "bool public paused;\n\nmodifier whenNotPaused() {\n    require(!paused, \"Contract is paused\");\n    _;\n}",
    {}
  )),

  -- =========================================================================
  -- Functions
  -- =========================================================================
  s("tr", fmt(
    "function transfer(address _to, uint256 _value) external returns (bool) {\n    require(balanceOf[msg.sender] >= _value, \"Insufficient balance\");\n    require(_to != address(0), \"Invalid address\");\n\n    balanceOf[msg.sender] -= _value;\n    balanceOf[_to] += _value;\n\n    emit Transfer(msg.sender, _to, _value);\n    return true;\n}",
    {}
  )),

  s("ap", fmt(
    "function approve(address _spender, uint256 _value) external returns (bool) {\n    require(_spender != address(0), \"Invalid spender\");\n\n    allowance[msg.sender][_spender] = _value;\n    emit Approval(msg.sender, _spender, _value);\n    return true;\n}",
    {}
  )),

  s("tf", fmt(
    "function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {\n    require(balanceOf[_from] >= _value, \"Insufficient balance\");\n    require(allowance[_from][msg.sender] >= _value, \"Insufficient allowance\");\n    require(_to != address(0), \"Invalid address\");\n\n    balanceOf[_from] -= _value;\n    balanceOf[_to] += _value;\n    allowance[_from][msg.sender] -= _value;\n\n    emit Transfer(_from, _to, _value);\n    return true;\n}",
    {}
  )),

  s("mi", fmt(
    "function mint(address _to, uint256 _amount) external {\n    require(_to != address(0), \"Invalid address\");\n    balanceOf[_to] += _amount;\n    totalSupply += _amount;\n    emit Mint(_to, _amount);\n}",
    {}
  )),

  s("bu", fmt(
    "function burn(uint256 _amount) external {\n    require(balanceOf[msg.sender] >= _amount, \"Insufficient balance\");\n    balanceOf[msg.sender] -= _amount;\n    totalSupply -= _amount;\n    emit Burn(msg.sender, _amount);\n}",
    {}
  )),

  -- =========================================================================
  -- Mappings & Vars
  -- =========================================================================
  s("bal", fmt(
    "mapping(address => uint256) public balanceOf;",
    {}
  )),

  s("alw", fmt(
    "mapping(address => mapping(address => uint256)) public allowance;",
    {}
  )),

  s("aut", fmt(
    "mapping(address => bool) public auth;",
    {}
  )),

  s("ts", fmt(
    "uint256 public totalSupply;",
    {}
  )),

  s("su", fmt(
    "uint256 public decimals = 18;",
    {}
  )),

  s("nm", fmt(
    "string public name;",
    {}
  )),

  s("sy", fmt(
    "string public symbol;",
    {}
  )),

  -- =========================================================================
  -- Require Statements
  -- =========================================================================
  s("req", fmt(
    "require(, \"\");",
    { i(1, "condition"), i(2, "error message") }
  )),

  -- =========================================================================
  -- ERC20 Template
  -- =========================================================================
  s("erc20", fmt(
    "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\ncontract {} is ERC20 {{\n    string public name = \"\";\n    string public symbol = \"\";\n    uint8 public decimals = 18;\n    uint256 public override totalSupply;\n\n    mapping(address => uint256) public override balanceOf;\n    mapping(address => mapping(address => uint256)) public override allowance;\n\n    constructor(uint256 _initialSupply) {{\n        totalSupply = _initialSupply;\n        balanceOf[msg.sender] = _initialSupply;\n        emit Transfer(address(0), msg.sender, _initialSupply);\n    }}\n\n    function transfer(address _to, uint256 _value) public override returns (bool) {{\n        require(balanceOf[msg.sender] >= _value, \"Insufficient balance\");\n        require(_to != address(0), \"Invalid address\");\n\n        balanceOf[msg.sender] -= _value;\n        balanceOf[_to] += _value;\n\n        emit Transfer(msg.sender, _to, _value);\n        return true;\n    }}\n\n    function approve(address _spender, uint256 _value) public override returns (bool) {{\n        require(_spender != address(0), \"Invalid spender\");\n\n        allowance[msg.sender][_spender] = _value;\n        emit Approval(msg.sender, _spender, _value);\n        return true;\n    }}\n\n    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool) {{\n        require(balanceOf[_from] >= _value, \"Insufficient balance\");\n        require(allowance[_from][msg.sender] >= _value, \"Insufficient allowance\");\n        require(_to != address(0), \"Invalid address\");\n\n        balanceOf[_from] -= _value;\n        balanceOf[_to] += _value;\n        allowance[_from][msg.sender] -= _value;\n\n        emit Transfer(_from, _to, _value);\n        return true;\n    }}\n}}",
    { i(1, "MyToken"), i(2, "My Token"), i(3, "MTK") }
  )),

  -- =========================================================================
  -- Ownable Pattern
  -- =========================================================================
  s("owncont", fmt(
    "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\ncontract Ownable {{\n    address public owner;\n    address public pendingOwner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    constructor() {{\n        owner = msg.sender;\n        emit OwnershipTransferred(address(0), msg.sender);\n    }}\n\n    modifier onlyOwner() {{\n        require(msg.sender == owner, \"Ownable: caller is not the owner\");\n        _;\n    }}\n\n    function transferOwnership(address newOwner) external onlyOwner {{\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        owner = newOwner;\n        emit OwnershipTransferred(owner, newOwner);\n    }}\n}}",
    {}
  )),

  -- =========================================================================
  -- ReentrancyGuard
  -- =========================================================================
  s("reent", fmt(
    "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\nabstract contract ReentrancyGuard {{\n    uint256 private _counter;\n\n    modifier nonReentrant() {{\n        require(_counter == 0, \"ReentrancyGuard: reentrant call\");\n        _counter = 1;\n        _;\n        _counter = 0;\n    }}\n}}",
    {}
  )),

  -- =========================================================================
  -- Pausable
  -- =========================================================================
  s("pausec", fmt(
    "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\nabstract contract Pausable {{\n    bool public paused;\n\n    event Paused(address account);\n    event Unpaused(address account);\n\n    modifier whenNotPaused() {{\n        require(!paused, \"Pausable: paused\");\n        _;\n    }}\n\n    modifier whenPaused() {{\n        require(paused, \"Pausable: not paused\");\n        _;\n    }}\n\n    function _pause() internal {{\n        require(!paused, \"Pausable: already paused\");\n        paused = true;\n        emit Paused(msg.sender);\n    }}\n\n    function _unpause() internal {{\n        require(paused, \"Pausable: not paused\");\n        paused = false;\n        emit Unpaused(msg.sender);\n    }}\n}}",
    {}
  )),

  -- =========================================================================
  -- Factory Pattern
  -- =========================================================================
  s("factory", fmt(
    "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\ncontract {}Factory {{\n    address[] public deployed;\n    mapping(address => bool) public isDeployed;\n    address public owner;\n\n    event Deployed(address child, uint256 index);\n\n    modifier onlyOwner() {{\n        require(msg.sender == owner, \"Not owner\");\n        _;\n    }}\n\n    constructor() {{\n        owner = msg.sender;\n    }}\n\n    function deployContract(bytes memory initCode) external returns (address) {{\n        address child;\n        assembly {{\n            child := create(0, add(initCode, 0x20), mload(initCode))\n        }}\n        require(child != address(0), \"Deployment failed\");\n        deployed.push(child);\n        isDeployed[child] = true;\n        emit Deployed(child, deployed.length - 1);\n        return child;\n    }}\n\n    function getDeployedCount() external view returns (uint256) {{\n        return deployed.length;\n    }}\n}}",
    { i(1, "Token") }
  )),

  -- =========================================================================
  -- Proxy Pattern
  -- =========================================================================
  s("proxy", fmt(
    "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\ncontract Proxy {{\n    address public implementation;\n\n    event Upgraded(address indexed implementation);\n\n    constructor(address _implementation) {{\n        implementation = _implementation;\n    }}\n\n    modifier onlyOwner() {{\n        require(msg.sender == owner(), \"Not owner\");\n        _;\n    }}\n\n    function upgradeTo(address newImplementation) external onlyOwner {{\n        require(newImplementation != address(0), \"Invalid implementation\");\n        implementation = newImplementation;\n        emit Upgraded(newImplementation);\n    }}\n\n    fallback() external payable {{\n        address impl = implementation;\n        assembly {{\n            calldatacopy(0, 0, calldatasize())\n            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)\n            returndatacopy(0, 0, returndatasize())\n            switch result\n            case 0 {{ revert(0, returndatasize()) }}\n            default {{ return(0, returndatasize()) }}\n        }}\n    }}\n\n    receive() external payable {{}}\n}}",
    {}
  )),

  s("impl", fmt(
    "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\nabstract contract Implementation {{\n    uint256 public version;\n\n    constructor(uint256 _version) {{\n        version = _version;\n    }}\n\n    function getImplementation() external view returns (address) {{\n        return address(this);\n    }}\n}}",
    {}
  )),

  -- =========================================================================
  -- Upgradeable Beacon Pattern
  -- =========================================================================
  s("beacon", fmt(
    "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\ncontract Beacon {{\n    address public implementation;\n    address public owner;\n\n    event Upgraded(address indexed implementation);\n\n    constructor(address _implementation) {{\n        implementation = _implementation;\n        owner = msg.sender;\n    }}\n\n    function upgradeTo(address newImplementation) external {{\n        require(msg.sender == owner, \"Not owner\");\n        require(newImplementation != address(0), \"Invalid implementation\");\n        implementation = newImplementation;\n        emit Upgraded(newImplementation);\n    }}\n}}",
    {}
  )),

  -- =========================================================================
  -- Multisig Pattern
  -- =========================================================================
  s("multi", fmt(
    "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\ncontract MultisigWallet {{\n    mapping(address => bool) public isOwner;\n    uint256 public threshold;\n    uint256 public nonce;\n    address[] public owners;\n\n    event ExecutionSuccess(uint256 indexed nonce);\n    event ExecutionFailure(uint256 indexed nonce);\n    event OwnerAdded(address indexed owner);\n    event OwnerRemoved(address indexed owner);\n\n    modifier onlyWallet() {{\n        require(isOwner[msg.sender], \"Not owner\");\n        _;\n    }}\n\n    constructor(address[] memory _owners, uint256 _threshold) {{\n        require(_owners.length >= _threshold, \"Invalid threshold\");\n        require(_owners.length <= 10, \"Too many owners\");\n        for (uint256 i = 0; i < _owners.length; i++) {{\n            require(_owners[i] != address(0), \"Invalid owner\");\n            require(!isOwner[_owners[i]], \"Duplicate owner\");\n            isOwner[_owners[i]] = true;\n            owners.push(_owners[i]);\n        }}\n        threshold = _threshold;\n    }}\n\n    function executeTransaction(\n        address to,\n        uint256 value,\n        bytes memory data,\n        uint8[] memory signatures,\n        uint256 nonce_\n    ) external returns (bool) {{\n        require(nonce == nonce_, \"Invalid nonce\");\n        nonce++;\n        require(verifySignatures(data, signatures), \"Invalid signatures\");\n        (bool success, ) = to.call{{value: value, data: data}};\n        if (success) {{\n            emit ExecutionSuccess(nonce_);\n        }} else {{\n            emit ExecutionFailure(nonce_);\n        }}\n        return success;\n    }}\n\n    function verifySignatures(bytes memory data, uint8[] memory signatures) private view returns (bool) {{\n        uint256 count = 0;\n        for (uint256 i = 0; i < signatures.length; i++) {{\n            bytes memory message = abi.encodePacked(keccak256(abi.encodePacked(data, nonce)));\n            address signer = recoverSigner(message, signatures[i]);\n            if (isOwner[signer]) count++;\n        }}\n        return count >= threshold;\n    }}\n\n    function recoverSigner(bytes memory message, uint8 sig) private pure returns (address) {{\n        bytes32 r;\n        bytes32 s;\n        uint8 v;\n        assembly {{\n            r := mload(add(sig, 32))\n            s := mload(add(sig, 64))\n            v := mload(add(sig, 96))\n        }}\n        return ecrecover(keccak256(message), v, r, s);\n    }}\n}}",
    {}
  )),

  -- =========================================================================
  -- Timelock Pattern
  -- =========================================================================
  s("time", fmt(
    "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\ncontract Timelock {{\n    address public owner;\n    uint256 public timelockDuration;\n    uint256 public timeLockEnd;\n    address public pendingOwner;\n    mapping(bytes32 => bool) public executedTransactions;\n\n    event QueuedTransaction(bytes32 indexed txHash, uint256 executionTime);\n    event ExecutedTransaction(bytes32 indexed txHash);\n    event ChangedTimelockDuration(uint256 newDuration);\n\n    modifier onlyOwner() {{\n        require(msg.sender == owner, \"Not owner\");\n        _;\n    }}\n\n    modifier timelockExpired() {{\n        require(block.timestamp >= timeLockEnd, \"Timelock not expired\");\n        _;\n    }}\n\n    constructor(uint256 _timelockDuration) {{\n        owner = msg.sender;\n        timelockDuration = _timelockDuration;\n        timeLockEnd = block.timestamp + _timelockDuration;\n    }}\n\n    function changeTimelockDuration(uint256 _timelockDuration) external onlyOwner {{\n        timelockDuration = _timelockDuration;\n        emit ChangedTimelockDuration(_timelockDuration);\n    }}\n\n    function transferOwnership(address _pendingOwner) external onlyOwner {{\n        pendingOwner = _pendingOwner;\n    }}\n\n    function acceptOwnership() external {{\n        require(msg.sender == pendingOwner, \"Not pending owner\");\n        owner = pendingOwner;\n        pendingOwner = address(0);\n        timeLockEnd = block.timestamp + timelockDuration;\n    }}\n\n    function executeTransaction(\n        address to,\n        uint256 value,\n        bytes memory data,\n        uint256 executionTime\n    ) external onlyOwner timelockExpired {{\n        bytes32 txHash = keccak256(abi.encodePacked(to, value, data, executionTime));\n        require(!executedTransactions[txHash], \"Transaction already executed\");\n        require(block.timestamp >= executionTime + 1 hours, \"Execution time not reached\");\n        executedTransactions[txHash] = true;\n        (bool success, ) = to.call{{value: value, data: data}};\n        require(success, \"Transaction failed\");\n        emit ExecutedTransaction(txHash);\n    }}\n}}",
    {}
  )),

  -- =========================================================================
  -- SafeERC20
  -- =========================================================================
  s("safeerc20", fmt(
    "abstract contract SafeERC20 is IERC20 {{\n    function safeTransfer(address token, address to, uint256 amount) internal {{\n        (bool success, bytes memory data) = token.call(abi.encodeWithSignature(\"transfer(address,uint256)\", to, amount));\n        require(success && (data.length == 0 || abi.decode(data, (bool))), \"SafeERC20: transfer failed\");\n    }}\n\n    function safeTransferFrom(address token, address from, address to, uint256 amount) internal {{\n        (bool success, bytes memory data) = token.call(abi.encodeWithSignature(\"transferFrom(address,address,uint256)\", from, to, amount));\n        require(success && (data.length == 0 || abi.decode(data, (bool))), \"SafeERC20: transfer failed\");\n    }}\n}}",
    {}
  )),
}