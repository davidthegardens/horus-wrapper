{"SafeMath.sol":{"content":"pragma solidity ^0.5.0;\r\n\r\n/**\r\n * @dev Wrappers over Solidity\u0027s arithmetic operations with added overflow\r\n * checks.\r\n *\r\n * Arithmetic operations in Solidity wrap on overflow. This can easily result\r\n * in bugs, because programmers usually assume that an overflow raises an\r\n * error, which is the standard behavior in high level programming languages.\r\n * `SafeMath` restores this intuition by reverting the transaction when an\r\n * operation overflows.\r\n *\r\n * Using this library instead of the unchecked operations eliminates an entire\r\n * class of bugs, so it\u0027s recommended to use it always.\r\n */\r\nlibrary SafeMath {\r\n    /**\r\n     * @dev Returns the addition of two unsigned integers, reverting on\r\n     * overflow.\r\n     *\r\n     * Counterpart to Solidity\u0027s `+` operator.\r\n     *\r\n     * Requirements:\r\n     * - Addition cannot overflow.\r\n     */\r\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        uint256 c = a + b;\r\n        require(c \u003e= a, \"SafeMath: addition overflow\");\r\n\r\n        return c;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the subtraction of two unsigned integers, reverting on\r\n     * overflow (when the result is negative).\r\n     *\r\n     * Counterpart to Solidity\u0027s `-` operator.\r\n     *\r\n     * Requirements:\r\n     * - Subtraction cannot overflow.\r\n     */\r\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return sub(a, b, \"SafeMath: subtraction overflow\");\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\r\n     * overflow (when the result is negative).\r\n     *\r\n     * Counterpart to Solidity\u0027s `-` operator.\r\n     *\r\n     * Requirements:\r\n     * - Subtraction cannot overflow.\r\n     *\r\n     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.\r\n     * @dev Get it via `npm install @openzeppelin/contracts@next`.\r\n     */\r\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b \u003c= a, errorMessage);\r\n        uint256 c = a - b;\r\n\r\n        return c;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the multiplication of two unsigned integers, reverting on\r\n     * overflow.\r\n     *\r\n     * Counterpart to Solidity\u0027s `*` operator.\r\n     *\r\n     * Requirements:\r\n     * - Multiplication cannot overflow.\r\n     */\r\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        // Gas optimization: this is cheaper than requiring \u0027a\u0027 not being zero, but the\r\n        // benefit is lost if \u0027b\u0027 is also tested.\r\n        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\r\n        if (a == 0) {\r\n            return 0;\r\n        }\r\n\r\n        uint256 c = a * b;\r\n        require(c / a == b, \"SafeMath: multiplication overflow\");\r\n\r\n        return c;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the integer division of two unsigned integers. Reverts on\r\n     * division by zero. The result is rounded towards zero.\r\n     *\r\n     * Counterpart to Solidity\u0027s `/` operator. Note: this function uses a\r\n     * `revert` opcode (which leaves remaining gas untouched) while Solidity\r\n     * uses an invalid opcode to revert (consuming all remaining gas).\r\n     *\r\n     * Requirements:\r\n     * - The divisor cannot be zero.\r\n     */\r\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return div(a, b, \"SafeMath: division by zero\");\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\r\n     * division by zero. The result is rounded towards zero.\r\n     *\r\n     * Counterpart to Solidity\u0027s `/` operator. Note: this function uses a\r\n     * `revert` opcode (which leaves remaining gas untouched) while Solidity\r\n     * uses an invalid opcode to revert (consuming all remaining gas).\r\n     *\r\n     * Requirements:\r\n     * - The divisor cannot be zero.\r\n     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.\r\n     * @dev Get it via `npm install @openzeppelin/contracts@next`.\r\n     */\r\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        // Solidity only automatically asserts when dividing by 0\r\n        require(b \u003e 0, errorMessage);\r\n        uint256 c = a / b;\r\n        // assert(a == b * c + a % b); // There is no case in which this doesn\u0027t hold\r\n\r\n        return c;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\r\n     * Reverts when dividing by zero.\r\n     *\r\n     * Counterpart to Solidity\u0027s `%` operator. This function uses a `revert`\r\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\r\n     * invalid opcode to revert (consuming all remaining gas).\r\n     *\r\n     * Requirements:\r\n     * - The divisor cannot be zero.\r\n     */\r\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return mod(a, b, \"SafeMath: modulo by zero\");\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\r\n     * Reverts with custom message when dividing by zero.\r\n     *\r\n     * Counterpart to Solidity\u0027s `%` operator. This function uses a `revert`\r\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\r\n     * invalid opcode to revert (consuming all remaining gas).\r\n     *\r\n     * Requirements:\r\n     * - The divisor cannot be zero.\r\n     *\r\n     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.\r\n     * @dev Get it via `npm install @openzeppelin/contracts@next`.\r\n     */\r\n    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\r\n        require(b != 0, errorMessage);\r\n        return a % b;\r\n    }\r\n}"},"SinguLottery.sol":{"content":"pragma solidity 0.5.12;\r\n\r\nimport \"./SafeMath.sol\";\r\n\r\ncontract Token {\r\n\r\n    /// @param _owner The address from which the balance will be retrieved\r\n    /// @return The balance\r\n    function balanceOf(address _owner) view public returns (uint256 balance) {}\r\n\r\n    /// @notice send `_value` token to `_to` from `msg.sender`\r\n    /// @param _to The address of the recipient\r\n    /// @param _value The amount of token to be transferred\r\n    /// @return Whether the transfer was successful or not\r\n    function transfer(address _to, uint256 _value) public returns (bool success) {}\r\n\r\n    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\r\n    /// @param _from The address of the sender\r\n    /// @param _to The address of the recipient\r\n    /// @param _value The amount of token to be transferred\r\n    /// @return Whether the transfer was successful or not\r\n    function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success) {}\r\n\r\n    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\r\n    /// @param _spender The address of the account able to transfer the tokens\r\n    /// @param _value The amount of wei to be approved for transfer\r\n    /// @return Whether the approval was successful or not\r\n    function approve(address _spender, uint256 _value)  public returns (bool success) {}\r\n\r\n    /// @param _owner The address of the account owning tokens\r\n    /// @param _spender The address of the account able to transfer the tokens\r\n    /// @return Amount of remaining tokens allowed to spent\r\n    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {}\r\n\r\n    event Transfer(address indexed _from, address indexed _to, uint256 _value);\r\n    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\r\n\r\n}\r\n\r\n\r\n\r\ncontract StandardToken is Token {\r\n    \r\n    /**\r\n     * @dev Destroys `amount` tokens from `account`, reducing the\r\n     * total supply.\r\n     *\r\n     * Emits a {Transfer} event with `to` set to the zero address.\r\n     *\r\n     * Requirements\r\n     *\r\n     * - `account` cannot be the zero address.\r\n     * - `account` must have at least `amount` tokens.\r\n     */\r\n    function _burn(address account, uint256 amount) internal {\r\n        require(account != address(0), \"ERC20: burn from the zero address\");\r\n\r\n        balances[account] = SafeMath.sub(balances[account], amount, \"ERC20: burn amount exceeds balance\");\r\n        totalSupply = SafeMath.sub(totalSupply, amount);\r\n        circulatingSupply = SafeMath.sub(circulatingSupply, amount);\r\n        emit Transfer(account, address(0), amount);\r\n    }\r\n\r\n    function transfer(address _to, uint256 _value) public returns (bool success) {\r\n        //Default assumes totalSupply can\u0027t be over max (2^256 - 1).\r\n        if (balances[msg.sender] \u003e= _value \u0026\u0026 _value \u003e 0) {\r\n            \r\n            uint256 burnVal = _value / BurnRateDenominator;\r\n            \r\n            _burn(msg.sender, burnVal);\r\n            \r\n            balances[msg.sender] -= (_value - burnVal);\r\n            balances[_to] += (_value - burnVal);\r\n            emit Transfer(msg.sender, _to, (_value - burnVal));\r\n            \r\n            \r\n            return true;\r\n        } else { return false; }\r\n    }\r\n\r\n    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\r\n        \r\n        if (balances[_from] \u003e= _value \u0026\u0026 allowed[_from][msg.sender] \u003e= _value \u0026\u0026 _value \u003e 0) {\r\n            \r\n            uint256 burnVal = _value / BurnRateDenominator;\r\n            \r\n            _burn(_from, burnVal);\r\n            \r\n            balances[_to] += (_value - burnVal);\r\n            balances[_from] -= (_value - burnVal);\r\n            allowed[_from][msg.sender] -= (_value - burnVal);\r\n            emit Transfer(_from, _to, (_value - burnVal));\r\n            return true;\r\n        } else { return false; }\r\n    }\r\n\r\n    function balanceOf(address _owner) view public returns (uint256 balance) {\r\n        return balances[_owner];\r\n    }\r\n\r\n    function approve(address _spender, uint256 _value) public returns (bool success) {\r\n        allowed[msg.sender][_spender] = _value;\r\n        emit Approval(msg.sender, _spender, _value);\r\n        return true;\r\n    }\r\n\r\n    function allowance(address _owner, address _spender) view public returns (uint256 remaining) {\r\n      return allowed[_owner][_spender];\r\n    }\r\n\r\n\r\n    mapping (address =\u003e uint256) balances;\r\n    mapping (address =\u003e mapping (address =\u003e uint256)) allowed;\r\n    uint256 public circulatingSupply;\r\n    uint256 public totalSupply;\r\n    uint256 public BurnRateDenominator = 100;\r\n}\r\n\r\n\r\ncontract SinguLottery is StandardToken {\r\n    \r\n    // Struct of the entries for the current giveaway\r\n    struct Entry { \r\n        address payable ticket;\r\n        uint256 currentTotal;\r\n        uint256 tokensSent;\r\n    }\r\n    \r\n    // public variables\r\n    string public name;                  \r\n    string public symbol;            \r\n    uint8 public decimals;                \r\n    address payable public mostRecentWinner;\r\n    uint256 public giveaway_total;\r\n    \r\n    // timestamps\r\n    uint256 public startTime;\r\n    uint256 public endTime;\r\n    uint256 public duration;\r\n    \r\n    // private variables\r\n    address payable private owner;\r\n    \r\n    // bonus multipliers\r\n    uint private hundMult;     // 10^20 == 100 eth\r\n    uint private tenMult;      // 10^19 == 10 eth\r\n    uint private oneMult;      // 10^18 == 1 eth\r\n    uint private halfMult;     // 10^17 * 5 == 0.5 eth\r\n    uint private tenthMult;    // 10^17 == 0.1 eth\r\n    uint private fiveHundMult; // 10^16 * 5 == 0.05 eth\r\n    \r\n    \r\n    // seed for randomization\r\n    uint256 private storedSeed;\r\n    Entry[] private entries;\r\n    \r\n    function () external payable {\r\n        //if ETH is sent to this address, do something\r\n        require(msg.sender != owner); // don\u0027t let owner participate \r\n        uint256 giveaway_value = calculateGiveaway(msg.value,0);\r\n        \r\n        require(giveaway_value \u003e 0);\r\n        entries.push(Entry(msg.sender, giveaway_total, SafeMath.div(giveaway_value, oneMult)));\r\n\r\n        circulatingSupply = SafeMath.add(circulatingSupply, giveaway_value);\r\n        \r\n        giveaway_total = SafeMath.add(giveaway_total, SafeMath.div(giveaway_value, oneMult));\r\n\r\n        \r\n        balances[msg.sender] = SafeMath.add(balances[msg.sender], giveaway_value);\r\n        balances[owner]      = SafeMath.sub(balances[owner], giveaway_value);\r\n        \r\n        // XOR the current block, difficulty, sender data, and the sender to randomize the seed\r\n        storedSeed = storedSeed ^ uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.data, msg.sender)));\r\n\r\n        owner.transfer(SafeMath.div(msg.value, 10));\r\n        emit Transfer(owner, msg.sender, giveaway_value);\r\n        \r\n    }\r\n \r\n    function calculateGiveaway(uint256 eth_val, uint256 giveout) private view returns (uint256 result) {\r\n        uint256 multiplier;\r\n        \r\n        multiplier  = SafeMath.div(eth_val, hundMult);\r\n        giveout     = SafeMath.add(giveout, SafeMath.mul(multiplier, 10000));\r\n        eth_val     = SafeMath.sub(eth_val, SafeMath.mul(multiplier, hundMult));\r\n        \r\n        multiplier  = SafeMath.div(eth_val, tenMult);\r\n        giveout     = SafeMath.add(giveout, SafeMath.mul(multiplier, 666));\r\n        eth_val     = SafeMath.sub(eth_val, SafeMath.mul(multiplier, tenMult)); \r\n        \r\n        multiplier  = SafeMath.div(eth_val, oneMult);\r\n        giveout     = SafeMath.add(giveout, SafeMath.mul(multiplier, 35));\r\n        eth_val     = SafeMath.sub(eth_val, SafeMath.mul(multiplier, oneMult)); \r\n        \r\n        multiplier  = SafeMath.div(eth_val, halfMult);\r\n        giveout     = SafeMath.add(giveout, SafeMath.mul(multiplier, 20));\r\n        eth_val     = SafeMath.sub(eth_val, SafeMath.mul(multiplier, halfMult)); \r\n        \r\n        multiplier  = SafeMath.div(eth_val, tenthMult);\r\n        giveout     = SafeMath.add(giveout, SafeMath.mul(multiplier, 3));\r\n        eth_val     = SafeMath.sub(eth_val, SafeMath.mul(multiplier, tenthMult)); \r\n        \r\n        multiplier  = SafeMath.div(eth_val, fiveHundMult);\r\n        giveout     = SafeMath.add(giveout, multiplier);\r\n        eth_val     = SafeMath.sub(eth_val, SafeMath.mul(multiplier, fiveHundMult)); \r\n        \r\n        return SafeMath.mul(giveout, oneMult);\r\n    }\r\n    \r\n    function enterHouseSeedAndStartGiveaway(string memory _seed) public{\r\n        require(msg.sender == owner);\r\n        storedSeed = storedSeed ^ uint256(keccak256(abi.encodePacked(_seed)));\r\n        triggerGiveaway();\r\n\r\n    }\r\n\r\n    function triggerGiveaway() private {\r\n        require (block.timestamp \u003e endTime \u0026\u0026 block.timestamp \u003e startTime);\r\n        mostRecentWinner = findWinner();\r\n        mostRecentWinner.transfer(address(this).balance);\r\n        entries.length = 0;\r\n        startTime = block.timestamp;\r\n        endTime = startTime + duration;\r\n        giveaway_total = 0;\r\n    }\r\n    \r\n    function findWinner() private view returns (address payable winner){\r\n        uint256 randomNumber = storedSeed % giveaway_total;\r\n    \r\n        for (uint i = 0; i \u003c entries.length; i++){\r\n            if(randomNumber \u003e entries[i].currentTotal \u0026\u0026 randomNumber \u003c= entries[i].tokensSent + entries[i].currentTotal) return entries[i].ticket;\r\n        }\r\n        \r\n    }\r\n\r\n    constructor() SinguLottery (\r\n        ) public {      \r\n        totalSupply       = 50000000000000000000000000; \r\n        circulatingSupply =  5000000000000000000000000;\r\n        \r\n        balances[msg.sender] = totalSupply - circulatingSupply;        \r\n        \r\n        // Common ERC20 Parameters\r\n        name     = \"SinguLottery\";                            \r\n        decimals = 18;                                  \r\n        symbol   = \"SLY\";                                \r\n        owner    = msg.sender;\r\n        \r\n        // Premine distributed in constructor to prevent burns\r\n        emit Transfer(owner, address(0x5357721aa06f21587b0c0D59734D57Be176C220f), 2500000000000000000000000); // Airdrop and bounty wallet\r\n        emit Transfer(owner, address(0x0704Ff94E4dd0becac849139608621f869Cf01Ed), 650000000000000000000000);  // Anonymous investor #1\r\n        emit Transfer(owner, address(0x832B4718505f27e3Ee5Ad07cD5d369ed2087c3AC), 300000000000000000000000);  // Anonymous investor #2\r\n        emit Transfer(owner, address(0x3532F06e749Ed7BAC22bA4510d90063127D50220), 300000000000000000000000);  // Anonymous investor #3\r\n        emit Transfer(owner, address(0xC755318832F3F5509a66E6506A9DfcA64e8F2a6A), 300000000000000000000000);  // Anonymous investor #4\r\n        emit Transfer(owner, address(0xD26B07DfE5482c8BAb5EaFc0BF411f9c207710b0), 100000000000000000000000);  // Anonymous investor #5\r\n        emit Transfer(owner, address(0xa9Fc957bba450bFe7B57CF07098e59b69F390892), 85000000000000000000000);   // Anonymous investor #6\r\n        emit Transfer(owner, address(0x8859e56693c8A8292a38acDEcCD97b9bc2307e43), 85000000000000000000000);   // Anonymous investor #7\r\n        emit Transfer(owner, address(0x9251dB9Bbeba1431F94c52Da83cFdAfeaD800bf3), 85000000000000000000000);   // Anonymous investor #8\r\n        emit Transfer(owner, address(0xAF08BF99a98D09118299A80A5Ce0a009B03B6B4d), 85000000000000000000000);   // Anonymous investor #9\r\n        emit Transfer(owner, address(0xCCf9e8CdA151b6d314201E9da65697B0eBc8A381), 85000000000000000000000);   // Anonymous investor #10\r\n        emit Transfer(owner, address(0x5Dc178505FaabA7302e48e9Df22C74C9Dd63ecf1), 85000000000000000000000);   // Anonymous investor #11\r\n        emit Transfer(owner, address(0xdA503fb4e92b78Fd399B922836C9b1F94321802B), 85000000000000000000000);   // Anonymous investor #12\r\n        emit Transfer(owner, address(0xa9D0934123cD23Eff65ac17A52FD3197afAb8860), 85000000000000000000000);   // Anonymous investor #13\r\n        emit Transfer(owner, address(0x32409B1C6dE73136f6e4C4315569197Ea425D85A), 85000000000000000000000);   // Anonymous investor #14\r\n        emit Transfer(owner, address(0x8852De0be6eAFF06AC4B7Ca11DcAf4873CA609Dc), 85000000000000000000000);   // Anonymous investor #15\r\n        \r\n        \r\n        balances[address(0x5357721aa06f21587b0c0D59734D57Be176C220f)] = 2500000000000000000000000;  // Airdrop and bounty wallet\r\n        balances[address(0x0704Ff94E4dd0becac849139608621f869Cf01Ed)] =  650000000000000000000000;  // Anonymous investor #1\r\n        balances[address(0x832B4718505f27e3Ee5Ad07cD5d369ed2087c3AC)] =  300000000000000000000000;  // Anonymous investor #2\r\n        balances[address(0x3532F06e749Ed7BAC22bA4510d90063127D50220)] =  300000000000000000000000;  // Anonymous investor #3\r\n        balances[address(0xC755318832F3F5509a66E6506A9DfcA64e8F2a6A)] =  300000000000000000000000;  // Anonymous investor #4\r\n        balances[address(0xD26B07DfE5482c8BAb5EaFc0BF411f9c207710b0)] =  100000000000000000000000;  // Anonymous investor #5\r\n        balances[address(0xa9Fc957bba450bFe7B57CF07098e59b69F390892)] =   85000000000000000000000;  // Anonymous investor #6\r\n        balances[address(0x8859e56693c8A8292a38acDEcCD97b9bc2307e43)] =   85000000000000000000000;  // Anonymous investor #7\r\n        balances[address(0x9251dB9Bbeba1431F94c52Da83cFdAfeaD800bf3)] =   85000000000000000000000;  // Anonymous investor #8\r\n        balances[address(0xAF08BF99a98D09118299A80A5Ce0a009B03B6B4d)] =   85000000000000000000000;  // Anonymous investor #9\r\n        balances[address(0xCCf9e8CdA151b6d314201E9da65697B0eBc8A381)] =   85000000000000000000000;  // Anonymous investor #10\r\n        balances[address(0x5Dc178505FaabA7302e48e9Df22C74C9Dd63ecf1)] =   85000000000000000000000;  // Anonymous investor #11\r\n        balances[address(0xdA503fb4e92b78Fd399B922836C9b1F94321802B)] =   85000000000000000000000;  // Anonymous investor #12\r\n        balances[address(0xa9D0934123cD23Eff65ac17A52FD3197afAb8860)] =   85000000000000000000000;  // Anonymous investor #13\r\n        balances[address(0x32409B1C6dE73136f6e4C4315569197Ea425D85A)] =   85000000000000000000000;  // Anonymous investor #14\r\n        balances[address(0x8852De0be6eAFF06AC4B7Ca11DcAf4873CA609Dc)] =   85000000000000000000000;  // Anonymous investor #15\r\n\r\n        \r\n        // Multipliers\r\n        hundMult     = 10**20;\r\n        tenMult      = 10**19;\r\n        oneMult      = 10**18;\r\n        halfMult     = (10**17) * 5;\r\n        tenthMult    = 10**17;\r\n        fiveHundMult = (10**16) * 5;\r\n        \r\n        startTime = block.timestamp;\r\n        \r\n        duration = 60 * 60 * 24 * 7; // 7 days\r\n        \r\n        endTime = startTime + duration;\r\n        storedSeed = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender)));\r\n    }\r\n}"}}