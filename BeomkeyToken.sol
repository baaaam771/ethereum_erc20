pragma solidity >=0.4.0 <0.7.0;

contract Ownable {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    constructor ( ) public {
    address msgSender = msg.sender;
    _owner = msg.sender;
    emit OwnershipTransferred(address(0), msgSender);
     }
    function owner( ) public view returns (address) {
        return _owner;
    }
    modifier onlyOwner( ) {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }
    function renounceOwnership( ) public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract BeomkeyToken is Ownable {
    
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint256 private _decimals;
    
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    
    constructor (string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
        // _totalSupply = 3000*(10**_decimals);
        // _balances[msg.sender] = 3000*(10**_decimals);
        _mint(msg.sender, 3000*(10**_decimals));
    }
    
    event Mint(address account, uint256 amount);
    
    function _mint(address account, uint256 amount) public onlyOwner {
        // require(_totalSupply <= 10000 *(10**_decimals), "totalSupply is over 10000 MT");
        _totalSupply = _totalSupply+amount;
        _balances[account] = _balances[account]+amount;
        emit Mint(account, amount);
    }
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    function _transfer(address sender, address recipient, uint256 amount) internal{
        _balances[sender] = _balances[sender]-amount;
        _balances[recipient] = _balances[recipient]+amount;
    }
    
    function transfer(address recipient, uint256 amount) public returns (bool){
        _transfer(msg.sender, recipient, amount);
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }
    
    event Apporval(address indexed owner, address indexed spender, uint256 value);
    
     function approve(address spender, uint256 amount) public returns(bool) {
        _allowances[msg.sender][spender]= amount;
        emit Apporval(msg.sender,spender,amount); //log data
    }

     function increaseAllowance(address spender, uint256 addedValue) public returns (bool){
        approve(spender,_allowances[msg.sender][spender]+addedValue);
        return true;
    }
    
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool){
        approve(spender,_allowances[msg.sender][spender]-subtractedValue);
        return true;
    }
    
    function TransferFrom(address sender, address recipient, uint256 amount) public returns (bool){
        _transfer(sender,recipient,amount);
        uint256 currentAllowance = _allowances[sender][msg.sender];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _allowances[sender][msg.sender] = currentAllowance - amount;
        emit Transfer(sender,recipient,amount);
        return true;
    }
    
    //조회용 함수
    function name() public view returns (string memory){
        return _name;
    }
    
    function symbol() public view returns (string memory){
        return _symbol;
    }
    
    function decimals() public view returns (uint256){
        return _decimals;
    }
    
    function totalSupply() public view returns (uint256){
        return _totalSupply;
    }

     function balanceOf(address account) public view returns (uint256){
        return _balances[account];
    }

    function allowance(address owner, address spender) public view returns (uint256){
        return _allowances[owner][spender];
    }

}
