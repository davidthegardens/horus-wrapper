{"EdgewareSignalProxy.sol":{"content":"pragma solidity ^0.5.11;\n\nimport \"./Lockdrop.sol\";\n\n/// @dev Proxy contract that enables secure signalling through three-distinct private keys.\n/// fundSrc = address that provides funds to the proxy\n/// fundDst = address that receives funds when signalling is completed\n/// admin = address that can trigger release() of funds to fundDst\ncontract EdgewareSignalProxy {\n  address payable public fundDst;\n  address public fundSrc;\n  address public admin;\n  bytes public edgewareAddr;\n  Lockdrop public lockdrop;\n\n  /// @dev Establish a new proxy for singnalling.\n  /// @param _lockdrop Address of the Edgeware Lockdrop singalling contract\n  /// @param _fundSrc The address that provides funds to this proxy\n  /// @param _fundDst The address that will receive funds after signalling is complete\n  /// @param _admin The administration address: can call signal() and release()\n  /// @param _edgewareAddr The edgeware address that will receive funds from the lockdrop\n  constructor(\n    Lockdrop _lockdrop,\n    address _fundSrc,\n    address payable _fundDst,\n    address _admin,\n    bytes memory _edgewareAddr\n  ) public {\n    lockdrop = _lockdrop;\n    fundSrc = _fundSrc;\n    fundDst = _fundDst;\n    admin = _admin;\n    edgewareAddr = _edgewareAddr;\n  }\n\n  /// @dev Ensures that only the admin or the fundDst addresses can call a given function.\n  modifier auth() {\n    require(msg.sender == admin || msg.sender == fundDst, \"Sender must be the fund destination or admin address\");\n    _;\n  }\n\n  /// @dev Signals to the lockdrop contract when new founds are deposited.\n  /// Will only receive deposits from the designated fundSrc address\n  function () external payable {\n    require(msg.sender == fundSrc, \"Sender must be the fund source address\");\n    signal();\n  }\n\n  /// @dev Calls the signal() method on the lockdrop contract with the Edgeware address\n  /// associated with this proxy.\n  function signal() internal {\n    // Note that the nonce parameter can be set to any value. We\u0027re signalling on behalf of\n    // oursevles and not another contract and so when Lockdrop.signal calls didCreate\n    // the nonce value is ignored.\n    lockdrop.signal(address(this), 0, edgewareAddr);\n  }\n\n  /// @dev Sends all fund held by this contract back to the fundDst address.\n  /// Note that if funds are release()d before the Edgeware Lockdrop snapshot has occurred\n  /// that no credit for this signalling will take place. Be sure to release() funds\n  /// after the snapshot has completed to ensure credit for signal()ing.\n  function release() external auth {\n    address(fundDst).transfer(address(this).balance);\n  }\n}"},"EdgewareSignalProxyFactory.sol":{"content":"pragma solidity ^0.5.11;\n\nimport \"./Lockdrop.sol\";\nimport \"./EdgewareSignalProxy.sol\";\n\n/// @dev Proxy factory that makes it easy to originate new SignalProxy contracts\n// on the ethereum blockchain. Keeps track of the admin address associated with each\n// proxy contract and enforces a 1:1 mapping of admin address:proxy.\ncontract EdgewareSignalProxyFactory {\n\n  /// Mapping of admin address to proxy contract\n  mapping(address =\u003e EdgewareSignalProxy) public proxies;\n\n  /// @dev Originate a new proxy factory. All parameters are passed to the\n  /// the SignalProxy constructor.\n  /// see: SignalProxyFactoy constructor.\n  function newProxy(\n    Lockdrop _lockdrop,\n    address _fundSrc,\n    address payable _fundDst,\n    bytes memory _edgewareAddr\n  ) public {\n    // Enforce a 1:1 mapping otherwise we loose track of proxy contracts\n    require(address(proxies[msg.sender]) == address(0), \"Duplicate admin key not permitted\");\n\n    // Originate our signal proxy\n    EdgewareSignalProxy proxy = new EdgewareSignalProxy(\n      _lockdrop,\n      _fundSrc,\n      _fundDst,\n      msg.sender,\n      _edgewareAddr\n    );\n\n    // Store the admin address:proxy mapping\n    proxies[msg.sender] = proxy;\n  }\n}"},"Lockdrop.sol":{"content":"pragma solidity ^0.5.0;\n\ncontract Lock {\n    // address owner; slot #0\n    // address unlockTime; slot #1\n    constructor (address owner, uint256 unlockTime) public payable {\n        assembly {\n            sstore(0x00, owner)\n            sstore(0x01, unlockTime)\n        }\n    }\n    \n    /**\n     * @dev        Withdraw function once timestamp has passed unlock time\n     */\n    function () external payable { // payable so solidity doesn\u0027t add unnecessary logic\n        assembly {\n            switch gt(timestamp, sload(0x01))\n            case 0 { revert(0, 0) }\n            case 1 {\n                switch call(gas, sload(0x00), balance(address), 0, 0, 0, 0)\n                case 0 { revert(0, 0) }\n            }\n        }\n    }\n}\n\ncontract Lockdrop {\n    enum Term {\n        ThreeMo,\n        SixMo,\n        TwelveMo\n    }\n    // Time constants\n    uint256 constant public LOCK_DROP_PERIOD = 1 days * 92; // 3 months\n    uint256 public LOCK_START_TIME;\n    uint256 public LOCK_END_TIME;\n    // ETH locking events\n    event Locked(address indexed owner, uint256 eth, Lock lockAddr, Term term, bytes edgewareAddr, bool isValidator, uint time);\n    event Signaled(address indexed contractAddr, bytes edgewareAddr, uint time);\n    \n    constructor(uint startTime) public {\n        LOCK_START_TIME = startTime;\n        LOCK_END_TIME = startTime + LOCK_DROP_PERIOD;\n    }\n\n    /**\n     * @dev        Locks up the value sent to contract in a new Lock\n     * @param      term         The length of the lock up\n     * @param      edgewareAddr The bytes representation of the target edgeware key\n     * @param      isValidator  Indicates if sender wishes to be a validator\n     */\n    function lock(Term term, bytes calldata edgewareAddr, bool isValidator)\n        external\n        payable\n        didStart\n        didNotEnd\n    {\n        uint256 eth = msg.value;\n        address owner = msg.sender;\n        uint256 unlockTime = unlockTimeForTerm(term);\n        // Create ETH lock contract\n        Lock lockAddr = (new Lock).value(eth)(owner, unlockTime);\n        // ensure lock contract has at least all the ETH, or fail\n        assert(address(lockAddr).balance \u003e= msg.value);\n        emit Locked(owner, eth, lockAddr, term, edgewareAddr, isValidator, now);\n    }\n\n    /**\n     * @dev        Signals a contract\u0027s (or address\u0027s) balance decided after lock period\n     * @param      contractAddr  The contract address from which to signal the balance of\n     * @param      nonce         The transaction nonce of the creator of the contract\n     * @param      edgewareAddr   The bytes representation of the target edgeware key\n     */\n    function signal(address contractAddr, uint32 nonce, bytes calldata edgewareAddr)\n        external\n        didStart\n        didNotEnd\n        didCreate(contractAddr, msg.sender, nonce)\n    {\n        emit Signaled(contractAddr, edgewareAddr, now);\n    }\n\n    function unlockTimeForTerm(Term term) internal view returns (uint256) {\n        if (term == Term.ThreeMo) return now + 92 days;\n        if (term == Term.SixMo) return now + 183 days;\n        if (term == Term.TwelveMo) return now + 365 days;\n        \n        revert();\n    }\n\n    /**\n     * @dev        Ensures the lockdrop has started\n     */\n    modifier didStart() {\n        require(now \u003e= LOCK_START_TIME);\n        _;\n    }\n\n    /**\n     * @dev        Ensures the lockdrop has not ended\n     */\n    modifier didNotEnd() {\n        require(now \u003c= LOCK_END_TIME);\n        _;\n    }\n\n    /**\n     * @dev        Rebuilds the contract address from a normal address and transaction nonce\n     * @param      _origin  The non-contract address derived from a user\u0027s public key\n     * @param      _nonce   The transaction nonce from which to generate a contract address\n     */\n    function addressFrom(address _origin, uint32 _nonce) public pure returns (address) {\n        if(_nonce == 0x00)     return address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), _origin, byte(0x80))))));\n        if(_nonce \u003c= 0x7f)     return address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), _origin, uint8(_nonce))))));\n        if(_nonce \u003c= 0xff)     return address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd7), byte(0x94), _origin, byte(0x81), uint8(_nonce))))));\n        if(_nonce \u003c= 0xffff)   return address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd8), byte(0x94), _origin, byte(0x82), uint16(_nonce))))));\n        if(_nonce \u003c= 0xffffff) return address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd9), byte(0x94), _origin, byte(0x83), uint24(_nonce))))));\n        return address(uint160(uint256(keccak256(abi.encodePacked(byte(0xda), byte(0x94), _origin, byte(0x84), uint32(_nonce)))))); // more than 2^32 nonces not realistic\n    }\n\n    /**\n     * @dev        Ensures the target address was created by a parent at some nonce\n     * @param      target  The target contract address (or trivially the parent)\n     * @param      parent  The creator of the alleged contract address\n     * @param      nonce   The creator\u0027s tx nonce at the time of the contract creation\n     */\n    modifier didCreate(address target, address parent, uint32 nonce) {\n        // Trivially let senders \"create\" themselves\n        if (target == parent) {\n            _;\n        } else {\n            require(target == addressFrom(parent, nonce));\n            _;\n        }\n    }\n}"}}