# Solidity Snippets Reference

Guía completa de los 40+ snippets de Solidity disponibles en tu configuración Neovim.

> **Cómo usar**: Escribe el trigger de snippet y presiona `<Tab>` para expandir. Usa `<Tab>` y `<S-Tab>` para navegar entre placeholders.

---

## 📋 Contract Structure

### `sol` - Basic Contract Template

**Trigger**: `sol`

**Descripción**: Plantilla completa para un contrato Solidity con SPDX license, pragma statement y estructura básica.

**Resultado**:
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ContractName {
}
```

**Placeholders**:
1. License (MIT o Apache-2.0 seleccionable)
2. ContractName (nombre del contrato)
3. Cursor al final para agregar contenido

---

## 🎨 Events

### `evt` - Event Template

**Trigger**: `evt`

**Descripción**: Plantilla genérica para definir events con placeholders para nombre y parámetros.

**Resultado**:
```solidity
event EventName(param1, param2);
```

**Placeholders**:
1. Nombre del evento
2. Parámetros del evento

---

### `tx` - Transfer Event

**Trigger**: `tx`

**Descripción**: Evento estándar de transferencia de tokens (siguiendo ERC20).

**Resultado**:
```solidity
event Transfer(address indexed from, address indexed to, uint256 value);
```

**Uso típico**: En contratos de tokens para registrar transferencias.

---

### `ap` - Approval Event

**Trigger**: `ap`

**Descripción**: Evento de aprobación de allowance (ERC20).

**Resultado**:
```solidity
event Approval(address indexed owner, address indexed spender, uint256 value);
```

**Uso típico**: Cuando un usuario aprueba que otro gaste sus tokens.

---

### `mi` - Mint Event

**Trigger**: `mi`

**Descripción**: Evento de minteo (creación) de nuevos tokens.

**Resultado**:
```solidity
event Mint(address indexed to, uint256 amount);
```

**Uso típico**: Al crear nuevos tokens en el contrato.

---

### `bu` - Burn Event

**Trigger**: `bu`

**Descripción**: Evento de burning (destrucción) de tokens.

**Resultado**:
```solidity
event Burn(address indexed from, uint256 amount);
```

**Uso típico**: Al destruir tokens del contrato.

---

## 🛡️ Modifiers

### `own` - onlyOwner Modifier

**Trigger**: `own`

**Descripción**: Modificador estándar `onlyOwner` para restringir funciones solo al propietario del contrato.

**Resultado**:
```solidity
address public owner;

modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;
}
```

**Uso típico**:
```solidity
function myFunction() external onlyOwner {
    // Solo ejecutable por el owner
}
```

---

### `nr` - nonReentrant Modifier

**Trigger**: `nr`

**Descripción**: Protección contra ataques de reentrada.
> ⚠️ **Importante**: Este modificador debe agregarse al inicio del contrato con `constructor() { _status = 1; }`.

**Resultado**:
```solidity
uint256 private _status;

modifier nonReentrant() {
    require(_status == 1, "ReentrancyGuard: reentrant call");
    _status = 2;
    _;
    _status = 1;
}
```

**Uso típico**: En funciones que hacen `call` o `delegatecall` a otros contratos o transferencias.

```solidity
function withdraw() external nonReentrant {
    // Protected from reentrancy
}
```

---

### `va` - validAddress Modifier

**Trigger**: `va`

**Descripción**: Modificador que valida que una dirección no sea la dirección cero.

**Resultado**:
```solidity
modifier validAddress(address _addr) {
    require(_addr != address(0), "Invalid address");
    _;
}
```

**Uso típico**:
```solidity
function setAddress(address _addr) external validAddress(_addr) {
    // _addr is valid
}
```

---

### `au` - auth Modifier

**Trigger**: `au`

**Descripción**: Modificador que verifica autenticación usando un mapping de usuarios autorizados.

**Resultado**:
```solidity
mapping(address => bool) public auth;

modifier auth_check() {
    require(auth[msg.sender], "Unauthorized");
    _;
}
```

**Uso típico**: En contratos con sistema de permisos.

---

### `pa` - Pausable Modifiers

**Trigger**: `pa`

**Descripción**: Modificadores `whenNotPaused` y `whenPaused` para pausar contratos.

**Resultado**:
```solidity
bool public paused;

event Paused(address account);
event Unpaused(address account);

modifier whenNotPaused() {
    require(!paused, "Contract is paused");
    _;
}

modifier whenPaused() {
    require(paused, "Contract is not paused");
    _;
}

function _pause() internal {
    require(!paused, "Already paused");
    paused = true;
    emit Paused(msg.sender);
}

function _unpause() internal {
    require(paused, "Not paused");
    paused = false;
    emit Unpaused(msg.sender);
}
```

**Uso típico**:
```solidity
function mint(address _to, uint256 _amount) external whenNotPaused {
    // Solo puede ejecutarse si el contrato no está pausado
}

function pauseContract() external onlyOwner {
    _pause();
}

function unpauseContract() external onlyOwner {
    _unpause();
}
```

---

## ⚙️ Functions

### `tr` - Transfer Function

**Trigger**: `tr`

**Descripción**: Función estándar de transferencia de tokens (`transfer`).

**Resultado**:
```solidity
function transfer(address _to, uint256 _value) external returns (bool) {
    require(balanceOf[msg.sender] >= _value, "Insufficient balance");
    require(_to != address(0), "Invalid address");

    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;

    emit Transfer(msg.sender, _to, _value);
    return true;
}
```

**Uso típico**: Implementación ERC20 para transferir tokens.

---

### `ap` - Approve Function

**Trigger**: `ap`

**Descripción**: Función para aprobar que otra dirección gaste tokens (`approve`).

**Resultado**:
```solidity
function approve(address _spender, uint256 _value) external returns (bool) {
    require(_spender != address(0), "Invalid spender");

    allowance[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
}
```

**Uso típico**: Permitir que otro contrato gaste tus tokens.

---

### `tf` - transferFrom Function

**Trigger**: `tf`

**Descripción**: Función para transferir tokens en nombre de otro (`transferFrom`).

**Resultado**:
```solidity
function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
    require(balanceOf[_from] >= _value, "Insufficient balance");
    require(allowance[_from][msg.sender] >= _value, "Insufficient allowance");
    require(_to != address(0), "Invalid address");

    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;
    allowance[_from][msg.sender] -= _value;

    emit Transfer(_from, _to, _value);
    return true;
}
```

**Uso típico**: Delegator pattern para transferir tokens con allowance.

---

### `mi` - Mint Function

**Trigger**: `mi`

**Descripción**: Función para crear nuevos tokens (`mint`).

**Resultado**:
```solidity
function mint(address _to, uint256 _amount) external {
    require(_to != address(0), "Invalid address");
    balanceOf[_to] += _amount;
    totalSupply += _amount;
    emit Mint(_to, _amount);
}
```

**Uso típico**: En tokens con minteo controlado (no ilimitado).

---

### `bu` - Burn Function

**Trigger**: `bu`

**Descripción**: Función para destruir tokens (`burn`).

**Resultado**:
```solidity
function burn(uint256 _amount) external {
    require(balanceOf[msg.sender] >= _amount, "Insufficient balance");
    balanceOf[msg.sender] -= _amount;
    totalSupply -= _amount;
    emit Burn(msg.sender, _amount);
}
```

**Uso típico**: Reduce el totalSupply de un token.

---

## 🗂️ Mappings & Variables

### `bal` - balanceOf Mapping

**Trigger**: `bal`

**Descripción**: Mapping estándar para balances de tokens.

**Resultado**:
```solidity
mapping(address => uint256) public balanceOf;
```

**Uso de datos**: `uint256 balance = balanceOf[address_to_check];` o `balanceOf[address_to_change] += amount;`.

---

### `alw` - allowance Mapping

**Trigger**: `alw`

**Descripción**: Mapping de allowances (permisos delegados).

**Resultado**:
```solidity
mapping(address => mapping(address => uint256)) public allowance;
```

**Uso de datos**: `uint256 allowed = allowance[owner][spender];` o `allownance[owner][spender] += amount.`

---

### `aut` - auth Mapping

**Trigger**: `aut`

**Descripción**: Mapping para autenticación/permisos.

**Resultado**:
```solidity
mapping(address => bool) public auth;
```

**Uso de datos**: `if (auth[msg.sender]) { /* autorizado */ }`.

---

### `ts` - totalSupply Variable

**Trigger**: `ts`

**Descripción**: Variable pública del total de tokens emitidos.

**Resultado**:
```solidity
uint256 public totalSupply;
```

**Uso**: Para tracking global del supply.

---

### `su` - decimals Variable

**Trigger**: `su`

**Descripción**: Número de decimales del token (usualmente 18).

**Resultado**:
```solidity
uint256 public decimals = 18;
```

**Nota**: 18 es estándar para tokens con 18 decimales, cambiar si es necesario.

---

### `nm` - name Variable

**Trigger**: `nm`

**Descripción**: Nombre del token.

**Resultado**:
```solidity
string public name;
```

---

### `sy` - symbol Variable

**Trigger**: `sy`

**Descripción**: Símbolo del token (ticker).

**Resultado**:
```solidity
string public symbol;
```

---

## ✅ Require Statements

### `req` - Require Template

**Trigger**: `req`

**Descripción**: Plantilla para validaciones `require(condition, "error")`.

**Resultado**:
```solidity
require(condition, "error message");
```

**Placeholders**:
1. Condición a validar
2. Mensaje de error

**Uso típico**:
```
req[Tab]amount > 0[Tab]"Insufficient amount"[Tab]
```

---

## 🏗️ Contract Templates

### `erc20` - ERC20 Token Template (Simplified)

**Trigger**: `erc20`

**Descripción**: Plantilla simplificada de contrato ERC20 (versión abreviada - ver `example-contract.sol` para template completo y detallado).

**Resultado**:
```solidity
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
}

contract MyToken {
    string public name = "My Token";
    string public symbol = "MTK";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply;
        balanceOf[msg.sender] = _initialSupply;
        emit Transfer(address(0), msg.sender, _initialSupply);
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
}
```

**Nota**: Para contrato completo con todas las funciones ERC20, consultas `docs/examples/solidity/example-contract.sol`.

---

### `owncont` - Ownable Pattern

**Trigger**: `owncont`

**Descripción**: Contrato `Ownable` estándar con `onlyOwner` modifier y `transferOwnership`.

**Resultado**:
```solidity
address public owner;
address public pendingOwner;

event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

constructor() {
    owner = msg.sender;
    emit OwnershipTransferred(address(0), msg.sender);
}

modifier onlyOwner() {
    require(msg.sender == owner, "Ownable: caller is not the owner");
    _;
}

function transferOwnership(address newOwner) external onlyOwner {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    owner = newOwner;
    emit OwnershipTransferred(owner, newOwner);
}
```

**Uso típico**: Heredado por contratos que requieren ownership y administración.

---

### `reent` - ReentrancyGuard Abstract

**Trigger**: `reent`

**Descripción**: Contrato abstracto `ReentrancyGuard` con el modificador `nonReentrant`.

**Resultado**:
```solidity
uint256 private _status;

modifier nonReentrant() {
    require(_status == 1, "ReentrancyGuard: reentrant call");
    _status = 2;
    _;
    _status = 1;
}
```

**Uso típico**: Heredado por contratos que hacen calls externos o transfers.

---

### `pausec` - Pausable Abstract

**Trigger**: `pausec`

**Descripción**: Contrato abstracto `Pausable` con modificadores y funciones de pause/unpause.

**Resultado**:
```solidity
bool public paused;

event Paused(address account);
event Unpaused(address account);

modifier whenNotPaused() {
    require(!paused, "Pausable: paused");
    _;
}

modifier whenPaused() {
    require(paused, "Pausable: not paused");
    _;
}

function _pause() internal {
    require(!paused, "Pausable: already paused");
    paused = true;
    emit Paused(msg.sender);
}

function _unpause() internal {
    require(paused, "Pausable: not paused");
    paused = false;
    emit Unpaused(msg.sender);
}
```

**Uso típico**: Heredado por contratos que pueden pausarse.

---

## 🏭 Advanced Patterns

### `factory` - Factory Pattern

**Trigger**: `factory`

**Descripción**: Contrato de fábrica para desplegar otros contratos dinámicamente.

**Resultado**:
```solidity
address[] public deployed;
mapping(address => bool) public isDeployed;
address public owner;

event Deployed(address child, uint256 index);

modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;
}

constructor() {
    owner = msg.sender;
}

function deployContract(bytes memory initCode) external returns (address) {
    address child;
    assembly {
        child := create(0, add(initCode, 0x20), mload(initCode))
    }
    require(child != address(0), "Deployment failed");
    deployed.push(child);
    isDeployed[child] = true;
    emit Deployed(child, deployed.length - 1);
    return child;
}

function getDeployedCount() external view returns (uint256) {
    return deployed.length;
}
```

**Uso de datos**: Crear nuevas instancias de contratos desde un contrato padre (como factories de tokens o NFTs).

---

### `proxy` - Proxy Pattern

**Trigger**: `proxy`

**Descripción**: Contrato proxy que delega calls a un contrato de implementación (upgradeable contracts).

**Resultado**:
```solidity
address public implementation;
address public owner;

event Upgraded(address indexed implementation);

constructor(address _implementation) {
    implementation = _implementation;
    owner = msg.sender;
}

function upgradeTo(address newImplementation) external {
    require(msg.sender == owner, "Not owner");
    require(newImplementation != address(0), "Invalid implementation");
    implementation = newImplementation;
    emit Upgraded(newImplementation);
}

fallback() external payable {
    address impl = implementation;
    assembly {
        calldatacopy(0, 0, calldatasize())
        let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
        returndatacopy(0, 0, returndatasize())
        switch result
        case 0 { revert(0, returndatasize()) }
        default { return(0, returndatasize()) }
    }
}

receive() external payable {}
```

**Uso**: Para contratos upgradeables usando proxy pattern. El contrato `impl` (Implementation) debe contener la lógica del contrato.

---

### `impl` - Upgradeable Implementation

**Trigger**: `impl`

**Descripción**: Contracto de implementación abstracto para pattern upgradeable.

**Resultado**:
```solidity
uint256 public version;

constructor(uint256 _version) {
    version = _version;
}

function getImplementation() external view returns (address) {
    return address(this);
}
```

**Uso**: Como contrato hijo del `proxy` que se actualiza con `upgradeTo`.

---

### `beacon` - Upgradeable Beacon Pattern

**Trigger**: `beacon`

**Descripción**: Contrato Beacon que mantiene un single implementation address para múltiples proxies.

**Resultado**:
```solidity
address public implementation;
address public owner;

event Upgraded(address indexed implementation);

constructor(address _implementation) {
    implementation = _implementation;
    owner = msg.sender;
}

function upgradeTo(address newImplementation) external {
    require(msg.sender == owner, "Not owner");
    require(newImplementation != address(0), "Invalid implementation");
    implementation = newImplementation;
    emit Upgraded(newImplementation);
}
```

**Uso de datos**: Múltiples proxies apuntan al beacon, el beacon tiene la single implementation. Para upgradear, solo se actualiza el beacon, no cada proxy individual.

---

### `multi` - Multisig Wallet Pattern

**Trigger**: `multi`

**Descripción**: Contrato multisig con threshold de signatures.

**Resultado**:
```solidity
mapping(address => bool) public isOwner;
uint256 public threshold;
uint256 public nonce;
address[] public owners;

event ExecutionSuccess(uint256 indexed nonce);
event ExecutionFailure(uint256 indexed nonce);

modifier onlyWallet() {
    require(isOwner[msg.sender], "Not owner");
    _;
}

constructor(address[] memory _owners, uint256 _threshold) {
    require(_owners.length >= _threshold, "Invalid threshold");
    threshold = _threshold;
    for (uint256 i = 0; i < _owners.length; i++) {
        require(_owners[i] != address(0), "Invalid owner");
        require(!isOwner[_owners[i]], "Duplicate owner");
        isOwner[_owners[i]] = true;
        owners.push(_owners[i]);
    }
}

function executeTransaction(address to, uint256 value, bytes memory data, uint256 nonce_) external onlyWallet returns (bool) {
    require(nonce == nonce_, "Invalid nonce");
    nonce++;
    (bool success, ) = to.call{value: value, data: data};
    if (success) {
        emit ExecutionSuccess(nonce_);
    } else {
        emit ExecutionFailure(nonce_);
    }
    return success;
}
```

**Uso**: Para contratos que requieren múltiples firmantes para ejecutar funciones (ej: multisig wallet, treasury).

---

### `time` - Timelock Pattern

**Trigger**: `time`

**Descripción**: Contrato Timelock que retrasa la ejecución de funciones por un periodo específico.

**Resultado**:
```solidity
address public owner;
uint256 public timelockDuration;
uint256 public timeLockEnd;

event QueuedTransaction(bytes32 indexed txHash, uint256 executionTime);

modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;
}

constructor(uint256 _timelockDuration) {
    owner = msg.sender;
    timelockDuration = _timelockDuration;
    timeLockEnd = block.timestamp + _timelockDuration;
}

function executeTransaction(address to, uint256 value, bytes memory data, uint256 executionTime, uint256 duration_) external onlyWallet returns (bool) {
    require(block.timestamp >= timeLockEnd + duration_, "Timelock not expired");
    (bool success, ) = to.call{value: value, data: data};
    return success;
}
```

**Uso**: Para retrasar la ejecución de funciones críticas (ej: cambios de configuración, upgrades, etc.) permitiendo retractación.

---

### `safeerc20` - SafeERC20 Wrapper

**Trigger**: `safeerc20`

**Descripción**: Contracto abstracto con `safeTransfer` y `safeTransferFrom` que maneja tokens que no retornan `false` en failed transfer.

**Resultado**:
```solidity
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

abstract contract SafeERC20 {
    function safeTransfer(address token, address to, uint256 amount) internal {
        (bool success, bytes memory data) = token.call(abi.encodeWithSignature("transfer(address,uint256)"), to, amount);
        require(success && (data.length == 0 || abi.decode(data, (bool))), "SafeERC20: transfer failed");
    }

    function safeTransferFrom(address token, address from, address to, uint256 amount) internal {
        (bool success, bytes memory data) = token.call(abi.encodeWithSignature("transferFrom(address,address,uint256)"), from, to, amount);
        require(success && (data.length == 0 || abi.decode(data, (bool))), "SafeERC20: transfer failed");
    }
}
```

**Uso**: Para interacciones seguras con otros tokens que puedan no tener handling correcto de reverts en failed transfers.

---

## 📝 Quick Reference

| Trigger | Categoría | Descripción |
|---------|-----------|-------------|
| `sol` | Structure | Contract template básico |
| `evt` | Events | Evento genérico |
| `tx` | Events | Transfer event |
| `ap` | Events | Approval event |
| `mi` | Events | Mint event |
| `bu` | Events | Burn event |
| `own` | Modifiers | onlyOwner modifier |
| `nr` | Modifiers | nonReentrant modifier |
| `va` | Modifiers | validAddress modifier |
| `au` | Modifiers | auth modifier |
| `pa` | Modifiers | Pausable modifiers |
| `tr` | Functions | transfer function |
| `ap` | Functions | approve function |
| `tf` | Functions | transferFrom function |
| `mi` | Functions | mint function |
| `bu` | Functions | burn function |
| `bal` | Mappings | balanceOf mapping |
| `alw` | Mappings | allowance mapping |
| `aut` | Mappings | auth mapping |
| `ts` | Vars | totalSupply |
| `su` | Vars | decimals |
| `nm` | Vars | name |
| `sy` | Vars | symbol |
| `req` | Statements | require template |
| `erc20` | Templates | ERC20 simplificado |
| `owncont` | Templates | Ownable pattern |
| `reent` | Templates | ReentrancyGuard |
| `pausec` | Templates | Pausable |
| `factory` | Advanced | Factory pattern |
| `proxy` | Advanced | Proxy pattern |
| `impl` | Advanced | Upgradeable implementation |
| `beacon` | Advanced | Beacon pattern |
| `multi` | Advanced | Multisig wallet |
| `time` | Advanced | Timelock |
| `safeerc20` | Advanced | SafeERC20 wrapper |

---

## 🔔 Tips

- **Expansión**: Presiona `<Tab>` después de escribir el trigger para expandir el snippet.
- **Navegación**: Usa `<Tab>` y `<S-Tab>` para moverte entre placeholders dentro del snippet.
- **Abortar**: Presiona `<C-e>` para cancelar la expansión mientras estás en modo de selección.
- **Completión**: Los snippets aparecen en el menú de nvim-cmp con el icono de snippet (📄).

---

## ⚠️ Notes

- Los snippets con `{` y `}` usan escape porque son syntax de Solidity, no LuaSnip.
- Para templates ERC20 completos, ver `docs/examples/solidity/example-contract.sol`.
- DAP debugging no disponible todavía (ver issue foundry-rs/foundry#5784).

---

Última actualización: 2025-02-20
