// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.4.21 <0.8.40;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";



contract PadaCoin is ERC20Upgradeable, OwnableUpgradeable, AccessControlUpgradeable {
    bytes32 public constant MINTER_ROLE = keccak256('MINTER_ROLE');
    bytes32 public constant BURNER_ROLE = keccak256('BURNER_ROLE');
    uint256 constant MAX_TOTAL_SUPPLY = 1000000000000000000000000000;
    uint256 TOTAL_SUPPLY;

    struct Statistic {
        uint256 totalSupply;
        uint256 amount;
    }

    function initialize(address initialOwner) external initializer {
        __Ownable_init(initialOwner);
        _grantRole(DEFAULT_ADMIN_ROLE, initialOwner);
        _grantRole(MINTER_ROLE, initialOwner);
        _grantRole(BURNER_ROLE, initialOwner);
        __ERC20_init("Poliada Coin", "PADA");
        TOTAL_SUPPLY = 0;
    }

    function mint(address to, uint256 amount) public onlyMinter {
        require((amount + TOTAL_SUPPLY) <= MAX_TOTAL_SUPPLY, "Max supply reached");
        TOTAL_SUPPLY = TOTAL_SUPPLY + amount;
        _mint(to, amount);
    }

    function getBalance() public view returns(uint256){
        return address(this).balance;
    }

    function getStatistics() public view returns(Statistic memory){
        uint256 amount = IERC20(address(this)).balanceOf(address(this));

        return Statistic(
            TOTAL_SUPPLY,
            amount
        );
    }

    function burn(address account, uint256 amount) public onlyBurner {
        TOTAL_SUPPLY = TOTAL_SUPPLY - amount;
        _burn(account, amount);
    }

    function isMinter(address account) public virtual view returns (bool)
    {
        return hasRole(MINTER_ROLE, account);
    }

    function isBurner(address account) public virtual view returns (bool)
    {
        return hasRole(BURNER_ROLE, account);
    }

    function addMinter(address account) public onlyOwner ()
    {
        return grantRole(MINTER_ROLE, account);
    }

    function addBurner(address account) public onlyOwner ()
    {
        return grantRole(BURNER_ROLE, account);
    }

    modifier onlyMinter()
    {
        require(isMinter(msg.sender), 'Restricted to users.');
        _;
    }

    modifier onlyBurner()
    {
        require(isBurner(msg.sender), 'Restricted to users.');
        _;
    }
}
