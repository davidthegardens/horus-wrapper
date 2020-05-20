{"CharityChallenge.sol":{"content":"pragma solidity ^0.5.2;\n\nimport \"./IRealityCheck.sol\";\nimport \"./SafeMath.sol\";\n\ncontract CharityChallenge {\n    using SafeMath for uint256;\n    using SafeMath for uint8;\n\n    event Received(address indexed sender, uint256 value);\n\n    event Donated(address indexed npo, uint256 value);\n\n    event Failed();\n\n    event Fee(address indexed maker, uint256 value);\n\n    event Claimed(address indexed claimer, uint256 value);\n\n    event SafetyHatchClaimed(address indexed claimer, uint256 value);\n\n    string public constant VERSION = \"0.4.1\";\n\n    address payable public contractOwner;\n\n    // key is npo address, value is ratio\n    mapping(address =\u003e uint8) public npoRatios;\n\n    uint8 sumRatio;\n\n    address payable[] public npoAddresses;\n\n    uint8 public npoLength;\n\n    address public marketAddress;\n\n    bool public unlockOnNo;\n\n    IRealityCheck realityCheck;\n\n    string public question;\n\n    address public arbitrator;\n\n    uint256 public timeout;\n\n    bytes32 public questionId;\n\n    uint256 public challengeEndTime;\n\n    // For a fee of 10.5%, pass 1050\n    uint256 public makerFee;\n\n    uint256 public challengeSafetyHatchTime1;\n\n    uint256 public challengeSafetyHatchTime2;\n\n    // Valid outcomes are \u0027YES\u0027, \u0027NO\u0027 and \u0027INVALID\u0027\n    bool public isEventFinalized;\n\n    // hasChallengeAccomplished will be set to true if we got the expected\n    // result that allow to unlock the funds.\n    bool public hasChallengeAccomplished;\n\n    bool private safetyHatchClaimSucceeded;\n\n    mapping(address =\u003e uint256) public donorBalances;\n\n    uint256 public donorCount;\n\n    uint256 public contributedAmount;\n\n    // We use a divider of 10000 instead of 100 to have more granularity for\n    // the maker fee\n    uint256 constant feeDivider = 10000;\n\n    bool private mReentrancyLock = false;\n    modifier nonReentrant() {\n        require(!mReentrancyLock);\n        mReentrancyLock = true;\n        _;\n        mReentrancyLock = false;\n    }\n\n    constructor(\n        address payable _contractOwner,\n        address payable[] memory _npoAddresses,\n        uint8[] memory _ratios,\n        address _marketAddress,\n        string memory _question,\n        address _arbitrator,\n        uint256 _timeout,\n        uint256 _challengeEndTime,\n        uint256 _makerFee,\n        bool _unlockOnNo\n    ) public\n    {\n        require(_npoAddresses.length == _ratios.length);\n        require(makerFee \u003c feeDivider);\n        npoLength = uint8(_npoAddresses.length);\n        for (uint8 i = 0; i \u003c npoLength; i++) {\n            address payable npo = _npoAddresses[i];\n            npoAddresses.push(npo);\n            require(_ratios[i] \u003e 0, \"Ratio must be a positive number\");\n            npoRatios[npo] = _ratios[i];\n            sumRatio += _ratios[i];\n        }\n        contractOwner = _contractOwner;\n        marketAddress = _marketAddress;\n        realityCheck = IRealityCheck(_marketAddress);\n        question = _question;\n        arbitrator = _arbitrator;\n        timeout = _timeout;\n        challengeEndTime = _challengeEndTime;\n        makerFee = _makerFee;\n        questionId = realityCheck.askQuestion(0, question, arbitrator, uint32(timeout), uint32(challengeEndTime), 0);\n        unlockOnNo = _unlockOnNo;\n        challengeSafetyHatchTime1 = challengeEndTime + 26 weeks;\n        challengeSafetyHatchTime2 = challengeSafetyHatchTime1 + 52 weeks;\n        isEventFinalized = false;\n        hasChallengeAccomplished = false;\n    }\n\n    function() external payable {\n        require(now \u003c= challengeEndTime);\n        require(msg.value \u003e 0);\n        if (donorBalances[msg.sender] == 0 \u0026\u0026 msg.value \u003e 0) {\n            donorCount++;\n        }\n        donorBalances[msg.sender] += msg.value;\n        contributedAmount += msg.value;\n        emit Received(msg.sender, msg.value);\n    }\n\n    function balanceOf(address _donorAddress) public view returns (uint256) {\n        if (safetyHatchClaimSucceeded) {\n            return 0;\n        }\n        return donorBalances[_donorAddress];\n    }\n\n    function finalize() nonReentrant external {\n        require(now \u003e challengeEndTime);\n        require(now \u003c= challengeSafetyHatchTime1);\n        require(!isEventFinalized);\n        doFinalize();\n    }\n\n    function doFinalize() private {\n        bool hasError;\n        (hasChallengeAccomplished, hasError) = checkRealitio();\n        if (!hasError) {\n            isEventFinalized = true;\n            if (hasChallengeAccomplished) {\n                uint length = npoAddresses.length;\n                if (makerFee \u003e 0) {\n                    uint256 amount = address(this).balance.mul(makerFee).div(feeDivider);\n                    contractOwner.transfer(amount);\n                    emit Fee(contractOwner, amount);\n                }\n                for (uint i = 0; i \u003c length - 1; i++) {\n                    address payable npo = npoAddresses[i];\n                    uint8 ratio = npoRatios[npo];\n                    uint256 amount = address(this).balance.mul(ratio).div(sumRatio);\n                    npo.transfer(amount);\n                    emit Donated(npo, amount);\n                }\n                // Don\u0027t want to keep any amount in the contract\n                uint256 amount = address(this).balance;\n                address payable npo = npoAddresses[length - 1];\n                npo.transfer(amount);\n                emit Donated(npo, amount);\n            } else {\n                emit Failed();\n            }\n        }\n    }\n\n    function getExpectedDonationAmount(address payable _npo) view external returns (uint256) {\n        require(npoRatios[_npo] \u003e 0);\n        uint256 amountForNPO = address(this).balance.sub(address(this).balance.mul(makerFee).div(feeDivider));\n        uint8 ratio = npoRatios[_npo];\n        return amountForNPO.mul(ratio).div(sumRatio);\n    }\n\n    function claim() nonReentrant external {\n        require(now \u003e challengeEndTime);\n        require(isEventFinalized || now \u003e challengeSafetyHatchTime1);\n        require(!hasChallengeAccomplished || now \u003e challengeSafetyHatchTime1);\n        require(balanceOf(msg.sender) \u003e 0);\n\n        uint256 claimedAmount = balanceOf(msg.sender);\n        donorBalances[msg.sender] = 0;\n        msg.sender.transfer(claimedAmount);\n        emit Claimed(msg.sender, claimedAmount);\n    }\n\n    function safetyHatchClaim() external {\n        require(now \u003e challengeSafetyHatchTime2);\n        require(msg.sender == contractOwner);\n\n        uint totalContractBalance = address(this).balance;\n        safetyHatchClaimSucceeded = true;\n        contractOwner.transfer(address(this).balance);\n        emit SafetyHatchClaimed(contractOwner, totalContractBalance);\n    }\n\n    function checkRealitio() public view returns (bool happened, bool errored) {\n        if (realityCheck.isFinalized(questionId)) {\n            bytes32 answer = realityCheck.getFinalAnswer(questionId);\n            if (answer == 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) {\n                // Treat \u0027invalid\u0027 outcome as \u0027no\u0027\n                // because \u0027invalid\u0027 is one of the valid outcomes\n                return (false, false);\n            } else {\n                if (unlockOnNo) {\n                    return (answer == 0x0000000000000000000000000000000000000000000000000000000000000000, false);\n                }\n                return (answer == 0x0000000000000000000000000000000000000000000000000000000000000001, false);\n            }\n        } else {\n            return (false, true);\n        }\n    }\n}\n"},"IRealityCheck.sol":{"content":"pragma solidity ^0.5.2;\n\n// RealityCheck API used to interract with realit.io, we only need to describe the\n// functions we\u0027ll be using.\n// cf https://raw.githubusercontent.com/realitio/realitio-dapp/master/truffle/contracts/RealityCheck.sol\ninterface IRealityCheck {\n    function askQuestion(\n        uint256 template_id, string calldata question,\n        address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce) external returns (bytes32);\n    function isFinalized(bytes32 question_id) external view returns (bool);\n    function getFinalAnswer(bytes32 question_id) external view returns (bytes32);\n    function getOpeningTS(bytes32 question_id) external view returns(uint32);\n}\n"},"SafeMath.sol":{"content":"pragma solidity ^0.5.0;\n\n/**\n * @dev Wrappers over Solidity\u0027s arithmetic operations with added overflow\n * checks.\n *\n * Arithmetic operations in Solidity wrap on overflow. This can easily result\n * in bugs, because programmers usually assume that an overflow raises an\n * error, which is the standard behavior in high level programming languages.\n * `SafeMath` restores this intuition by reverting the transaction when an\n * operation overflows.\n *\n * Using this library instead of the unchecked operations eliminates an entire\n * class of bugs, so it\u0027s recommended to use it always.\n */\nlibrary SafeMath {\n    /**\n     * @dev Returns the addition of two unsigned integers, reverting on\n     * overflow.\n     *\n     * Counterpart to Solidity\u0027s `+` operator.\n     *\n     * Requirements:\n     * - Addition cannot overflow.\n     */\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        uint256 c = a + b;\n        require(c \u003e= a, \"SafeMath: addition overflow\");\n\n        return c;\n    }\n\n    /**\n     * @dev Returns the subtraction of two unsigned integers, reverting on\n     * overflow (when the result is negative).\n     *\n     * Counterpart to Solidity\u0027s `-` operator.\n     *\n     * Requirements:\n     * - Subtraction cannot overflow.\n     */\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        require(b \u003c= a, \"SafeMath: subtraction overflow\");\n        uint256 c = a - b;\n\n        return c;\n    }\n\n    /**\n     * @dev Returns the multiplication of two unsigned integers, reverting on\n     * overflow.\n     *\n     * Counterpart to Solidity\u0027s `*` operator.\n     *\n     * Requirements:\n     * - Multiplication cannot overflow.\n     */\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        // Gas optimization: this is cheaper than requiring \u0027a\u0027 not being zero, but the\n        // benefit is lost if \u0027b\u0027 is also tested.\n        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n        if (a == 0) {\n            return 0;\n        }\n\n        uint256 c = a * b;\n        require(c / a == b, \"SafeMath: multiplication overflow\");\n\n        return c;\n    }\n\n    /**\n     * @dev Returns the integer division of two unsigned integers. Reverts on\n     * division by zero. The result is rounded towards zero.\n     *\n     * Counterpart to Solidity\u0027s `/` operator. Note: this function uses a\n     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n     * uses an invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     * - The divisor cannot be zero.\n     */\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        // Solidity only automatically asserts when dividing by 0\n        require(b \u003e 0, \"SafeMath: division by zero\");\n        uint256 c = a / b;\n        // assert(a == b * c + a % b); // There is no case in which this doesn\u0027t hold\n\n        return c;\n    }\n\n    /**\n     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n     * Reverts when dividing by zero.\n     *\n     * Counterpart to Solidity\u0027s `%` operator. This function uses a `revert`\n     * opcode (which leaves remaining gas untouched) while Solidity uses an\n     * invalid opcode to revert (consuming all remaining gas).\n     *\n     * Requirements:\n     * - The divisor cannot be zero.\n     */\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n        require(b != 0, \"SafeMath: modulo by zero\");\n        return a % b;\n    }\n}"}}