pragma solidity >=0.5.0;

interface IPentaswapV2Callee {
    function PentaswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
}
