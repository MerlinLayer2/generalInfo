// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";


contract GeneralInfo is OwnableUpgradeable {
    string public constant version = "1.0.0";

    enum TokenType {
        BTC,
        ERC20,
        ERC721
    }

    struct ErcInfo {
        string name;
        string symbol;
        uint256 decimals;
    }


    modifier onlyValidAddress(address addr) {
        require(addr != address(0), "Illegal address");
        _;
    }

     constructor() {
         _disableInitializers();
     }

    /*
    * Initialization function
    * _initialOwner：the initial owner is set to the address provided by the deployer. This can
    *  later be changed with {transferOwnership}.
    */
    function initialize(address _initialOwner) external
    onlyValidAddress(_initialOwner) initializer {
        __Ownable_init_unchained(_initialOwner);
    }

    function batchUsersTokenBalances(address[] calldata _users, address _token) external view returns(uint256[] memory) {
        require(_users.length > 0, "invalid _users");
        require(_token != address(0), "invalid _token");

        uint256[] memory s = new uint256[](_users.length);
        for (uint16 i=0; i<_users.length; i++){
            s[i] = IERC20Metadata(_token).balanceOf(_users[i]);
        }

        return s;
    }

    function batchUserTokensBalances(address _user, address[] calldata _tokens) external view returns(uint256[] memory) {
        require(_user != address(0), "invalid _user");
        require(_tokens.length > 0, "invalid _tokens");

        uint256[] memory s = new uint256[](_tokens.length);
        for (uint16 i=0; i<_tokens.length; i++){
            s[i] = IERC20Metadata(_tokens[i]).balanceOf(_user);
        }

        return s;
    }

    function batchUsersTokensBalances(address[] calldata _users, address[] calldata _tokens) external view returns(uint256[] memory) {
        require(_users.length > 0, "invalid _users");
        require(_users.length == _tokens.length, "invalid length of (_users, _tokens)");

        uint256[] memory s = new uint256[](_users.length);
        for (uint16 i=0; i<_users.length; i++){
            s[i] = IERC20Metadata(_tokens[i]).balanceOf(_users[i]);
        }

        return s;
    }

    function batchErc20Infos(address[] calldata _tokens) external view returns(ErcInfo[] memory) {
        require(_tokens.length > 0, "invalid _tokens");

        ErcInfo[] memory s = new ErcInfo[](_tokens.length);
        for (uint16 i=0; i<_tokens.length; i++){
            address _token = _tokens[i];
            require(_token != address(0), "invalid _token");
            s[i].name = IERC20Metadata(_token).name();
            s[i].symbol = IERC20Metadata(_token).symbol();
            s[i].decimals = IERC20Metadata(_token).decimals();
        }

        return s;
    }

    function batchErc721Infos(address[] calldata _tokens) external view returns(ErcInfo[] memory) {
        require(_tokens.length > 0, "invalid _tokens");

        ErcInfo[] memory s = new ErcInfo[](_tokens.length);
        for (uint16 i=0; i<_tokens.length; i++){
            address _token = _tokens[i];
            require(_token != address(0), "invalid _token");
            s[i].name = IERC721Metadata(_token).name();
            s[i].symbol = IERC721Metadata(_token).symbol();
        }

        return s;
    }

    function batchErcInfos(address[] calldata _tokens, TokenType[] calldata _tokenTypes) external view returns(ErcInfo[] memory) {
        require(_tokens.length > 0, "invalid _tokens");

        ErcInfo[] memory s = new ErcInfo[](_tokens.length);
        for (uint16 i=0; i<_tokens.length; i++){
            address _token = _tokens[i];
            require(_token != address(0), "invalid _token");
            TokenType _tokenType = _tokenTypes[i];

            if (_tokenType == TokenType.ERC20) {
                s[i].name = IERC20Metadata(_token).name();
                s[i].symbol = IERC20Metadata(_token).symbol();
                s[i].decimals = IERC20Metadata(_token).decimals();
            } else if (_tokenType == TokenType.ERC721) {
                s[i].name = IERC721Metadata(_token).name();
                s[i].symbol = IERC721Metadata(_token).symbol();
            }
        }

        return s;
    }
}

