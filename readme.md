# Unitialized Implementation Vulnerability

### Attack Steps

1. Attack Contract calls initialize method of jettyFuel Implementation contract. 
2. UpgradeToCall method is called with data encoding destroy method
3. selfdestruct deletes implementation's byte code as it's called via delegate call
4. proxy is rendered useless as it can't upgrade implementation logic now

### Please note that selfdestruct is not supported by foundry causing verfication issues. 
### Attack steps can be validated by analyzing stack traces during testing.

###
1. Setup
```
gh repo clone kartkhira/UnitializedImplementaionVul
```

2. Testing
```
forge test -vvvv
```

