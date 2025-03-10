pragma solidity =0.5.16;

import './interfaces/IPentaswapV2Factory.sol';
import './PentaswapV2Pair.sol';

contract PentaswapV2Factory is IPentaswapV2Factory {
    address public feeTo;
    address public feeToSetter;

    mapping(address => mapping(address => address)) public getPair;

    address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    event FeeToUpdated(address indexed previousFeeTo, address indexed newFeeTo);

    event FeeToSetterUpdated(address indexed previousFeeToSetter, address indexed newFeeToSetter);

    event FeeToSetterRenounced(address indexed previousFeeToSetter);

    constructor(address _feeToSetter) public {
        require(_feeToSetter != address(0), 'FiveswapV2: ZERO_ADDRESS'); // Zero-address check added
        feeToSetter = _feeToSetter;
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'PentaswapV2: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'PentaswapV2: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'PentaswapV2: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(PentaswapV2Pair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        
        IPentaswapV2Pair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'PentaswapV2: FORBIDDEN');
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'PentaswapV2: FORBIDDEN');
        feeToSetter = _feeToSetter;
    }

    function renounceFeeToSetter() external {
        require(msg.sender == feeToSetter, 'FiveswapV2: FORBIDDEN');
        emit FeeToSetterRenounced(feeToSetter);
        feeToSetter = address(0); // Ownership is renounced
    }
}